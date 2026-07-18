"""Add tax_mode, customer GST snapshot to quotations

Revision ID: 020
Revises: 019
"""
from alembic import op
import sqlalchemy as sa

revision = '020'
down_revision = '019'
branch_labels = None
depends_on = None

def upgrade():
    # tax_mode: NONE | B2C | B2B  (default B2C = tax enabled, customer type consumer)
    op.execute(sa.text("ALTER TABLE quotations ADD COLUMN IF NOT EXISTS tax_mode VARCHAR(10) NOT NULL DEFAULT 'B2C'"))
    # B2B customer GST snapshot
    op.execute(sa.text("ALTER TABLE quotations ADD COLUMN IF NOT EXISTS customer_gst_number VARCHAR(20)"))
    op.execute(sa.text("ALTER TABLE quotations ADD COLUMN IF NOT EXISTS customer_gst_name VARCHAR(200)"))
    op.execute(sa.text("ALTER TABLE quotations ADD COLUMN IF NOT EXISTS customer_gst_address TEXT"))

def downgrade():
    op.drop_column('quotations', 'customer_gst_address')
    op.drop_column('quotations', 'customer_gst_name')
    op.drop_column('quotations', 'customer_gst_number')
    op.drop_column('quotations', 'tax_mode')
