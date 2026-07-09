"""058_fix_escalation_status_column_type

The escalations.status column was created as VARCHAR(20) in earlier
migrations, but the SQLAlchemy model declares it as SAEnum(EscalationStatus)
which PostgreSQL maps to the native `escalationstatus` enum type.

This causes:
  asyncpg.exceptions.UndefinedFunctionError:
    operator does not exist: character varying = escalationstatus

Fix: ALTER COLUMN status to use the existing `escalationstatus` PG enum type.
The enum type already exists (created by SQLAlchemy metadata or a prior
migration) — we only need to migrate the column's type.

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
    # Ensure the enum type exists (idempotent)
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

    # Alter status column from varchar to the native enum type (idempotent)
    op.execute(text("""
        DO $$
        BEGIN
            IF (SELECT data_type FROM information_schema.columns
                WHERE table_name='escalations' AND column_name='status') = 'character varying' THEN
                ALTER TABLE escalations
                    ALTER COLUMN status TYPE escalationstatus
                    USING status::escalationstatus;
            END IF;
        END$$;
    """))

    # Set sensible defaults
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
