"""050_vps_columns_final_hotfix

ROOT CAUSE FIX:
  On the VPS, `alembic stamp 049` was run manually BEFORE the migration
  scripts (047/048/049) were pushed. Alembic recorded 049 as applied and
  skipped all column additions on every subsequent startup.

  This migration adds every missing column with IF NOT EXISTS so it is a
  complete no-op on any DB that already has them, and a full fix on the VPS.

Revision ID: 050
Revises: 049
Create Date: 2026-07-07
"""
from alembic import op
from sqlalchemy import text

revision = '050'
down_revision = '049'
branch_labels = None
depends_on = None


def upgrade():
    bind = op.get_bind()

    ddl = [
        # ── technicians ──────────────────────────────────────────────────
        "ALTER TABLE technicians ADD COLUMN IF NOT EXISTS is_online               BOOLEAN NOT NULL DEFAULT FALSE",
        "ALTER TABLE technicians ADD COLUMN IF NOT EXISTS fcm_token               VARCHAR(500)",
        "ALTER TABLE technicians ADD COLUMN IF NOT EXISTS last_lat                DOUBLE PRECISION",
        "ALTER TABLE technicians ADD COLUMN IF NOT EXISTS last_lng                DOUBLE PRECISION",
        "ALTER TABLE technicians ADD COLUMN IF NOT EXISTS last_seen_at            TIMESTAMP WITH TIME ZONE",
        "ALTER TABLE technicians ADD COLUMN IF NOT EXISTS auto_assign_eligible    BOOLEAN NOT NULL DEFAULT TRUE",
        "ALTER TABLE technicians ADD COLUMN IF NOT EXISTS alternate_mobile        VARCHAR(20)",
        "ALTER TABLE technicians ADD COLUMN IF NOT EXISTS dob                     DATE",
        "ALTER TABLE technicians ADD COLUMN IF NOT EXISTS gender                  VARCHAR(10)",
        "ALTER TABLE technicians ADD COLUMN IF NOT EXISTS pincode                 VARCHAR(10)",
        "ALTER TABLE technicians ADD COLUMN IF NOT EXISTS identity_type           VARCHAR(50)",
        "ALTER TABLE technicians ADD COLUMN IF NOT EXISTS identity_number         VARCHAR(50)",
        "ALTER TABLE technicians ADD COLUMN IF NOT EXISTS emergency_contact_name  VARCHAR(150)",
        "ALTER TABLE technicians ADD COLUMN IF NOT EXISTS emergency_contact_mobile VARCHAR(20)",
        # ── users ────────────────────────────────────────────────────────
        "ALTER TABLE users ADD COLUMN IF NOT EXISTS fcm_token           VARCHAR(500)",
        "ALTER TABLE users ADD COLUMN IF NOT EXISTS firebase_uid        VARCHAR(128)",
        "ALTER TABLE users ADD COLUMN IF NOT EXISTS id_proof_url        VARCHAR(500)",
        "ALTER TABLE users ADD COLUMN IF NOT EXISTS address_proof_url   VARCHAR(500)",
        "ALTER TABLE users ADD COLUMN IF NOT EXISTS id_proof_type       VARCHAR(50)",
        "ALTER TABLE users ADD COLUMN IF NOT EXISTS address_proof_type  VARCHAR(50)",
        # ── services ─────────────────────────────────────────────────────
        "ALTER TABLE services ADD COLUMN IF NOT EXISTS is_pending_verify INTEGER NOT NULL DEFAULT 0",
        "ALTER TABLE services ADD COLUMN IF NOT EXISTS suggested_by_tech UUID",
        # ── quotation_service_items ───────────────────────────────────────
        "ALTER TABLE quotation_service_items ADD COLUMN IF NOT EXISTS is_pending_verify        INTEGER NOT NULL DEFAULT 0",
        "ALTER TABLE quotation_service_items ADD COLUMN IF NOT EXISTS custom_service_name      TEXT",
        "ALTER TABLE quotation_service_items ADD COLUMN IF NOT EXISTS tech_commission_override DOUBLE PRECISION",
        # ── payment_transactions ─────────────────────────────────────────
        "ALTER TABLE payment_transactions ADD COLUMN IF NOT EXISTS due_collect_at   TIMESTAMP WITH TIME ZONE",
        "ALTER TABLE payment_transactions ADD COLUMN IF NOT EXISTS last_reminder_at TIMESTAMP WITH TIME ZONE",
    ]

    for stmt in ddl:
        bind.execute(text(stmt))

    # Make service_id nullable if it isn't already
    row = bind.execute(text(
        "SELECT is_nullable FROM information_schema.columns "
        "WHERE table_name='quotation_service_items' AND column_name='service_id'"
    )).fetchone()
    if row and row[0] == 'NO':
        bind.execute(text(
            "ALTER TABLE quotation_service_items ALTER COLUMN service_id DROP NOT NULL"
        ))

    # Unique constraint on users.firebase_uid
    exists = bind.execute(text(
        "SELECT 1 FROM information_schema.table_constraints "
        "WHERE constraint_name='uq_users_firebase_uid'"
    )).fetchone()
    if not exists:
        try:
            bind.execute(text(
                "ALTER TABLE users ADD CONSTRAINT uq_users_firebase_uid UNIQUE (firebase_uid)"
            ))
        except Exception:
            pass


