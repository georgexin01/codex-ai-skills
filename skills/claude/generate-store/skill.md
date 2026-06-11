---
name: generate-store
description: Generate TypeScript types and Pinia store with Supabase CRUD, enums, FK joins, and centralized option arrays.
triggers: ["generate store", "pinia store", "types and store", "supabase crud"]
phase: 2-scaffold
requires: [analyze-schema]
unlocks: [generate-supabase-schema, generate-views]
inputs: [entity_definition, field_list]
output_format: typescript_files
model_hint: gpt-5.3-codex
version: 2.0
---

# Generate Pinia Store (generate-store)

Generate a Type file and Pinia Store based on the analyzed table structure.

## Description

Generate a complete type + store setup, including:
- **Type file** (`types/{{ENTITIES}}.ts`): TypeScript enums, interfaces, and centralized option arrays
- **Store file** (`stores/{{ENTITIES}}.ts`): Re-exports types, Supabase CRUD methods, helper actions
- M2M relationship methods (if applicable)
- Data refresh methods

## Prerequisites

Must run `/analyze-schema` first to confirm the table structure.

## Schema Architecture

The database uses a two-layer architecture:

| Layer | Schema | Table Names | Column Names | Example |
|---|---|---|---|---|
| **Auth/RBAC** | `public` | `snake_case` | `snake_case` | `project`, `role`, `"user"` |
| **Business data** | per-project (e.g., `quizLaa`) | `snake_case` | **camelCase** | `question_answers.lessonId` |

**Naming convention:**
- **DB table names** → `snake_case` (e.g., `question_answers`, `attachment`)
- **DB column names** → `camelCase` (e.g., `isDelete`, `createdAt`, `lessonId`)
- **Frontend code** → `camelCase` (matches DB column names)
- **Supabase `.from()`** → use `snake_case` table name (e.g., `.from('question_answers')`)

**Store CRUD methods always target the business schema** using `supabase.from('table_name')`. The Supabase client wrapper auto-routes to the correct schema based on `VITE_SUPABASE_SCHEMA`.

The business `users` table (in the schema) is separate from `public."user"` (auth layer). The store manages the business users table — NOT the auth users table.

### Supabase import

All stores import from `#/api/supabase`, NOT `#/api/request`:

```typescript
import { supabase } from '#/api/supabase';
// NOT: import { requestClient } from '#/api/request';
```

## Generated Content

### 1. Type File (Single Source of Truth)

File location: `apps/web-antd/src/types/{{ENTITIES}}.ts`

This file contains ALL type definitions, enums, and centralized option arrays. No runtime dependencies — only pure types and constants.

```typescript
// ==================== {{ENTITY_NAME}} Type Definitions ====================
// Pure type definitions, no runtime dependencies

// --- Enums (one per enum field) ---
{{#each ENUM_FIELDS}}
export enum {{EnumName}} {
  {{#each values}}
  {{UPPER_KEY}} = '{{value}}',
  {{/each}}
}
{{/each}}

// --- Entity interface ---
export interface {{ENTITY_NAME}} {
  id: string;
  // ... all fields (use enum types for enum fields)
  {{#each ENUM_FIELDS}}
  {{fieldName}}: {{EnumName}};
  {{/each}}
  isDelete: boolean;
  createdAt: string;
  updatedAt: string;
}

// --- Form values interface (excludes id, isDelete, createdAt, updatedAt, FK display fields) ---
export interface {{ENTITY_NAME}}FormValues {
  // ... form fields (use enum types)
  {{#each ENUM_FIELDS}}
  {{fieldName}}: {{EnumName}};
  {{/each}}
}

// --- List query parameters ---
export interface {{ENTITY_NAME}}PageParams {
  page?: number;
  pageSize?: number;
  sortBy?: string;
  sortOrder?: 'asc' | 'desc';
  // ... filter fields (use enum types)
  {{#each ENUM_FIELDS}}
  {{fieldName}}?: {{EnumName}};
  {{/each}}
}

// --- Centralized option arrays (value + label + color) ---
// IMPORTANT: These are the SINGLE SOURCE OF TRUTH for all views.
// Views import these directly — NO local option arrays in views.
{{#each ENUM_FIELDS}}

// Centralized {{fieldName}} options with color mapping
// Used by: list (CellStatus + filter), detail (Tag + dropdown), form (Select)
export const {{optionsVarName}} = [
  {{#each options}}
  { value: {{EnumName}}.{{UPPER_KEY}}, label: '{{label}}', color: '{{color}}' },
  {{/each}}
] as const;
{{/each}}
```

