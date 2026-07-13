from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select, func
from uuid import UUID
from pydantic import BaseModel
from typing import Optional
from app.core.database import get_db
from app.api.deps import AdminOnly, AdminOrCCO, AnyAuthenticated
from app.utils.response import success_response

router = APIRouter()

class CreateRefundRequest(BaseModel):
    booking_id: str
    payment_id: Optional[str] = None
    amount: float
    reason: str
    refund_method: str = "ORIGINAL"      # ORIGINAL/RAZORPAY, CASH, WALLET, BANK_TRANSFER
    upi_id: Optional[str] = None          # for manual UPI refunds
    bank_account: Optional[str] = None    # bank account number
    bank_ifsc: Optional[str] = None       # IFSC code
    beneficiary_name: Optional[str] = None

class ProcessRefundRequest(BaseModel):
    notes: Optional[str] = None
    gateway_refund_id: Optional[str] = None
    method: Optional[str] = None       # override refund method
    upi_id: Optional[str] = None
    bank_account: Optional[str] = None
    bank_ifsc: Optional[str] = None
    beneficiary_name: Optional[str] = None

@router.post("", summary="Initiate refund request")
async def create_refund(payload: CreateRefundRequest, current_user: dict = Depends(AdminOrCCO), db: AsyncSession = Depends(get_db)):
    from app.models.refund import Refund
    r = Refund(
        booking_id=UUID(payload.booking_id),
        amount=payload.amount,
        reason=payload.reason,
        refund_method=payload.refund_method,
        payment_id=UUID(payload.payment_id) if payload.payment_id else None,
        notes=f"UPI:{payload.upi_id}" if payload.upi_id else (
              f"Bank:{payload.bank_account}|IFSC:{payload.bank_ifsc}|Name:{payload.beneficiary_name}" if payload.bank_account else None),
    )
    db.add(r); await db.commit()
    return success_response(data={"id": str(r.id), "status": r.status}, message="Refund request created")

@router.get("", summary="List refunds [Admin]")
async def list_refunds(page: int = Query(1, ge=1), per_page: int = Query(20), status: Optional[str] = None,
                       current_user: dict = Depends(AdminOnly), db: AsyncSession = Depends(get_db)):
    from app.models.refund import Refund
    q = select(Refund)
    if status: q = q.where(Refund.status == status)
    total = (await db.execute(select(func.count()).select_from(q.subquery()))).scalar_one()
    items = (await db.execute(q.order_by(Refund.created_at.desc()).offset((page-1)*per_page).limit(per_page))).scalars().all()
    def _fmt(r):
        return {
            "id": str(r.id),
            "booking_id": str(r.booking_id),
            "payment_id": str(r.payment_id) if r.payment_id else None,
            "amount": r.amount,
            "reason": r.reason,
            "status": r.status,
            "refund_method": r.refund_method,
            "gateway_refund_id": r.gateway_refund_id,
            "notes": r.notes,
            "processed_at": r.processed_at.isoformat() if r.processed_at else None,
            "created_at": r.created_at.isoformat(),
        }
    return success_response(data={"items": [_fmt(r) for r in items], "total": total, "pages": (total + per_page - 1) // per_page})

@router.post("/{refund_id}/approve", summary="Approve refund [Admin]")
async def approve_refund(refund_id: UUID, payload: ProcessRefundRequest,
                         current_user: dict = Depends(AdminOnly), db: AsyncSession = Depends(get_db)):
    from app.models.refund import Refund
    from datetime import datetime, timezone
    r = (await db.execute(select(Refund).where(Refund.id == refund_id))).scalar_one_or_none()
    if not r: raise HTTPException(404, "Refund not found")
    r.status = "APPROVED"; r.processed_by = UUID(current_user["user_id"]); r.notes = payload.notes
    await db.commit()
    return success_response(message="Refund approved")

@router.post("/{refund_id}/process", summary="Mark refund processed [Admin]")
async def process_refund(refund_id: UUID, payload: ProcessRefundRequest,
                         current_user: dict = Depends(AdminOnly), db: AsyncSession = Depends(get_db)):
    from app.models.refund import Refund
    from datetime import datetime, timezone
    r = (await db.execute(select(Refund).where(Refund.id == refund_id))).scalar_one_or_none()
    if not r: raise HTTPException(404, "Refund not found")
    r.status = "PROCESSED"; r.gateway_refund_id = payload.gateway_refund_id
    r.processed_at = datetime.now(timezone.utc)
    if payload.notes: r.notes = payload.notes
    if payload.method: r.refund_method = payload.method
    await db.commit()
    return success_response(message="Refund processed")


@router.post("/{refund_id}/razorpay", summary="Initiate Razorpay refund [Admin]")
async def razorpay_refund(refund_id: UUID, current_user: dict = Depends(AdminOnly), db: AsyncSession = Depends(get_db)):
    """Calls Razorpay API to initiate the actual online refund for a payment made via Razorpay."""
    import razorpay
    from app.models.refund import Refund
    from app.models.payment import PaymentTransaction
    from app.models.system_setting import SystemSetting
    from datetime import datetime, timezone
    r = (await db.execute(select(Refund).where(Refund.id == refund_id))).scalar_one_or_none()
    if not r: raise HTTPException(404, "Refund not found")
    if r.status not in ("PENDING", "APPROVED"): raise HTTPException(400, f"Refund is already {r.status}")
    if not r.payment_id: raise HTTPException(400, "No payment linked to this refund")
    txn = (await db.execute(select(PaymentTransaction).where(PaymentTransaction.id == r.payment_id))).scalar_one_or_none()
    if not txn: raise HTTPException(404, "Payment transaction not found")
    if not txn.provider_payment_id: raise HTTPException(400, "No Razorpay payment ID on this transaction — cannot process via gateway")

    # Get Razorpay keys
    rows = (await db.execute(select(SystemSetting).where(SystemSetting.group == "payment", SystemSetting.key.in_(["razorpay_key_id", "razorpay_key_secret"])))).scalars().all()
    values = {row.key: row.value for row in rows if row.value}
    from app.core.config import settings as cfg
    key_id = values.get("razorpay_key_id") or cfg.RAZORPAY_KEY_ID
    key_secret = values.get("razorpay_key_secret") or cfg.RAZORPAY_KEY_SECRET
    if not key_id or not key_secret: raise HTTPException(500, "Razorpay keys not configured")

    try:
        client = razorpay.Client(auth=(key_id, key_secret))
        amount_paise = int(r.amount * 100)
        rzp_resp = client.payment.refund(txn.provider_payment_id, {"amount": amount_paise, "speed": "optimum"})
        r.gateway_refund_id = rzp_resp.get("id")
        r.status = "PROCESSED"
        r.processed_at = datetime.now(timezone.utc)
        r.notes = f"Razorpay refund: {r.gateway_refund_id}"
        await db.commit()
        return success_response(data={"gateway_refund_id": r.gateway_refund_id, "rzp_status": rzp_resp.get("status")}, message="Razorpay refund initiated")
    except Exception as e:
        raise HTTPException(502, f"Razorpay refund failed: {str(e)}")