def downgrade():
    op.execute("ALTER TABLE payment_transactions DROP COLUMN IF EXISTS last_reminder_at")
    op.execute("ALTER TABLE payment_transactions DROP COLUMN IF EXISTS due_collect_at")
    op.execute("ALTER TABLE quotation_service_items DROP COLUMN IF EXISTS tech_commission_override")
    op.execute("ALTER TABLE quotation_service_items DROP COLUMN IF EXISTS custom_service_name")
    op.execute("ALTER TABLE quotation_service_items DROP COLUMN IF EXISTS is_pending_verify")
    op.execute("ALTER TABLE services DROP COLUMN IF EXISTS suggested_by_tech")
    op.execute("ALTER TABLE services DROP COLUMN IF EXISTS is_pending_verify")
    op.execute("ALTER TABLE users DROP COLUMN IF EXISTS address_proof_type")
    op.execute("ALTER TABLE users DROP COLUMN IF EXISTS id_proof_type")
    op.execute("ALTER TABLE users DROP COLUMN IF EXISTS address_proof_url")
    op.execute("ALTER TABLE users DROP COLUMN IF EXISTS id_proof_url")
    op.execute("ALTER TABLE users DROP COLUMN IF EXISTS firebase_uid")
    op.execute("ALTER TABLE users DROP COLUMN IF EXISTS fcm_token")
    op.execute("ALTER TABLE technicians DROP COLUMN IF EXISTS emergency_contact_mobile")
    op.execute("ALTER TABLE technicians DROP COLUMN IF EXISTS emergency_contact_name")
    op.execute("ALTER TABLE technicians DROP COLUMN IF EXISTS identity_number")
    op.execute("ALTER TABLE technicians DROP COLUMN IF EXISTS identity_type")
    op.execute("ALTER TABLE technicians DROP COLUMN IF EXISTS pincode")
    op.execute("ALTER TABLE technicians DROP COLUMN IF EXISTS gender")
    op.execute("ALTER TABLE technicians DROP COLUMN IF EXISTS dob")
    op.execute("ALTER TABLE technicians DROP COLUMN IF EXISTS alternate_mobile")
    op.execute("ALTER TABLE technicians DROP COLUMN IF EXISTS auto_assign_eligible")
    op.execute("ALTER TABLE technicians DROP COLUMN IF EXISTS last_seen_at")
    op.execute("ALTER TABLE technicians DROP COLUMN IF EXISTS last_lng")
    op.execute("ALTER TABLE technicians DROP COLUMN IF EXISTS last_lat")
    op.execute("ALTER TABLE technicians DROP COLUMN IF EXISTS fcm_token")
    op.execute("ALTER TABLE technicians DROP COLUMN IF EXISTS is_online")
