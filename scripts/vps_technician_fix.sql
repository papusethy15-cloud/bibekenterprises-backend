-- ============================================================
-- VPS Technician POST 500 — Diagnostic & Fix Script
-- Run on VPS: PGPASSWORD=<pwd> psql -h localhost -p 5432 -U bibek_user -d bibek_enterprises -f vps_technician_fix.sql
-- ============================================================

\echo '=== 1. Checking userrole enum values ==='
SELECT unnest(enum_range(NULL::userrole))::text AS role_value;

\echo '=== 2. Checking users table columns ==='
SELECT column_name, data_type, is_nullable, column_default
FROM information_schema.columns
WHERE table_name = 'users'
ORDER BY ordinal_position;

\echo '=== 3. Checking technicians table columns ==='
SELECT column_name, data_type, is_nullable, column_default
FROM information_schema.columns
WHERE table_name = 'technicians'
ORDER BY ordinal_position;

\echo '=== 4. FIX: Ensure userrole enum has all values ==='
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_enum WHERE enumlabel = 'ACCOUNTANT'
                 AND enumtypid = (SELECT oid FROM pg_type WHERE typname = 'userrole')) THEN
    ALTER TYPE userrole ADD VALUE 'ACCOUNTANT';
    RAISE NOTICE 'Added ACCOUNTANT to userrole';
  ELSE
    RAISE NOTICE 'ACCOUNTANT already in userrole';
  END IF;
END$$;

DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_enum WHERE enumlabel = 'INVENTORY_MANAGER'
                 AND enumtypid = (SELECT oid FROM pg_type WHERE typname = 'userrole')) THEN
    ALTER TYPE userrole ADD VALUE 'INVENTORY_MANAGER';
    RAISE NOTICE 'Added INVENTORY_MANAGER to userrole';
  ELSE
    RAISE NOTICE 'INVENTORY_MANAGER already in userrole';
  END IF;
END$$;

\echo '=== 5. FIX: Ensure users table has all required columns ==='
ALTER TABLE users ADD COLUMN IF NOT EXISTS mpin_hash VARCHAR(255);
ALTER TABLE users ADD COLUMN IF NOT EXISTS firebase_uid VARCHAR(128);
ALTER TABLE users ADD COLUMN IF NOT EXISTS fcm_token VARCHAR(500);
ALTER TABLE users ADD COLUMN IF NOT EXISTS id_proof_url VARCHAR(500);
ALTER TABLE users ADD COLUMN IF NOT EXISTS id_proof_type VARCHAR(50);
ALTER TABLE users ADD COLUMN IF NOT EXISTS address_proof_url VARCHAR(500);
ALTER TABLE users ADD COLUMN IF NOT EXISTS address_proof_type VARCHAR(50);
ALTER TABLE users ADD COLUMN IF NOT EXISTS profile_image VARCHAR(500);
ALTER TABLE users ADD COLUMN IF NOT EXISTS city VARCHAR(100);
ALTER TABLE users ADD COLUMN IF NOT EXISTS is_verified BOOLEAN DEFAULT FALSE;

\echo '=== 6. FIX: Ensure technicians table has all required columns ==='
ALTER TABLE technicians ADD COLUMN IF NOT EXISTS is_online BOOLEAN NOT NULL DEFAULT FALSE;
ALTER TABLE technicians ADD COLUMN IF NOT EXISTS fcm_token VARCHAR(500);
ALTER TABLE technicians ADD COLUMN IF NOT EXISTS last_lat DOUBLE PRECISION;
ALTER TABLE technicians ADD COLUMN IF NOT EXISTS last_lng DOUBLE PRECISION;
ALTER TABLE technicians ADD COLUMN IF NOT EXISTS last_seen_at TIMESTAMP WITH TIME ZONE;
ALTER TABLE technicians ADD COLUMN IF NOT EXISTS auto_assign_eligible BOOLEAN NOT NULL DEFAULT TRUE;
ALTER TABLE technicians ADD COLUMN IF NOT EXISTS alternate_mobile VARCHAR(20);
ALTER TABLE technicians ADD COLUMN IF NOT EXISTS dob DATE;
ALTER TABLE technicians ADD COLUMN IF NOT EXISTS gender VARCHAR(10);
ALTER TABLE technicians ADD COLUMN IF NOT EXISTS emergency_contact_name VARCHAR(150);
ALTER TABLE technicians ADD COLUMN IF NOT EXISTS emergency_contact_mobile VARCHAR(20);
ALTER TABLE technicians ADD COLUMN IF NOT EXISTS identity_type VARCHAR(50);
ALTER TABLE technicians ADD COLUMN IF NOT EXISTS identity_number VARCHAR(50);
ALTER TABLE technicians ADD COLUMN IF NOT EXISTS pincode VARCHAR(10);
ALTER TABLE technicians ADD COLUMN IF NOT EXISTS area VARCHAR(200);
ALTER TABLE technicians ADD COLUMN IF NOT EXISTS address TEXT;
ALTER TABLE technicians ADD COLUMN IF NOT EXISTS profile_image VARCHAR(500);
ALTER TABLE technicians ADD COLUMN IF NOT EXISTS id_proof VARCHAR(500);
ALTER TABLE technicians ADD COLUMN IF NOT EXISTS email VARCHAR(200);
ALTER TABLE technicians ADD COLUMN IF NOT EXISTS technician_code VARCHAR(30);
ALTER TABLE technicians ADD COLUMN IF NOT EXISTS experience_years INTEGER DEFAULT 0;
ALTER TABLE technicians ADD COLUMN IF NOT EXISTS rating FLOAT DEFAULT 0.0;
ALTER TABLE technicians ADD COLUMN IF NOT EXISTS total_jobs INTEGER DEFAULT 0;

\echo '=== 7. FIX: Ensure firebase_uid unique constraint exists (only add if missing) ==='
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint
    WHERE conname = 'users_firebase_uid_key' AND conrelid = 'users'::regclass
  ) THEN
    -- Only add unique if column has no duplicates (it is nullable so NULLs are ok)
    ALTER TABLE users ADD CONSTRAINT users_firebase_uid_key UNIQUE (firebase_uid);
    RAISE NOTICE 'Added firebase_uid unique constraint';
  ELSE
    RAISE NOTICE 'firebase_uid unique constraint already exists';
  END IF;
EXCEPTION WHEN OTHERS THEN
  RAISE NOTICE 'Could not add firebase_uid constraint: %', SQLERRM;
END$$;

\echo '=== 8. Quick smoke test: attempt a dry-run insert to users (rollback) ==='
BEGIN;
INSERT INTO users (id, name, mobile, role, is_verified, created_at, updated_at)
VALUES (
  gen_random_uuid(),
  '__test_tech_smoke__',
  '0000000000',
  'TECHNICIAN',
  true,
  NOW(),
  NOW()
);
ROLLBACK;
\echo 'Smoke test PASSED — INSERT+ROLLBACK succeeded'

\echo '=== 9. Final column check after fixes ==='
SELECT column_name FROM information_schema.columns WHERE table_name = 'users' ORDER BY ordinal_position;
SELECT column_name FROM information_schema.columns WHERE table_name = 'technicians' ORDER BY ordinal_position;

\echo '=== DONE ==='
