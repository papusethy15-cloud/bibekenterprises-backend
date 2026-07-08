-- ============================================================
-- VPS FINAL FIX SQL — run ONCE to resolve all remaining 500s
-- Run as:
--   psql -U bibek_user -d bibek_enterprises -h localhost -p 5432 -W -f /tmp/vps_final_fix.sql
-- ============================================================

-- ── 1. Create item_service_categories (THE missing table) ────
-- This is a many-to-many junction: inventory_items ↔ service_categories
-- Used by /api/v1/inventory/categories endpoint
CREATE TABLE IF NOT EXISTS item_service_categories (
    item_id     UUID NOT NULL REFERENCES inventory_items(id) ON DELETE CASCADE,
    category_id UUID NOT NULL REFERENCES service_categories(id) ON DELETE CASCADE,
    created_at  TIMESTAMP DEFAULT NOW(),
    CONSTRAINT pk_item_service_categories PRIMARY KEY (item_id, category_id)
);
CREATE INDEX IF NOT EXISTS ix_isc_item_id     ON item_service_categories (item_id);
CREATE INDEX IF NOT EXISTS ix_isc_category_id ON item_service_categories (category_id);

-- Migrate existing single-category data if inventory_items.category_id exists
DO $$
BEGIN
    IF EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_name = 'inventory_items' AND column_name = 'category_id'
    ) THEN
        INSERT INTO item_service_categories (item_id, category_id, created_at)
        SELECT i.id, i.category_id, NOW()
        FROM inventory_items i
        WHERE i.category_id IS NOT NULL
          AND NOT EXISTS (
            SELECT 1 FROM item_service_categories isc
            WHERE isc.item_id = i.id AND isc.category_id = i.category_id
          );
    END IF;
END $$;

-- ── 2. customers.fcm_token (missing from VPS customers table) ─
ALTER TABLE customers ADD COLUMN IF NOT EXISTS fcm_token VARCHAR(500);

-- ── 3. quotation_part_items columns (from migration 006) ──────
ALTER TABLE quotation_part_items ADD COLUMN IF NOT EXISTS inventory_item_id UUID REFERENCES inventory_items(id);
ALTER TABLE quotation_part_items ADD COLUMN IF NOT EXISTS is_from_stock BOOLEAN DEFAULT false;

-- ── 4. Stamp alembic_version to 056 ──────────────────────────
DELETE FROM alembic_version;
INSERT INTO alembic_version (version_num) VALUES ('056');

SELECT 'VPS FINAL FIX COMPLETE' AS status;
