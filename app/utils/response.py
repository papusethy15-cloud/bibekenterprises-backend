from typing import Any, Optional
from datetime import datetime, timezone

def success_response(data: Any = None, message: str = "Success") -> dict:
    return {"success": True, "message": message, "data": data}

def error_response(message: str, errors: Optional[dict] = None) -> dict:
    return {"success": False, "message": message, "errors": errors or {}}

def iso(dt: datetime | None) -> str | None:
    """Return UTC-aware ISO-8601 string for any datetime (naive or aware).

    Guarantees the browser receives e.g. '2026-07-14T05:30:56+00:00' so that
    JavaScript's ``new Date()`` parses it as UTC and ``toLocaleString`` with
    timeZone 'Asia/Kolkata' displays the correct IST time (+05:30).

    Naive datetimes (no tzinfo) are assumed to be UTC — which is always the
    case here since ``BaseModel._utcnow()`` uses ``datetime.now(timezone.utc)``.
    """
    if dt is None:
        return None
    if dt.tzinfo is None:
        dt = dt.replace(tzinfo=timezone.utc)
    return dt.isoformat()
