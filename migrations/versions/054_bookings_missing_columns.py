"""054_bookings_missing_columns

ROOT CAUSE of /bookings 500 on VPS (but not local):
  Four columns exist in the Booking ORM model but were NEVER added in any
  Alembic migration. Local DB was created via create_all (has them). VPS DB
  was built from incremental migrations (missing them).

  Missing columns:
    bookings.coupon_id       UUID   (nullable)
    bookings.coupon_code     VARCHAR(50) (nullable)
    bookings.coupon_discount FLOAT  (nullable, default 0.0)
    bookings.city_id         UUID   FK → cities.id (nullable)

  All statements use ADD COLUMN IF NOT EXISTS — safe no-op on any DB that
  already has the columns (local dev, any VPS that ran create_all).

  env.py: FINAL_MIGRATION → '054', STAMP_AT → '053'

DO NOT manually stamp this on VPS. Push the code and let pm2 restart
trigger _auto_migrate() → env.py resets alembic_version to '053' →
alembic upgrade head runs this migration.

Revision ID: 054
Revises: 053
Create Date: 2026-07-08 (IST)
"""
from alembic import op
from sqlalchemy import text

revision = '054'
down_revision = '053'
branch_labels = None
depends_on = None


def upgrade():
    # ── bookings: coupon fields ───────────────────────────────────────────────
    # These were added to the ORM model (Booking class in models/booking.py)
    # but never appeared in any migration, causing a 500 on the VPS bookings
    # list endpoint because SQLAlchemy tries to read them from the result set.
    op.execute(text(
        "ALTER TABLE bookings ADD COLUMN IF NOT EXISTS coupon_id       UUID"
    ))
    op.execute(text(
        "ALTER TABLE bookings ADD COLUMN IF NOT EXISTS coupon_code     VARCHAR(50)"
    ))
    op.execute(text(
        "ALTER TABLE bookings ADD COLUMN IF NOT EXISTS coupon_discount  FLOAT DEFAULT 0.0"
    ))

    # ── bookings: city_id FK → cities ────────────────────────────────────────
    # Also in the ORM model but never migrated.
    # Add without FK constraint first (cities table may or may not exist on VPS).
    op.execute(text(
        "ALTER TABLE bookings ADD COLUMN IF NOT EXISTS city_id UUID"
    ))

    # Add FK constraint only if cities table exists and constraint not already there
    bind = op.get_bind()
    cities_exists = bind.execute(text(
        "SELECT EXISTS (SELECT 1 FROM information_schema.tables "
        "WHERE table_name = 'cities')"
    )).scalar()
    fk_exists = bind.execute(text(
        "SELECT EXISTS (SELECT 1 FROM information_schema.table_constraints "
        "WHERE constraint_name = 'fk_bookings_city_id' "
        "AND table_name = 'bookings')"
    )).scalar()
    if cities_exists and not fk_exists:
        try:
            op.execute(text(
                "ALTER TABLE bookings ADD CONSTRAINT fk_bookings_city_id "
                "FOREIGN KEY (city_id) REFERENCES cities(id)"
            ))
        except Exception:
            pass  # FK already exists under a different name — safe to skip

    print("[054] bookings missing columns added: coupon_id, coupon_code, coupon_discount, city_id")


def downgrade():
    op.execute(text("ALTER TABLE bookings DROP COLUMN IF EXISTS city_id"))
    op.execute(text("ALTER TABLE bookings DROP COLUMN IF EXISTS coupon_discount"))
    op.execute(text("ALTER TABLE bookings DROP COLUMN IF EXISTS coupon_code"))
    op.execute(text("ALTER TABLE bookings DROP COLUMN IF EXISTS coupon_id"))
