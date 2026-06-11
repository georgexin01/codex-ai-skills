# SOFT DELETE GUARD — AUTO-ALERT (Claude / Admin Panel)

> **AUTO-LOAD TRIGGER:** Fire this rule the moment you touch ANY of these:
> - A `.from('...')` Supabase query
> - A `select()` with a relation embed (`!relation`, `(count)`, `(name)`, `(*)`)
> - A table column displaying a count, name, or value sourced from a related table
> - A store `getList`, `getDetail`, `fetchOptions`, or any helper that reads DB rows
> - A drawer that lists related records (e.g. "Resources — Normal Map")
> - A `watch(() => dataRefreshStore.someVersion, ...)` in any list component

---

## THE CORE LAW

**Every soft-deletable table requires `.is('deleted_at', null)` on EVERY query path — including relation embeds, count columns, name lookups, options dropdowns, and drawer sub-lists.**

Soft-deleted = `deleted_at IS NOT NULL` = **does not exist** for all display purposes.

---

## CASE 1 — Main table query (always filter)

```ts
// ✅ CORRECT
supabase.from('material_resources')
  .select('*')
  .eq('project_id', PROJECT_ID)
  .is('deleted_at', null)          // ← NON-NEGOTIABLE

// ❌ WRONG — soft-deleted rows leak into every list, drawer, dropdown
supabase.from('material_resources')
  .select('*')
  .eq('project_id', PROJECT_ID)
```

---

## CASE 2 — Relation count column in a table (THE SILENT BUG)

PostgREST `!relation(count)` embed **does NOT inherit** the parent query's `deleted_at` filter.
It counts ALL rows in the related table, including soft-deleted ones.

```ts
// ❌ WRONG — counts soft-deleted related rows, shows wrong number
supabase.from('material_categories')
  .select('*, material_resources!category_id(count)')
  .is('deleted_at', null)
  // The (count) here still includes soft-deleted resources!

// ✅ CORRECT — parallel query, build countMap from filtered rows
const [catsRes, resRes] = await Promise.all([
  supabase.from('material_categories')
    .select('*', { count: 'exact' })
    .eq('project_id', PROJECT_ID)
    .is('deleted_at', null),
  supabase.from('material_resources')
    .select('category_id')
    .eq('project_id', PROJECT_ID)
    .is('deleted_at', null),         // ← filters soft-deleted resources
]);
const countMap: Record<string, number> = {};
for (const r of resRes.data ?? []) {
  if (r.category_id) countMap[r.category_id] = (countMap[r.category_id] ?? 0) + 1;
}
const items = (catsRes.data ?? []).map(row => ({
  ...row,
  resources_count: countMap[row.id] ?? 0,
}));
```

**This pattern is REQUIRED for every `resources_count` / `items_count` / `posts_count` column in any admin table.**

---

## CASE 3 — Relation name/label displayed in a table column

When a table column shows a related entity's name (e.g. `category_name` in a resources list), the join must also exclude soft-deleted parents.

```ts
// ❌ WRONG — may return name of a soft-deleted category
supabase.from('material_resources')
  .select('*, material_categories(name)')
  .is('deleted_at', null)
  // material_categories join has no deleted_at guard — soft-deleted category name leaks in

// ✅ CORRECT — fetch category map separately, filtered
const catMap: Record<string, string> = {};
const { data: cats } = await supabase
  .from('material_categories')
  .select('id, name')
  .eq('project_id', PROJECT_ID)
  .is('deleted_at', null);          // ← only active categories
for (const c of cats ?? []) catMap[c.id] = c.name;

// Then resolve in mapping:
const items = (resourceRows ?? []).map(row => ({
  ...row,
  category_name: catMap[row.category_id] ?? '',  // '' if parent soft-deleted
}));
```

---

## CASE 4 — Drawer sub-list (related records shown inside a drawer)

When clicking a relation count opens a drawer listing related records, that drawer query MUST also filter `deleted_at`.

