-- ============================================================
-- VPS FIX: Backfill service_name from services table
-- for all bookings where service_name is NULL or empty
-- but service_id is set.
-- Run on VPS:
--   PGPASSWORD='Bibek@2026#Secure' psql -U bibek_user -d bibek_enterprises -f vps_fix_service_name.sql
-- ============================================================

-- 1. Show before state (how many need fixing)
SELECT
  COUNT(*) AS bookings_missing_service_name
FROM bookings
WHERE (service_name IS NULL OR service_name = '' OR service_name = '—')
  AND service_id IS NOT NULL;

-- 2. Backfill service_name from services table
UPDATE bookings b
SET service_name = s.name
FROM services s
WHERE b.service_id = s.id
  AND (b.service_name IS NULL OR b.service_name = '' OR b.service_name = '—');

-- 3. Show after state (verify fix)
SELECT
  COUNT(*) AS bookings_still_missing_service_name
FROM bookings
WHERE (service_name IS NULL OR service_name = '' OR service_name = '—')
  AND service_id IS NOT NULL;

-- 4. Also show a sample of fixed bookings
SELECT
  booking_number,
  service_id,
  service_name,
  status,
  source
FROM bookings
WHERE service_name IS NOT NULL
  AND service_name != ''
  AND service_name != '—'
ORDER BY created_at DESC
LIMIT 10;
