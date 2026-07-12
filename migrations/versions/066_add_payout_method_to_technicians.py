"""066_add_payout_method_to_technicians

Revision ID: 066
Revises: 065
Create Date: 2026-07-12

Adds payout method fields directly on the technicians table so that each
technician can save their UPI ID or bank details once (during registration
or profile edit) and have them auto-populated on every withdrawal request.

Fields added:
  payout_upi_id            — technician's preferred UPI ID for payouts
  payout_bank_account      — bank account number
  payout_bank_ifsc         — IFSC code (11 chars)
  payout_bank_name         — bank name (for display / admin info)
  payout_account_holder    — account holder name (may differ from tech name)
  payout_method_verified   — admin-marked flag: payment details verified
"""
from alembic import op
import sqlalchemy as sa

revision = '066'
down_revision = '065'
branch_labels = None
depends_on = None


def upgrade():
    op.execute(sa.text("""
        ALTER TABLE technicians
            ADD COLUMN IF NOT EXISTS payout_upi_id           VARCHAR(200),
            ADD COLUMN IF NOT EXISTS payout_bank_account     VARCHAR(200),
            ADD COLUMN IF NOT EXISTS payout_bank_ifsc        VARCHAR(20),
            ADD COLUMN IF NOT EXISTS payout_bank_name        VARCHAR(200),
            ADD COLUMN IF NOT EXISTS payout_account_holder   VARCHAR(200),
            ADD COLUMN IF NOT EXISTS payout_method_verified  BOOLEAN DEFAULT FALSE
    """))


def downgrade():
    op.execute(sa.text("""
        ALTER TABLE technicians
            DROP COLUMN IF EXISTS payout_upi_id,
            DROP COLUMN IF EXISTS payout_bank_account,
            DROP COLUMN IF EXISTS payout_bank_ifsc,
            DROP COLUMN IF EXISTS payout_bank_name,
            DROP COLUMN IF EXISTS payout_account_holder,
            DROP COLUMN IF EXISTS payout_method_verified
    """))
