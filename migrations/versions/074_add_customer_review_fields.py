"""Add customer review fields to bookings table

Revision ID: 074_add_customer_review_fields
Revises: 073_cco_attendance_and_salary
Create Date: 2026-07-18
"""
from alembic import op
import sqlalchemy as sa
from sqlalchemy import text

revision = '074_add_customer_review_fields'
down_revision = '073_cco_attendance_and_salary'
branch_labels = None
depends_on = None


def _column_exists(bind, table_name: str, column_name: str) -> bool:
    result = bind.execute(text(
        "SELECT EXISTS (SELECT 1 FROM information_schema.columns "
        "WHERE table_name = :t AND column_name = :c)"
    ), {"t": table_name, "c": column_name})
    return result.scalar()


def upgrade():
    bind = op.get_bind()
    cols = [
        ('customer_rating', sa.Float()),
        ('customer_review', sa.Text()),
        ('customer_name',   sa.String(120)),
        ('customer_city',   sa.String(80)),
    ]
    for col_name, col_type in cols:
        if not _column_exists(bind, 'bookings', col_name):
            op.add_column('bookings', sa.Column(col_name, col_type, nullable=True))
        else:
            print(f"[INFO] 074: bookings.{col_name} already exists — skipping")


def downgrade():
    bind = op.get_bind()
    for col in ['customer_city', 'customer_name', 'customer_review', 'customer_rating']:
        if _column_exists(bind, 'bookings', col):
            op.drop_column('bookings', col)
