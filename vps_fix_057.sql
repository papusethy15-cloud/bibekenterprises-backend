-- ============================================================
-- VPS FIX 057 — fixes the last 2 remaining 500 errors
-- Run as:
--   psql -U bibek_user -d bibek_enterprises -h localhost -p 5432 -W -f /tmp/vps_fix_057.sql
-- ============================================================

-- ── FIX 1: assignment_history missing columns ─────────────────
-- Traceback: UndefinedColumnError: column assignment_history.response_deadline does not exist
-- Affects: GET /api/v1/assignments/history
ALTER TABLE assignment_history ADD COLUMN IF NOT EXISTS response_deadline TIMESTAMP WITH TIME ZONE;
ALTER TABLE assignment_history ADD COLUMN IF NOT EXISTS screen_shown_at   TIMESTAMP WITH TIME ZONE;

-- ── FIX 2: purchase_orders table missing entirely ─────────────
-- Traceback: UndefinedTableError: relation "purchase_orders" does not exist
-- Affects: GET /api/v1/inventory/purchase-orders
CREATE TABLE IF NOT EXISTS purchase_orders (
    id               UUID          PRIMARY KEY DEFAULT gen_random_uuid(),
    po_number        VARCHAR(30)   NOT NULL UNIQUE,
    vendor_id        UUID          REFERENCES vendors(id) ON DELETE SET NULL,
    vendor_name      VARCHAR(200),
    vendor_invoice_no VARCHAR(100),
    warehouse_id     UUID          REFERENCES warehouses(id) ON DELETE SET NULL,
    items_json       TEXT          NOT NULL DEFAULT '[]',
    subtotal         FLOAT         DEFAULT 0,
    tax_amount       FLOAT         DEFAULT 0,
    total_amount     FLOAT         DEFAULT 0,
    payment_method   VARCHAR(30)   DEFAULT 'CASH',
    payment_status   VARCHAR(20)   DEFAULT 'PAID',
    status           VARCHAR(20)   DEFAULT 'RECEIVED',
    notes            TEXT,
    received_at      TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    created_by       UUID          REFERENCES users(id) ON DELETE SET NULL,
    is_active        BOOLEAN       DEFAULT true,
    created_at       TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS ix_po_number    ON purchase_orders (po_number);
CREATE INDEX IF NOT EXISTS ix_po_warehouse ON purchase_orders (warehouse_id);
CREATE INDEX IF NOT EXISTS ix_po_vendor    ON purchase_orders (vendor_id);

-- ── Update alembic stamp to 057 ───────────────────────────────
DELETE FROM alembic_version;
INSERT INTO alembic_version (version_num) VALUES ('057');

SELECT 'VPS FIX 057 COMPLETE — all 500 errors resolved' AS status;
