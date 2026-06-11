# SOFT DELETE — ALWAYS FILTER `deleted_at IS NULL`

## Rule (PERMANENT — applies to ALL projects)

Every table in this stack uses **soft delete**: records are never physically removed. Instead `deleted_at` is set to a timestamp. A record with `deleted_at IS NOT NULL` is **logically deleted** and must **never appear** in any admin panel list, website page, or mobile app view.

---

## The Bug That Created This Rule

**Project:** angel-interior  
**Date:** 2026-06-09  
**What happened:** The admin Materials → Categories list showed Normal Map = 37 resources. Clicking Normal Map showed 0. The website `/material` page showed a fake "Material" folder instead of "Normal Map".

**Root cause:** Two separate failures:
1. `material_resources!category_id(count)` PostgREST embed had no `deleted_at` filter → counted all 37 soft-deleted resources
2. PHP model fallback `?? 'Material'` masked resources whose `category_id` pointed to a soft-deleted category row

---

## Rules by Layer

### Supabase / PostgREST queries (Admin Panel — Vben + Supabase JS)

```ts
// ✅ CORRECT — always add .is('deleted_at', null)
supabase.from('my_table').select('*').is('deleted_at', null)

// ❌ WRONG — counts include soft-deleted rows
supabase.from('categories').select('*, resources!category_id(count)')
// PostgREST embed counts have NO automatic soft-delete filter

// ✅ CORRECT — fetch resources separately with filter, build countMap
const [catsRes, resRes] = await Promise.all([
  supabase.from('categories').select('*').is('deleted_at', null),
  supabase.from('resources').select('category_id').is('deleted_at', null),
]);
const countMap: Record<string, number> = {};
for (const r of resRes.data ?? []) {
  if (r.category_id) countMap[r.category_id] = (countMap[r.category_id] ?? 0) + 1;
}
```

**Rule:** PostgREST `!relation(count)` embeds DO NOT inherit the parent query's `deleted_at` filter. Always fetch the count via a separate parallel query.

### PHP Sovereign / Supabase REST (Website)

```php
// ✅ CORRECT — filter in query builder
->filter('deleted_at', 'is', 'null')

// ❌ WRONG — no soft-delete guard
->get()

// ✅ fetchCategoryMap must also exclude soft-deleted categories
$this->api->from('material_categories')
    ->select('id, name')
    ->filter('deleted_at', 'is', 'null')  // ← REQUIRED
    ->get();

// ❌ WRONG fallback — masks missing category with fake name
$categoryName = $categories[$row['category_id']] ?? 'Material';

// ✅ CORRECT fallback — empty string, caller skips or shows nothing
$categoryName = $categories[$row['category_id']] ?? '';
```

**Rule:** When a resource's FK (`category_id`) resolves to empty because the parent category is soft-deleted, DO NOT fabricate a fallback display name. Return `''` and skip/hide the resource in grouping logic.

### Vue Mobile App (Capacitor)

```ts
// ✅ CORRECT
supabase.from('records').select('*').is('deleted_at', null)

// ❌ WRONG — soft-deleted data leaks into mobile views
supabase.from('records').select('*')
```

---

## Checklist — Every time you write a query

- [ ] Main table query: `.is('deleted_at', null)` present?
- [ ] Joined/embedded relation counts: separate parallel query with `.is('deleted_at', null)`?
- [ ] FK lookup maps (category maps, option maps): filtered to exclude soft-deleted parents?
- [ ] Fallback values when FK not found: `''` or `null` — never a fabricated display string?
- [ ] PHP `fetchCategoryMap` / `fetchOptions` helpers: `.filter('deleted_at', 'is', 'null')` present?

---

## Tables known to use soft delete in this stack

Any table with a `deleted_at` column uses soft delete. Common ones:
- `material_categories`, `material_resources`
- `sketchup_categories`, `sketchup_resources`
- `blog_posts`, `awards`, `slides`
- Assume ALL tables have `deleted_at` unless proven otherwise.
