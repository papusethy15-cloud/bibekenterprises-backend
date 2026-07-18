"""Add CCO attendance table, CCO salary fields, and CCO salary settlements

Revision ID: 073_cco_attendance_and_salary
Revises: 072_add_salary_settlements
Create Date: 2026-07-18
"""
from alembic import op
import sqlalchemy as sa
from sqlalchemy.dialects import postgresql
from sqlalchemy import text

revision = '073_cco_attendance_and_salary'
down_revision = '072_add_salary_settlements'
branch_labels = None
depends_on = None


def _table_exists(bind, table_name: str) -> bool:
    result = bind.execute(text(
        "SELECT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = :t)"
    ), {"t": table_name})
    return result.scalar()


def _column_exists(bind, table_name: str, column_name: str) -> bool:
    result = bind.execute(text(
        "SELECT EXISTS (SELECT 1 FROM information_schema.columns "
        "WHERE table_name = :t AND column_name = :c)"
    ), {"t": table_name, "c": column_name})
    return result.scalar()


def upgrade():
    bind = op.get_bind()

    # ── 1. CCO Attendance table ───────────────────────────────────────────────
    if not _table_exists(bind, 'cco_attendance'):
        op.create_table(
            'cco_attendance',
            sa.Column('id', postgresql.UUID(as_uuid=True), primary_key=True,
                      server_default=sa.text('gen_random_uuid()')),
            sa.Column('user_id', postgresql.UUID(as_uuid=True),
                      sa.ForeignKey('users.id', ondelete='CASCADE'), nullable=False),
            sa.Column('date', sa.Date(), nullable=False),
            sa.Column('check_in', sa.DateTime(timezone=True), nullable=True),
            sa.Column('check_out', sa.DateTime(timezone=True), nullable=True),
            sa.Column('accumulated_seconds', sa.Integer(), nullable=False, server_default='0'),
            sa.Column('status', sa.String(20), nullable=False, server_default='PRESENT'),
            sa.Column('notes', sa.Text(), nullable=True),
            sa.Column('created_at', sa.DateTime(timezone=True), server_default=sa.text('now()')),
            sa.UniqueConstraint('user_id', 'date', name='uq_cco_attendance_user_date'),
        )
        op.create_index('ix_cco_attendance_user_id', 'cco_attendance', ['user_id'])
        op.create_index('ix_cco_attendance_date',    'cco_attendance', ['date'])
    else:
        print("[INFO] 073: cco_attendance already exists — skipping create")

    # ── 2. CCO Salary Settlements table ──────────────────────────────────────
    if not _table_exists(bind, 'cco_salary_settlements'):
        op.create_table(
            'cco_salary_settlements',
            sa.Column('id', postgresql.UUID(as_uuid=True), primary_key=True,
                      server_default=sa.text('gen_random_uuid()')),
            sa.Column('user_id', postgresql.UUID(as_uuid=True),
                      sa.ForeignKey('users.id', ondelete='CASCADE'), nullable=False),
            sa.Column('month', sa.Integer(), nullable=False),
            sa.Column('year',  sa.Integer(), nullable=False),
            sa.Column('monthly_salary',   sa.Float(), nullable=False, server_default='0'),
            sa.Column('petrol_amount',    sa.Float(), nullable=False, server_default='0'),
            sa.Column('mobile_recharge',  sa.Float(), nullable=False, server_default='0'),
            sa.Column('bonus_amount',     sa.Float(), nullable=False, server_default='0'),
            sa.Column('hra_amount',       sa.Float(), nullable=False, server_default='0'),
            sa.Column('other_allowances', sa.Float(), nullable=False, server_default='0'),
            sa.Column('deductions',       sa.Float(), nullable=False, server_default='0'),
            sa.Column('deduction_notes',  sa.String(500), nullable=True),
            sa.Column('total_days',       sa.Integer(), nullable=False, server_default='0'),
            sa.Column('present_days',     sa.Integer(), nullable=False, server_default='0'),
            sa.Column('total_hours',      sa.Float(),   nullable=False, server_default='0'),
            sa.Column('gross_salary',     sa.Float(), nullable=False, server_default='0'),
            sa.Column('net_salary',       sa.Float(), nullable=False, server_default='0'),
            sa.Column('status', sa.String(20), nullable=False, server_default='PENDING'),
            sa.Column('payment_method',   sa.String(20), nullable=True),
            sa.Column('payment_ref',      sa.String(200), nullable=True),
            sa.Column('paid_at',          sa.DateTime(timezone=True), nullable=True),
            sa.Column('paid_by',          postgresql.UUID(as_uuid=True),
                      sa.ForeignKey('users.id', ondelete='SET NULL'), nullable=True),
            sa.Column('salary_notes',     sa.Text(), nullable=True),
            sa.Column('created_at', sa.DateTime(timezone=True), server_default=sa.text('now()')),
            sa.UniqueConstraint('user_id', 'month', 'year', name='uq_cco_salary_user_month_year'),
        )
        op.create_index('ix_cco_salary_user_id', 'cco_salary_settlements', ['user_id'])
    else:
        print("[INFO] 073: cco_salary_settlements already exists — skipping create")

    # ── 3. Add payout / salary fields to users table (skip if already exist) ─
    users_cols = [
        ('payout_upi_id',         sa.String(200)),
        ('payout_bank_account',   sa.String(100)),
        ('payout_bank_ifsc',      sa.String(20)),
        ('payout_bank_name',      sa.String(100)),
        ('payout_account_holder', sa.String(150)),
        ('monthly_salary',        sa.Float()),
        ('petrol_amount',         sa.Float()),
        ('mobile_recharge',       sa.Float()),
        ('bonus_amount',          sa.Float()),
        ('hra_amount',            sa.Float()),
        ('other_allowances',      sa.Float()),
        ('salary_notes',          sa.Text()),
    ]
    for col_name, col_type in users_cols:
        if not _column_exists(bind, 'users', col_name):
            op.add_column('users', sa.Column(col_name, col_type, nullable=True))
        else:
            print(f"[INFO] 073: users.{col_name} already exists — skipping")


def downgrade():
    for col in ['salary_notes', 'other_allowances', 'hra_amount', 'bonus_amount',
                'mobile_recharge', 'petrol_amount', 'monthly_salary',
                'payout_account_holder', 'payout_bank_name', 'payout_bank_ifsc',
                'payout_bank_account', 'payout_upi_id']:
        op.drop_column('users', col)
    op.drop_table('cco_salary_settlements')
    op.drop_table('cco_attendance')
