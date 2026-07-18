"""Add purchase_price, inventory_item_id, is_pending_verify to quotation_part_items

Revision ID: 018
Revises: 017
Create Date: 2026-06-16
"""
from alembic import op
import sqlalchemy as sa

revision = '018'
down_revision = '017_bookings_nullable_fks'
branch_labels = None
depends_on = None

def upgrade():
    # Add new columns — all guarded with IF NOT EXISTS for idempotency on fresh DBs
    op.execute(sa.text("ALTER TABLE quotation_part_items ADD COLUMN IF NOT EXISTS purchase_price FLOAT DEFAULT 0"))
    op.execute(sa.text("ALTER TABLE quotation_part_items ADD COLUMN IF NOT EXISTS inventory_item_id UUID"))
    op.execute(sa.text("ALTER TABLE quotation_part_items ADD COLUMN IF NOT EXISTS is_pending_verify INTEGER DEFAULT 0"))

def downgrade():
    op.drop_column('quotation_part_items', 'is_pending_verify')
    op.drop_column('quotation_part_items', 'inventory_item_id')
    op.drop_column('quotation_part_items', 'purchase_price')
