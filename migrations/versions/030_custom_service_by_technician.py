"""Add custom service support: tech-suggested services in quotations

Revision ID: 030
Revises: 029
Create Date: 2026-06-27

Changes:
  1. services.is_pending_verify  INTEGER default 0  (0=verified, 1=pending admin verify)
  2. services.suggested_by_tech  UUID nullable       (FK → users.id — who suggested it)
  3. services.is_active already exists; new services default is_active=False until verified
  4. quotation_service_items.service_id  → nullable=True  (custom services have no FK yet)
  5. quotation_service_items.is_pending_verify  INTEGER default 0
  6. quotation_service_items.custom_service_name TEXT nullable (when service_id IS NULL)
  7. quotation_service_items.tech_commission_override FLOAT nullable (admin sets after verify)
"""
from alembic import op
import sqlalchemy as sa
from sqlalchemy.dialects.postgresql import UUID

revision = '030'
down_revision = '029'
branch_labels = None
depends_on = None


def upgrade():
    # 1. Add is_pending_verify and suggested_by_tech to services
    op.execute(sa.text("ALTER TABLE services ADD COLUMN IF NOT EXISTS is_pending_verify INTEGER NOT NULL DEFAULT 0"))
    op.execute(sa.text("ALTER TABLE services ADD COLUMN IF NOT EXISTS suggested_by_tech UUID"))

    # 2. Make service_id nullable in quotation_service_items (for custom/suggested services)
    op.execute(sa.text("ALTER TABLE quotation_service_items ALTER COLUMN service_id DROP NOT NULL"))

    # 3. Add custom_service tracking columns to quotation_service_items
    op.execute(sa.text("ALTER TABLE quotation_service_items ADD COLUMN IF NOT EXISTS is_pending_verify INTEGER NOT NULL DEFAULT 0"))
    op.execute(sa.text("ALTER TABLE quotation_service_items ADD COLUMN IF NOT EXISTS custom_service_name TEXT"))
    op.execute(sa.text("ALTER TABLE quotation_service_items ADD COLUMN IF NOT EXISTS tech_commission_override FLOAT"))


def downgrade():
    op.drop_column('quotation_service_items', 'tech_commission_override')
    op.drop_column('quotation_service_items', 'custom_service_name')
    op.drop_column('quotation_service_items', 'is_pending_verify')
    op.alter_column('quotation_service_items', 'service_id', nullable=False)
    op.drop_column('services', 'suggested_by_tech')
    op.drop_column('services', 'is_pending_verify')