**Example — `types/packing-orders.ts`:**

```typescript
export enum PackingOrderStatus {
  COMPLETED = 'completed',
  ON_PROGRESS = 'onProgress',
  PENDING = 'pending',
  STOCKED_OUT = 'stockedOut',
}

export enum PackingOrderType {
  CONTAINER = 'container',
  PALETTE = 'palette',
  PARCEL = 'parcel',
}

export interface PackingOrder {
  id: string;
  code: string;
  customerId: string;
  customerName?: string;
  type: PackingOrderType;
  status: PackingOrderStatus;
  remark: string;
  isDelete: boolean;
  createdAt: string;
  updatedAt: string;
}

export interface PackingOrderFormValues {
  customerId: string;
  type: PackingOrderType;
  status: PackingOrderStatus;
  remark: string;
}

export const packingOrderTypeOptions = [
  { value: PackingOrderType.PARCEL, label: 'Parcel', color: 'blue' },
  { value: PackingOrderType.CONTAINER, label: 'Container', color: 'orange' },
  { value: PackingOrderType.PALETTE, label: 'Palette', color: 'green' },
] as const;

export const packingTaskStatusOptions = [
  { value: PackingOrderStatus.PENDING, label: 'Pending', color: 'warning' },
  { value: PackingOrderStatus.ON_PROGRESS, label: 'On Progress', color: 'processing' },
  { value: PackingOrderStatus.COMPLETED, label: 'Completed', color: 'success' },
  { value: PackingOrderStatus.STOCKED_OUT, label: 'Stocked Out', color: 'default' },
] as const;
```

### 2. Store File Structure

File location: `apps/web-antd/src/stores/{{ENTITIES}}.ts`

The store **re-exports everything** from the type file via `export *`, then adds Supabase CRUD methods and helper actions.

**IMPORTANT:** All CRUD methods use `supabase.from()` — NOT `requestClient`. The Supabase client is imported from `#/api/supabase`.

