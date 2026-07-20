-- ============================================================
-- palei_vps_fix.sql  (v2 - adds ALL missing columns)
-- Safe: all statements use IF NOT EXISTS / DO $$ guards
--
-- Usage on VPS:
--   PGPASSWORD="SrikantaDB1994" psql -h localhost -p 5432 \
--     -U palei_user palei_solutions -f palei_vps_fix.sql
-- ============================================================

\echo '>>> [1] ENUMs...'
DO $$ BEGIN CREATE TYPE bookingstatus AS ENUM ('PENDING','CONFIRMED','ASSIGNED','ACCEPTED','EN_ROUTE','ARRIVED','INSPECTING','IN_PROGRESS','COMPLETED','CANCELLED','RESCHEDULED','NO_SHOW','PENDING_VERIFICATION','TECHNICIAN_ACCEPTED','INVOICE_GENERATED','PAYMENT_PENDING','WORK_STARTED','WORK_PAUSED','REFUND_INITIATED','PAID','CLOSED','SETTLED','QUOTATION_APPROVED','CANCELLATION_REQUESTED'); EXCEPTION WHEN duplicate_object THEN NULL; END $$;
DO $$ BEGIN ALTER TYPE bookingstatus ADD VALUE IF NOT EXISTS 'PENDING_VERIFICATION'; EXCEPTION WHEN others THEN NULL; END $$;
DO $$ BEGIN ALTER TYPE bookingstatus ADD VALUE IF NOT EXISTS 'TECHNICIAN_ACCEPTED'; EXCEPTION WHEN others THEN NULL; END $$;
DO $$ BEGIN ALTER TYPE bookingstatus ADD VALUE IF NOT EXISTS 'INVOICE_GENERATED'; EXCEPTION WHEN others THEN NULL; END $$;
DO $$ BEGIN ALTER TYPE bookingstatus ADD VALUE IF NOT EXISTS 'PAYMENT_PENDING'; EXCEPTION WHEN others THEN NULL; END $$;
DO $$ BEGIN ALTER TYPE bookingstatus ADD VALUE IF NOT EXISTS 'WORK_STARTED'; EXCEPTION WHEN others THEN NULL; END $$;
DO $$ BEGIN ALTER TYPE bookingstatus ADD VALUE IF NOT EXISTS 'WORK_PAUSED'; EXCEPTION WHEN others THEN NULL; END $$;
DO $$ BEGIN ALTER TYPE bookingstatus ADD VALUE IF NOT EXISTS 'REFUND_INITIATED'; EXCEPTION WHEN others THEN NULL; END $$;
DO $$ BEGIN ALTER TYPE bookingstatus ADD VALUE IF NOT EXISTS 'PAID'; EXCEPTION WHEN others THEN NULL; END $$;
DO $$ BEGIN ALTER TYPE bookingstatus ADD VALUE IF NOT EXISTS 'CLOSED'; EXCEPTION WHEN others THEN NULL; END $$;
DO $$ BEGIN ALTER TYPE bookingstatus ADD VALUE IF NOT EXISTS 'SETTLED'; EXCEPTION WHEN others THEN NULL; END $$;
DO $$ BEGIN ALTER TYPE bookingstatus ADD VALUE IF NOT EXISTS 'QUOTATION_APPROVED'; EXCEPTION WHEN others THEN NULL; END $$;
DO $$ BEGIN ALTER TYPE bookingstatus ADD VALUE IF NOT EXISTS 'CANCELLATION_REQUESTED'; EXCEPTION WHEN others THEN NULL; END $$;
DO $$ BEGIN ALTER TYPE bookingstatus ADD VALUE IF NOT EXISTS 'NO_SHOW'; EXCEPTION WHEN others THEN NULL; END $$;
DO $$ BEGIN CREATE TYPE userrole AS ENUM ('SUPER_ADMIN','ADMIN','CCO','TECHNICIAN','CUSTOMER','ACCOUNTANT','INVENTORY_MANAGER'); EXCEPTION WHEN duplicate_object THEN NULL; END $$;
DO $$ BEGIN ALTER TYPE userrole ADD VALUE IF NOT EXISTS 'ACCOUNTANT'; EXCEPTION WHEN others THEN NULL; END $$;
DO $$ BEGIN ALTER TYPE userrole ADD VALUE IF NOT EXISTS 'INVENTORY_MANAGER'; EXCEPTION WHEN others THEN NULL; END $$;
DO $$ BEGIN CREATE TYPE technicianstatus AS ENUM ('ACTIVE','INACTIVE','ON_LEAVE','SUSPENDED'); EXCEPTION WHEN duplicate_object THEN NULL; END $$;
DO $$ BEGIN ALTER TYPE technicianstatus ADD VALUE IF NOT EXISTS 'ON_LEAVE'; EXCEPTION WHEN others THEN NULL; END $$;
DO $$ BEGIN ALTER TYPE technicianstatus ADD VALUE IF NOT EXISTS 'SUSPENDED'; EXCEPTION WHEN others THEN NULL; END $$;
DO $$ BEGIN ALTER TYPE paymentstatus ADD VALUE IF NOT EXISTS 'CANCELLED'; EXCEPTION WHEN others THEN NULL; END $$;
DO $$ BEGIN ALTER TYPE bookingsource ADD VALUE IF NOT EXISTS 'CALL_CENTER'; EXCEPTION WHEN others THEN NULL; END $$;
DO $$ BEGIN ALTER TYPE bookingsource ADD VALUE IF NOT EXISTS 'WALK_IN'; EXCEPTION WHEN others THEN NULL; END $$;
DO $$ BEGIN ALTER TYPE bookingsource ADD VALUE IF NOT EXISTS 'FRANCHISE'; EXCEPTION WHEN others THEN NULL; END $$;

