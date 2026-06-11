# SOFT DELETE GUARD — AUTO-ALERT (Vue Mobile App / Capacitor)

> **AUTO-LOAD:** Read this before writing ANY Supabase query in stores, composables, or API helpers.

## Hard Rule

Every Supabase query in the mobile app must include `.is('deleted_at', null)`. Soft-deleted records must never appear in any list, detail view, or offline cache.

## Pattern

```ts
// ✅ CORRECT — always filter soft-deleted
const { data } = await supabase
  .from('material_resources')
  .select('*')
  .eq('project_id', PROJECT_ID)
  .is('deleted_at', null)

// ❌ WRONG — soft-deleted records leak into the app
const { data } = await supabase
  .from('material_resources')
  .select('*')
  .eq('project_id', PROJECT_ID)

// ✅ Relation/count queries — use parallel query, NOT embed
// PostgREST !relation(count) embeds do NOT filter deleted_at automatically
const [catsRes, resRes] = await Promise.all([
  supabase.from('categories').select('*').is('deleted_at', null),
  supabase.from('resources').select('category_id').is('deleted_at', null),
])
```

## Pre-write Checklist

- [ ] Every `.from()` query → `.is('deleted_at', null)` present?
- [ ] No `!relation(count)` embeds without a separate filtered count query?
- [ ] Offline cache seeding → filtered to `deleted_at IS NULL` only?
- [ ] FK/options lookups → soft-deleted parents excluded?

## Reference

Full rule + origin story: `C:\Users\user\.codex\antigravity\knowledge\soft-delete-always-filter.md`
