# Array FK Count Pattern

## Problem
When a table stores related IDs as an array (`category_ids uuid[]`), PostgREST cannot
auto-count via FK relationship syntax like `related_table!fk_col(count)`.

## Solution: Client-side count via parallel query

In the categories store `getList`:
```typescript
const [{ count, data, error }, resourcesRes] = await Promise.all([
  categoryQuery,
  supabase
    .from('sketchup_resources')
    .select('category_ids')
    .eq('project_id', PROJECT_ID)
    .is('deleted_at', null),
]);

// Build per-category count map
const countMap: Record<string, number> = {};
for (const r of resourcesRes.data ?? []) {
  const ids: string[] = Array.isArray(r.category_ids) ? r.category_ids : [];
  for (const id of ids) countMap[id] = (countMap[id] ?? 0) + 1;
}

const items = (data ?? []).map((row: any) => ({
  ...row,
  resources_count: countMap[row.id] ?? 0,
}));
```

## Key points
- Run both queries in parallel with `Promise.all` — no extra latency
- Only fetches `category_ids` (minimal payload)
- Works well when resource count is low (<1000 rows)
- For larger datasets, consider a DB view with `unnest(category_ids)` + GROUP BY

## Contrast: Simple FK (works natively)
When resources have a simple `category_id` column (not array):
```typescript
supabase.from('material_categories')
  .select('*, material_resources!category_id(count)')
// Then: resources_count: row.material_resources?.[0]?.count ?? 0
```

## Applied in angel-interior
- `useSketchupCategoriesStore.getList` — counts sketchup_resources per category