```typescript
import type { PageResponse } from './types';

import type {
  {{ENTITY_NAME}},
  {{ENTITY_NAME}}FormValues,
  {{ENTITY_NAME}}PageParams,
} from '#/types/{{ENTITIES}}';

import { defineStore } from 'pinia';

import { supabase } from '#/api/supabase';
{{#each ENUM_FIELDS}}
import { {{optionsVarName}} } from '#/types/{{ENTITIES}}';
{{/each}}

// Re-export all types from type file (single source of truth)
// This allows views to import EVERYTHING from '#/stores'
export * from '#/types/{{ENTITIES}}';

// ==================== Store ====================

export const use{{ENTITY_NAME}}sStore = defineStore('{{ENTITIES}}', {
  state: () => ({
    version: 0,
  }),

  actions: {
    // --- Helper actions: lookup color/label from centralized options ---
    {{#each ENUM_FIELDS}}
    get{{FieldPascal}}Color({{fieldName}}: string): string {
      return (
        {{optionsVarName}}.find((opt) => opt.value === {{fieldName}})?.color ?? 'default'
      );
    },

    get{{FieldPascal}}Label({{fieldName}}: string): string {
      return (
        {{optionsVarName}}.find((opt) => opt.value === {{fieldName}})?.label ?? {{fieldName}}
      );
    },
    {{/each}}

    // --- CRUD methods (Supabase) ---

    /**
     * List with pagination, sorting, and filtering
     */
    async getList(params?: {{ENTITY_NAME}}PageParams): Promise<PageResponse<{{ENTITY_NAME}}>> {
      const page = params?.page ?? 1;
      const pageSize = params?.pageSize ?? 10;
      const from = (page - 1) * pageSize;
      const to = from + pageSize - 1;

      let query = supabase
        .from('{{TABLE_NAME}}')
        .select('*', { count: 'exact' })
        .eq('isDelete', false);

      // --- Apply filters ---
      {{#each FILTER_FIELDS}}
      {{#if isTextSearch}}
      if (params?.{{fieldName}}) {
        query = query.ilike('{{fieldName}}', `%${params.{{fieldName}}}%`);
      }
      {{else}}
      if (params?.{{fieldName}}) {
        query = query.eq('{{fieldName}}', params.{{fieldName}});
      }
      {{/if}}
      {{/each}}

      // --- Apply sorting ---
      if (params?.sortBy) {
        query = query.order(params.sortBy, {
          ascending: params.sortOrder !== 'desc',
        });
      } else {
        query = query.order('createdAt', { ascending: false });
      }

      // --- Apply pagination ---
      query = query.range(from, to);

      const { count, data, error } = await query;

      if (error) {
        throw error;
      }

      return {
        items: (data as {{ENTITY_NAME}}[]) ?? [],
        total: count ?? 0,
        page,
        pageSize,
      };
    },

    /**
     * Get single record by ID
     */
    async getDetail(id: string): Promise<{{ENTITY_NAME}} | null> {
      const { data, error } = await supabase
        .from('{{TABLE_NAME}}')
        .select('*')
        .eq('id', id)
        .eq('isDelete', false)
        .single();

      if (error) {
        throw error;
      }

      return data as {{ENTITY_NAME}};
    },

    /**
     * Create new record
     */
    async create(data: {{ENTITY_NAME}}FormValues): Promise<{{ENTITY_NAME}}> {
      const { data: result, error } = await supabase
        .from('{{TABLE_NAME}}')
        .insert(data)
        .select()
        .single();

      if (error) {
        throw error;
      }

      this.version++;
      return result as {{ENTITY_NAME}};
    },

    /**
     * Update existing record
     */
    async update(id: string, data: Partial<{{ENTITY_NAME}}FormValues>): Promise<{{ENTITY_NAME}}> {
      const { data: result, error } = await supabase
        .from('{{TABLE_NAME}}')
        .update(data)
        .eq('id', id)
        .select()
        .single();

      if (error) {
        throw error;
      }

      this.version++;
      return result as {{ENTITY_NAME}};
    },

    /**
     * Soft-delete record (set isDelete = true)
     */
    async remove(id: string): Promise<boolean> {
      const { error } = await supabase
        .from('{{TABLE_NAME}}')
        .update({ isDelete: true })
        .eq('id', id);

      if (error) {
        throw error;
      }

      this.version++;
      return true;
    },

    /**
     * Restore soft-deleted record (undo delete)
     */
    async restore(id: string): Promise<boolean> {
      const { error } = await supabase
        .from('{{TABLE_NAME}}')
        .update({ isDelete: false })
        .eq('id', id);

      if (error) {
        throw error;
      }

      this.version++;
      return true;
    },

    /**
     * Hard delete record (permanently remove from database)
     */
    async hardDelete(id: string): Promise<boolean> {
      const { error } = await supabase
        .from('{{TABLE_NAME}}')
        .delete()
        .eq('id', id);

      if (error) {
        throw error;
      }

      this.version++;
      return true;
    },

    /**
     * Fetch options for ApiSelect dropdowns
     * Returns [{ label, value }] format
     */
    async fetchOptions(): Promise<Array<{ label: string; value: string }>> {
      const { data, error } = await supabase
        .from('{{TABLE_NAME}}')
        .select('id, {{DISPLAY_FIELD}}')
        .eq('isDelete', false)
        .order('{{DISPLAY_FIELD}}', { ascending: true })
        .limit(100);

      if (error) {
        throw error;
      }

      return (data ?? []).map((item: any) => ({
        label: item.{{DISPLAY_FIELD}},
        value: item.id,
      }));
    },

    // M2M methods (if many-to-many relationships exist)
    {{#each M2M_RELATIONS}}

    /**
     * Get related {{RelatedEntityPlural}} via junction table
     */
    async get{{RelatedEntityPlural}}({{entityLower}}Id: string): Promise<{{RelatedEntity}}[]> {
      const { data, error } = await supabase
        .from('{{junctionTable}}')
        .select('{{relatedEntityLower}}:{{relatedEntities}}(*)')
        .eq('{{entityLower}}Id', {{entityLower}}Id);

      if (error) {
        throw error;
      }

      return (data ?? []).map((row: any) => row.{{relatedEntityLower}});
    },

    /**
     * Add M2M relation
     */
    async add{{RelatedEntity}}({{entityLower}}Id: string, {{relatedEntityLower}}Id: string): Promise<void> {
      const { error } = await supabase
        .from('{{junctionTable}}')
        .insert({ {{entityLower}}Id: {{entityLower}}Id, {{relatedEntityLower}}Id: {{relatedEntityLower}}Id });

      if (error) {
        throw error;
      }

      this.version++;
    },

    /**
     * Remove M2M relation
     */
    async remove{{RelatedEntity}}({{entityLower}}Id: string, {{relatedEntityLower}}Id: string): Promise<void> {
      const { error } = await supabase
        .from('{{junctionTable}}')
        .delete()
        .eq('{{entityLower}}Id', {{entityLower}}Id)
        .eq('{{relatedEntityLower}}Id', {{relatedEntityLower}}Id);

      if (error) {
        throw error;
      }

      this.version++;
    },
    {{/each}}

    // Drag-and-drop sort methods (only if table has `sort` integer column)
    {{#if HAS_SORT_COLUMN}}

    /**
     * Auto-assign sort = max + GAP on create
     * Called inside create() before insert
     */
    // In create(): replace `.insert(data)` with:
    // const SORT_GAP = 1000;
    // const { data: maxRow } = await supabase
    //   .from('{{TABLE_NAME}}')
    //   .select('sort')
    //   .eq('isDelete', false)
    //   .order('sort', { ascending: false })
    //   .limit(1)
    //   .single();
    // const nextSort = (maxRow?.sort ?? 0) + SORT_GAP;
    // .insert({ ...data, sort: nextSort })

    /**
     * Update single row's sort value (used by drag-and-drop)
     */
    async updateSort(id: string, sort: number): Promise<void> {
      const { error } = await supabase
        .from('{{TABLE_NAME}}')
        .update({ sort })
        .eq('id', id);

      if (error) {
        throw error;
      }

      this.version++;
    },

    /**
     * Re-normalize all rows back to GAP spacing
     * Called when gap between neighbors < 2 after drag
     */
    async renormalizeSort(): Promise<void> {
      const SORT_GAP = 1000;
      const { data, error } = await supabase
        .from('{{TABLE_NAME}}')
        .select('id')
        .eq('isDelete', false)
        .order('sort', { ascending: true });

      if (error) {
        throw error;
      }

      const promises = (data ?? []).map((row: any, i: number) =>
        supabase
          .from('{{TABLE_NAME}}')
          .update({ sort: (i + 1) * SORT_GAP })
          .eq('id', row.id),
      );
      const results = await Promise.all(promises);
      const updateError = results.find((r) => r.error)?.error;
      if (updateError) {
        throw updateError;
      }

      this.version++;
    },
    {{/if}}

    /**
     * Mark data as changed (trigger reactive updates)
     */
    invalidate() {
      this.version++;
    },
  },
});
```