\echo '>>> [2] customers table...'
ALTER TABLE customers ADD COLUMN IF NOT EXISTS fcm_token    VARCHAR(500);
ALTER TABLE customers ADD COLUMN IF NOT EXISTS gst_number   VARCHAR(20);
ALTER TABLE customers ADD COLUMN IF NOT EXISTS gst_name     VARCHAR(200);
ALTER TABLE customers ADD COLUMN IF NOT EXISTS gst_address  TEXT;

\echo '>>> [3] users table...'
ALTER TABLE users ADD COLUMN IF NOT EXISTS fcm_token           VARCHAR(500);
ALTER TABLE users ADD COLUMN IF NOT EXISTS firebase_uid        VARCHAR(128);
ALTER TABLE users ADD COLUMN IF NOT EXISTS mpin_hash           VARCHAR(255);
ALTER TABLE users ADD COLUMN IF NOT EXISTS id_proof_url        VARCHAR(500);
ALTER TABLE users ADD COLUMN IF NOT EXISTS id_proof_type       VARCHAR(50);
ALTER TABLE users ADD COLUMN IF NOT EXISTS address_proof_url   VARCHAR(500);
ALTER TABLE users ADD COLUMN IF NOT EXISTS address_proof_type  VARCHAR(50);
ALTER TABLE users ADD COLUMN IF NOT EXISTS payout_upi_id          VARCHAR(200);
ALTER TABLE users ADD COLUMN IF NOT EXISTS payout_bank_account    VARCHAR(100);
ALTER TABLE users ADD COLUMN IF NOT EXISTS payout_bank_ifsc       VARCHAR(20);
ALTER TABLE users ADD COLUMN IF NOT EXISTS payout_bank_name       VARCHAR(100);
ALTER TABLE users ADD COLUMN IF NOT EXISTS payout_account_holder  VARCHAR(150);
ALTER TABLE users ADD COLUMN IF NOT EXISTS monthly_salary      FLOAT;
ALTER TABLE users ADD COLUMN IF NOT EXISTS petrol_amount       FLOAT;
ALTER TABLE users ADD COLUMN IF NOT EXISTS mobile_recharge     FLOAT;
ALTER TABLE users ADD COLUMN IF NOT EXISTS bonus_amount        FLOAT;
ALTER TABLE users ADD COLUMN IF NOT EXISTS hra_amount          FLOAT;
ALTER TABLE users ADD COLUMN IF NOT EXISTS other_allowances    FLOAT;
ALTER TABLE users ADD COLUMN IF NOT EXISTS salary_notes        TEXT;

