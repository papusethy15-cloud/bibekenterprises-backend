"""048_vps_payment_transactions_hotfix

VPS hotfix: adds columns to payment_transactions that were defined in
migration 036_pay_later_proper but never applied on the VPS because the
VPS DB was bootstrapped from a pre-036 snapshot.

Columns added (both idempotent with IF NOT EXISTS):
  - payment_transactions.due_collect_at   TIMESTAMP WITH TIME ZONE
  - payment_transactions.last_reminder_at TIMESTAMP WITH TIME ZONE

Also ensures the PAY_LATER enum value exists on paymentmethod.

Revision ID: 048
Revises: 047
Create Date: 2026-07-07
"""
from alembic import op
import sqlalchemy as sa

revision = '048'
down_revision = '047'
branch_labels = None
depends_on = None


def upgrade():
    # ── payment_transactions: due_collect_at ─────────────────────────────
    op.execute(
        "ALTER TABLE payment_transactions "
        "ADD COLUMN IF NOT EXISTS due_collect_at TIMESTAMP WITH TIME ZONE"
    )

    # ── payment_transactions: last_reminder_at ───────────────────────────
    op.execute(
        "ALTER TABLE payment_transactions "
        "ADD COLUMN IF NOT EXISTS last_reminder_at TIMESTAMP WITH TIME ZONE"
    )

    # ── paymentmethod enum: PAY_LATER value ──────────────────────────────
    # Safe no-op if the value already exists
    op.execute("ALTER TYPE paymentmethod ADD VALUE IF NOT EXISTS 'PAY_LATER'")


def downgrade():
    op.execute("ALTER TABLE payment_transactions DROP COLUMN IF EXISTS last_reminder_at")
    op.execute("ALTER TABLE payment_transactions DROP COLUMN IF EXISTS due_collect_at")
    # Note: cannot remove enum values in PostgreSQL without recreating the type
