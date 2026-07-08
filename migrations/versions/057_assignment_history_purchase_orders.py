"""057_assignment_history_purchase_orders

Fixes two missing schema items on VPS:
  1. assignment_history.response_deadline + screen_shown_at columns
  2. purchase_orders table

All DDL already applied via vps_fix_057.sql directly on VPS.
This migration is a no-op to advance the alembic head to 057.

Revision ID: 057
Revises: 056
"""
from alembic import op
from sqlalchemy import text

revision = '057'
down_revision = '056'
branch_labels = None
depends_on = None


def upgrade():
    op.execute(text("ALTER TABLE assignment_history ADD COLUMN IF NOT EXISTS response_deadline TIMESTAMP WITH TIME ZONE"))
    op.execute(text("ALTER TABLE assignment_history ADD COLUMN IF NOT EXISTS screen_shown_at   TIMESTAMP WITH TIME ZONE"))

    op.execute(text("""
        CREATE TABLE IF NOT EXISTS purchase_orders (
            id               UUID          PRIMARY KEY DEFAULT gen_random_uuid(),
            po_number        VARCHAR(30)   NOT NULL UNIQUE,
            vendor_id        UUID          REFERENCES vendors(id) ON DELETE SET NULL,
            vendor_name      VARCHAR(200),
            vendor_invoice_no VARCHAR(100),
            warehouse_id     UUID          REFERENCES warehouses(id) ON DELETE SET NULL,
            items_json       TEXT          NOT NULL DEFAULT '[]',
            subtotal         FLOAT         DEFAULT 0,
            tax_amount       FLOAT         DEFAULT 0,
            total_amount     FLOAT         DEFAULT 0,
            payment_method   VARCHAR(30)   DEFAULT 'CASH',
            payment_status   VARCHAR(20)   DEFAULT 'PAID',
            status           VARCHAR(20)   DEFAULT 'RECEIVED',
            notes            TEXT,
            received_at      TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
            created_by       UUID          REFERENCES users(id) ON DELETE SET NULL,
            is_active        BOOLEAN       DEFAULT true,
            created_at       TIMESTAMP WITH TIME ZONE DEFAULT NOW()
        )
    """))
    op.execute(text("CREATE INDEX IF NOT EXISTS ix_po_number    ON purchase_orders (po_number)"))
    op.execute(text("CREATE INDEX IF NOT EXISTS ix_po_warehouse ON purchase_orders (warehouse_id)"))
    op.execute(text("CREATE INDEX IF NOT EXISTS ix_po_vendor    ON purchase_orders (vendor_id)"))
    print("[057] assignment_history columns + purchase_orders table ensured.")


def downgrade():
    op.execute(text("DROP TABLE IF EXISTS purchase_orders"))
    op.execute(text("ALTER TABLE assignment_history DROP COLUMN IF EXISTS screen_shown_at"))
    op.execute(text("ALTER TABLE assignment_history DROP COLUMN IF EXISTS response_deadline"))