\echo '>>> [4] technicians table...'
ALTER TABLE technicians ADD COLUMN IF NOT EXISTS is_online               BOOLEAN NOT NULL DEFAULT FALSE;
ALTER TABLE technicians ADD COLUMN IF NOT EXISTS fcm_token               VARCHAR(500);
ALTER TABLE technicians ADD COLUMN IF NOT EXISTS last_lat                DOUBLE PRECISION;
ALTER TABLE technicians ADD COLUMN IF NOT EXISTS last_lng                DOUBLE PRECISION;
ALTER TABLE technicians ADD COLUMN IF NOT EXISTS last_seen_at            TIMESTAMP WITH TIME ZONE;
ALTER TABLE technicians ADD COLUMN IF NOT EXISTS auto_assign_eligible    BOOLEAN NOT NULL DEFAULT TRUE;
ALTER TABLE technicians ADD COLUMN IF NOT EXISTS alternate_mobile        VARCHAR(20);
ALTER TABLE technicians ADD COLUMN IF NOT EXISTS dob                     DATE;
ALTER TABLE technicians ADD COLUMN IF NOT EXISTS gender                  VARCHAR(10);
ALTER TABLE technicians ADD COLUMN IF NOT EXISTS pincode                 VARCHAR(10);
ALTER TABLE technicians ADD COLUMN IF NOT EXISTS identity_type           VARCHAR(50);
ALTER TABLE technicians ADD COLUMN IF NOT EXISTS identity_number         VARCHAR(50);
ALTER TABLE technicians ADD COLUMN IF NOT EXISTS emergency_contact_name  VARCHAR(150);
ALTER TABLE technicians ADD COLUMN IF NOT EXISTS emergency_contact_mobile VARCHAR(20);
ALTER TABLE technicians ADD COLUMN IF NOT EXISTS payout_upi_id           VARCHAR(200);
ALTER TABLE technicians ADD COLUMN IF NOT EXISTS payout_bank_account     VARCHAR(200);
ALTER TABLE technicians ADD COLUMN IF NOT EXISTS payout_bank_ifsc        VARCHAR(20);
ALTER TABLE technicians ADD COLUMN IF NOT EXISTS payout_bank_name        VARCHAR(200);
ALTER TABLE technicians ADD COLUMN IF NOT EXISTS payout_account_holder   VARCHAR(200);
ALTER TABLE technicians ADD COLUMN IF NOT EXISTS payout_method_verified  BOOLEAN DEFAULT FALSE;

\echo '>>> [5] services table...'
ALTER TABLE services ADD COLUMN IF NOT EXISTS is_pending_verify INTEGER NOT NULL DEFAULT 0;
ALTER TABLE services ADD COLUMN IF NOT EXISTS suggested_by_tech UUID;

\echo '>>> [6] customer_addresses table...'
ALTER TABLE customer_addresses ADD COLUMN IF NOT EXISTS location_source VARCHAR(50);

\echo '>>> [7] quotation_service_items table...'
ALTER TABLE quotation_service_items ADD COLUMN IF NOT EXISTS is_pending_verify INTEGER NOT NULL DEFAULT 0;
ALTER TABLE quotation_service_items ADD COLUMN IF NOT EXISTS custom_service_name TEXT;
ALTER TABLE quotation_service_items ADD COLUMN IF NOT EXISTS tech_commission_override FLOAT;

\echo '>>> [8] quotation_part_items table...'
ALTER TABLE quotation_part_items ADD COLUMN IF NOT EXISTS is_pending_verify INTEGER DEFAULT 0;
ALTER TABLE quotation_part_items ADD COLUMN IF NOT EXISTS is_active BOOLEAN DEFAULT TRUE;

\echo '>>> [9] quotations table...'
ALTER TABLE quotations ADD COLUMN IF NOT EXISTS customer_gst_number VARCHAR(20);
ALTER TABLE quotations ADD COLUMN IF NOT EXISTS customer_gst_name   VARCHAR(200);
ALTER TABLE quotations ADD COLUMN IF NOT EXISTS customer_gst_address TEXT;

