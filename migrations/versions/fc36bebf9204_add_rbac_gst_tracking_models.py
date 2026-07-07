"""add_rbac_gst_tracking_models

Revision ID: fc36bebf9204
Revises: 91baaab49547
Create Date: 2026-05-29 19:14:33.316983

REWRITTEN: All CREATE TABLE calls converted to IF NOT EXISTS raw SQL for idempotency.
"""
from typing import Sequence, Union
from alembic import op
import sqlalchemy as sa


revision: str = 'fc36bebf9204'
down_revision: Union[str, None] = '91baaab49547'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    op.execute("""
        CREATE TABLE IF NOT EXISTS permissions (
            code VARCHAR(100) NOT NULL,
            module VARCHAR(50) NOT NULL,
            name VARCHAR(150) NOT NULL,
            description TEXT,
            id UUID NOT NULL,
            created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL,
            updated_at TIMESTAMP WITHOUT TIME ZONE,
            is_active BOOLEAN,
            PRIMARY KEY (id),
            UNIQUE (code)
        )
    """)

    op.execute("""
        CREATE TABLE IF NOT EXISTS roles (
            code VARCHAR(50) NOT NULL,
            name VARCHAR(150) NOT NULL,
            description TEXT,
            is_system BOOLEAN NOT NULL,
            id UUID NOT NULL,
            created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL,
            updated_at TIMESTAMP WITHOUT TIME ZONE,
            is_active BOOLEAN,
            PRIMARY KEY (id),
            UNIQUE (code)
        )
    """)

    op.execute("""
        CREATE TABLE IF NOT EXISTS gst_settings (
            gst_enabled BOOLEAN NOT NULL,
            default_rate FLOAT NOT NULL,
            allow_b2b BOOLEAN NOT NULL,
            allow_b2c BOOLEAN NOT NULL,
            allow_non_gst BOOLEAN NOT NULL,
            gstin_validation_enabled BOOLEAN NOT NULL,
            company_gstin VARCHAR(50),
            company_name VARCHAR(200),
            company_address TEXT,
            hsn_code VARCHAR(30),
            invoice_prefix VARCHAR(20) NOT NULL,
            state_code VARCHAR(10),
            updated_by UUID REFERENCES users(id),
            id UUID NOT NULL,
            created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL,
            updated_at TIMESTAMP WITHOUT TIME ZONE,
            is_active BOOLEAN,
            PRIMARY KEY (id)
        )
    """)

    op.execute("""
        CREATE TABLE IF NOT EXISTS role_permissions (
            role_id UUID NOT NULL REFERENCES roles(id),
            permission_id UUID NOT NULL REFERENCES permissions(id),
            id UUID NOT NULL,
            created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL,
            updated_at TIMESTAMP WITHOUT TIME ZONE,
            is_active BOOLEAN,
            PRIMARY KEY (id),
            UNIQUE (role_id, permission_id)
        )
    """)

    op.execute("""
        CREATE TABLE IF NOT EXISTS user_permissions (
            user_id UUID NOT NULL REFERENCES users(id),
            permission_id UUID NOT NULL REFERENCES permissions(id),
            is_granted BOOLEAN NOT NULL,
            id UUID NOT NULL,
            created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL,
            updated_at TIMESTAMP WITHOUT TIME ZONE,
            is_active BOOLEAN,
            PRIMARY KEY (id),
            UNIQUE (user_id, permission_id)
        )
    """)

    op.execute("""
        CREATE TABLE IF NOT EXISTS tracking_locations (
            technician_id UUID NOT NULL REFERENCES technicians(id),
            booking_id UUID REFERENCES bookings(id),
            latitude FLOAT NOT NULL,
            longitude FLOAT NOT NULL,
            accuracy FLOAT,
            speed FLOAT,
            heading FLOAT,
            source VARCHAR(50) NOT NULL,
            recorded_at TIMESTAMP WITHOUT TIME ZONE NOT NULL,
            id UUID NOT NULL,
            created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL,
            updated_at TIMESTAMP WITHOUT TIME ZONE,
            is_active BOOLEAN,
            PRIMARY KEY (id)
        )
    """)


def downgrade() -> None:
    op.drop_table('tracking_locations')
    op.drop_table('user_permissions')
    op.drop_table('role_permissions')
    op.drop_table('gst_settings')
    op.drop_table('roles')
    op.drop_table('permissions')
