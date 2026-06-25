"""
bulk_override.py
────────────────
Bulk-upsert domain-service overrides from a JSON file.

Usage (run from the backend folder):
    python scripts/bulk_override.py --domain bibekenterprises --file scripts/overrides/bibekenterprises.json
    python scripts/bulk_override.py --domain bibekenterprises --file scripts/overrides/bibekenterprises.json --dry-run

Options:
    --domain   Domain slug (e.g. bibeke-nterprises)
    --file     Path to the override JSON file
    --dry-run  Print what would be updated without writing to the database
    --service  (optional) Only process one service by name substring match
"""

import argparse
import asyncio
import json
import sys
from pathlib import Path

# ── Make sure the app package is importable ──────────────────────────────────
sys.path.insert(0, str(Path(__file__).resolve().parent.parent))

from sqlalchemy import select, text
from sqlalchemy.ext.asyncio import create_async_engine, AsyncSession
from sqlalchemy.orm import sessionmaker

from app.core.config import settings
from app.models.domain import Domain, DomainService, DomainServiceOverride
from app.models.service import Service  # global service table

# ── Async DB engine (use asyncpg driver) ─────────────────────────────────────
DB_URL = settings.DATABASE_URL.replace("postgresql://", "postgresql+asyncpg://")
engine = create_async_engine(DB_URL, echo=False)
AsyncSessionLocal = sessionmaker(engine, class_=AsyncSession, expire_on_commit=False)


# ─────────────────────────────────────────────────────────────────────────────
async def run(domain_slug: str, json_path: str, dry_run: bool, only_service: str | None):
    data = json.loads(Path(json_path).read_text(encoding="utf-8"))
    services_data: list[dict] = data.get("services", [])
    if not services_data:
        print("❌  No 'services' array found in JSON file.")
        return

    async with AsyncSessionLocal() as db:
        # 1. Resolve domain slug → domain row
        domain = (await db.execute(
            select(Domain).where(Domain.slug == domain_slug)
        )).scalar_one_or_none()
        if not domain:
            print(f"❌  Domain with slug '{domain_slug}' not found.")
            return
        print(f"✅  Domain: {domain.name}  (id={domain.id})")

        # 2. Load all DomainService rows for this domain (joins global Service for name)
        rows = (await db.execute(
            select(DomainService, Service.name.label("svc_name"))
            .join(Service, Service.id == DomainService.service_id)
            .where(DomainService.domain_id == domain.id)
        )).all()

        # Build lookup: lowercase_name → DomainService
        name_map: dict[str, DomainService] = {
            r.svc_name.lower().strip(): r.DomainService for r in rows
        }
        print(f"ℹ️   {len(name_map)} services linked to this domain.\n")

        ok = skipped = errors = 0

        for entry in services_data:
            svc_name: str = entry.get("service_name", "").strip()
            if not svc_name:
                print("  ⚠️  Entry missing 'service_name', skipping.")
                skipped += 1
                continue

            # Filter by --service flag if given
            if only_service and only_service.lower() not in svc_name.lower():
                skipped += 1
                continue

            ds = name_map.get(svc_name.lower())
            if not ds:
                # Try partial match
                matches = [v for k, v in name_map.items() if svc_name.lower() in k]
                if len(matches) == 1:
                    ds = matches[0]
                    print(f"  🔍  '{svc_name}' → partial match found.")
                else:
                    print(f"  ❌  '{svc_name}' not found in this domain (no match). Skipping.")
                    errors += 1
                    continue

            # Build payload — only include keys that are present in the entry
            allowed = {
                "image_url", "thumbnail_url",
                "meta_title", "meta_description", "meta_keywords",
                "og_title", "og_description", "og_image_url",
            }
            payload: dict = {}
            for k in allowed:
                if k in entry:
                    payload[k] = entry[k] or None

            # includes / excludes → JSON strings
            if "includes" in entry:
                payload["includes_json"] = json.dumps(entry["includes"] or [], ensure_ascii=False)
            if "excludes" in entry:
                payload["excludes_json"] = json.dumps(entry["excludes"] or [], ensure_ascii=False)
            if "faqs" in entry:
                # each faq must be {"q": "...", "a": "..."}
                payload["faqs_json"] = json.dumps(entry["faqs"] or [], ensure_ascii=False)

            if not payload:
                print(f"  ⚠️  '{svc_name}' — no override fields provided, skipping.")
                skipped += 1
                continue

            if dry_run:
                print(f"  🔎  [DRY-RUN] Would update '{svc_name}' (ds_id={ds.id})")
                print(f"       Fields: {list(payload.keys())}")
                ok += 1
                continue

            # Upsert the override row
            try:
                override = (await db.execute(
                    select(DomainServiceOverride)
                    .where(DomainServiceOverride.domain_service_id == ds.id)
                )).scalar_one_or_none()

                if not override:
                    override = DomainServiceOverride(domain_service_id=ds.id)
                    db.add(override)

                for k, v in payload.items():
                    setattr(override, k, v)

                await db.flush()
                print(f"  ✅  '{svc_name}' updated  ({len(payload)} fields)")
                ok += 1
            except Exception as e:
                print(f"  ❌  '{svc_name}' ERROR: {e}")
                errors += 1

        if not dry_run:
            await db.commit()

    print(f"\n{'─'*50}")
    print(f"Done.  Updated: {ok}  |  Skipped: {skipped}  |  Errors: {errors}")
    if dry_run:
        print("(Dry-run — no changes were written to the database.)")


# ─────────────────────────────────────────────────────────────────────────────
if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Bulk upsert domain-service overrides from JSON")
    parser.add_argument("--domain",  required=True, help="Domain slug, e.g. bibeke-nterprises")
    parser.add_argument("--file",    required=True, help="Path to override JSON file")
    parser.add_argument("--dry-run", action="store_true", help="Preview without writing")
    parser.add_argument("--service", default=None, help="Only update services matching this name substring")
    args = parser.parse_args()

    asyncio.run(run(args.domain, args.file, args.dry_run, args.service))
