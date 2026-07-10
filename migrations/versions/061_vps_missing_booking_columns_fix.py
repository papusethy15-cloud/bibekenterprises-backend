"""061_vps_missing_booking_columns_fix

ROOT CAUSE ANALYSIS
====================
Two endpoints fail on VPS with HTTP 500:

1. GET /captain/me/jobs  → "Failed to load jobs" on technician app
2. GET /assignments/candidates/{booking_id} → "Internal server error" on admin dashboard

Both crash because SQLAlchemy tries to access columns that do NOT exist in the
VPS PostgreSQL database. The columns are present on local (created via create_all)
but were never reliably applied on VPS via Alembic.

MISSING COLUMNS (bookings table):
──────────────────────────────────
• inspection_notes (TEXT)
  Added in migration 028 — but 028 uses `op.get_bind()` which causes
  "Aborted!" in async context on VPS → column was never actually created.

• inspection_photos (TEXT)
  Same migration 028 — same failure.

• inspection_submitted_by (VARCHAR 20)
  Added in migration 040 — uses bare `op.execute("")` (plain string, not
  text()) which also causes silent failure in asyncpg's run_sync bridge.

• pre_reschedule_status (VARCHAR 30)
  Added in migration 041 — uses op.add_column which SHOULD work, but if
  040 aborted, Alembic may have stamped the wrong version and 041 never ran.

MISSING COLUMNS (technicians table):
─────────────────────────────────────
• last_seen_at (TIMESTAMPTZ)
  Supposed to be added in 053/055 — but 053 used op.get_bind() → failed.
  Migration 055 was the guaranteed re-apply, but we add it here as belt+suspenders.

HOW env.py RUNS THIS MIGRATION:
─────────────────────────────────
env.py stamps STAMP_AT='057', runs upgrade to FINAL_MIGRATION.
We update FINAL_MIGRATION to '061' and STAMP_AT to '060' so Alembic
runs exactly this one migration on VPS startup.

All DDL uses IF NOT EXISTS / DO $$ guards — 100% idempotent.

Revision ID: 061
Revises: 060
Create Date: 2026-07-10
"""
from alembic import op
from sqlalchemy import text

revision = '061'
down_revision = '060'
branch_labels = None
depends_on = None


def upgrade() -> None:
    # ── bookings: inspection fields (migration 028 failed on VPS) ─────────────
    op.execute(text(
        "ALTER TABLE bookings ADD COLUMN IF NOT EXISTS inspection_notes  TEXT"
    ))
    op.execute(text(
        "ALTER TABLE bookings ADD COLUMN IF NOT EXISTS inspection_photos TEXT"
    ))

    # ── bookings: inspection_submitted_by (migration 040 failed on VPS) ───────
    op.execute(text(
        "ALTER TABLE bookings ADD COLUMN IF NOT EXISTS inspection_submitted_by VARCHAR(20)"
    ))

    # ── bookings: pre_reschedule_status (migration 041 may have missed) ───────
    op.execute(text(
        "ALTER TABLE bookings ADD COLUMN IF NOT EXISTS pre_reschedule_status VARCHAR(30)"
    ))

    # ── technicians: last_seen_at (belt+suspenders after 055) ─────────────────
    op.execute(text(
        "ALTER TABLE technicians ADD COLUMN IF NOT EXISTS last_seen_at TIMESTAMP WITH TIME ZONE"
    ))

    # ── technicians: last_lat / last_lng (same safety net) ────────────────────
    op.execute(text(
        "ALTER TABLE technicians ADD COLUMN IF NOT EXISTS last_lat DOUBLE PRECISION"
    ))
    op.execute(text(
        "ALTER TABLE technicians ADD COLUMN IF NOT EXISTS last_lng DOUBLE PRECISION"
    ))

    # ── technicians: is_online (same safety net) ──────────────────────────────
    op.execute(text(
        "ALTER TABLE technicians ADD COLUMN IF NOT EXISTS is_online BOOLEAN NOT NULL DEFAULT FALSE"
    ))

    # ── technicians: auto_assign_eligible (same safety net) ───────────────────
    op.execute(text(
        "ALTER TABLE technicians ADD COLUMN IF NOT EXISTS auto_assign_eligible BOOLEAN NOT NULL DEFAULT TRUE"
    ))

    # ── assignment_history: response_deadline + screen_shown_at (057 safety) ──
    op.execute(text(
        "ALTER TABLE assignment_history ADD COLUMN IF NOT EXISTS response_deadline TIMESTAMP WITH TIME ZONE"
    ))
    op.execute(text(
        "ALTER TABLE assignment_history ADD COLUMN IF NOT EXISTS screen_shown_at   TIMESTAMP WITH TIME ZONE"
    ))

    print("[061] VPS missing booking/technician columns ensured — all IF NOT EXISTS.")


def downgrade() -> None:
    # These are all nullable additions; safe to drop if needed.
    op.execute(text("ALTER TABLE assignment_history DROP COLUMN IF EXISTS screen_shown_at"))
    op.execute(text("ALTER TABLE assignment_history DROP COLUMN IF EXISTS response_deadline"))
    op.execute(text("ALTER TABLE bookings DROP COLUMN IF EXISTS pre_reschedule_status"))
    op.execute(text("ALTER TABLE bookings DROP COLUMN IF EXISTS inspection_submitted_by"))
    op.execute(text("ALTER TABLE bookings DROP COLUMN IF EXISTS inspection_photos"))
    op.execute(text("ALTER TABLE bookings DROP COLUMN IF EXISTS inspection_notes"))
