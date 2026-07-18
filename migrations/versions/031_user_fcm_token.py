"""Add fcm_token to users table

Revision ID: 031
Revises: 030
Create Date: 2026-06-28
"""
from alembic import op
import sqlalchemy as sa

revision = '031'
down_revision = '030'
branch_labels = None
depends_on = None

def upgrade():
    op.execute(sa.text("ALTER TABLE users ADD COLUMN IF NOT EXISTS fcm_token VARCHAR(500)"))

def downgrade():
    op.drop_column('users', 'fcm_token')
