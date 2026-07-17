"""add is_salary_group and salary structure to commission_groups

Revision ID: 071_add_is_salary_group
Revises: 070_add_is_active_to_quotation_part_items
Create Date: 2026-07-17

"""
from alembic import op
import sqlalchemy as sa

revision = '071_add_is_salary_group'
down_revision = '070'
branch_labels = None
depends_on = None


def upgrade():
    op.add_column('commission_groups',
        sa.Column('is_salary_group', sa.Boolean(), nullable=False, server_default='false'))
    op.add_column('commission_groups',
        sa.Column('monthly_salary', sa.Float(), nullable=True))
    op.add_column('commission_groups',
        sa.Column('petrol_amount', sa.Float(), nullable=True, server_default='0'))
    op.add_column('commission_groups',
        sa.Column('mobile_recharge', sa.Float(), nullable=True, server_default='0'))
    op.add_column('commission_groups',
        sa.Column('bonus_amount', sa.Float(), nullable=True, server_default='0'))
    op.add_column('commission_groups',
        sa.Column('hra_amount', sa.Float(), nullable=True, server_default='0'))
    op.add_column('commission_groups',
        sa.Column('other_allowances', sa.Float(), nullable=True, server_default='0'))
    op.add_column('commission_groups',
        sa.Column('salary_notes', sa.String(500), nullable=True))


def downgrade():
    op.drop_column('commission_groups', 'salary_notes')
    op.drop_column('commission_groups', 'other_allowances')
    op.drop_column('commission_groups', 'hra_amount')
    op.drop_column('commission_groups', 'bonus_amount')
    op.drop_column('commission_groups', 'mobile_recharge')
    op.drop_column('commission_groups', 'petrol_amount')
    op.drop_column('commission_groups', 'monthly_salary')
    op.drop_column('commission_groups', 'is_salary_group')
