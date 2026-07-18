"""Add firebase_uid to users table for Google/Firebase auth linking

Revision ID: 032
Revises: 031
Create Date: 2026-06-30
"""
from alembic import op
import sqlalchemy as sa

revision = '032'
down_revision = '031'
branch_labels = None
depends_on = None

def upgrade():
    op.execute(sa.text("ALTER TABLE users ADD COLUMN IF NOT EXISTS firebase_uid VARCHAR(128)"))
    # Add unique constraint only if it doesn't already exist
    bind = op.get_bind()
    exists = bind.execute(sa.text(
        "SELECT EXISTS (SELECT 1 FROM information_schema.table_constraints "
        "WHERE constraint_name='uq_users_firebase_uid' AND table_name='users')"
    )).scalar()
    if not exists:
        op.create_unique_constraint('uq_users_firebase_uid', 'users', ['firebase_uid'])

def downgrade():
    op.drop_constraint('uq_users_firebase_uid', 'users', type_='unique')
    op.drop_column('users', 'firebase_uid')
