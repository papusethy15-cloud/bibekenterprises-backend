#!/bin/bash
# ============================================================
# VPS Technician POST /500 — Diagnose & Fix
# Run on VPS as: bash /opt/backend/bibekenterprises-backend/scripts/vps_diagnose_technician.sh
# ============================================================
set -e

DB_HOST="localhost"
DB_PORT="5432"
DB_USER="bibek_user"
DB_NAME="bibek_enterprises"

if [ -z "$PGPASSWORD" ]; then
  echo "ERROR: Set PGPASSWORD first:  export PGPASSWORD='your_password'"
  exit 1
fi

PSQL="psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -v ON_ERROR_STOP=1"

echo ""
echo "========================================"
echo "  STEP 1: CLEAR PM2 LOGS (fresh start)"
echo "========================================"
pm2 flush bibek-backend
echo "PM2 logs cleared."

echo ""
echo "========================================"
echo "  STEP 2: CHECK userrole ENUM"
echo "========================================"
$PSQL -c "SELECT unnest(enum_range(NULL::userrole))::text AS role_value;"

echo ""
echo "========================================"
echo "  STEP 3: FIX ENUM — add missing values"
echo "========================================"
$PSQL << 'SQL'
DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_enum WHERE enumlabel='ACCOUNTANT'
                 AND enumtypid=(SELECT oid FROM pg_type WHERE typname='userrole'))
  THEN ALTER TYPE userrole ADD VALUE 'ACCOUNTANT';
       RAISE NOTICE 'Added ACCOUNTANT'; END IF;
END$$;
DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_enum WHERE enumlabel='INVENTORY_MANAGER'
                 AND enumtypid=(SELECT oid FROM pg_type WHERE typname='userrole'))
  THEN ALTER TYPE userrole ADD VALUE 'INVENTORY_MANAGER';
       RAISE NOTICE 'Added INVENTORY_MANAGER'; END IF;
END$$;
SQL
echo "Enum check done."

echo ""
echo "========================================"
echo "  STEP 4: FIX users TABLE columns"
echo "========================================"
$PSQL << 'SQL'
ALTER TABLE users ADD COLUMN IF NOT EXISTS mpin_hash        VARCHAR(255);
ALTER TABLE users ADD COLUMN IF NOT EXISTS firebase_uid     VARCHAR(128);
ALTER TABLE users ADD COLUMN IF NOT EXISTS fcm_token        VARCHAR(500);
ALTER TABLE users ADD COLUMN IF NOT EXISTS id_proof_url     VARCHAR(500);
ALTER TABLE users ADD COLUMN IF NOT EXISTS id_proof_type    VARCHAR(50);
ALTER TABLE users ADD COLUMN IF NOT EXISTS address_proof_url  VARCHAR(500);
ALTER TABLE users ADD COLUMN IF NOT EXISTS address_proof_type VARCHAR(50);
ALTER TABLE users ADD COLUMN IF NOT EXISTS profile_image    VARCHAR(500);
ALTER TABLE users ADD COLUMN IF NOT EXISTS city             VARCHAR(100);
ALTER TABLE users ADD COLUMN IF NOT EXISTS is_verified      BOOLEAN DEFAULT FALSE;
SQL
echo "users table fixed."

echo ""
echo "========================================"
echo "  STEP 5: FIX technicians TABLE columns"
echo "========================================"
$PSQL << 'SQL'
ALTER TABLE technicians ADD COLUMN IF NOT EXISTS is_online               BOOLEAN NOT NULL DEFAULT FALSE;
ALTER TABLE technicians ADD COLUMN IF NOT EXISTS fcm_token               VARCHAR(500);
ALTER TABLE technicians ADD COLUMN IF NOT EXISTS last_lat                DOUBLE PRECISION;
ALTER TABLE technicians ADD COLUMN IF NOT EXISTS last_lng                DOUBLE PRECISION;
ALTER TABLE technicians ADD COLUMN IF NOT EXISTS last_seen_at            TIMESTAMP WITH TIME ZONE;
ALTER TABLE technicians ADD COLUMN IF NOT EXISTS auto_assign_eligible    BOOLEAN NOT NULL DEFAULT TRUE;
ALTER TABLE technicians ADD COLUMN IF NOT EXISTS alternate_mobile        VARCHAR(20);
ALTER TABLE technicians ADD COLUMN IF NOT EXISTS dob                     DATE;
ALTER TABLE technicians ADD COLUMN IF NOT EXISTS gender                  VARCHAR(10);
ALTER TABLE technicians ADD COLUMN IF NOT EXISTS emergency_contact_name  VARCHAR(150);
ALTER TABLE technicians ADD COLUMN IF NOT EXISTS emergency_contact_mobile VARCHAR(20);
ALTER TABLE technicians ADD COLUMN IF NOT EXISTS identity_type           VARCHAR(50);
ALTER TABLE technicians ADD COLUMN IF NOT EXISTS identity_number         VARCHAR(50);
ALTER TABLE technicians ADD COLUMN IF NOT EXISTS pincode                 VARCHAR(10);
ALTER TABLE technicians ADD COLUMN IF NOT EXISTS area                    VARCHAR(200);
ALTER TABLE technicians ADD COLUMN IF NOT EXISTS address                 TEXT;
ALTER TABLE technicians ADD COLUMN IF NOT EXISTS profile_image           VARCHAR(500);
ALTER TABLE technicians ADD COLUMN IF NOT EXISTS id_proof                VARCHAR(500);
ALTER TABLE technicians ADD COLUMN IF NOT EXISTS email                   VARCHAR(200);
ALTER TABLE technicians ADD COLUMN IF NOT EXISTS technician_code         VARCHAR(30);
ALTER TABLE technicians ADD COLUMN IF NOT EXISTS experience_years        INTEGER DEFAULT 0;
ALTER TABLE technicians ADD COLUMN IF NOT EXISTS rating                  FLOAT DEFAULT 0.0;
ALTER TABLE technicians ADD COLUMN IF NOT EXISTS total_jobs              INTEGER DEFAULT 0;
SQL
echo "technicians table fixed."

echo ""
echo "========================================"
echo "  STEP 6: SMOKE TEST — dry INSERT into users"
echo "========================================"
$PSQL << 'SQL'
BEGIN;
INSERT INTO users (id, name, mobile, role, is_verified, created_at, updated_at)
VALUES (gen_random_uuid(), '__smoke_test__', '9999999999', 'TECHNICIAN', true, NOW(), NOW());
ROLLBACK;
SQL
echo "Smoke test PASSED — INSERT+ROLLBACK succeeded."

echo ""
echo "========================================"
echo "  STEP 7: RESTART backend"
echo "========================================"
pm2 restart bibek-backend
sleep 4
pm2 status bibek-backend

echo ""
echo "========================================"
echo "  STEP 8: TAIL fresh logs (20s) — trigger POST /technicians now from admin dashboard"
echo "========================================"
timeout 20 pm2 logs bibek-backend --lines 0 --raw 2>&1 || true

echo ""
echo "========================================"
echo "  DONE — Check above for any errors."
echo "  If still 500: see STEP 8 output for traceback."
echo "========================================"
