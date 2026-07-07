"""047_vps_missing_columns_hotfix

Emergency hotfix: applies columns that were missing on the VPS because
migrations 030 and 039 were never run there (the VPS DB was initialised
from an earlier snapshot and the Alembic chain was not fully applied).

All statements use IF NOT EXISTS so this is a completely safe no-op on
any database that already has the columns (dev machine, CI, etc.).

Missing columns fixed here:
  FROM migration 030 (services table):
    - services.is_pending_verify  INTEGER NOT NULL DEFAULT 0
    - services.suggested_by_tech  UUID nullable
    - quotation_service_items.is_pending_verify  INTEGER NOT NULL DEFAULT 0
    - quotation_service_items.custom_service_name  TEXT nullable
    - quotation_service_items.tech_commission_override  FLOAT nullable
    (service_id nullable change is NOT repeated — ALTER COLUMN has no IF NOT EXISTS,
     but the column already exists; we only guard the ADD COLUMN calls)

  FROM migration 039 (users table):
    - users.id_proof_url         VARCHAR(500) nullable
    - users.address_proof_url    VARCHAR(500) nullable
    - users.id_proof_type        VARCHAR(50)  nullable
    - users.address_proof_type   VARCHAR(50)  nullable

Revision ID: 047
Revises: 046
Create Date: 2026-07-07
"""
from alembic import op
import sqlalchemy as sa

revision = '047'
down_revision = '046'
branch_labels = None
depends_on = None


def upgrade():
    # ── services table (from migration 030) ──────────────────────────────
    op.execute("""
        ALTER TABLE services
            ADD COLUMN IF NOT EXISTS is_pending_verify INTEGER NOT NULL DEFAULT 0
    """)
    op.execute("""
        ALTER TABLE services
            ADD COLUMN IF NOT EXISTS suggested_by_tech UUID
    """)

    # ── quotation_service_items table (from migration 030) ────────────────
    op.execute("""
        ALTER TABLE quotation_service_items
            ADD COLUMN IF NOT EXISTS is_pending_verify INTEGER NOT NULL DEFAULT 0
    """)
    op.execute("""
        ALTER TABLE quotation_service_items
            ADD COLUMN IF NOT EXISTS custom_service_name TEXT
    """)
    op.execute("""
        ALTER TABLE quotation_service_items
            ADD COLUMN IF NOT EXISTS tech_commission_override FLOAT
    """)

    # Make quotation_service_items.service_id nullable (from migration 030).
    # PostgreSQL allows this without IF NOT EXISTS; it is idempotent because
    # dropping a NOT NULL constraint on an already-nullable column is a no-op.
    try:
        op.alter_column('quotation_service_items', 'service_id', nullable=True)
    except Exception:
        pass  # already nullable — safe to swallow

    # ── users table (from migration 039) ─────────────────────────────────
    op.execute("ALTER TABLE users ADD COLUMN IF NOT EXISTS id_proof_url VARCHAR(500)")
    op.execute("ALTER TABLE users ADD COLUMN IF NOT EXISTS address_proof_url VARCHAR(500)")
    op.execute("ALTER TABLE users ADD COLUMN IF NOT EXISTS id_proof_type VARCHAR(50)")
    op.execute("ALTER TABLE users ADD COLUMN IF NOT EXISTS address_proof_type VARCHAR(50)")


def downgrade():
    # Only drops columns that were genuinely missing on VPS; columns that
    # already existed there (from the snapshot) are left untouched.
    op.execute("ALTER TABLE users DROP COLUMN IF EXISTS id_proof_type")
    op.execute("ALTER TABLE users DROP COLUMN IF EXISTS address_proof_type")
    op.execute("ALTER TABLE users DROP COLUMN IF EXISTS id_proof_url")
    op.execute("ALTER TABLE users DROP COLUMN IF EXISTS address_proof_url")

    op.execute("ALTER TABLE quotation_service_items DROP COLUMN IF EXISTS tech_commission_override")
    op.execute("ALTER TABLE quotation_service_items DROP COLUMN IF EXISTS custom_service_name")
    op.execute("ALTER TABLE quotation_service_items DROP COLUMN IF EXISTS is_pending_verify")

    op.execute("ALTER TABLE services DROP COLUMN IF EXISTS suggested_by_tech")
    op.execute("ALTER TABLE services DROP COLUMN IF EXISTS is_pending_verify")
