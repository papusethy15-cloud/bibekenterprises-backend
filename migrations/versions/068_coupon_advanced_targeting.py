"""068 coupon advanced targeting

Revision ID: 068_coupon_advanced_targeting
Revises: 067
Create Date: 2026-07-13
"""

from alembic import op
import sqlalchemy as sa
from sqlalchemy.dialects.postgresql import ARRAY, UUID

revision = '068'
down_revision = '067'
branch_labels = None
depends_on = None

def upgrade():
    op.add_column('coupons', sa.Column('customer_mobile_numbers', ARRAY(sa.String()), nullable=True))
    op.add_column('coupons', sa.Column('service_ids', ARRAY(sa.String()), nullable=True))
    op.add_column('coupons', sa.Column('category_ids', ARRAY(sa.String()), nullable=True))
    op.add_column('coupons', sa.Column('per_customer_limit', sa.Integer(), nullable=True))

def downgrade():
    op.drop_column('coupons', 'customer_mobile_numbers')
    op.drop_column('coupons', 'service_ids')
    op.drop_column('coupons', 'category_ids')
    op.drop_column('coupons', 'per_customer_limit')
