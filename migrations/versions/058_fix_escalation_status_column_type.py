"""058_fix_escalation_status_column_type

Migration 001 created the escalations table with an old schema that is missing
several columns the current SQLAlchemy model expects, and has extra columns
the model no longer uses.

Current model (escalation.py) expects:
  created_by, booking_id, subject, description, priority, status (enum),
  assigned_to, resolved_by, resolved_at, resolution_notes,
  escalation_level, escalation_notes

Migration 001 created:
  id, booking_id, customer_id, raised_by, type, description, priority,
  status (VARCHAR), resolved_by, resolution, is_active, created_at, updated_at

This migration:
  1. Ensures escalationstatus enum type exists
  2. Adds ALL missing columns (IF NOT EXISTS — safe no-op if already present)
  3. Converts status column from VARCHAR to escalationstatus enum
  4. Sets sensible column defaults

Revision ID: 058
Revises: 057
"""
from alembic import op
from sqlalchemy import text

revision = '058'
down_revision = '057'
branch_labels = None
depends_on = None


def upgrade():
    # ── 1. Ensure escalationstatus enum type exists ──────────────────────
    op.execute(text("""
        DO $$
        BEGIN
            IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'escalationstatus') THEN
                CREATE TYPE escalationstatus AS ENUM (
                    'OPEN', 'IN_PROGRESS', 'ESCALATED', 'RESOLVED', 'CLOSED'
                );
            END IF;
        END$$;
    """))

    # ── 2. Add all missing columns (IF NOT EXISTS — fully idempotent) ────
    op.execute(text("""
        ALTER TABLE escalations
            ADD COLUMN IF NOT EXISTS created_by UUID REFERENCES users(id),
            ADD COLUMN IF NOT EXISTS subject VARCHAR(300),
            ADD COLUMN IF NOT EXISTS assigned_to UUID REFERENCES users(id),
            ADD COLUMN IF NOT EXISTS resolved_at TIMESTAMP,
            ADD COLUMN IF NOT EXISTS resolution_notes TEXT,
            ADD COLUMN IF NOT EXISTS escalation_level INTEGER DEFAULT 1,
            ADD COLUMN IF NOT EXISTS escalation_notes TEXT;
    """))

    # ── 3. Convert status column from VARCHAR to escalationstatus enum ───
    op.execute(text("""
        DO $$
        BEGIN
            IF (SELECT data_type FROM information_schema.columns
                WHERE table_name='escalations' AND column_name='status') = 'character varying' THEN
                ALTER TABLE escalations
                    ALTER COLUMN status TYPE escalationstatus
                    USING COALESCE(
                        CASE
                            WHEN status IN ('OPEN','IN_PROGRESS','ESCALATED','RESOLVED','CLOSED')
                            THEN status::escalationstatus
                            ELSE 'OPEN'::escalationstatus
                        END,
                        'OPEN'::escalationstatus
                    );
            END IF;
        END$$;
    """))

    # ── 4. Set column defaults ────────────────────────────────────────────
    op.execute(text("""
        ALTER TABLE escalations
            ALTER COLUMN status SET DEFAULT 'OPEN'::escalationstatus;
    """))

    op.execute(text("""
        ALTER TABLE escalations
            ALTER COLUMN escalation_level SET DEFAULT 1;
    """))

    op.execute(text("""
        ALTER TABLE escalations
            ALTER COLUMN priority SET DEFAULT 'MEDIUM';
    """))


def downgrade():
    op.execute(text("""
        ALTER TABLE escalations
            ALTER COLUMN status TYPE VARCHAR(20)
            USING status::text;
    """))
    op.execute(text("ALTER TABLE escalations ALTER COLUMN status DROP DEFAULT;"))
