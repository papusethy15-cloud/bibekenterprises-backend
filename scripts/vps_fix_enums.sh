#!/bin/bash
# Run ENUM fixes separately — ALTER TYPE ADD VALUE cannot run inside a transaction.
# Reads DATABASE_URL from .env automatically.

# Parse DATABASE_URL from .env
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_FILE="$SCRIPT_DIR/../.env"

if [ ! -f "$ENV_FILE" ]; then
    echo "ERROR: .env not found at $ENV_FILE"
    exit 1
fi

RAW_URL=$(grep '^DATABASE_URL=' "$ENV_FILE" | cut -d= -f2-)

# URL-decode %40 -> @ and %23 -> #
DECODED_URL=$(python3 -c "import urllib.parse, sys; print(urllib.parse.unquote(sys.argv[1]))" "$RAW_URL")

echo "Using connection: $DECODED_URL"
echo ""

echo "Adding PAY_LATER to paymentmethod enum..."
psql "$DECODED_URL" -c "ALTER TYPE paymentmethod ADD VALUE IF NOT EXISTS 'PAY_LATER';"

echo "Adding CANCELLED to paymentstatus enum..."
psql "$DECODED_URL" -c "ALTER TYPE paymentstatus ADD VALUE IF NOT EXISTS 'CANCELLED';"

echo ""
echo "Verifying enum values..."
psql "$DECODED_URL" -c "
SELECT t.typname AS enum_name, e.enumlabel AS value
FROM pg_enum e
JOIN pg_type t ON t.oid = e.enumtypid
WHERE t.typname IN ('paymentmethod','paymentstatus')
ORDER BY t.typname, e.enumsortorder;
"

echo "Done."
