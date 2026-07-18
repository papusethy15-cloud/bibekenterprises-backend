"""069 — Fix commissions table + widen item_type + create missing commission tables

On a fresh DB, migration 001 creates the commissions table with a minimal
schema (no item_type, rule_id, base_amount, etc.). This migration:

  1. Adds all missing columns to commissions (IF NOT EXISTS — idempotent)
  2. Creates commission_groups, commission_group_rules, commission_group_assignments,
     commission_group_part_rules tables if they don't exist
  3. Widens commissions.item_type from VARCHAR(20) to VARCHAR(50) if needed
     (fixes PURCHASE_REIMBURSEMENT truncation error)

Revision ID: 069
Revises: 068
Create Date: 2026-07-14
"""

from alembic import op
import sqlalchemy as sa
from sqlalchemy import text
from sqlalchemy.dialects.postgresql import UUID

revision = '069'
down_revision = '068'
branch_labels = None
depends_on = None


def upgrade():
    # ── 1. Add all missing columns to commissions (IF NOT EXISTS) ────────
    op.execute(text("""
        ALTER TABLE commissions
            ADD COLUMN IF NOT EXISTS rule_id UUID REFERENCES commission_rules(id),
            ADD COLUMN IF NOT EXISTS base_amount FLOAT,
            ADD COLUMN IF NOT EXISTS commission_amount FLOAT,
            ADD COLUMN IF NOT EXISTS payout_date TIMESTAMP WITH TIME ZONE,
            ADD COLUMN IF NOT EXISTS notes TEXT,
            ADD COLUMN IF NOT EXISTS item_type VARCHAR(50),
            ADD COLUMN IF NOT EXISTS item_name VARCHAR(300),
            ADD COLUMN IF NOT EXISTS item_quantity INTEGER DEFAULT 1,
            ADD COLUMN IF NOT EXISTS part_source VARCHAR(30);
    """))

    # ── 2. Widen item_type to VARCHAR(50) if it was already created as VARCHAR(20) ──
    op.execute(text("""
        DO $$
        BEGIN
            IF EXISTS (
                SELECT 1 FROM information_schema.columns
                WHERE table_name = 'commissions'
                  AND column_name = 'item_type'
                  AND character_maximum_length = 20
            ) THEN
                ALTER TABLE commissions ALTER COLUMN item_type TYPE VARCHAR(50);
            END IF;
        END $$;
    """))

    # ── 3. Create commission_groups if missing ────────────────────────────
    op.execute(text("""
        CREATE TABLE IF NOT EXISTS commission_groups (
            id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
            name VARCHAR(150) NOT NULL,
            description VARCHAR(500),
            is_active BOOLEAN DEFAULT TRUE,
            is_salary_group BOOLEAN DEFAULT FALSE,
            monthly_salary FLOAT,
            petrol_amount FLOAT DEFAULT 0.0,
            mobile_recharge FLOAT DEFAULT 0.0,
            bonus_amount FLOAT DEFAULT 0.0,
            hra_amount FLOAT DEFAULT 0.0,
            other_allowances FLOAT DEFAULT 0.0,
            salary_notes VARCHAR(500),
            created_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
            updated_at TIMESTAMP WITH TIME ZONE DEFAULT now()
        );
    """))

    # ── 4. Create commission_group_rules if missing ───────────────────────
    op.execute(text("""
        CREATE TABLE IF NOT EXISTS commission_group_rules (
            id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
            group_id UUID NOT NULL REFERENCES commission_groups(id) ON DELETE CASCADE,
            service_id UUID NOT NULL REFERENCES services(id) ON DELETE CASCADE,
            domain_id UUID REFERENCES domains(id) ON DELETE CASCADE,
            commission_type VARCHAR(20) NOT NULL DEFAULT 'PERCENTAGE',
            rate FLOAT NOT NULL DEFAULT 0.0,
            is_active BOOLEAN DEFAULT TRUE,
            updated_at TIMESTAMP WITHOUT TIME ZONE,
            created_at TIMESTAMP WITH TIME ZONE DEFAULT now()
        );
    """))

    # ── 5. Create commission_group_assignments if missing ─────────────────
    op.execute(text("""
        CREATE TABLE IF NOT EXISTS commission_group_assignments (
            id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
            technician_id UUID NOT NULL REFERENCES technicians(id) ON DELETE CASCADE,
            group_id UUID NOT NULL REFERENCES commission_groups(id) ON DELETE CASCADE,
            assigned_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
            created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT now(),
            is_active BOOLEAN DEFAULT TRUE,
            updated_at TIMESTAMP WITHOUT TIME ZONE,
            CONSTRAINT uq_commission_group_assignments_tech_group UNIQUE (technician_id, group_id)
        );
    """))

    # ── 6. Create commission_group_part_rules if missing ──────────────────
    op.execute(text("""
        CREATE TABLE IF NOT EXISTS commission_group_part_rules (
            id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
            group_id UUID NOT NULL REFERENCES commission_groups(id) ON DELETE CASCADE,
            part_name_match VARCHAR(200),
            part_source_filter VARCHAR(30),
            commission_type VARCHAR(20) NOT NULL DEFAULT 'PERCENTAGE',
            rate FLOAT NOT NULL DEFAULT 0.0,
            is_active BOOLEAN DEFAULT TRUE,
            updated_at TIMESTAMP WITHOUT TIME ZONE,
            created_at TIMESTAMP WITH TIME ZONE DEFAULT now()
        );
    """))


def downgrade():
    # Downgrade is a no-op — dropping tables/columns is too destructive
    pass
