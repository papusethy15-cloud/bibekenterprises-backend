"""add mpin_hash to users

Revision ID: 059
Revises: 058
Create Date: 2026-07-09

"""
from alembic import op
import sqlalchemy as sa
from sqlalchemy import text, inspect

revision = '059'
down_revision = '058'
branch_labels = None
depends_on = None

def upgrade() -> None:
    # Idempotent: skip if column already exists (safe for VPS re-runs)
    bind = op.get_bind()
    inspector = inspect(bind)
    cols = [c['name'] for c in inspector.get_columns('users')]
    if 'mpin_hash' not in cols:
        op.add_column('users', sa.Column('mpin_hash', sa.String(255), nullable=True))

def downgrade() -> None:
    bind = op.get_bind()
    inspector = inspect(bind)
    cols = [c['name'] for c in inspector.get_columns('users')]
    if 'mpin_hash' in cols:
        op.drop_column('users', 'mpin_hash')
