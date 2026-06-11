# SOFT DELETE GUARD — AUTO-ALERT (PHP Sovereign Website)

> **AUTO-LOAD:** Read this before writing ANY Supabase query in PHP models, controllers, or data helpers.

## Hard Rule

Every query against a `deleted_at`-capable table MUST include `.filter('deleted_at', 'is', 'null')`. This applies to:
- Main resource queries
- Category/FK lookup maps (`fetchCategoryMap`)
- Options helpers (`fetchOptions`, `listCategories`)

## PHP Query Pattern

```php
// ✅ CORRECT
$rows = $this->api
    ->from('material_resources')
    ->select('id, category_id, title, image_path')
    ->eq('project_id', $projectId)
    ->filter('deleted_at', 'is', 'null')   // ← NEVER OMIT
    ->get();

// ✅ FK map helper — must also filter
$map = [];
$rows = $this->api->from('material_categories')
    ->select('id, name')
    ->eq('project_id', $projectId)
    ->filter('deleted_at', 'is', 'null')   // ← REQUIRED or soft-deleted categories leak in
    ->get();
foreach ($rows as $row) {
    $map[$row['id']] = $row['name'];
}

// ✅ Fallback when FK resolves to nothing — empty string, NOT a fake name
$categoryName = $map[$row['category_id']] ?? '';  // '' — caller skips it

// ❌ WRONG — fabricated fallback masks the real problem
$categoryName = $map[$row['category_id']] ?? 'Material';
```

## Grouping Logic — Skip Empty Categories

```php
foreach ($resources as $resource) {
    $category = trim((string)($resource['category'] ?? ''));
    if ($category === '') continue;  // ✅ skip orphaned resources
    // ...
}
```

## Folder Listing — Seed from DB, not from resources

When building a folder/category index page, always seed from the DB category list first (so empty categories still show), then overlay resource data:

```php
// ✅ Seed folders from DB categories — empty ones still appear
foreach (getMaterialPageCategories() as $cat) {
    $grouped[$cat['name']] = ['name' => $cat['name'], 'count' => 0, 'images' => []];
}
// Then fill in resource counts
foreach ($resources as $r) {
    if ($r['category'] === '' || !isset($grouped[$r['category']])) continue;
    $grouped[$r['category']]['count']++;
}
```

## Reference

Full rule + origin story: `C:\Users\user\.codex\antigravity\knowledge\soft-delete-always-filter.md`
