"""065_add_payment_reference_to_withdrawal_requests

Revision ID: 065
Revises: 064
Create Date: 2026-07-12

Adds payment_reference column to withdrawal_requests table.

When an admin approves a withdrawal they must enter the UTR / UPI
transaction reference number from their bank or UPI app. That value is
stored here so it can be displayed to the technician in their wallet
history and used for audit purposes.

Also stored in wallet_transactions.reference_id at the application
layer in wallet.py — no schema change needed there as that column
already exists.
"""
from alembic import op
import sqlalchemy as sa

revision = '065'
down_revision = '064'
branch_labels = None
depends_on = None


def upgrade():
    # IF NOT EXISTS makes this idempotent — safe to run on VPS even if
    # the column was already added manually via psql.
    op.execute(sa.text("""
        ALTER TABLE withdrawal_requests
            ADD COLUMN IF NOT EXISTS payment_reference VARCHAR(300)
    """))


def downgrade():
    op.execute(sa.text("""
        ALTER TABLE withdrawal_requests
            DROP COLUMN IF EXISTS payment_reference
    """))
