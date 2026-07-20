"""VPS missing columns fix: inventory_items.gst_percent, vendors.contact_person

Revision ID: 076
Revises: 075
Create Date: 2026-07-20
"""
from alembic import op
import sqlalchemy as sa

revision = '076'
down_revision = '075'
branch_labels = None
depends_on = None


def upgrade():
    conn = op.get_bind()

    # Fix 1: inventory_items.gst_percent
    exists = conn.execute(sa.text(
        "SELECT 1 FROM information_schema.columns "
        "WHERE table_name='inventory_items' AND column_name='gst_percent'"
    )).fetchone()
    if not exists:
        conn.execute(sa.text(
            "ALTER TABLE inventory_items ADD COLUMN gst_percent FLOAT DEFAULT 18.0"
        ))
        print("[OK] Added inventory_items.gst_percent")
    else:
        print("[SKIP] inventory_items.gst_percent already exists")

    # Fix 2: vendors.contact_person
    exists = conn.execute(sa.text(
        "SELECT 1 FROM information_schema.columns "
        "WHERE table_name='vendors' AND column_name='contact_person'"
    )).fetchone()
    if not exists:
        conn.execute(sa.text(
            "ALTER TABLE vendors ADD COLUMN contact_person VARCHAR(150)"
        ))
        print("[OK] Added vendors.contact_person")
    else:
        print("[SKIP] vendors.contact_person already exists")


def downgrade():
    conn = op.get_bind()
    conn.execute(sa.text("ALTER TABLE inventory_items DROP COLUMN IF EXISTS gst_percent"))
    conn.execute(sa.text("ALTER TABLE vendors DROP COLUMN IF EXISTS contact_person"))
