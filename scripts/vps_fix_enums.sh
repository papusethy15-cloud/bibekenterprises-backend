#!/bin/bash
# Run ENUM fixes separately — ALTER TYPE ADD VALUE cannot run inside a transaction.
# Run as: bash vps_fix_enums.sh
# Adjust DB credentials as needed.

DB_USER="${DB_USER:-bibek_user}"
DB_NAME="${DB_NAME:-palei_solutions}"
DB_HOST="${DB_HOST:-localhost}"

echo "Adding PAY_LATER to paymentmethod enum..."
psql -h $DB_HOST -U $DB_USER -d $DB_NAME -c "ALTER TYPE paymentmethod ADD VALUE IF NOT EXISTS 'PAY_LATER';"

echo "Adding CANCELLED to paymentstatus enum..."
psql -h $DB_HOST -U $DB_USER -d $DB_NAME -c "ALTER TYPE paymentstatus ADD VALUE IF NOT EXISTS 'CANCELLED';"

echo "Done."
