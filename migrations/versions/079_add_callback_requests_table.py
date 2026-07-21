"""Add callbackstatus enum and callback_requests table

This migration was missing — the model existed in code but was never
migrated, causing:
  asyncpg.exceptions.UndefinedObjectError: type "callbackstatus" does not exist

Revision ID: 079
Revises: 078
Create Date: 2026-07-21
"""
from alembic import op
import sqlalchemy as sa
from sqlalchemy.dialects import postgresql

revision = '079'
down_revision = '078'
branch_labels = None
depends_on = None


def upgrade():
    # 1. Create the callbackstatus enum type (idempotent via DO block)
    op.execute("""
        DO $$
        BEGIN
            IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'callbackstatus') THEN
                CREATE TYPE callbackstatus AS ENUM ('PENDING', 'CALLED', 'RESOLVED', 'SKIPPED');
            END IF;
        END
        $$;
    """)

    # 2. Create callback_requests table (idempotent)
    op.execute("""
        CREATE TABLE IF NOT EXISTS callback_requests (
            id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
            mobile       VARCHAR(20)  NOT NULL,
            name         VARCHAR(150),
            message      TEXT,
            source       VARCHAR(30)  DEFAULT 'CHATBOT',
            status       callbackstatus DEFAULT 'PENDING',
            admin_notes  TEXT,
            called_at    TIMESTAMP WITHOUT TIME ZONE,
            domain_id    UUID,
            page_url     VARCHAR(500),
            ip_address   VARCHAR(64),
            user_agent   VARCHAR(500),
            location     VARCHAR(255),
            created_at   TIMESTAMP WITH TIME ZONE DEFAULT now() NOT NULL,
            updated_at   TIMESTAMP WITH TIME ZONE DEFAULT now(),
            is_active    BOOLEAN DEFAULT TRUE
        );
    """)

    # 3. Add indexes
    op.execute("""
        CREATE INDEX IF NOT EXISTS ix_callback_requests_mobile
            ON callback_requests (mobile);
    """)
    op.execute("""
        CREATE INDEX IF NOT EXISTS ix_callback_requests_domain_id
            ON callback_requests (domain_id);
    """)


def downgrade():
    op.execute("DROP TABLE IF EXISTS callback_requests;")
    op.execute("DROP TYPE IF EXISTS callbackstatus;")
