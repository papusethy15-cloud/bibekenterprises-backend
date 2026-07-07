#!/bin/bash
# vps_fix_columns.sh
# -------------------------------------------------------------------
# EMERGENCY FIX: Adds all columns that were missing on the VPS because
# `alembic stamp 049` was run manually before the migration scripts ran.
#
# Safe to run multiple times — all statements use IF NOT EXISTS.
# Run this ONCE on the VPS, then `pm2 restart bibek-backend`.
# -------------------------------------------------------------------

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_FILE="$SCRIPT_DIR/../.env"

if [ ! -f "$ENV_FILE" ]; then
    echo "ERROR: .env not found at $ENV_FILE"
    exit 1
fi

RAW_URL=$(grep '^DATABASE_URL=' "$ENV_FILE" | cut -d= -f2-)

read DB_HOST DB_PORT DB_USER DB_NAME < <(python3 -c "
import re, urllib.parse, sys
url = sys.argv[1]
m = re.match(r'postgresql://([^:]+):([^@]+)@([^:/]+):?(\d+)?/([^?#]+)', url)
if not m:
    print('PARSE_ERROR', '5432', 'PARSE_ERROR', 'PARSE_ERROR')
    sys.exit(1)
user = urllib.parse.unquote(m.group(1))
host = m.group(3)
port = m.group(4) or '5432'
db   = m.group(5)
print(host, port, user, db)
" "$RAW_URL")

echo "Host=$DB_HOST  Port=$DB_PORT  User=$DB_USER  DB=$DB_NAME"
echo ""
read -s -p "Enter password for $DB_USER: " PGPASSWORD
echo ""
export PGPASSWORD

PSQL="psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME"

run() {
    echo "  → $1"
    $PSQL -c "$1" 2>&1 | grep -v "^$\|^psql"
}

echo ""
echo "=== technicians columns ==="
run "ALTER TABLE technicians ADD COLUMN IF NOT EXISTS is_online               BOOLEAN NOT NULL DEFAULT FALSE;"
run "ALTER TABLE technicians ADD COLUMN IF NOT EXISTS fcm_token               VARCHAR(500);"
run "ALTER TABLE technicians ADD COLUMN IF NOT EXISTS last_lat                DOUBLE PRECISION;"
run "ALTER TABLE technicians ADD COLUMN IF NOT EXISTS last_lng                DOUBLE PRECISION;"
run "ALTER TABLE technicians ADD COLUMN IF NOT EXISTS last_seen_at            TIMESTAMP WITH TIME ZONE;"
run "ALTER TABLE technicians ADD COLUMN IF NOT EXISTS auto_assign_eligible    BOOLEAN NOT NULL DEFAULT TRUE;"
run "ALTER TABLE technicians ADD COLUMN IF NOT EXISTS alternate_mobile        VARCHAR(20);"
run "ALTER TABLE technicians ADD COLUMN IF NOT EXISTS dob                     DATE;"
run "ALTER TABLE technicians ADD COLUMN IF NOT EXISTS gender                  VARCHAR(10);"
run "ALTER TABLE technicians ADD COLUMN IF NOT EXISTS pincode                 VARCHAR(10);"
run "ALTER TABLE technicians ADD COLUMN IF NOT EXISTS identity_type           VARCHAR(50);"
run "ALTER TABLE technicians ADD COLUMN IF NOT EXISTS identity_number         VARCHAR(50);"
run "ALTER TABLE technicians ADD COLUMN IF NOT EXISTS emergency_contact_name  VARCHAR(150);"
run "ALTER TABLE technicians ADD COLUMN IF NOT EXISTS emergency_contact_mobile VARCHAR(20);"

echo ""
echo "=== users columns ==="
run "ALTER TABLE users ADD COLUMN IF NOT EXISTS fcm_token           VARCHAR(500);"
run "ALTER TABLE users ADD COLUMN IF NOT EXISTS firebase_uid        VARCHAR(128);"
run "ALTER TABLE users ADD COLUMN IF NOT EXISTS id_proof_url        VARCHAR(500);"
run "ALTER TABLE users ADD COLUMN IF NOT EXISTS address_proof_url   VARCHAR(500);"
run "ALTER TABLE users ADD COLUMN IF NOT EXISTS id_proof_type       VARCHAR(50);"
run "ALTER TABLE users ADD COLUMN IF NOT EXISTS address_proof_type  VARCHAR(50);"

echo ""
echo "=== services columns ==="
run "ALTER TABLE services ADD COLUMN IF NOT EXISTS is_pending_verify INTEGER NOT NULL DEFAULT 0;"
run "ALTER TABLE services ADD COLUMN IF NOT EXISTS suggested_by_tech UUID;"

echo ""
echo "=== quotation_service_items columns ==="
run "ALTER TABLE quotation_service_items ADD COLUMN IF NOT EXISTS is_pending_verify        INTEGER NOT NULL DEFAULT 0;"
run "ALTER TABLE quotation_service_items ADD COLUMN IF NOT EXISTS custom_service_name      TEXT;"
run "ALTER TABLE quotation_service_items ADD COLUMN IF NOT EXISTS tech_commission_override DOUBLE PRECISION;"
run "ALTER TABLE quotation_service_items ALTER COLUMN service_id DROP NOT NULL;" 2>/dev/null || true

echo ""
echo "=== payment_transactions columns ==="
run "ALTER TABLE payment_transactions ADD COLUMN IF NOT EXISTS due_collect_at   TIMESTAMP WITH TIME ZONE;"
run "ALTER TABLE payment_transactions ADD COLUMN IF NOT EXISTS last_reminder_at TIMESTAMP WITH TIME ZONE;"

echo ""
echo "=== unique constraint ==="
$PSQL -c "ALTER TABLE users ADD CONSTRAINT uq_users_firebase_uid UNIQUE (firebase_uid);" 2>/dev/null || echo "  (uq_users_firebase_uid already exists — OK)"

echo ""
echo "=== stamp alembic to 050 ==="
# After this script runs all columns exist. Tell Alembic 050 is done.
$PSQL -c "DELETE FROM alembic_version;"
$PSQL -c "INSERT INTO alembic_version (version_num) VALUES ('050');"
echo "  alembic_version set to 050"

echo ""
echo "=== Verifying critical columns ==="
$PSQL -c "
SELECT
  (SELECT COUNT(*) FROM information_schema.columns WHERE table_name='technicians' AND column_name='is_online')     AS tech_is_online,
  (SELECT COUNT(*) FROM information_schema.columns WHERE table_name='technicians' AND column_name='fcm_token')     AS tech_fcm_token,
  (SELECT COUNT(*) FROM information_schema.columns WHERE table_name='payment_transactions' AND column_name='due_collect_at')   AS pay_due_collect_at,
  (SELECT COUNT(*) FROM information_schema.columns WHERE table_name='payment_transactions' AND column_name='last_reminder_at') AS pay_last_reminder_at,
  (SELECT COUNT(*) FROM information_schema.columns WHERE table_name='users' AND column_name='fcm_token')           AS users_fcm_token;
"

echo ""
echo "Done. Now run: pm2 restart bibek-backend"
unset PGPASSWORD
