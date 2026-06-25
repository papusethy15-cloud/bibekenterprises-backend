# Service Override JSON — Format Reference

## File location
```
backend/scripts/overrides/<domain-slug>.json
```

---

## Top-level structure

```json
{
  "services": [ ...one object per service... ]
}
```

---

## One service object — all fields

```json
{
  "service_name": "Gas Charging",

  "image_url":      "https://res.cloudinary.com/.../gas-charging-main.jpg",
  "thumbnail_url":  "https://res.cloudinary.com/.../gas-charging-thumb.jpg",

  "meta_title":       "Gas Charging Service | Bibek Enterprises",
  "meta_description": "Professional AC gas charging at your doorstep. 30-day warranty.",
  "meta_keywords":    "gas charging, AC gas refill, refrigerant, Bibek Enterprises",

  "og_title":       "Book AC Gas Charging — Bibek Enterprises",
  "og_description": "Certified technicians. Transparent pricing. 30-day warranty.",
  "og_image_url":   "https://res.cloudinary.com/.../gas-charging-og.jpg",

  "includes": [
    "Refrigerant gas refill",
    "Leak detection before filling",
    "Cooling performance test"
  ],

  "excludes": [
    "Pipe leakage repair (extra)",
    "Compressor repair or replacement"
  ],

  "faqs": [
    {
      "q": "How do I know if my AC needs gas charging?",
      "a": "Signs include warm air, ice on pipes, or hissing sounds. Our technician confirms with a pressure check."
    },
    {
      "q": "How long does it take?",
      "a": "Typically 45–90 minutes."
    }
  ]
}
```

---

## Field reference

| Field | Type | Required | Notes |
|---|---|---|---|
| `service_name` | string | **YES** | Must match global service name (case-insensitive). Partial match supported. |
| `image_url` | string / null | no | Main image on service detail page. Skip if uploading manually via Admin Dashboard. |
| `thumbnail_url` | string / null | no | Card thumbnail (16:9). Skip if uploading manually. |
| `meta_title` | string / null | no | Page `<title>` tag for this domain |
| `meta_description` | string / null | no | Meta description for search results |
| `meta_keywords` | string / null | no | Comma-separated keywords |
| `og_title` | string / null | no | Social share title |
| `og_description` | string / null | no | Social share description |
| `og_image_url` | string / null | no | Social share image (1200×630px) |
| `includes` | string[] | no | What this service covers — shown as ✅ bullet list |
| `excludes` | string[] | no | What is NOT covered — shown as ❌ bullet list |
| `faqs` | `{q, a}`[] | no | FAQ accordion on service detail page |

> **Any field you omit is left unchanged** in the database. You can run the
> script multiple times — it is always a safe upsert (insert or update).

---

## Commands

### 1. Preview (dry run) — see what would change, writes nothing
```bash
cd "C:\MyWorkspace\Palei Solutions\backend"
venv\Scripts\python scripts/bulk_override.py --domain bibekenterprises --file scripts/overrides/bibekenterprises.json --dry-run
```

### 2. Run for all services in the file
```bash
venv\Scripts\python scripts/bulk_override.py --domain bibekenterprises --file scripts/overrides/bibekenterprises.json
```

### 3. Run for one specific service only
```bash
venv\Scripts\python scripts/bulk_override.py --domain bibekenterprises --file scripts/overrides/bibekenterprises.json --service "Gas Charging"
```

### 4. Different domain
```bash
venv\Scripts\python scripts/bulk_override.py --domain paleisolutions --file scripts/overrides/paleisolutions.json
```

---

## Tips

- **Images**: Upload images via the Admin Dashboard (`🖼️ Override` button) and copy
  the Cloudinary URLs into the JSON, **or** just omit `image_url` / `thumbnail_url`
  entirely and manage images through the UI — both work independently.
- **Run safely multiple times**: The script is idempotent — running it again only
  updates what changed.
- **Partial name match**: If your service is "AC Gas Charging" but the JSON says
  "Gas Charging", the script does a substring match and logs a `🔍 partial match` warning.
  Review the output to confirm the right service was matched.
