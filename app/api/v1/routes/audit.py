from fastapi import APIRouter, Depends, Query
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select, func
from uuid import UUID
from typing import Optional
from app.core.database import get_db
from app.api.deps import AdminOnly
from app.utils.response import success_response

router = APIRouter()

@router.get("", summary="Audit logs [Admin]")
async def list_audit_logs(
    page: int = Query(1, ge=1),
    per_page: int = Query(50),
    user_id: Optional[str] = None,
    action: Optional[str] = None,
    resource: Optional[str] = None,   # maps to resource_type
    resource_type: Optional[str] = None,
    search: Optional[str] = None,     # search user_name or description
    date_from: Optional[str] = None,
    date_to: Optional[str] = None,
    current_user: dict = Depends(AdminOnly),
    db: AsyncSession = Depends(get_db),
):
    from app.models.audit import AuditLog
    from sqlalchemy import or_
    from datetime import datetime as dt
    q = select(AuditLog).order_by(AuditLog.created_at.desc())
    if user_id:
        try: q = q.where(AuditLog.user_id == UUID(user_id))
        except Exception: pass
    if action: q = q.where(AuditLog.action.ilike(f"%{action}%"))
    res = resource or resource_type
    if res: q = q.where(AuditLog.resource_type == res)
    if search:
        s = f"%{search}%"
        q = q.where(or_(AuditLog.user_name.ilike(s), AuditLog.description.ilike(s), AuditLog.action.ilike(s)))
    if date_from:
        try: q = q.where(AuditLog.created_at >= dt.fromisoformat(date_from))
        except Exception: pass
    if date_to:
        try: q = q.where(AuditLog.created_at <= dt.fromisoformat(date_to))
        except Exception: pass
    total = (await db.execute(select(func.count()).select_from(q.subquery()))).scalar_one()
    pages = max(1, (total + per_page - 1) // per_page)
    logs = (await db.execute(q.offset((page-1)*per_page).limit(per_page))).scalars().all()

    def _fmt(l):
        changes = None
        if l.old_data or l.new_data:
            changes = {"old": l.old_data, "new": l.new_data}
        return {
            "id": str(l.id),
            "user_id": str(l.user_id) if l.user_id else None,
            "user_name": l.user_name or "—",
            "user_role": l.user_role or "",
            "action": l.action,
            "resource": l.resource_type,
            "resource_type": l.resource_type,
            "resource_id": l.resource_id,
            "description": l.description,
            "summary": l.description,
            "ip_address": l.ip_address,
            "user_agent": l.user_agent,
            "changes": changes,
            "created_at": l.created_at.isoformat(),
        }

    return success_response(data={"items": [_fmt(l) for l in logs], "total": total, "pages": pages})
