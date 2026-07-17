from typing import Any, Optional
from datetime import datetime, date, timezone

def success_response(data: Any = None, message: str = "Success") -> dict:
    return {"success": True, "message": message, "data": data}

def error_response(message: str, errors: Optional[dict] = None) -> dict:
    return {"success": False, "message": message, "errors": errors or {}}

def iso(dt: datetime | date | None) -> str | None:
    """Return ISO-8601 string for a datetime or plain date.

    - datetime (naive)  → treated as UTC → '2026-07-14T05:30:56+00:00'
    - datetime (aware)  → returned as-is in ISO format
    - date              → returned as plain date string '2026-07-14'
    - None              → None
    """
    if dt is None:
        return None
    # plain date (not datetime) — just return YYYY-MM-DD
    if type(dt) is date:
        return dt.isoformat()
    # datetime from here
    if dt.tzinfo is None:
        dt = dt.replace(tzinfo=timezone.utc)
    return dt.isoformat()
