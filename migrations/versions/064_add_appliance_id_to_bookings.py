"""064_add_appliance_id_to_bookings

Revision ID: 064
Revises: 063
Create Date: 2026-07-11

Adds appliance_id FK column to the bookings table so that a booking can
be linked to a specific CustomerAppliance record selected by the customer
during the booking flow (step 3).
"""
from alembic import op
import sqlalchemy as sa
from sqlalchemy.dialects import postgresql

revision = '064'
down_revision = '063'
branch_labels = None
depends_on = None


def upgrade():
    # Add appliance_id nullable FK column to bookings
    op.add_column(
        'bookings',
        sa.Column(
            'appliance_id',
            postgresql.UUID(as_uuid=True),
            nullable=True,
        )
    )
    # FK constraint (separate so it can be applied even if table locks differ)
    op.create_foreign_key(
        'fk_bookings_appliance_id',
        'bookings', 'customer_appliances',
        ['appliance_id'], ['id'],
        ondelete='SET NULL',
    )
    # Index for quick look-up of all bookings for a given appliance
    op.create_index('ix_bookings_appliance_id', 'bookings', ['appliance_id'])


def downgrade():
    op.drop_index('ix_bookings_appliance_id', table_name='bookings')
    op.drop_constraint('fk_bookings_appliance_id', 'bookings', type_='foreignkey')
    op.drop_column('bookings', 'appliance_id')
