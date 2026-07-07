-- ============================================================
-- VPS Direct Schema Fix
-- Run as:  psql -U bibek_user -d palei_solutions -f vps_direct_fix.sql
-- ============================================================

-- technicians table
ALTER TABLE technicians ADD COLUMN IF NOT EXISTS is_online BOOLEAN NOT NULL DEFAULT FALSE;
ALTER TABLE technicians ADD COLUMN IF NOT EXISTS fcm_token VARCHAR(500);
ALTER TABLE technicians ADD COLUMN IF NOT EXISTS last_lat DOUBLE PRECISION;
ALTER TABLE technicians ADD COLUMN IF NOT EXISTS last_lng DOUBLE PRECISION;
ALTER TABLE technicians ADD COLUMN IF NOT EXISTS last_seen_at TIMESTAMP WITH TIME ZONE;
ALTER TABLE technicians ADD COLUMN IF NOT EXISTS auto_assign_eligible BOOLEAN NOT NULL DEFAULT TRUE;
ALTER TABLE technicians ADD COLUMN IF NOT EXISTS alternate_mobile VARCHAR(20);
ALTER TABLE technicians ADD COLUMN IF NOT EXISTS dob DATE;
ALTER TABLE technicians ADD COLUMN IF NOT EXISTS gender VARCHAR(10);
ALTER TABLE technicians ADD COLUMN IF NOT EXISTS pincode VARCHAR(10);
ALTER TABLE technicians ADD COLUMN IF NOT EXISTS identity_type VARCHAR(50);
ALTER TABLE technicians ADD COLUMN IF NOT EXISTS identity_number VARCHAR(50);
ALTER TABLE technicians ADD COLUMN IF NOT EXISTS emergency_contact_name VARCHAR(150);
ALTER TABLE technicians ADD COLUMN IF NOT EXISTS emergency_contact_mobile VARCHAR(20);

-- payment_transactions table
ALTER TABLE payment_transactions ADD COLUMN IF NOT EXISTS due_collect_at TIMESTAMP WITH TIME ZONE;
ALTER TABLE payment_transactions ADD COLUMN IF NOT EXISTS last_reminder_at TIMESTAMP WITH TIME ZONE;

-- users table
ALTER TABLE users ADD COLUMN IF NOT EXISTS fcm_token VARCHAR(500);
ALTER TABLE users ADD COLUMN IF NOT EXISTS firebase_uid VARCHAR(128);
ALTER TABLE users ADD COLUMN IF NOT EXISTS id_proof_url VARCHAR(500);
ALTER TABLE users ADD COLUMN IF NOT EXISTS address_proof_url VARCHAR(500);
ALTER TABLE users ADD COLUMN IF NOT EXISTS id_proof_type VARCHAR(50);
ALTER TABLE users ADD COLUMN IF NOT EXISTS address_proof_type VARCHAR(50);

-- services table
ALTER TABLE services ADD COLUMN IF NOT EXISTS is_pending_verify INTEGER NOT NULL DEFAULT 0;
ALTER TABLE services ADD COLUMN IF NOT EXISTS suggested_by_tech UUID;

-- quotation_service_items table
ALTER TABLE quotation_service_items ADD COLUMN IF NOT EXISTS is_pending_verify INTEGER NOT NULL DEFAULT 0;
ALTER TABLE quotation_service_items ADD COLUMN IF NOT EXISTS custom_service_name TEXT;
ALTER TABLE quotation_service_items ADD COLUMN IF NOT EXISTS tech_commission_override DOUBLE PRECISION;
ALTER TABLE quotation_service_items ALTER COLUMN service_id DROP NOT NULL;

-- Unique constraint on users.firebase_uid (skip if exists)
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.table_constraints
        WHERE constraint_name = 'uq_users_firebase_uid'
    ) THEN
        ALTER TABLE users ADD CONSTRAINT uq_users_firebase_uid UNIQUE (firebase_uid);
    END IF;
END$$;

-- Verify result
SELECT
    table_name,
    column_name,
    data_type
FROM information_schema.columns
WHERE (table_name = 'technicians'          AND column_name IN ('is_online','fcm_token','last_lat','last_lng','last_seen_at','auto_assign_eligible'))
   OR (table_name = 'payment_transactions' AND column_name IN ('due_collect_at','last_reminder_at','collected_by_role','cash_collection_status'))
   OR (table_name = 'users'                AND column_name IN ('fcm_token','firebase_uid','id_proof_url','address_proof_url'))
   OR (table_name = 'services'             AND column_name IN ('is_pending_verify','suggested_by_tech'))
   OR (table_name = 'quotation_service_items' AND column_name IN ('is_pending_verify','custom_service_name','tech_commission_override'))
ORDER BY table_name, column_name;
