"""widen commissions.item_type from VARCHAR(20) to VARCHAR(50)

Revision ID: 069
Revises: 068
Create Date: 2026-07-14

Reason: PURCHASE_REIMBURSEMENT (22 chars) exceeds the old VARCHAR(20) limit,
causing StringDataRightTruncationError during booking settlement.
"""

from alembic import op
import sqlalchemy as sa

revision = '069'
down_revision = '068'
branch_labels = None
depends_on = None


def upgrade():
    op.alter_column(
        'commissions',
        'item_type',
        existing_type=sa.String(20),
        type_=sa.String(50),
        existing_nullable=True,
    )


def downgrade():
    # Truncate any values longer than 20 chars before narrowing back
    op.execute("UPDATE commissions SET item_type = LEFT(item_type, 20) WHERE LENGTH(item_type) > 20")
    op.alter_column(
        'commissions',
        'item_type',
        existing_type=sa.String(50),
        type_=sa.String(20),
        existing_nullable=True,
    )
