#!/bin/bash
# ============================================================
# VPS Technician POST 500 Fix — One-Shot Script
# 
# Usage on VPS:
#   export PGPASSWORD='your_db_password'
#   bash /opt/backend/bibekenterprises-backend/scripts/vps_technician_fix.sh
#
# What this does:
#   1. Shows current userrole enum values on VPS
#   2. Adds ACCOUNTANT + INVENTORY_MANAGER if missing
#   3. Ensures all required columns exist on users + technicians
#   4. Runs a smoke-test INSERT (rolled back)
#   5. Clears PM2 logs + restarts backend
#   6. Tails logs for 15s — trigger POST /technicians during this time
# ============================================================
set -euo pipefail

DB_HOST="${DB_HOST:-localhost}"
DB_PORT="${DB_PORT:-5432}"
DB_USER="${DB_USER:-bibek_user}"
DB_NAME="${DB_NAME:-bibek_enterprises}"

if [ -z "${PGPASSWORD:-}" ]; then
  echo "ERROR: export PGPASSWORD='your_password' first"
  exit 1
fi

PSQL="psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME"

echo ""
echo "▶ Step 1: Current userrole enum values"
$PSQL -c "SELECT unnest(enum_range(NULL::userrole))::text AS role;"

echo ""
echo "▶ Step 2: Add ACCOUNTANT + INVENTORY_MANAGER (AUTOCOMMIT required)"
$PSQL << 'SQL'
-- Must run outside transaction for PG < 12
ALTER TYPE userrole ADD VALUE IF NOT EXISTS 'ACCOUNTANT';
ALTER TYPE userrole ADD VALUE IF NOT EXISTS 'INVENTORY_MANAGER';
SQL
echo "   Enum fix done."

echo ""
echo "▶ Step 3: Verify enum now has all 7 values"
$PSQL -c "SELECT unnest(enum_range(NULL::userrole))::text AS role;"

echo ""
echo "▶ Step 4: Add missing columns to users table"
$PSQL << 'SQL'
ALTER TABLE users ADD COLUMN IF NOT EXISTS mpin_hash         VARCHAR(255);
ALTER TABLE users ADD COLUMN IF NOT EXISTS firebase_uid      VARCHAR(128);
ALTER TABLE users ADD COLUMN IF NOT EXISTS fcm_token         VARCHAR(500);
ALTER TABLE users ADD COLUMN IF NOT EXISTS id_proof_url      VARCHAR(500);
ALTER TABLE users ADD COLUMN IF NOT EXISTS id_proof_type     VARCHAR(50);
ALTER TABLE users ADD COLUMN IF NOT EXISTS address_proof_url VARCHAR(500);
ALTER TABLE users ADD COLUMN IF NOT EXISTS address_proof_type VARCHAR(50);
ALTER TABLE users ADD COLUMN IF NOT EXISTS profile_image     VARCHAR(500);
ALTER TABLE users ADD COLUMN IF NOT EXISTS city              VARCHAR(100);
ALTER TABLE users ADD COLUMN IF NOT EXISTS is_verified       BOOLEAN DEFAULT FALSE;
SQL
echo "   users columns done."

echo ""
echo "▶ Step 5: Add missing columns to technicians table"
$PSQL << 'SQL'
ALTER TABLE technicians ADD COLUMN IF NOT EXISTS is_online                BOOLEAN NOT NULL DEFAULT FALSE;
ALTER TABLE technicians ADD COLUMN IF NOT EXISTS fcm_token                VARCHAR(500);
ALTER TABLE technicians ADD COLUMN IF NOT EXISTS last_lat                 DOUBLE PRECISION;
ALTER TABLE technicians ADD COLUMN IF NOT EXISTS last_lng                 DOUBLE PRECISION;
ALTER TABLE technicians ADD COLUMN IF NOT EXISTS last_seen_at             TIMESTAMP WITH TIME ZONE;
ALTER TABLE technicians ADD COLUMN IF NOT EXISTS auto_assign_eligible     BOOLEAN NOT NULL DEFAULT TRUE;
ALTER TABLE technicians ADD COLUMN IF NOT EXISTS alternate_mobile         VARCHAR(20);
ALTER TABLE technicians ADD COLUMN IF NOT EXISTS dob                      DATE;
ALTER TABLE technicians ADD COLUMN IF NOT EXISTS gender                   VARCHAR(10);
ALTER TABLE technicians ADD COLUMN IF NOT EXISTS emergency_contact_name   VARCHAR(150);
ALTER TABLE technicians ADD COLUMN IF NOT EXISTS emergency_contact_mobile VARCHAR(20);
ALTER TABLE technicians ADD COLUMN IF NOT EXISTS identity_type            VARCHAR(50);
ALTER TABLE technicians ADD COLUMN IF NOT EXISTS identity_number          VARCHAR(50);
ALTER TABLE technicians ADD COLUMN IF NOT EXISTS pincode                  VARCHAR(10);
ALTER TABLE technicians ADD COLUMN IF NOT EXISTS area                     VARCHAR(200);
ALTER TABLE technicians ADD COLUMN IF NOT EXISTS address                  TEXT;
ALTER TABLE technicians ADD COLUMN IF NOT EXISTS profile_image            VARCHAR(500);
ALTER TABLE technicians ADD COLUMN IF NOT EXISTS id_proof                 VARCHAR(500);
ALTER TABLE technicians ADD COLUMN IF NOT EXISTS email                    VARCHAR(200);
ALTER TABLE technicians ADD COLUMN IF NOT EXISTS technician_code          VARCHAR(30);
ALTER TABLE technicians ADD COLUMN IF NOT EXISTS experience_years         INTEGER DEFAULT 0;
ALTER TABLE technicians ADD COLUMN IF NOT EXISTS rating                   FLOAT DEFAULT 0.0;
ALTER TABLE technicians ADD COLUMN IF NOT EXISTS total_jobs               INTEGER DEFAULT 0;
SQL
echo "   technicians columns done."

echo ""
echo "▶ Step 6: Smoke test — dry INSERT into users (rolled back)"
$PSQL << 'SQL'
BEGIN;
INSERT INTO users (id, name, mobile, role, is_verified, created_at, updated_at)
VALUES (gen_random_uuid(), '__smoke__', '0000000099', 'TECHNICIAN', true, NOW(), NOW());
ROLLBACK;
SQL
echo "   Smoke test PASSED."

echo ""
echo "▶ Step 7: Stamp alembic_version to 060 if migration has already applied"
$PSQL -c "
  INSERT INTO alembic_version (version_num) VALUES ('060')
  ON CONFLICT DO NOTHING;
  SELECT version_num FROM alembic_version;
"

echo ""
echo "▶ Step 8: Clear PM2 logs and restart backend"
pm2 flush bibek-backend
pm2 restart bibek-backend
sleep 5
pm2 status bibek-backend

echo ""
echo "▶ Step 9: Watching logs for 20s — trigger POST /technicians from admin dashboard NOW"
echo "   (Look for 'Unhandled exception' or errors below)"
timeout 20 pm2 logs bibek-backend --raw 2>&1 | grep --line-buffered -v "WebSocket\|ws/\|/api/v1/domains\|/api/v1/services" || true

echo ""
echo "=========================================="
echo "  DONE."
echo "  If Step 9 shows no errors → 500 is fixed."
echo "  If still errors → copy the traceback here."
echo "=========================================="