### Template Variables Reference

| Variable | Description | Example |
|---|---|---|
| `{{TABLE_NAME}}` | Supabase table name (snake_case) | `users`, `lessons`, `question_answers` |
| `{{ENTITY_NAME}}` | PascalCase singular | `User`, `Lesson`, `QuestionAnswer` |
| `{{ENTITIES}}` | camelCase plural | `users`, `lessons`, `questionAnswers` |
| `{{DISPLAY_FIELD}}` | Primary display field for fetchOptions | `name`, `title`, `email` |
| `{{FILTER_FIELDS}}` | Fields that appear in PageParams (excluding pagination/sort) | `name`, `role`, `lessonId` |

### Filter Field Types

When generating filter logic in `getList`:

| Field Purpose | Supabase Method | Example |
|---|---|---|
| Text search (name, title, email) | `.ilike('field', '%value%')` | `query.ilike('name', '%${params.name}%')` |
| Exact match (status, role, FK ID) | `.eq('field', value)` | `query.eq('role', params.role)` |
| Boolean | `.eq('field', value)` | `query.eq('isActive', params.isActive)` |

### FK Display Fields

For FK relationships (e.g., `questions.lessonId → lessons`), the display field (e.g., `lessonTitle`) is **NOT** stored in the table. Instead, use PostgREST resource embedding in `getList` and `getDetail`:

```typescript
// In getList — select with FK join
let query = supabase
  .from('questions')
  .select('*, lessons!lessonId(title)', { count: 'exact' })
  .eq('isDelete', false);

// Map the nested result to flat structure
const items = (data ?? []).map((item: any) => ({
  ...item,
  lessonTitle: item.lessons?.title ?? '',
}));

// Use explicit arrow callbacks for all Supabase row maps. Do not write
// `.map(flattenQuestion)`; `.map()` passes (value, index, array), which
// can trip lint rules and create parseInt-style bugs.
```

For `getDetail`:
```typescript
const { data, error } = await supabase
  .from('questions')
  .select('*, lessons!lessonId(title)')
  .eq('id', id)
  .eq('isDelete', false)
  .single();

// Flatten FK display field
if (data) {
  data.lessonTitle = data.lessons?.title ?? '';
  delete data.lessons;
}
```

**Key pattern — re-export chain:**

```
types/{{ENTITIES}}.ts  →  stores/{{ENTITIES}}.ts  →  stores/index.ts
   (enums, interfaces,      (export * from         (export * from
    option arrays)            '#/types/{{ENTITIES}}')    './{{ENTITIES}}')
```

This allows views to import EVERYTHING from `#/stores`:

```typescript
// In views — one import for enums, options, store, and types
import {
  PackingOrderStatus,          // enum
  PackingOrderType,            // enum
  packingTaskStatusOptions,    // centralized options
  packingOrderTypeOptions,     // centralized options
  usePackingOrdersStore,       // store
  TABLE_IDS,
  useDataRefreshStore,
} from '#/stores';
```

### 2. Modify data-refresh.ts

Append TABLE_ID constant and invalidate methods:

```typescript
// Add to TABLE_IDS
export const TABLE_IDS = {
  // ... existing entries
  {{TABLE_ID}}: '{{ENTITY_NAME_LOWER}}-list',
} as const;

// Add to store
const {{ENTITIES}}Version = ref(0);

const invalidate{{ENTITY_NAME}}s = () => {
  {{ENTITIES}}Version.value++;
};

// Remember to add to return and $reset
return {
  // ... existing entries
  {{ENTITIES}}Version,
  invalidate{{ENTITY_NAME}}s,
};
```

### 3. Modify stores/index.ts

Export the new store:

```typescript
export * from './{{ENTITIES}}';
```

### 4. Modify delete-actions.ts

Add delete confirmation function:

