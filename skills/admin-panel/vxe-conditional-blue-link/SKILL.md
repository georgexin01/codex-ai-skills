# VXE Table — Conditional Blue Link Column

## Problem
Using scoped CSS with VXE's generated `col--{field}` class is unreliable (specificity issues,
doesn't support conditional styling per row).

## Solution: Dynamic `className` function + scoped class

### Column config
```typescript
{
  field: 'category_names',
  minWidth: 160,
  width: 'auto',
  showOverflow: false,          // show full text, no "..." truncation
  className: ({ row }: any) => {
    const names = Array.isArray(row.category_names) ? row.category_names : [];
    return names.length ? 'cursor-pointer cell-category-link' : '';
    // Only apply blue class when there's actual content to click
  },
  formatter: ({ row }: any) => {
    const names = Array.isArray(row.category_names) ? row.category_names : [];
    return names.length ? names.join(', ') : '-';
  },
},
```

### Scoped CSS
```css
:deep(.vxe-body--column.cell-category-link .vxe-cell) {
  color: rgb(59 130 246) !important;
  cursor: pointer;
  text-decoration: underline;
}
:deep(.vxe-body--column.cell-category-link:hover .vxe-cell) {
  color: rgb(37 99 235) !important;
}
```

## Key points
- `className` as a function receives `{ row }` — enables per-row conditional styling
- Custom class name (e.g. `cell-category-link`) is more reliable than VXE's auto `col--{field}`
- `!important` needed to override VXE's own cell color
- `showOverflow: false` — prevents "..." truncation for multi-value fields
- `-` dash when empty stays plain white (no blue on empty rows)
- Works for both single-value and array-value fields

## Applied in angel-interior
- `sketchup-resource-list.vue` category_names column (array of strings)