```ts
// ✅ CORRECT — resources drawer query
supabase.from('material_resources')
  .select('*')
  .eq('category_id', categoryId)
  .eq('project_id', PROJECT_ID)
  .is('deleted_at', null)          // ← without this, deleted resources appear in drawer
```

---

## CASE 5 — Options / dropdown helpers (`fetchOptions`)

FK dropdowns (category selects, user selects, etc.) must exclude soft-deleted options.

```ts
// ✅ CORRECT
async fetchOptions() {
  const { data } = await supabase
    .from('material_categories')
    .select('id, name')
    .eq('project_id', PROJECT_ID)
    .is('deleted_at', null)        // ← soft-deleted categories must not appear as selectable options
  return (data ?? []).map(r => ({ label: r.name, value: r.id }));
}
```

---

## CASE 6 — Fallback when FK parent is soft-deleted

Never fabricate a display name when a FK resolves to nothing (parent was soft-deleted).

```ts
// ❌ WRONG — fake name masks the real problem
category_name: catMap[row.category_id] ?? 'Material'

// ✅ CORRECT — empty string, UI shows nothing or skips the row
category_name: catMap[row.category_id] ?? ''
```

---

## MANDATORY PRE-WRITE CHECKLIST

Before writing or reviewing any store function, run through ALL of these:

- [ ] **Main query** — `.is('deleted_at', null)` present?
- [ ] **Relation count column** — using parallel countMap, NOT `!relation(count)` embed?
- [ ] **Relation name/label column** — parent FK map built from filtered query, not raw join?
- [ ] **Drawer sub-list** — filters `deleted_at IS NULL` on its own query?
- [ ] **Options/dropdown helpers** — `fetchOptions` filters soft-deleted?
- [ ] **FK fallback** — returns `''` not a fabricated string?
- [ ] **Array FK** (sketchup-style `category_ids[]`) — resource fetch uses `.is('deleted_at', null)` before building countMap?
- [ ] **`watch()` in category/parent list** — watches BOTH `categoriesVersion` AND `resourcesVersion`?

---

## CASE 7 — Stale count column after resource create/edit/delete

A category list that shows a `Resources` count column must re-query whenever **resources** change, not only when categories change. If the `watch()` only listens to `categoriesVersion`, the count goes stale the moment a resource is added or deleted.

```ts
// ❌ WRONG — count column goes stale when a resource is created/deleted
watch(() => dataRefreshStore.sketchupCategoriesVersion, () => gridApi.query());

// ✅ CORRECT — watch both: category changes AND resource changes
watch(
  () => [dataRefreshStore.sketchupCategoriesVersion, dataRefreshStore.sketchupResourcesVersion],
  () => gridApi.query(),
);

// ✅ Same rule for material
watch(
  () => [dataRefreshStore.materialCategoriesVersion, dataRefreshStore.materialResourcesVersion],
  () => gridApi.query(),
);
```

**Rule: Any list component that displays a count/summary derived from a child table MUST watch that child table's version too.**

Pattern: if column X counts rows from table Y, the list must `watch([tableVersion, yVersion])`.

---

## Real Examples from This Project

| Module | What went wrong | Fix |
|--------|----------------|-----|
| `material.ts` categories list | `!category_id(count)` counted 37 deleted Normal Map resources → showed wrong number | Replaced with parallel countMap query |
| `MaterialResourceModel.php` | `?? 'Material'` fallback showed fake "Material" folder on website | Changed to `?? ''`, skip in grouping |
| `getMaterialCategoryFolders()` | Grouped from resources only → 0-count categories disappeared | Seed from DB category list first, overlay counts |
| `sketchup-category-list.vue` | Watched only `sketchupCategoriesVersion` → Resources count stale after resource added | Added `sketchupResourcesVersion` to watch array |
| `material-category-list.vue` | Same stale-count bug as above | Added `materialResourcesVersion` to watch array |

---

## Reference

Full knowledge entry: `C:\Users\user\.codex\antigravity\knowledge\soft-delete-always-filter.md`
