"""062_customer_address_location_source

ROOT CAUSE
===========
Migration 044 (payment_status_cancelled) used op.get_bind() which caused
an "Aborted!" in asyncpg's run_sync bridge on VPS — the transaction was
aborted mid-migration.

Even though 045 and 046 were stamped, 046's op.add_column for
customer_addresses.location_source may have been rolled back as part of
the 044 transaction failure, leaving the column absent on VPS.

This migration adds the column idempotently using IF NOT EXISTS.

SYMPTOM FIXED
==============
GET /assignments/candidates/{booking_id} → HTTP 500:
  "UndefinedColumnError: column customer_addresses.location_source
   does not exist"

This fires because the candidates endpoint JOINs customer_addresses to
resolve the booking address for distance scoring — triggering a full
SELECT on the table which includes the missing column.

Revision ID: 062
Revises: 061
Create Date: 2026-07-10
"""
from alembic import op
from sqlalchemy import text

revision = '062'
down_revision = '061'
branch_labels = None
depends_on = None


def upgrade() -> None:
    op.execute(text(
        "ALTER TABLE customer_addresses "
        "ADD COLUMN IF NOT EXISTS location_source VARCHAR(50)"
    ))
    print("[062] customer_addresses.location_source ensured.")


def downgrade() -> None:
    op.execute(text(
        "ALTER TABLE customer_addresses "
        "DROP COLUMN IF EXISTS location_source"
    ))