\echo '>>> [10] bookings table...'
ALTER TABLE bookings ADD COLUMN IF NOT EXISTS service_name             VARCHAR(200);
ALTER TABLE bookings ADD COLUMN IF NOT EXISTS address_line             TEXT;
ALTER TABLE bookings ADD COLUMN IF NOT EXISTS city                     VARCHAR(100);
ALTER TABLE bookings ADD COLUMN IF NOT EXISTS pincode                  VARCHAR(10);
ALTER TABLE bookings ADD COLUMN IF NOT EXISTS coupon_id                UUID;
ALTER TABLE bookings ADD COLUMN IF NOT EXISTS coupon_code              VARCHAR(50);
ALTER TABLE bookings ADD COLUMN IF NOT EXISTS coupon_discount          FLOAT DEFAULT 0.0;
ALTER TABLE bookings ADD COLUMN IF NOT EXISTS technician_to_customer_rating FLOAT;
ALTER TABLE bookings ADD COLUMN IF NOT EXISTS technician_to_customer_notes  TEXT;
ALTER TABLE bookings ADD COLUMN IF NOT EXISTS inspection_notes         TEXT;
ALTER TABLE bookings ADD COLUMN IF NOT EXISTS inspection_photos        TEXT;
ALTER TABLE bookings ADD COLUMN IF NOT EXISTS city_id                  UUID;
ALTER TABLE bookings ADD COLUMN IF NOT EXISTS pre_cancel_status        VARCHAR(30);
ALTER TABLE bookings ADD COLUMN IF NOT EXISTS repeat_of_booking_id     UUID;
ALTER TABLE bookings ADD COLUMN IF NOT EXISTS inspection_submitted_by  VARCHAR(20);
ALTER TABLE bookings ADD COLUMN IF NOT EXISTS pre_reschedule_status    VARCHAR(30);
ALTER TABLE bookings ADD COLUMN IF NOT EXISTS appliance_id             UUID;
ALTER TABLE bookings ADD COLUMN IF NOT EXISTS customer_rating          FLOAT;
ALTER TABLE bookings ADD COLUMN IF NOT EXISTS customer_review          TEXT;
ALTER TABLE bookings ADD COLUMN IF NOT EXISTS customer_name            VARCHAR(120);
ALTER TABLE bookings ADD COLUMN IF NOT EXISTS customer_city            VARCHAR(80);
DO $$ BEGIN ALTER TABLE bookings ADD CONSTRAINT fk_bookings_city_id FOREIGN KEY (city_id) REFERENCES cities(id); EXCEPTION WHEN duplicate_object THEN NULL; END $$;
DO $$ BEGIN ALTER TABLE bookings ADD CONSTRAINT fk_bookings_repeat_of_booking_id FOREIGN KEY (repeat_of_booking_id) REFERENCES bookings(id); EXCEPTION WHEN duplicate_object THEN NULL; END $$;
DO $$ BEGIN ALTER TABLE bookings ADD CONSTRAINT fk_bookings_appliance_id FOREIGN KEY (appliance_id) REFERENCES customer_appliances(id) ON DELETE SET NULL; EXCEPTION WHEN duplicate_object THEN NULL; END $$;

\echo '>>> [11] coupons table...'
ALTER TABLE coupons ADD COLUMN IF NOT EXISTS customer_mobile_numbers TEXT[];
ALTER TABLE coupons ADD COLUMN IF NOT EXISTS service_ids             TEXT[];

\echo '>>> [12] commission_groups table...'
ALTER TABLE commission_groups ADD COLUMN IF NOT EXISTS is_salary_group BOOLEAN NOT NULL DEFAULT false;
ALTER TABLE commission_groups ADD COLUMN IF NOT EXISTS monthly_salary  FLOAT;

\echo '>>> [13] withdrawal_requests table...'
ALTER TABLE withdrawal_requests ADD COLUMN IF NOT EXISTS payment_reference VARCHAR(200);

\echo '>>> [14] domain_service_overrides table...'
ALTER TABLE domain_service_overrides ADD COLUMN IF NOT EXISTS includes_json TEXT;
ALTER TABLE domain_service_overrides ADD COLUMN IF NOT EXISTS excludes_json TEXT;
ALTER TABLE domain_service_overrides ADD COLUMN IF NOT EXISTS faqs_json     TEXT;

