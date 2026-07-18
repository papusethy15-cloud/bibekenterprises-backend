"""048_vps_payment_transactions_hotfix

VPS hotfix: adds columns to payment_transactions that were defined in
migration 036_pay_later_proper but never applied on the VPS because the
VPS DB was bootstrapped from a pre-036 snapshot.

Columns added (both idempotent with IF NOT EXISTS):
  - payment_transactions.due_collect_at   TIMESTAMP WITH TIME ZONE
  - payment_transactions.last_reminder_at TIMESTAMP WITH TIME ZONE

Also ensures the PAY_LATER enum value exists on paymentmethod.

NOTE: ALTER TYPE ADD VALUE cannot run inside a PostgreSQL transaction block.
      We use AUTOCOMMIT isolation for that single statement only.

Revision ID: 048
Revises: 047
Create Date: 2026-07-07
"""
from alembic import op
import sqlalchemy as sa
from sqlalchemy import text

revision = '048'
down_revision = '047'
branch_labels = None
depends_on = None


def upgrade():
    # ── payment_transactions: due_collect_at ─────────────────────────────
    op.execute(text(
        "ALTER TABLE payment_transactions "
        "ADD COLUMN IF NOT EXISTS due_collect_at TIMESTAMP WITH TIME ZONE"
    ))

    # ── payment_transactions: last_reminder_at ───────────────────────────
    op.execute(text(
        "ALTER TABLE payment_transactions "
        "ADD COLUMN IF NOT EXISTS last_reminder_at TIMESTAMP WITH TIME ZONE"
    ))

    # ── paymentmethod / paymentstatus enum: PAY_LATER / CANCELLED values ─
    # ALTER TYPE ADD VALUE cannot run inside a transaction block in PostgreSQL.
    # Use Alembic's autocommit_block() — the correct API for async engines.
    with op.get_context().autocommit_block():
        op.execute(text("ALTER TYPE paymentmethod ADD VALUE IF NOT EXISTS 'PAY_LATER'"))
        op.execute(text("ALTER TYPE paymentstatus ADD VALUE IF NOT EXISTS 'CANCELLED'"))


def downgrade():
    op.execute("ALTER TABLE payment_transactions DROP COLUMN IF EXISTS last_reminder_at")
    op.execute("ALTER TABLE payment_transactions DROP COLUMN IF EXISTS due_collect_at")
    # Note: cannot remove enum values in PostgreSQL without recreating the type