```typescript
import { use{{ENTITY_NAME}}sStore } from '#/stores';

export const showDelete{{ENTITY_NAME}}Modal = (
  {{ENTITY_NAME_LOWER}}Id: string,
  {{ENTITY_NAME_LOWER}}Name: string,
  onSuccess?: () => void,
) => {
  Modal.confirm({
    title: $t('page.modal.deleteTitle'),
    content: $t('page.modal.deleteContent', { name: {{ENTITY_NAME_LOWER}}Name }),
    okType: 'danger',
    onOk: async () => {
      const {{ENTITIES}}Store = use{{ENTITY_NAME}}sStore();
      await {{ENTITIES}}Store.remove({{ENTITY_NAME_LOWER}}Id);
      message.success($t('page.modal.deleteSuccess'));
      useDataRefreshStore().invalidate{{ENTITY_NAME}}s();
      onSuccess?.();
    },
  });
};

// M2M remove relation (if applicable)
{{#each M2M_RELATIONS}}
export const showRemove{{ENTITY_NAME}}{{RelatedEntity}}Modal = (
  {{entityLower}}Id: string,
  {{relatedEntityLower}}Id: string,
  {{relatedEntityLower}}Name: string,
  onSuccess?: () => void,
) => {
  Modal.confirm({
    title: $t('page.modal.removeTitle'),
    content: $t('page.modal.removeRelationContent', { name: {{relatedEntityLower}}Name }),
    okType: 'danger',
    onOk: async () => {
      const {{entities}}Store = use{{ENTITY_NAME}}sStore();
      await {{entities}}Store.remove{{RelatedEntity}}({{entityLower}}Id, {{relatedEntityLower}}Id);
      message.success($t('page.modal.removeSuccess'));
      onSuccess?.();
    },
  });
};
{{/each}}
```

## Field Type Mapping

### Entity Interface Fields

| Input Type | TypeScript | Notes |
| --- | --- | --- |
| `string` / `string(n)` | `string` | |
| `text` | `string` | |
| `number` | `number` | |
| `boolean` | `boolean` | |
| `enum('a','b')` | `{{EnumName}}` (TypeScript enum) | **NOT** `'a' \| 'b'` — always use enum |
| `fk:Entity` | `string` | |
| `datetime` | `string` | |

**IMPORTANT:** All enum fields MUST use TypeScript `enum`, not string union types. The enum is defined in `types/{{ENTITIES}}.ts` and re-exported through the store.

### FormValues Interface Fields

Exclude the following fields:
- `id`
- `isDelete`
- `createdAt`
- `updatedAt`
- FK display fields (e.g., `homeroomTeacherName`)

Use enum types for enum fields (e.g., `status: PackingOrderStatus`, not `status: 'pending' | 'completed'`).

### PageParams Interface Fields

Include:
- `page`, `pageSize`, `sortBy`, `sortOrder` (standard pagination)
- All filterable fields (name, status, FK IDs, etc.)
- Use enum types for enum filter fields (e.g., `status?: PackingOrderStatus`)

## Output Checklist

After generation is complete, output:

```
## Store Generation Complete

New: types/{{ENTITIES}}.ts (enums + interfaces + centralized option arrays)
New: stores/{{ENTITIES}}.ts (re-exports types + Supabase CRUD + helper actions)
Modified: stores/data-refresh.ts (added TABLE_ID + version + invalidate)
Modified: stores/index.ts (exported new store)
Modified: utils/delete-actions.ts (added delete confirmation function)

### Next Step
Run `/generate-supabase-schema` to generate the SQL and set up the database table.
```

## Notes

1. All stores must implement the `$reset()` method (via Options API `state` — auto-reset)
2. M2M relationships require the junction table name to be determined during analysis
3. FK fields require the related store to already exist (generate parent entities first)
4. **Enum fields** always generate TypeScript enums (not string unions) in the type file
5. **Centralized option arrays** (with value + label + color) are defined in the type file with `as const`
6. **The store re-exports everything** from the type file via `export * from '#/types/{{ENTITIES}}'`
7. **Helper actions** (`getStatusColor`, `getStatusLabel`, etc.) are defined in the store, using the centralized option arrays
8. **Views import from `#/stores` only** — they never import from `#/types` directly
9. **All CRUD uses `supabase.from()`** — never `requestClient`
10. **Soft delete** is the default — `remove()` sets `isDelete: true`, `hardDelete()` permanently removes
11. **All normal fetch queries filter `isDelete: false`** — soft-deleted records are hidden by default in frontend stores. RLS SELECT policies must not include `isDelete = false`; the store/query layer owns active/deleted filtering.
12. **Supabase `.map()` transforms use arrow callbacks** — prefer `.map((row: any) => ({ ... }))` or `.map((row: any) => flattenRow(row))`, never `.map(flattenRow)`.

