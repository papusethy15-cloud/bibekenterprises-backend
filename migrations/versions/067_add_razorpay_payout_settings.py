"""067_add_razorpay_payout_settings

Revision ID: 067
Revises: 066
Create Date: 2026-07-12

Seeds the system_settings table with Razorpay Payout (X) API config keys
so admins can configure auto-payout via the Settings → Payment tab.

Keys added (value starts empty / false) under group 'payment':
  razorpay_payout_enabled     — toggle: use Razorpay X for auto-payout
  razorpay_x_key_id           — Razorpay X API Key ID (rzp_live_...)
  razorpay_x_key_secret       — Razorpay X API Key Secret (encrypted at app layer)
  razorpay_x_account_number   — Fund account number linked to your Razorpay X account
  withdrawal_payout_mode      — 'manual' | 'razorpay'  (default: manual)
"""
from alembic import op
import sqlalchemy as sa
from sqlalchemy import text

revision = '067'
down_revision = '066'
branch_labels = None
depends_on = None


def upgrade():
    op.execute(text("""
        INSERT INTO system_settings (id, "group", key, value, is_secret, label, created_at, updated_at, is_active)
        VALUES
          (gen_random_uuid(), 'payment', 'razorpay_payout_enabled',   'false',   false, 'Enable automatic payouts via Razorpay X (true/false)', now(), now(), true),
          (gen_random_uuid(), 'payment', 'razorpay_x_key_id',         '',        false, 'Razorpay X API Key ID (rzp_live_...)',                  now(), now(), true),
          (gen_random_uuid(), 'payment', 'razorpay_x_key_secret',     '',        true,  'Razorpay X API Key Secret — stored encrypted',         now(), now(), true),
          (gen_random_uuid(), 'payment', 'razorpay_x_account_number', '',        false, 'Razorpay X fund account number for outgoing payouts',  now(), now(), true),
          (gen_random_uuid(), 'payment', 'withdrawal_payout_mode',    'manual',  false, 'Payout mode: manual or razorpay',                      now(), now(), true)
        ON CONFLICT ("group", key) DO NOTHING;
    """))


def downgrade():
    op.execute(text("""
        DELETE FROM system_settings
        WHERE "group" = 'payment'
          AND key IN (
            'razorpay_payout_enabled',
            'razorpay_x_key_id',
            'razorpay_x_key_secret',
            'razorpay_x_account_number',
            'withdrawal_payout_mode'
          );
    """))
