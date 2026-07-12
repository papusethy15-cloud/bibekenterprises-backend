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
    # Use op.execute(text(...)) — the only safe pattern under asyncpg run_sync.
    # op.add_column() and op.get_bind() both cause DuplicateColumnError / abort
    # when the column already exists (partial VPS run). IF NOT EXISTS guards make
    # this migration 100% idempotent.
    op.execute(sa.text("""
        ALTER TABLE bookings
            ADD COLUMN IF NOT EXISTS appliance_id UUID
                REFERENCES customer_appliances(id) ON DELETE SET NULL
    """))
    op.execute(sa.text("""
        CREATE INDEX IF NOT EXISTS ix_bookings_appliance_id
            ON bookings (appliance_id)
    """))


def downgrade():
    op.execute(sa.text("DROP INDEX IF EXISTS ix_bookings_appliance_id"))
    op.execute(sa.text("ALTER TABLE bookings DROP COLUMN IF EXISTS appliance_id"))
