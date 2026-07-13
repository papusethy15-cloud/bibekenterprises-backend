from fastapi import APIRouter, Depends, Query
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select, func, and_, desc
from datetime import datetime, timedelta, date
from app.core.database import get_db
from app.api.deps import AdminOnly, AnyStaff
from app.utils.response import success_response

router = APIRouter()

@router.get("/dashboard", summary="Dashboard KPIs [Admin]")
async def dashboard_kpis(current_user: dict = Depends(AnyStaff), db: AsyncSession = Depends(get_db)):
    from app.models.booking import Booking, BookingStatus
    from app.models.customer import Customer
    from app.models.technician import Technician
    from app.models.escalation import Escalation, EscalationStatus

    now = datetime.utcnow()
    today = now.replace(hour=0, minute=0, second=0, microsecond=0)
    week_start = today - timedelta(days=today.weekday())
    month_start = today.replace(day=1)
    prev_month_end = month_start - timedelta(days=1)
    prev_month_start = prev_month_end.replace(day=1)

    # ── Booking KPIs ──────────────────────────────────────────
    total_bookings        = (await db.execute(select(func.count()).select_from(Booking))).scalar_one()
    today_bookings        = (await db.execute(select(func.count()).select_from(Booking).where(Booking.created_at >= today))).scalar_one()
    week_bookings         = (await db.execute(select(func.count()).select_from(Booking).where(Booking.created_at >= week_start))).scalar_one()
    pending_bookings      = (await db.execute(select(func.count()).select_from(Booking).where(Booking.status == BookingStatus.PENDING))).scalar_one()
    confirmed_bookings    = (await db.execute(select(func.count()).select_from(Booking).where(Booking.status == BookingStatus.CONFIRMED))).scalar_one()
    in_progress_bookings  = (await db.execute(select(func.count()).select_from(Booking).where(Booking.status == BookingStatus.IN_PROGRESS))).scalar_one()
    completed_this_month  = (await db.execute(select(func.count()).select_from(Booking).where(and_(Booking.status == BookingStatus.COMPLETED, Booking.created_at >= month_start)))).scalar_one()
    cancelled_this_month  = (await db.execute(select(func.count()).select_from(Booking).where(and_(Booking.status == BookingStatus.CANCELLED, Booking.created_at >= month_start)))).scalar_one()
    total_completed       = (await db.execute(select(func.count()).select_from(Booking).where(Booking.status == BookingStatus.COMPLETED))).scalar_one()

    # ── Revenue ───────────────────────────────────────────────
    total_revenue    = (await db.execute(select(func.coalesce(func.sum(Booking.total_amount), 0)).where(Booking.status == BookingStatus.COMPLETED))).scalar_one()
    month_revenue    = (await db.execute(select(func.coalesce(func.sum(Booking.total_amount), 0)).where(and_(Booking.status == BookingStatus.COMPLETED, Booking.created_at >= month_start)))).scalar_one()
    week_revenue     = (await db.execute(select(func.coalesce(func.sum(Booking.total_amount), 0)).where(and_(Booking.status == BookingStatus.COMPLETED, Booking.created_at >= week_start)))).scalar_one()
    today_revenue    = (await db.execute(select(func.coalesce(func.sum(Booking.total_amount), 0)).where(and_(Booking.status == BookingStatus.COMPLETED, Booking.created_at >= today)))).scalar_one()
    prev_month_rev   = (await db.execute(select(func.coalesce(func.sum(Booking.total_amount), 0)).where(and_(Booking.status == BookingStatus.COMPLETED, Booking.created_at >= prev_month_start, Booking.created_at <= prev_month_end)))).scalar_one()

    # ── Revenue last 30 days daily chart ─────────────────────
    since_30 = now - timedelta(days=29)
    daily_rev_rows = (await db.execute(
        select(func.date(Booking.created_at).label("d"), func.coalesce(func.sum(Booking.total_amount), 0).label("rev"), func.count(Booking.id).label("cnt"))
        .where(and_(Booking.status == BookingStatus.COMPLETED, Booking.created_at >= since_30))
        .group_by(func.date(Booking.created_at)).order_by(func.date(Booking.created_at))
    )).all()
    revenue_chart = [{"date": str(r.d), "revenue": round(float(r.rev), 2), "bookings": r.cnt} for r in daily_rev_rows]

    # ── Booking status breakdown (last 30 days) ───────────────
    status_rows = (await db.execute(
        select(Booking.status, func.count(Booking.id))
        .where(Booking.created_at >= since_30).group_by(Booking.status)
    )).all()
    status_chart = {s.value: c for s, c in status_rows}

    # ── Monthly booking trend (last 6 months) ─────────────────
    since_6m = now - timedelta(days=180)
    monthly_trend_rows = (await db.execute(
        select(
            func.to_char(Booking.created_at, "YYYY-MM").label("month"),
            func.count(Booking.id).label("total"),
            func.sum(func.cast(Booking.status == BookingStatus.COMPLETED, func.count().type)).label("completed"),
        )
        .where(Booking.created_at >= since_6m)
        .group_by(func.to_char(Booking.created_at, "YYYY-MM"))
        .order_by(func.to_char(Booking.created_at, "YYYY-MM"))
    )).all()
    monthly_trend = [{"month": r.month, "total": r.total, "completed": r.completed or 0} for r in monthly_trend_rows]

    # ── Customer KPIs ─────────────────────────────────────────
    total_customers     = (await db.execute(select(func.count()).select_from(Customer))).scalar_one()
    new_customers_month = (await db.execute(select(func.count()).select_from(Customer).where(Customer.created_at >= month_start))).scalar_one()
    new_customers_today = (await db.execute(select(func.count()).select_from(Customer).where(Customer.created_at >= today))).scalar_one()

    # ── Technician KPIs ───────────────────────────────────────
    active_techs = (await db.execute(select(func.count()).select_from(Technician).where(Technician.status == "ACTIVE"))).scalar_one()
    total_techs  = (await db.execute(select(func.count()).select_from(Technician).where(Technician.is_active == True))).scalar_one()

    # ── Top technicians ───────────────────────────────────────
    top_techs = (await db.execute(
        select(Technician).where(Technician.is_active == True)
        .order_by(desc(Technician.total_jobs)).limit(5)
    )).scalars().all()
    top_technicians = [
        {"id": str(t.id), "name": t.name, "rating": t.rating or 0, "total_jobs": t.total_jobs or 0, "status": t.status}
        for t in top_techs
    ]

    # ── Recent bookings ───────────────────────────────────────
    from app.models.customer import Customer as Cust
    recent_bk_rows = (await db.execute(
        select(Booking, Cust.name.label("customer_name"))
        .outerjoin(Cust, Cust.id == Booking.customer_id)
        .order_by(desc(Booking.created_at)).limit(8)
    )).all()
    recent_bookings = [
        {
            "id": str(bk.id),
            "booking_number": bk.booking_number,
            "customer_name": cname or "—",
            "status": bk.status.value if bk.status else "UNKNOWN",
            "total_amount": float(bk.total_amount or 0),
            "created_at": bk.created_at.isoformat() if bk.created_at else None,
        }
        for bk, cname in recent_bk_rows
    ]

    # ── Escalation count ──────────────────────────────────────
    open_escalations = 0
    try:
        open_escalations = (await db.execute(
            select(func.count()).select_from(Escalation).where(Escalation.status == EscalationStatus.OPEN)
        )).scalar_one()
    except Exception:
        pass

    # ── Completion rate ───────────────────────────────────────
    completion_rate = round((total_completed / total_bookings * 100) if total_bookings else 0, 1)
    month_growth = round(((float(month_revenue) - float(prev_month_rev)) / float(prev_month_rev) * 100) if prev_month_rev else 0, 1)

    return success_response(data={
        "bookings": {
            "total": total_bookings,
            "today": today_bookings,
            "this_week": week_bookings,
            "pending": pending_bookings,
            "confirmed": confirmed_bookings,
            "in_progress": in_progress_bookings,
            "completed_this_month": completed_this_month,
            "cancelled_this_month": cancelled_this_month,
            "total_completed": total_completed,
            "completion_rate": completion_rate,
        },
        "revenue": {
            "total": round(float(total_revenue), 2),
            "this_month": round(float(month_revenue), 2),
            "this_week": round(float(week_revenue), 2),
            "today": round(float(today_revenue), 2),
            "prev_month": round(float(prev_month_rev), 2),
            "month_growth": month_growth,
        },
        "customers": {
            "total": total_customers,
            "new_this_month": new_customers_month,
            "new_today": new_customers_today,
        },
        "technicians": {
            "active": active_techs,
            "total": total_techs,
        },
        "open_escalations": open_escalations,
        "charts": {
            "revenue_last_30_days": revenue_chart,
            "booking_status": status_chart,
            "monthly_trend": monthly_trend,
        },
        "top_technicians": top_technicians,
        "recent_bookings": recent_bookings,
    })

