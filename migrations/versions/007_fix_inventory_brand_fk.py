"""Fix inventory_items.brand_id FK: inventory_brands → appliance_brands

Revision ID: 007_fix_inv_brand_fk
Revises: 006_inventory_multi_cat
Create Date: 2026-06-01

Why: inventory_items.brand_id was pointing to the empty inventory_brands table.
     Brands are managed in appliance_brands (Appliances module).
     This migration re-points the FK so inventory items use the same brand table.
"""
from alembic import op
import sqlalchemy as sa

revision = '007_fix_inv_brand_fk'
down_revision = '006_inventory_multi_cat'
branch_labels = None
depends_on = None


def _fk_exists(bind, table, constraint_name):
    return bind.execute(sa.text(
        "SELECT EXISTS ("
        "  SELECT 1 FROM information_schema.table_constraints "
        f" WHERE table_schema='public' AND table_name='{table}' "
        f" AND constraint_name='{constraint_name}' AND constraint_type='FOREIGN KEY'"
        ")"
    )).scalar()


def _fk_target(bind, table, column):
    """Return the FK target table for a given column, or None."""
    row = bind.execute(sa.text("""
        SELECT ccu.table_name
        FROM information_schema.key_column_usage kcu
        JOIN information_schema.referential_constraints rc
          ON rc.constraint_name = kcu.constraint_name
          AND rc.constraint_schema = kcu.constraint_schema
        JOIN information_schema.constraint_column_usage ccu
          ON ccu.constraint_name = rc.unique_constraint_name
          AND ccu.constraint_schema = rc.constraint_schema
        WHERE kcu.table_schema = 'public'
          AND kcu.table_name   = :tbl
          AND kcu.column_name  = :col
    """), {"tbl": table, "col": column}).fetchone()
    return row[0] if row else None


def _col_exists(bind, table, column):
    """Check if a column exists in a table."""
    row = bind.execute(sa.text(
        "SELECT EXISTS ("
        "  SELECT 1 FROM information_schema.columns "
        "  WHERE table_schema='public' AND table_name=:tbl AND column_name=:col"
        ")"
    ), {"tbl": table, "col": column}).scalar()
    return row


def upgrade():
    bind = op.get_bind()

    # ── Guard: brand_id column must exist before we can add a FK on it.
    #    On a fresh paleisolutions DB, brand_id is added by migration 009.
    #    If the column is absent here, skip gracefully — 010_merge_and_fix_inventory_tables
    #    will handle the FK once 009 has created the column.
    if not _col_exists(bind, 'inventory_items', 'brand_id'):
        print("  brand_id column not present in inventory_items — skipping FK (will be handled in 010).")
        return

    current_target = _fk_target(bind, 'inventory_items', 'brand_id')
    print(f"  Current FK target for inventory_items.brand_id: {current_target}")

    if current_target == 'appliance_brands':
        print("  Already pointing to appliance_brands — nothing to do.")
        return

    # ── Drop whatever FK currently exists ──────────────────────
    rows = bind.execute(sa.text("""
        SELECT rc.constraint_name
        FROM information_schema.key_column_usage kcu
        JOIN information_schema.referential_constraints rc
          ON rc.constraint_name = kcu.constraint_name
         AND rc.constraint_schema = kcu.constraint_schema
        WHERE kcu.table_schema = 'public'
          AND kcu.table_name   = 'inventory_items'
          AND kcu.column_name  = 'brand_id'
    """)).fetchall()

    for row in rows:
        constraint_name = row[0]
        print(f"  Dropping FK constraint: {constraint_name}")
        op.drop_constraint(constraint_name, 'inventory_items', type_='foreignkey')

    # ── Add new FK pointing to appliance_brands ─────────────────
    op.create_foreign_key(
        'fk_inventory_items_brand_appliance',
        'inventory_items', 'appliance_brands',
        ['brand_id'], ['id'],
        ondelete='SET NULL'
    )
    print("  Created FK: inventory_items.brand_id → appliance_brands.id")


def downgrade():
    op.drop_constraint('fk_inventory_items_brand_appliance', 'inventory_items', type_='foreignkey')
    op.create_foreign_key(
        'inventory_items_brand_id_fkey',
        'inventory_items', 'inventory_brands',
        ['brand_id'], ['id']
    )
