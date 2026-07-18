"""Fix userrole enum — add ACCOUNTANT and INVENTORY_MANAGER values

These two enum values exist in the Python UserRole enum and SQLAlchemy model
but were never added to the VPS PostgreSQL userrole enum type via a numbered
migration.  When any request path causes SQLAlchemy to INSERT or SELECT a user
with one of these roles, PostgreSQL throws:
  asyncpg.exceptions.InvalidTextRepresentationError:
    invalid input value for enum userrole: "ACCOUNTANT"

Root cause of POST /technicians 500: the create_technician endpoint inserts a
User with role=TECHNICIAN which itself is fine, BUT loading ANY user row that
has role=ACCOUNTANT or INVENTORY_MANAGER from the DB (e.g. in auth middleware,
JWT lookup, or admin user list) causes the asyncpg connection to crash and
invalidates the SQLAlchemy connection pool — making subsequent requests also
fail with 500 until the pool recovers.

Fix: Add both values to the PG enum using AUTOCOMMIT (required for ALTER TYPE
ADD VALUE in PostgreSQL — cannot run inside an explicit transaction).

Revision ID: 060
Revises: 059
Create Date: 2026-07-09
"""
from alembic import op
from sqlalchemy import text

revision = '060'
down_revision = '059'
branch_labels = None
depends_on = None


def upgrade() -> None:
    # ALTER TYPE ADD VALUE requires autocommit — use Alembic's autocommit_block
    with op.get_context().autocommit_block():
        op.execute(text("ALTER TYPE userrole ADD VALUE IF NOT EXISTS 'ACCOUNTANT'"))
        op.execute(text("ALTER TYPE userrole ADD VALUE IF NOT EXISTS 'INVENTORY_MANAGER'"))
    print("[060] userrole enum: ACCOUNTANT and INVENTORY_MANAGER ensured")


def downgrade() -> None:
    # PostgreSQL cannot remove enum values without recreating the type.
    # Safe no-op.
    pass