@router.get("/revenue", summary="Revenue analytics [Admin]")
async def revenue_analytics(
    period: str = Query("monthly", regex="^(daily|weekly|monthly)$"),
    current_user: dict = Depends(AnyStaff), db: AsyncSession = Depends(get_db)
):
    from app.models.booking import Booking, BookingStatus
    days = 30 if period == "monthly" else (7 if period == "weekly" else 14)
    since = datetime.utcnow() - timedelta(days=days)
    result = await db.execute(
        select(func.date(Booking.created_at).label("date"),
               func.coalesce(func.sum(Booking.total_amount), 0).label("revenue"),
               func.count(Booking.id).label("count"))
        .where(and_(Booking.status == BookingStatus.COMPLETED, Booking.created_at >= since))
        .group_by(func.date(Booking.created_at)).order_by(func.date(Booking.created_at))
    )
    rows = result.all()
    return success_response(data={"period": period, "data": [
        {"date": str(r.date), "revenue": round(float(r.revenue), 2), "bookings": r.count} for r in rows
    ]})

@router.get("/bookings", summary="Booking analytics [Admin]")
async def booking_analytics(current_user: dict = Depends(AnyStaff), db: AsyncSession = Depends(get_db)):
    from app.models.booking import Booking, BookingStatus
    since = datetime.utcnow() - timedelta(days=30)
    status_counts = (await db.execute(
        select(Booking.status, func.count(Booking.id))
        .where(Booking.created_at >= since).group_by(Booking.status)
    )).all()
    return success_response(data={
        "by_status": {s.value: c for s, c in status_counts},
        "period": "last_30_days"
    })

@router.get("/technicians", summary="Technician analytics [Admin]")
async def technician_analytics(current_user: dict = Depends(AnyStaff), db: AsyncSession = Depends(get_db)):
    from app.models.technician import Technician
    techs = (await db.execute(select(Technician).where(Technician.is_active == True).order_by(Technician.rating.desc()).limit(10))).scalars().all()
    return success_response(data={"top_technicians": [
        {"id": str(t.id), "name": t.name, "rating": t.rating, "total_jobs": t.total_jobs} for t in techs
    ]})

@router.get("/customers", summary="Customer analytics [Admin]")
async def customer_analytics(current_user: dict = Depends(AnyStaff), db: AsyncSession = Depends(get_db)):
    from app.models.customer import Customer
    since = datetime.utcnow() - timedelta(days=30)
    new_this_month = (await db.execute(select(func.count()).select_from(Customer).where(Customer.created_at >= since))).scalar_one()
    total = (await db.execute(select(func.count()).select_from(Customer))).scalar_one()
    return success_response(data={"total_customers": total, "new_this_month": new_this_month})