\echo '>>> [15] salary_settlements table...'
CREATE TABLE IF NOT EXISTS salary_settlements (
  id               UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  technician_id    UUID NOT NULL REFERENCES technicians(id) ON DELETE CASCADE,
  month            INTEGER NOT NULL,
  year             INTEGER NOT NULL,
  commission_total FLOAT NOT NULL DEFAULT 0,
  deductions       FLOAT NOT NULL DEFAULT 0,
  deduction_notes  VARCHAR(500),
  net_amount       FLOAT NOT NULL DEFAULT 0,
  status           VARCHAR(20) NOT NULL DEFAULT 'PENDING',
  payment_method   VARCHAR(20),
  payment_ref      VARCHAR(200),
  paid_at          TIMESTAMP WITH TIME ZONE,
  paid_by          UUID REFERENCES users(id) ON DELETE SET NULL,
  settlement_notes TEXT,
  created_at       TIMESTAMP WITH TIME ZONE DEFAULT now(),
  UNIQUE (technician_id, month, year)
);

\echo '>>> [16] cco_attendance table...'
CREATE TABLE IF NOT EXISTS cco_attendance (
  id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id             UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  date                DATE NOT NULL,
  check_in            TIMESTAMP WITH TIME ZONE,
  check_out           TIMESTAMP WITH TIME ZONE,
  accumulated_seconds INTEGER NOT NULL DEFAULT 0,
  status              VARCHAR(20) NOT NULL DEFAULT 'PRESENT',
  notes               TEXT,
  created_at          TIMESTAMP WITH TIME ZONE DEFAULT now(),
  UNIQUE (user_id, date)
);
CREATE INDEX IF NOT EXISTS ix_cco_attendance_user_id ON cco_attendance(user_id);
CREATE INDEX IF NOT EXISTS ix_cco_attendance_date    ON cco_attendance(date);

\echo '>>> [17] cco_salary_settlements table...'
CREATE TABLE IF NOT EXISTS cco_salary_settlements (
  id               UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id          UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  month            INTEGER NOT NULL,
  year             INTEGER NOT NULL,
  monthly_salary   FLOAT NOT NULL DEFAULT 0,
  petrol_amount    FLOAT NOT NULL DEFAULT 0,
  mobile_recharge  FLOAT NOT NULL DEFAULT 0,
  bonus_amount     FLOAT NOT NULL DEFAULT 0,
  hra_amount       FLOAT NOT NULL DEFAULT 0,
  other_allowances FLOAT NOT NULL DEFAULT 0,
  deductions       FLOAT NOT NULL DEFAULT 0,
  deduction_notes  VARCHAR(500),
  total_days       INTEGER NOT NULL DEFAULT 0,
  present_days     INTEGER NOT NULL DEFAULT 0,
  total_hours      FLOAT NOT NULL DEFAULT 0,
  gross_salary     FLOAT NOT NULL DEFAULT 0,
  net_salary       FLOAT NOT NULL DEFAULT 0,
  status           VARCHAR(20) NOT NULL DEFAULT 'PENDING',
  payment_method   VARCHAR(20),
  payment_ref      VARCHAR(200),
  paid_at          TIMESTAMP WITH TIME ZONE,
  paid_by          UUID REFERENCES users(id) ON DELETE SET NULL,
  salary_notes     TEXT,
  created_at       TIMESTAMP WITH TIME ZONE DEFAULT now(),
  UNIQUE (user_id, month, year)
);
CREATE INDEX IF NOT EXISTS ix_cco_salary_user_id ON cco_salary_settlements(user_id);

\echo '>>> [18] Update alembic_version to 075...'
DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM alembic_version) THEN
    UPDATE alembic_version SET version_num = '075';
  ELSE
    INSERT INTO alembic_version (version_num) VALUES ('075');
  END IF;
END $$;

\echo ''
\echo '============================================================'
\echo 'palei_vps_fix.sql v2 completed! Run: pm2 restart palei-backend'
\echo '============================================================'
