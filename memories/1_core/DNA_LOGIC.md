---
name: dna-logic
description: "Sovereign Logic DNA — TypeScript, Pinia & Engineering Standards for Vben Admin + Vue stack"
triggers: ["typescript", "ts", "pinia", "store", "state", "entity", "component", "quality", "logic"]
version: 16.0
status: authoritative
date_updated: "2026-06-08"
---

# SOVEREIGN LOGIC DNA

Engineering standards for the Vben Admin + Vue 3 + Supabase stack.

---

## 1. ENGINEERING GUARDRAILS

1. **Schema Isolation (Rule #1)** — all DB access must be scoped to the project schema. Cross-schema only for `public.project/role/user`. Cross-schema leak is a critical failure.
2. **Entity Definition** — every entity must have: `Interface`, `FormValues`, `Status enum`, and `Options array`. Define before writing the store.
3. **Store Pattern** — use Pinia with `try/catch` on every async action. No unhandled promise rejections.
4. **Form Validation** — use Vben Admin's built-in `formApi` for all admin forms. Do NOT introduce raw `zod` unless the form lives outside Vben Admin's form system.
5. **Type Safety** — DB columns are `snake_case`. TS interfaces are `camelCase`. Map at the store boundary — never leak DB shape into Vue components.

---

## 2. PINIA STORE PATTERN

```ts
// Contract first — define shape before implementation
// Input:  entity id (string)
// Output: Entity | null

export const useEntityStore = defineStore('entity', () => {
  const list = ref<Entity[]>([])
  const loading = ref(false)

  async function fetchList() {          // C unit — one job
    loading.value = true
    try {
      const { data, error } = await supabase
        .schema(SCHEMA)
        .from('entity')
        .select('*')
        .is('deleted_at', null)
      if (error) throw error
      list.value = data ?? []
    } catch (e) {
      handleError(e)
    } finally {
      loading.value = false
    }
  }

  return { list, loading, fetchList }
})
```

**Rules:**
- One action per job (C-unit principle)
- Always `.schema(SCHEMA)` — never raw table name without schema
- Soft delete: always filter `.is('deleted_at', null)` on list queries
- `loading` state on every async action

---

## 3. ENTITY DEFINITION PATTERN

```ts
// Interface — DB shape mapped to TS
export interface Entity {
  id: string
  projectId: string
  titleEn: string
  titleCn: string           // only if table is bilingual
  status: EntityStatus
  sortOrder: number
  deletedAt: string | null
  createdAt: string
  updatedAt: string
}

// Form values — what the form submits
export interface EntityFormValues {
  titleEn: string
  titleCn?: string
  status: EntityStatus
}

// Status enum
export enum EntityStatus {
  Active = 'active',
  Inactive = 'inactive',
}

// Options for dropdowns
export const ENTITY_STATUS_OPTIONS = [
  { label: 'Active', value: EntityStatus.Active },
  { label: 'Inactive', value: EntityStatus.Inactive },
]
```

---

## 4. DB → TS COLUMN MAPPING

| DB (snake_case) | TS (camelCase) |
|---|---|
| `project_id` | `projectId` |
| `title_en` | `titleEn` |
| `sort_order` | `sortOrder` |
| `deleted_at` | `deletedAt` |
| `created_at` | `createdAt` |

Map at the store `select()` call using `.select('id, project_id, title_en, ...')` and transform in a mapper function if needed. Never expose snake_case in Vue components.

---

## 5. SELF-CHECK BEFORE COMMITTING STORE CODE

- [ ] Entity interface defined before store written?
- [ ] Every action has try/catch?
- [ ] Schema scoped with `.schema(SCHEMA)`?
- [ ] List queries filter `deleted_at IS NULL`?
- [ ] Form uses Vben `formApi`, not raw zod?
- [ ] Bilingual gate checked if `_en/_cn` pairs exist?
