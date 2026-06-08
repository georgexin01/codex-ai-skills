# BILINGUAL COMPLETENESS GATE PROTOCOL
**Type: AI Behavior Rule — MANDATORY**

---

## The Rule

Not all tables or forms are bilingual. Only enforce this gate when `_en` / `_cn` paired columns are **detected** in the table schema or form spec.

---

## How to Detect a Bilingual Table/Form

AI looks for column pairs matching:
```
*_en   +   *_cn   (e.g. title_en + title_cn, description_en + description_cn)
```

If paired columns exist → bilingual gate is active for that table/form.  
If no pairs exist → bilingual gate is OFF. Do not apply.

---

## Gate Rules (Only When Active)

When bilingual gate is active, before finalizing any of these:

| Output | Gate Check |
|---|---|
| SQL INSERT / seed | Both `_en` and `_cn` columns present and non-null |
| Vue form | Both fields rendered with label + validation |
| Pinia action payload | Both fields included in the object |
| PHP model / controller | Both fields in fillable + response |
| i18n composable | Both locale keys mapped |

If one half is missing → **hard stop**. State which column is missing and do not proceed.

---

## AI Output When Gate Fires

```
🌐 BILINGUAL GATE
Table: services
Detected pairs: title_en + title_cn, description_en + description_cn

✅ title_en — present
⛔ title_cn — MISSING from INSERT. Add before continuing.
```

---

## When Bilingual Gate is OFF

- Single-language tables (no `_en` / `_cn` pairs) → skip silently, no output
- Fields like `created_at`, `status`, `sort_order` — never bilingual, always skip
- User explicitly says "English only" or "CN only" for a specific field → gate off for that field only

---

## Example: Mixed Table

```sql
-- products table
title_en text,    -- ← paired
title_cn text,    -- ← paired
sku text,         -- ← NOT bilingual, skip
price numeric     -- ← NOT bilingual, skip
```

Gate only checks `title_en` + `title_cn`. Ignores `sku` and `price`.
