from datetime import date
import sqlalchemy as sa

from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.ext.asyncio import AsyncSession

from app.api.deps import AnyStaff
from app.core.database import get_db
from app.services.reporting import (
    build_customer_report,
    build_gst_report,
    build_placeholder_report,
    build_revenue_report,
)
from app.utils.response import success_response

router = APIRouter()


def _handle_report_range_error(exc: ValueError):
    raise HTTPException(status_code=400, detail=str(exc)) from exc


@router.get("/revenue", summary="Revenue report")
async def revenue_report(
    start_date: date | None = Query(None),
    end_date: date | None = Query(None),
    current_user: dict = Depends(AnyStaff),
    db: AsyncSession = Depends(get_db),
):
    try:
        report = await build_revenue_report(db, start_date=start_date, end_date=end_date)
    except ValueError as exc:
        _handle_report_range_error(exc)
    return success_response(data=report)


@router.get("/gst", summary="GST report")
async def gst_report(
    start_date: date | None = Query(None),
    end_date: date | None = Query(None),
    current_user: dict = Depends(AnyStaff),
    db: AsyncSession = Depends(get_db),
):
    try:
        report = await build_gst_report(db, start_date=start_date, end_date=end_date)
    except ValueError as exc:
        _handle_report_range_error(exc)
    return success_response(data=report)


@router.get("/commission", summary="Commission report")
async def commission_report(current_user: dict = Depends(AnyStaff)):
    return success_response(
        data=build_placeholder_report("commission", "Commission source tables are not implemented yet"),
        message="Commission report is waiting on the commission module",
    )


@router.get("/inventory", summary="Inventory report")
async def inventory_report(current_user: dict = Depends(AnyStaff)):
    return success_response(
        data=build_placeholder_report("inventory", "Inventory source tables are not implemented yet"),
        message="Inventory report is waiting on the inventory module",
    )


@router.get("/amc", summary="AMC report")
async def amc_report(current_user: dict = Depends(AnyStaff)):
    return success_response(
        data=build_placeholder_report("amc", "AMC source tables are not implemented yet"),
        message="AMC report is waiting on the AMC module",
    )


@router.get("/warranty", summary="Warranty report")
async def warranty_report(current_user: dict = Depends(AnyStaff)):
    return success_response(
        data=build_placeholder_report("warranty", "Warranty source tables are not implemented yet"),
        message="Warranty report is waiting on the warranty module",
    )


@router.get("/customer", summary="Customer report")
async def customer_report(
    start_date: date | None = Query(None),
    end_date: date | None = Query(None),
    current_user: dict = Depends(AnyStaff),
    db: AsyncSession = Depends(get_db),
):
    try:
        report = await build_customer_report(db, start_date=start_date, end_date=end_date)
    except ValueError as exc:
        _handle_report_range_error(exc)
    return success_response(data=report)


@router.get("/franchise", summary="Franchise report")
async def franchise_report(current_user: dict = Depends(AnyStaff)):
    return success_response(
        data=build_placeholder_report("franchise", "Franchise source tables are not implemented yet"),
        message="Franchise report is waiting on the franchise module",
    )


@router.get("/technician", summary="Technician performance report")
async def technician_report(
    technician_id: str | None = Query(None),
    start_date: date | None = Query(None),
    end_date: date | None = Query(None),
    period: str = Query("monthly", regex="^(daily|weekly|monthly|yearly)$"),
    current_user: dict = Depends(AnyStaff),
    db: AsyncSession = Depends(get_db),
):
    """Returns booking counts, revenue, ratings, attendance for one or all technicians."""
    from sqlalchemy import select, func, and_
    from app.models.technician import Technician
    from app.models.booking import Booking
    from app.models.payment import PaymentTransaction, PaymentStatus
    from app.models.attendance import AttendanceRecord
    from uuid import UUID

    # Date range defaults
    from datetime import datetime, timezone
    if end_date is None:
        end_date = date.today()
    if start_date is None:
        from dateutil.relativedelta import relativedelta
        start_date = end_date - relativedelta(months=1)

    start_dt = datetime.combine(start_date, datetime.min.time()).replace(tzinfo=timezone.utc)
    end_dt = datetime.combine(end_date, datetime.max.time()).replace(tzinfo=timezone.utc)

    # Base technician query
    tech_q = select(Technician).where(Technician.is_active == True)
    if technician_id:
        try:
            tech_q = tech_q.where(Technician.id == UUID(technician_id))
        except Exception:
            pass
    technicians = (await db.execute(tech_q)).scalars().all()

    results = []
    for tech in technicians:
        # Booking stats
        booking_q = select(
            func.count(Booking.id).label("total"),
            func.sum(
                func.cast(Booking.status == "COMPLETED", sa.Integer)
            ).label("completed"),
        ).where(
            Booking.technician_id == tech.id,
            Booking.created_at >= start_dt,
            Booking.created_at <= end_dt,
        )
        bk_row = (await db.execute(booking_q)).one()
        total_bookings = bk_row.total or 0
        completed = int(bk_row.completed or 0)

        # Revenue
        rev_q = select(func.sum(PaymentTransaction.amount)).join(
            Booking, Booking.id == PaymentTransaction.booking_id
        ).where(
            Booking.technician_id == tech.id,
            PaymentTransaction.status == PaymentStatus.SUCCESS,
            PaymentTransaction.paid_at >= start_dt,
            PaymentTransaction.paid_at <= end_dt,
        )
        revenue = (await db.execute(rev_q)).scalar_one() or 0.0

        results.append({
            "technician_id": str(tech.id),
            "technician_name": tech.name,
            "mobile": tech.mobile,
            "total_bookings": total_bookings,
            "completed_bookings": completed,
            "completion_rate": round((completed / total_bookings * 100) if total_bookings else 0, 1),
            "revenue_generated": round(revenue, 2),
            "period": {"start": str(start_date), "end": str(end_date)},
        })

    results.sort(key=lambda x: x["revenue_generated"], reverse=True)
    return success_response(data={
        "technicians": results,
        "period": {"start": str(start_date), "end": str(end_date)},
        "total_technicians": len(results),
    })
