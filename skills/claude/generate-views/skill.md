---
name: generate-views
description: Generate Vue 3 components — list, detail, form, and drawer variants with centralized options and Vben patterns.
triggers: ["generate views", "vue components", "generate form", "list detail form"]
phase: 2-scaffold
requires: [generate-store]
unlocks: [generate-route, generate-i18n, generate-e2e, workflow-test]
inputs: [entity_definition, field_list]
output_format: vue_files
model_hint: gpt-5.3-codex
version: 2.0
---

# Generate Vue Components (generate-views)

Generate Vue components based on the analyzed table structure.

## Description

Generate a complete Vue component suite:
- list.vue - List page (supports embedded/relation/select modes)
- detail.vue - Detail page (supports page/drawer modes)
- form.vue - Form component
- drawer/ - Various Drawer components

## Prerequisites

Must run `/generate-store` and `/generate-mock` first.

## Centralized Options Pattern (CRITICAL)

**Views NEVER define local option arrays.** All enum/status options come from centralized option arrays defined in `types/{{ENTITIES}}.ts` and re-exported through `#/stores`.

| Usage | How to use centralized options |
| --- | --- |
| **CellStatus** (table column) | `props: { options: {{optionsVarName}} }` — pass directly |
| **Filter Select** (form schema) | `{{optionsVarName}}.map(opt => ({ label: opt.label, value: opt.value }))` |
| **Form Select** (form schema) | Same `.map()` pattern as filter |
| **Detail Tag** (color/label) | `store.getStatusColor(status)` / `store.getStatusLabel(status)` |
| **Form defaults** | `{{EnumName}}.{{DEFAULT_KEY}}` (e.g., `PackingOrderStatus.PENDING`) |
| **Switch/case** | Use `{{EnumName}}.VALUE` (e.g., `StockOutSourceType.DIRECT`) |

**WRONG (DO NOT DO):**
```typescript
// WRONG — local option arrays in views
const statusOptions = [
  { value: 'pending', label: 'Pending', color: 'warning' },
  { value: 'completed', label: 'Completed', color: 'success' },
];
```

**CORRECT:**
```typescript
// CORRECT — import centralized options from #/stores
import { packingTaskStatusOptions } from '#/stores';
// Use directly for CellStatus:
cellRender: { name: 'CellStatus', props: { options: packingTaskStatusOptions } }
// Map for filter/form Select:
options: packingTaskStatusOptions.map(opt => ({ label: opt.label, value: opt.value }))
```

## File Structure

```
views/{{ENTITIES}}/
├── {{ENTITY_NAME_LOWER}}-list.vue           # List page
├── {{ENTITY_NAME_LOWER}}-detail.vue         # Detail page
├── {{ENTITY_NAME_LOWER}}-form.vue           # Form component
└── drawer/
    ├── {{ENTITY_NAME_LOWER}}-create-drawer.vue   # Create Drawer
    ├── {{ENTITY_NAME_LOWER}}-edit-drawer.vue     # Edit Drawer
    ├── {{ENTITY_NAME_LOWER}}-detail-drawer.vue   # Detail Drawer
    ├── {{ENTITY_NAME_LOWER}}-list-drawer.vue     # O2M List Drawer (if applicable)
    ├── {{ENTITY_NAME_LOWER}}-relation-drawer.vue # M2M Relation Drawer (if applicable)
    └── {{ENTITY_NAME_LOWER}}-select-drawer.vue   # M2M Select Drawer (if applicable)
```

## Drawer Type Summary

| Drawer Type | Purpose | Trigger | Position |
| --- | --- | --- | --- |
| create-drawer | Create new record | Toolbar "Create" button | left |
| edit-drawer | Edit record | Action column "Edit" icon | right |
| detail-drawer | View details | CellFkLink click | right |
| list-drawer | O2M child list | Action column layer icon | top |
| relation-drawer | M2M relation management | Action column link icon | top |
| select-drawer | M2M select and add | relation-drawer "Add" button | left |

## Component Specifications

### 1. list.vue Structure

```vue
<script lang="ts" setup>
import type { {{ENTITY_NAME}} } from '#/stores';
import type { ActionButton, ToolbarButton } from '#/adapter/vxe-table';

import { computed } from 'vue';

import { useVbenDrawer } from '@vben/common-ui';
import { $t } from '@vben/locales';

import {
  defaultFormOptions,
  defaultGridOptions,
  useVbenVxeGrid,
} from '#/adapter/vxe-table';
import {
  {{#each ENUM_FIELDS}}
  {{optionsVarName}},
  {{/each}}
  TABLE_IDS,
  use{{ENTITY_NAME}}sStore,
  useDataRefreshStore,
} from '#/stores';
import { showDelete{{ENTITY_NAME}}Modal } from '#/utils/delete-actions';

// Import Drawers
import CreateDrawer from './drawer/{{ENTITY_NAME_LOWER}}-create-drawer.vue';
import EditDrawer from './drawer/{{ENTITY_NAME_LOWER}}-edit-drawer.vue';
{{#if HAS_FK}}
import {{FkEntity}}DetailDrawer from '../{{fkEntities}}/drawer/{{fkEntityLower}}-detail-drawer.vue';
{{/if}}
{{#if HAS_M2M}}
import RelationDrawer from './drawer/{{ENTITY_NAME_LOWER}}-relation-drawer.vue';
import SelectDrawer from './drawer/{{ENTITY_NAME_LOWER}}-select-drawer.vue';
{{/if}}

// Props (supports embedded, relation, select modes)
interface Props {
  {{#each FK_FIELDS}}
  {{fkField}}?: string;
  {{/each}}
  embedded?: boolean;
  mode?: 'list' | 'relation' | 'select';
  exclude{{ENTITY_NAME}}Ids?: string[];
  onSelect?: (item: {{ENTITY_NAME}}) => void;
}

const props = withDefaults(defineProps<Props>(), {
  {{#each FK_FIELDS}}
  {{fkField}}: '',
  {{/each}}
  embedded: false,
  mode: 'list',
  exclude{{ENTITY_NAME}}Ids: () => [],
  onSelect: undefined,
});

// Store
const {{ENTITIES}}Store = use{{ENTITY_NAME}}sStore();
const dataRefreshStore = useDataRefreshStore();

// Mode detection
const isRelationMode = computed(() => props.mode === 'relation');
const isSelectMode = computed(() => props.mode === 'select');

// Drawer registration
const [CreateDrawerComponent, createDrawerApi] = useVbenDrawer({
  connectedComponent: CreateDrawer,
});
const [EditDrawerComponent, editDrawerApi] = useVbenDrawer({
  connectedComponent: EditDrawer,
});
{{#if HAS_FK}}
const [{{FkEntity}}DetailDrawerComponent, {{fkEntityLower}}DetailDrawerApi] = useVbenDrawer({
  connectedComponent: {{FkEntity}}DetailDrawer,
});
{{/if}}
{{#if HAS_M2M}}
const [RelationDrawerComponent, relationDrawerApi] = useVbenDrawer({
  connectedComponent: RelationDrawer,
});
{{/if}}

// Search form schema
const formSchema = [
  {
    component: 'Input',
    componentProps: {
      placeholder: $t('page.{{ENTITIES}}.form.namePlaceholder'),
      size: 'small',
    },
    fieldName: 'name',
    label: $t('page.{{ENTITIES}}.table.name'),
  },
  {{#each FK_FIELDS}}
  {
    component: 'ApiSelect',
    componentProps: {
      allowClear: !props.{{fkField}},
      disabled: !!props.{{fkField}},
      api: fetch{{FkEntity}}Options,
      placeholder: $t('page.{{ENTITIES}}.form.{{fkField}}Placeholder'),
      showSearch: true,
      size: 'small',
    },
    fieldName: '{{fkField}}',
    label: $t('page.{{ENTITIES}}.form.{{fkLabel}}'),
  },
  {{/each}}
  {{#each ENUM_FIELDS}}
  {
    component: 'Select',
    componentProps: {
      allowClear: true,
      // Map centralized options to { label, value } for filter Select
      options: {{optionsVarName}}.map((opt) => ({
        label: opt.label,
        value: opt.value,
      })),
      placeholder: $t('page.{{ENTITIES}}.form.{{fieldName}}Placeholder'),
      size: 'small',
    },
    fieldName: '{{fieldName}}',
    label: $t('page.{{ENTITIES}}.table.{{fieldName}}'),
  },
  {{/each}}
];

// Handler functions
const handleCreate = () => {
  {{#if HAS_FK}}
  const data: Record<string, string> = {};
  {{#each FK_FIELDS}}
  if (props.{{fkField}}) {
    data.default{{FkEntity}}Id = props.{{fkField}};
  }
  {{/each}}
  createDrawerApi.setData(data).open();
  {{else}}
  createDrawerApi.open();
  {{/if}}
};

const handleEdit = (row: any) => {
  editDrawerApi.setData({ {{ENTITY_NAME_LOWER}}Id: row.id }).open();
};

const handleDelete = (row: any) => {
  showDelete{{ENTITY_NAME}}Modal(row.id, row.name);
};

{{#if HAS_FK}}
const handleShow{{FkEntity}}Detail = (row: any) => {
  if (row.{{fkField}}) {
    {{fkEntityLower}}DetailDrawerApi.setData({ {{fkEntityLower}}Id: row.{{fkField}} }).open();
  }
};
{{/if}}

{{#if HAS_M2M}}
const handleManageRelation = (row: any) => {
  relationDrawerApi.setData({ {{ENTITY_NAME_LOWER}}Id: row.id, {{ENTITY_NAME_LOWER}}Name: row.name }).open();
};
{{/if}}

const handleSelect = (row: any) => {
  props.onSelect?.(row);
};

const handleRemoveRelation = (row: any) => {
  // Handled by parent component
  emit('remove', row);
};

const emit = defineEmits<{
  remove: [row: any];
}>();

// Action buttons - list mode
const listActionButtons: ActionButton[] = [
  {{#if HAS_O2M}}
  {
    icon: 'lucide:layers',
    title: $t('page.{{ENTITIES}}.actions.showChildren'),
    onClick: handleShowChildren,
    testId: 'show-children',
  },
  {{/if}}
  {{#if HAS_M2M}}
  {
    icon: 'lucide:link',
    title: $t('page.{{ENTITIES}}.actions.manageRelation'),
    onClick: handleManageRelation,
    testId: 'manage-relation',
  },
  {{/if}}
  {
    icon: 'lucide:eye',
    title: $t('page.table.actions.view'),
    to: (row) => `/{{ENTITIES}}/detail/${row.id}`,
    testId: 'view-{{ENTITY_NAME_LOWER}}',
  },
  {
    icon: 'lucide:edit',
    title: $t('page.table.actions.edit'),
    onClick: handleEdit,
    testId: 'edit-{{ENTITY_NAME_LOWER}}',
  },
  {
    icon: 'lucide:trash-2',
    title: $t('page.table.actions.delete'),
    hoverClass: 'hover:text-red-500',
    onClick: handleDelete,
    testId: 'delete-{{ENTITY_NAME_LOWER}}',
  },
];

// Action buttons - relation mode
const relationActionButtons: ActionButton[] = [
  {
    icon: 'lucide:eye',
    title: $t('page.table.actions.view'),
    to: (row) => `/{{ENTITIES}}/detail/${row.id}`,
    testId: 'view-{{ENTITY_NAME_LOWER}}',
  },
  {
    icon: 'lucide:unlink',
    title: $t('page.table.actions.remove'),
    hoverClass: 'hover:text-red-500',
    onClick: handleRemoveRelation,
    testId: 'remove-{{ENTITY_NAME_LOWER}}',
  },
];

// Action buttons - select mode
const selectActionButtons: ActionButton[] = [
  {
    icon: 'lucide:plus',
    title: $t('page.table.actions.select'),
    onClick: handleSelect,
    testId: 'select-{{ENTITY_NAME_LOWER}}',
  },
];

// Choose action buttons based on mode
const actionButtons = computed(() => {
  if (isSelectMode.value) return selectActionButtons;
  if (isRelationMode.value) return relationActionButtons;
  return listActionButtons;
});

// Toolbar buttons
const toolbarButtons: ToolbarButton[] = [
  {
    text: $t('page.{{ENTITIES}}.toolbar.create'),
    type: 'primary',
    onClick: handleCreate,
    attrs: { 'data-testid': 'create-{{ENTITY_NAME_LOWER}}-btn' },
  },
];

// Relation mode toolbar (add button)
const relationToolbarButtons: ToolbarButton[] = [
  {
    text: $t('page.{{ENTITIES}}.toolbar.addRelation'),
    type: 'primary',
    onClick: () => emit('add'),
    attrs: { 'data-testid': 'add-relation-btn' },
  },
];

// Grid configuration
const [Grid, gridApi] = useVbenVxeGrid({
  formOptions: {
    ...defaultFormOptions,
    schema: formSchema,
  },
  gridOptions: {
    ...defaultGridOptions,
    id: props.embedded ? 'embedded-{{ENTITY_NAME_LOWER}}-list' : TABLE_IDS.{{TABLE_ID}},
    height: props.embedded ? 350 : undefined,
    toolbarConfig: {
      ...defaultGridOptions.toolbarConfig,
      buttons: (isRelationMode.value ? relationToolbarButtons : toolbarButtons).map(
        (btn) => ({
          buttonRender: { name: 'ToolbarButton', props: btn },
        })
      ),
    },
    columns: [
      { type: 'seq', title: $t('page.table.common.seq'), width: 60 },
      { field: 'name', title: $t('page.{{ENTITIES}}.table.name'), minWidth: 150 },
      {{#each FK_FIELDS}}
      {
        field: '{{fkNameField}}',
        title: $t('page.{{ENTITIES}}.table.{{fkLabel}}'),
        cellRender: {
          name: 'CellFkLink',
          props: {
            nameField: '{{fkNameField}}',
            onClick: handleShow{{FkEntity}}Detail,
          },
        },
      },
      {{/each}}
      {{#each ENUM_FIELDS}}
      {
        field: '{{fieldName}}',
        title: $t('page.{{ENTITIES}}.table.{{fieldName}}'),
        cellRender: {
          name: 'CellStatus',
          // Use centralized options DIRECTLY — no local arrays
          props: { options: {{optionsVarName}} },
        },
      },
      {{/each}}
      {
        field: 'actions',
        title: $t('page.table.common.actions'),
        cellRender: { name: 'CellActions', props: { actions: actionButtons.value } },
      },
    ],
    proxyConfig: {
      autoLoad: !props.embedded,
      ajax: {
        query: async ({ page, sorts }, formValues) => {
          const params: Record<string, any> = {
            page: page.currentPage,
            pageSize: page.pageSize,
          };

          // Search criteria
          if (formValues?.name) params.name = formValues.name;
          if (formValues?.status) params.status = formValues.status;

          {{#each FK_FIELDS}}
          // FK filter prioritizes props
          if (props.{{fkField}}) {
            params.{{fkField}} = props.{{fkField}};
          } else if (formValues?.{{fkField}}) {
            params.{{fkField}} = formValues.{{fkField}};
          }
          {{/each}}

          // Sorting
          if (sorts?.length) {
            params.sortBy = sorts[0].field;
            params.sortOrder = sorts[0].order;
          }

          // Select mode excludes already selected
          let result = await {{ENTITIES}}Store.getList(params);
          if (isSelectMode.value && props.exclude{{ENTITY_NAME}}Ids.length) {
            result = {
              ...result,
              items: result.items.filter(
                (item) => !props.exclude{{ENTITY_NAME}}Ids.includes(item.id)
              ),
            };
          }

          return result;
        },
      },
    },
  },
});

// Expose methods to parent component
defineExpose({
  query: async () => {
    {{#each FK_FIELDS}}
    if (props.{{fkField}}) {
      await gridApi.formApi?.setValues({ {{fkField}}: props.{{fkField}} });
    }
    {{/each}}
    return gridApi.query();
  },
});

// Watch for data refresh
watch(
  () => [
    dataRefreshStore.{{ENTITIES}}Version,
    {{#each FK_PARENT_ENTITIES}}dataRefreshStore.{{fkParentEntities}}Version,
    {{/each}}
  ],
  () => {
    gridApi.query();
  }
);

// If the list displays FK labels via CellFkLink, always watch the parent FK
// versions too (e.g. driversVersion + usersVersion). Otherwise linked labels
// can stay stale after editing the parent entity.
</script>

<template>
  <div class="flex h-full flex-col">
    <Grid class="flex-1" />
    <template v-if="mode === 'list'">
      <CreateDrawerComponent />
      <EditDrawerComponent />
      {{#if HAS_FK}}
      <{{FkEntity}}DetailDrawerComponent />
      {{/if}}
      {{#if HAS_M2M}}
      <RelationDrawerComponent />
      {{/if}}
    </template>
    <template v-if="mode === 'relation'">
      <SelectDrawerComponent />
    </template>
  </div>
</template>
```

### Drag-and-Drop Sort (if table has `sort` integer column)

When a table has a `sort` integer column, enable row drag reordering with gap-based sort values (1000, 2000, 3000...).

**Reference implementation:** `views/lessons/lesson-list.vue`

**Key changes to list.vue:**

```typescript
import { message } from 'ant-design-vue';

const SORT_GAP = 1000;

// Row drag-end handler — gap-based sort calculation
const handleRowDragend = async (params: any) => {
  const { oldRow, _index } = params;
  const { newIndex, oldIndex } = _index;
  if (newIndex === oldIndex) return;

  const draggedRow = oldRow;
  if (!draggedRow) return;

  // IMPORTANT: getData() returns ORIGINAL order, not reordered
  // Must manually splice to simulate the move
  const tableData = [...(gridApi.grid?.getData() ?? [])];
  const [moved] = tableData.splice(oldIndex, 1);
  if (!moved) return;
  tableData.splice(newIndex, 0, moved);

  // Get neighbors at new position (they keep their original sort values)
  const prevRow = newIndex > 0 ? tableData[newIndex - 1] : null;
  const nextRow =
    newIndex < tableData.length - 1 ? tableData[newIndex + 1] : null;

  let newSort: number;
  if (!prevRow) {
    newSort = Math.floor((nextRow?.sort ?? SORT_GAP) / 2);
  } else if (!nextRow) {
    newSort = (prevRow?.sort ?? 0) + SORT_GAP;
  } else {
    newSort = Math.floor((prevRow.sort + nextRow.sort) / 2);
  }

  const needsRenormalize =
    newSort === (prevRow?.sort ?? 0) || newSort === (nextRow?.sort ?? 0);

  try {
    if (needsRenormalize) {
      await {{ENTITIES}}Store.renormalizeSort();
    } else {
      await {{ENTITIES}}Store.updateSort(draggedRow.id, newSort);
    }
    await gridApi.query(); // Refresh to show updated sort values
    message.success($t('page.{{ENTITIES}}.message.sortUpdated'));
  } catch {
    message.error($t('page.{{ENTITIES}}.message.sortFailed'));
  }
};
```

**Grid config additions:**

```typescript
const [Grid, gridApi] = useVbenVxeGrid({
  // ... existing config
  gridEvents: {
    rowDragend: handleRowDragend,
  },
  gridOptions: {
    ...defaultGridOptions,
    rowConfig: {
      ...defaultGridOptions.rowConfig,
      drag: true,  // Enable row drag
    },
    columns: [
      {
        type: 'seq',
        field: '_seq',
        title: $t('page.table.common.seq'),
        width: 'auto',
        align: 'center',
        dragSort: true,  // Show drag handle icon on this column
      },
      // ... other columns
      {
        field: 'sort',
        title: $t('page.{{ENTITIES}}.table.sort'),
        width: 'auto',
        sortable: true,
        align: 'center',
      },
      // ...
    ],
    sortConfig: {
      remote: true,
      trigger: 'default',
      defaultSort: {
        field: 'sort',
        order: 'asc',
      },
    },
  },
});
```

**Form changes:** Remove `sort` from `emptyValues` and `formSchema` — sort is auto-managed.

**Type changes:** Remove `sort` from `{{ENTITY_NAME}}FormValues` — keep it only in the `{{ENTITY_NAME}}` entity type.

---

### ⚠️ MANDATORY: Conditional Drag Handle (6-dot icon) Behavior

> **This is a required principle for ALL tables with a `sort` column.**

The 6-dot drag handle icon in the No./seq column **must be hidden by default** and **only shown when the Sort column is the active sort**. This prevents user confusion — drag reordering only makes sense when data is ordered by `sort`.

**Rules:**
1. **Sort column MUST be `sortable: true`** — the asc/desc arrows are the user's toggle trigger
2. **Drag handle (6 dots) is HIDDEN by default** — visible only when Sort is the active sort column
3. **When user clicks Sort column (asc/desc)** → drag handles appear, rows become draggable
4. **When user clicks any other sortable column** → drag handles hide, drag is blocked
5. **`rowDragend` must guard early-return** if not in drag sort mode (safety)

**Implementation pattern:**

```typescript
import { ref } from 'vue';

// Default: sort column is default sort → drag starts enabled
const isDragSortMode = ref(true);

const handleSortChange = ({ sortList }: any) => {
  const active = sortList?.[0];
  // Enable drag only when 'sort' column is active sort (any direction)
  isDragSortMode.value = !active || active.field === 'sort';
};

const handleRowDragend = async (params: any) => {
  if (!isDragSortMode.value) return; // Safety guard
  // ... rest of drag logic
};

const [Grid, gridApi] = useVbenVxeGrid({
  gridEvents: {
    rowDragend: handleRowDragend,
    sortChange: handleSortChange,  // ← REQUIRED
  },
  gridOptions: {
    rowConfig: { ...defaultGridOptions.rowConfig, drag: true },
    columns: [
      {
        type: 'seq', field: '_seq',
        title: $t('page.table.common.seq'),
        width: 'auto', align: 'center',
        dragSort: true,  // Always true — CSS controls visibility
      },
      {
        field: 'sort',
        title: $t('page.{{ENTITIES}}.table.sort'),
        width: 60, align: 'center',
        sortable: true,  // ← MUST be sortable (enables the toggle)
      },
    ],
    sortConfig: {
      remote: true,
      trigger: 'default',
      defaultSort: { field: 'sort', order: 'asc' },
    },
  },
});
```

**Template — wrapper class binding:**

```vue
<template>
  <div :class="['flex h-full flex-col', isDragSortMode ? 'is-drag-sort-mode' : '']">
    <Grid class="flex-1" />
    <!-- drawers... -->
  </div>
</template>

<style scoped>
/* Drag handle (6-dot icon) hidden by default */
:deep(.vxe-cell--drag-handle) {
  visibility: hidden;
  pointer-events: none;
}

/* Show drag handle only when Sort column is the active sort */
.is-drag-sort-mode :deep(.vxe-cell--drag-handle) {
  visibility: visible;
  pointer-events: auto;
}
</style>
```

**Why `visibility: hidden` instead of `display: none`:** Keeps the cell width stable so the No. column doesn't resize when toggling. The drag handle space is reserved but invisible.

---

**Migration SQL (run once):**

```sql
WITH ranked AS (
  SELECT "id", ROW_NUMBER() OVER (ORDER BY "sort" ASC, "createdAt" ASC) AS rn
  FROM "{{SCHEMA}}"."{{TABLE_NAME}}"
)
UPDATE "{{SCHEMA}}"."{{TABLE_NAME}}" l
SET "sort" = r.rn * 1000
FROM ranked r
WHERE l."id" = r."id";
```

**i18n keys needed:**

| Key | EN | ZH |
| --- | --- | --- |
| `page.{{ENTITIES}}.message.sortUpdated` | Sort order updated | 排序已更新 |
| `page.{{ENTITIES}}.message.sortFailed` | Failed to update sort order | 排序更新失败 |

### 2. form.vue Structure

Uses `useEntityForm` composable:

```vue
<script lang="ts" setup>
import type { {{ENTITY_NAME}}, {{ENTITY_NAME}}FormValues } from '#/stores';

import { $t } from '@vben/locales';

import { useEntityForm } from '#/composables/useEntityForm';
import {
  {{#each ENUM_FIELDS}}
  {{EnumName}},
  {{optionsVarName}},
  {{/each}}
} from '#/stores';
{{#if HAS_FK}}
import { fetch{{FkEntity}}Options } from '#/api/{{fkEntities}}';
{{/if}}

interface Props {
  {{ENTITY_NAME_LOWER}}?: {{ENTITY_NAME}};
  mode: 'create' | 'edit';
  {{#if HAS_FK}}
  default{{FkEntity}}Id?: string;
  {{/if}}
}

const props = withDefaults(defineProps<Props>(), {
  {{ENTITY_NAME_LOWER}}: undefined,
  {{#if HAS_FK}}
  default{{FkEntity}}Id: '',
  {{/if}}
});

// Use enum refs for default values — NOT string literals
const emptyValues: {{ENTITY_NAME}}FormValues = {
  name: '',
  {{#each FORM_FIELDS}}
  {{fieldName}}: {{defaultValue}},
  {{/each}}
  {{#each ENUM_FIELDS}}
  {{fieldName}}: {{EnumName}}.{{DEFAULT_ENUM_KEY}}, // e.g. PackingOrderStatus.PENDING
  {{/each}}
};

const formSchema = [
  {
    component: 'Input',
    componentProps: {
      id: '{{ENTITY_NAME_LOWER}}-form-name-input',
      'data-testid': '{{ENTITY_NAME_LOWER}}-form-name-input',
      placeholder: $t('page.{{ENTITIES}}.form.namePlaceholder'),
    },
    fieldName: 'name',
    label: $t('page.{{ENTITIES}}.form.name'),
    rules: 'required',
  },
  {{#each FK_FIELDS}}
  {
    component: 'ApiSelect',
    componentProps: {
      id: '{{ENTITY_NAME_LOWER}}-form-{{fkField}}-select',
      'data-testid': '{{ENTITY_NAME_LOWER}}-form-{{fkField}}-select',
      api: fetch{{FkEntity}}Options,
      placeholder: $t('page.{{ENTITIES}}.form.{{fkField}}Placeholder'),
      disabled: !!props.default{{FkEntity}}Id,
    },
    fieldName: '{{fkField}}',
    label: $t('page.{{ENTITIES}}.form.{{fkLabel}}'),
    rules: 'selectRequired',
    {{#if isRequired}}
    defaultValue: props.default{{FkEntity}}Id || undefined,
    {{/if}}
  },
  {{/each}}
  {{#each OTHER_FIELDS}}
  {{fieldSchema}},
  {{/each}}
  {{#each ENUM_FIELDS}}
  {
    component: 'Select',
    componentProps: {
      id: '{{ENTITY_NAME_LOWER}}-form-{{fieldName}}-select',
      'data-testid': '{{ENTITY_NAME_LOWER}}-form-{{fieldName}}-select',
      // Map centralized options for form Select
      options: {{optionsVarName}}.map((opt) => ({
        label: opt.label,
        value: opt.value,
      })),
      placeholder: $t('page.{{ENTITIES}}.form.{{fieldName}}Placeholder'),
    },
    fieldName: '{{fieldName}}',
    label: $t('page.{{ENTITIES}}.form.{{fieldName}}'),
    rules: 'selectRequired',
  },
  {{/each}}
];

const { Form, formApi, focus, isDirty, resetForm, submitForm, watchEntity } =
  useEntityForm<{{ENTITY_NAME}}FormValues, {{ENTITY_NAME}}>({
    emptyValues,
    schema: formSchema,
    firstInputId: '{{ENTITY_NAME_LOWER}}-form-name-input',
  });

watchEntity(
  () => props.{{ENTITY_NAME_LOWER}},
  () => props.mode
);

defineExpose({ focus, isDirty, resetForm, submitForm });
</script>

<template>
  <Form />
</template>
```

### 3. detail.vue Structure

Supports dual mode: full page (`/{{ENTITIES}}/detail/:id`) and embedded in drawer (`mode="drawer"`).

**IMPORTANT:** Uses `onActivated` for KeepAlive data refresh. Vue 3.5 pauses watchers when KeepAlive components are deactivated, so version-based watchers alone won't catch changes made while the tab was inactive. The `onActivated` hook ensures data is refreshed when the user navigates back to the detail tab.

```vue
<script lang="ts" setup>
import type { {{ENTITY_NAME}} } from '#/stores/{{ENTITIES}}';

import { computed, nextTick, onActivated, onMounted, ref, watch } from 'vue';
import { useRoute, useRouter } from 'vue-router';

import { useVbenDrawer } from '@vben/common-ui';
import { useTabs } from '@vben/hooks';
import { IconifyIcon } from '@vben/icons';

import { Button, Card, Descriptions, message, Spin, Tag } from 'ant-design-vue';

import { $t } from '#/locales';
import {
  {{#each ENUM_FIELDS}}
  {{optionsVarName}},
  {{/each}}
  useDataRefreshStore,
  use{{ENTITY_NAME}}sStore,
} from '#/stores';
import { showDelete{{ENTITY_NAME}}Modal } from '#/utils/delete-actions';
import { formatDateTime } from '#/utils/format';
{{#if HAS_FK}}
import {{FkEntity}}DetailDrawer from '../{{fkEntities}}/drawer/{{fkEntityLower}}-detail-drawer.vue';
{{/if}}
{{#if HAS_O2M_CHILD}}
import {{ChildEntity}}List from '../{{childEntities}}/{{childEntityLower}}-list.vue';
{{/if}}

import EditDrawer from './drawer/{{ENTITY_NAME_LOWER}}-edit-drawer.vue';

interface Props {
  /** ID passed via prop (drawer mode) */
  {{ENTITY_NAME_LOWER}}Id?: string;
  /** Display mode */
  mode?: 'drawer' | 'page';
}

defineOptions({
  name: '{{ENTITY_NAME}}Detail',
});

const props = withDefaults(defineProps<Props>(), {
  {{ENTITY_NAME_LOWER}}Id: '',
  mode: 'page',
});

const route = useRoute();
const router = useRouter();
const { closeCurrentTab } = useTabs();
const {{ENTITIES}}Store = use{{ENTITY_NAME}}sStore();
const dataRefreshStore = useDataRefreshStore();

// Use prop ID first, fallback to route params
const current{{ENTITY_NAME}}Id = computed(
  () => props.{{ENTITY_NAME_LOWER}}Id || (route.params.id as string),
);

const loading = ref(false);
const {{ENTITY_NAME_LOWER}} = ref<{{ENTITY_NAME}} | null>(null);
const isDeleting = ref(false);
const isInitialMount = ref(true);

const columnCount = computed(() => (props.mode === 'drawer' ? 1 : 2));

{{#if HAS_O2M_CHILD}}
// Embedded child list ref
const {{childEntityLower}}ListRef = ref<InstanceType<typeof {{ChildEntity}}List>>();
{{/if}}

// Edit Drawer
const [EditDrawerComponent, editDrawerApi] = useVbenDrawer({
  connectedComponent: EditDrawer,
});

{{#if HAS_FK}}
// FK Detail Drawer
const [{{FkEntity}}DetailDrawerComponent, {{fkEntityLower}}DetailDrawerApi] =
  useVbenDrawer({
    connectedComponent: {{FkEntity}}DetailDrawer,
  });

const handleShow{{FkEntity}}Detail = () => {
  if ({{ENTITY_NAME_LOWER}}.value?.{{fkField}}) {
    {{fkEntityLower}}DetailDrawerApi
      .setData({ {{fkEntityLower}}Id: {{ENTITY_NAME_LOWER}}.value.{{fkField}} })
      .open();
  }
};
{{/if}}

// Watch data version changes (works when component is active)
watch(
  () => dataRefreshStore.{{ENTITIES}}Version,
  () => {
    if (current{{ENTITY_NAME}}Id.value && !isDeleting.value) {
      fetchDetail();
    }
  },
);

// Watch ID prop changes (drawer mode)
watch(
  () => props.{{ENTITY_NAME_LOWER}}Id,
  (newId) => {
    if (newId) {
      fetchDetail();
    }
  },
);

// Fetch detail
const fetchDetail = async () => {
  if (!current{{ENTITY_NAME}}Id.value) return;

  loading.value = true;
  try {
    {{ENTITY_NAME_LOWER}}.value = await {{ENTITIES}}Store.getDetail(
      current{{ENTITY_NAME}}Id.value,
    );
    {{#if HAS_O2M_CHILD}}
    await nextTick();
    {{childEntityLower}}ListRef.value?.query();
    {{/if}}
  } catch (error) {
    message.error($t('page.{{ENTITIES}}.detail.notFound'));
    console.error('Failed to fetch {{ENTITY_NAME_LOWER}} detail:', error);
  } finally {
    loading.value = false;
  }
};

// Open Edit Drawer
const handleEdit = () => {
  editDrawerApi
    .setData({ {{ENTITY_NAME_LOWER}}Id: current{{ENTITY_NAME}}Id.value })
    .open();
};

// Delete
const handleDelete = () => {
  if (!{{ENTITY_NAME_LOWER}}.value) return;

  isDeleting.value = true;
  showDelete{{ENTITY_NAME}}Modal(
    {{ENTITY_NAME_LOWER}}.value.id,
    {{ENTITY_NAME_LOWER}}.value.name,
    async () => {
      if (props.mode === 'page') {
        await closeCurrentTab();
        router.push('/{{ENTITIES}}/list');
      }
    },
  );
};

onMounted(async () => {
  if (current{{ENTITY_NAME}}Id.value) {
    await fetchDetail();
  }
});

// KeepAlive reactivation: refresh data when tab becomes active again
// Vue 3.5 pauses watchers when deactivated, so version changes are missed
onActivated(() => {
  if (isInitialMount.value) {
    isInitialMount.value = false;
    return;
  }
  if (current{{ENTITY_NAME}}Id.value && !isDeleting.value) {
    fetchDetail();
  }
});

// Expose refresh for drawer parent
defineExpose({
  refresh: fetchDetail,
});
</script>

<template>
  <div :class="mode === 'page' ? 'p-5' : ''">
    <Spin :spinning="loading">
      <div class="{{ENTITY_NAME_LOWER}}-detail">
        <!-- Action buttons -->
        <div v-if="{{ENTITY_NAME_LOWER}}" class="mb-4 flex gap-2">
          <Button type="primary" @click="handleEdit">
            <IconifyIcon icon="lucide:edit" class="mr-1" />
            {{ $t('page.table.actions.edit') }}
          </Button>
          <Button danger @click="handleDelete">
            <IconifyIcon icon="lucide:trash-2" class="mr-1" />
            {{ $t('page.table.actions.delete') }}
          </Button>
        </div>

        <!-- Detail card -->
        <Card v-if="{{ENTITY_NAME_LOWER}}">
          <div class="mb-6">
            <h2 class="text-xl font-semibold">{{ {{ENTITY_NAME_LOWER}}.name }}</h2>
            {{#if HAS_STATUS}}
            <div class="mt-2">
              <!-- Use store helper actions for color/label lookup -->
              <Tag :color="{{ENTITIES}}Store.getStatusColor({{ENTITY_NAME_LOWER}}.status)">
                {{ {{ENTITIES}}Store.getStatusLabel({{ENTITY_NAME_LOWER}}.status) }}
              </Tag>
            </div>
            {{/if}}
          </div>

          <Descriptions :column="columnCount" bordered size="small">
            {{#each DETAIL_FIELDS}}
            <Descriptions.Item :label="$t('page.{{ENTITIES}}.detail.{{fieldName}}')">
              {{ {{ENTITY_NAME_LOWER}}.{{fieldName}} || '-' }}
            </Descriptions.Item>
            {{/each}}
            {{#if HAS_FK}}
            <Descriptions.Item :label="$t('page.{{ENTITIES}}.detail.{{fkLabel}}')">
              <a
                class="cursor-pointer text-blue-500 hover:text-blue-700"
                @click="handleShow{{FkEntity}}Detail"
              >
                {{ {{ENTITY_NAME_LOWER}}.{{fkNameField}} || '-' }}
              </a>
            </Descriptions.Item>
            {{/if}}
            <Descriptions.Item :label="$t('page.table.common.createdAt')">
              {{ formatDateTime({{ENTITY_NAME_LOWER}}.createdAt) }}
            </Descriptions.Item>
            <Descriptions.Item :label="$t('page.table.common.updatedAt')">
              {{ formatDateTime({{ENTITY_NAME_LOWER}}.updatedAt) }}
            </Descriptions.Item>
          </Descriptions>
        </Card>

        {{#if HAS_O2M_CHILD}}
        <!-- Embedded child list (reuse component, filtered by FK) -->
        <div v-if="{{ENTITY_NAME_LOWER}}" class="mt-4">
          <{{ChildEntity}}List
            ref="{{childEntityLower}}ListRef"
            :{{childFkProp}}="current{{ENTITY_NAME}}Id"
            embedded
          />
        </div>
        {{/if}}

        <!-- Empty state -->
        <div
          v-if="!{{ENTITY_NAME_LOWER}} && !loading"
          class="text-center text-gray-500"
        >
          {{ $t('page.{{ENTITIES}}.detail.notFound') }}
        </div>
      </div>
    </Spin>

    <!-- Edit Drawer -->
    <EditDrawerComponent />
    {{#if HAS_FK}}
    <!-- FK Detail Drawer -->
    <{{FkEntity}}DetailDrawerComponent />
    {{/if}}
  </div>
</template>

<style scoped>
.{{ENTITY_NAME_LOWER}}-detail {
  @media (max-width: 768px) {
    :deep(.ant-descriptions) {
      .ant-descriptions-item {
        padding: 8px 12px;
      }

      .ant-descriptions-item-label {
        width: 100px;
      }
    }
  }
}
</style>
```

**Key patterns:**

| Pattern | Purpose |
| --- | --- |
| `onMounted` | Initial data fetch on first load |
| `onActivated` + `isInitialMount` | Re-fetch on KeepAlive reactivation (skips first activation to avoid double-fetch with onMounted) |
| `watch(dataRefreshStore.xxxVersion)` | Real-time refresh when component is active (e.g., editing from detail page itself) |
| `watch(props.xxxId)` | Re-fetch when drawer parent changes the ID prop |
| `isDeleting` guard | Prevents refresh during delete operation |
| `defineExpose({ refresh })` | Allows drawer parent to trigger manual refresh |
| `columnCount` computed | 2 columns in page mode, 1 column in drawer mode |
| Embedded child list | If entity has O2M children, reuse the child's list component below the Card with `embedded` + FK prop. Trigger `query()` via ref after `nextTick` in `fetchDetail`. The child list component must support `embedded` mode (see list.vue embedded pattern). |

### 4. Drawer Components

Use `useCreateDrawer` and `useEditDrawer` composables.

## ActionButton Icon Order

```typescript
const actionButtons: ActionButton[] = [
  // 1. O2M layer icon
  { icon: 'lucide:layers', ... },
  // 2. M2M link icon (first)
  { icon: 'lucide:link', ... },
  // 3. M2M second icon
  { icon: 'lucide:book-open', ... },
  // 4. View icon
  { icon: 'lucide:eye', to: ... },
  // 5. Edit icon
  { icon: 'lucide:edit', onClick: ... },
  // 6. Delete icon
  { icon: 'lucide:trash-2', onClick: ... },
];
```

## O2M Layers Icon Placement (IMPORTANT)

When an entity has one-to-many (O2M) child relationships, **always ask the user** where to place the `lucide:layers` icon before generating. Do NOT assume placement.

**Prompt the user:**
> "This entity has O2M child records (e.g., Lessons → Questions). Which parent list should have the layers icon to view the child records? Options:
> 1. On the **parent** list (e.g., lesson-list shows questions)
> 2. On the **child** list (e.g., question-list shows question-answers)
> 3. Both"

**Key considerations:**
- The layers icon opens a list-drawer showing the child entity's list in embedded mode
- A single list can have **multiple** layers icons for different child entities
- The layers icon should always be the **first** action button (before eye, edit, delete)
- The child list must support `embedded` mode with FK prop and `defineExpose({ query })` for lazy loading

## JSONB Contacts Array Pattern

When an entity has a `contacts` JSONB array field (e.g., Customer, Vendor, Address Book), apply the following patterns. This is **not** a standard field — it requires special handling in both detail and form views.

### Contacts in detail.vue

Display contacts as an Ant Design `Table` inside the **same Card** as other fields (not a separate Card). Add `Table` to imports.

**Script — define contact columns:**

```typescript
import { Table } from 'ant-design-vue'; // Add to imports

// Contact table columns
const contactColumns = [
  {
    title: $t('page.{{ENTITIES}}.form.contactName'),
    dataIndex: 'name',
    key: 'name',
  },
  // Add columns matching the contact interface fields:
  // e.g. position, phone, email — varies per entity
  {
    title: $t('page.{{ENTITIES}}.form.contactPhone'),
    dataIndex: 'phone',
    key: 'phone',
  },
];
```

**Template — render inside main Card, after last Descriptions section:**

```vue
<!-- Contact Information — inside main Card -->
<h3 class="mb-3 mt-6 font-medium">
  {{ $t('page.{{ENTITIES}}.form.contactInfo') }}
</h3>
<Table
  :columns="contactColumns"
  :data-source="{{ENTITY_NAME_LOWER}}.contacts || []"
  :pagination="false"
  size="small"
  row-key="name"
/>
```

**Key rules:**
- Table sits inside the same `<Card>` as other Descriptions sections
- No separate Card for contacts
- No pagination
- `row-key` should be a field likely to be unique (e.g. `name` or `emailAddress`)

### Contacts in form.vue

Contacts are managed **separately** from `useEntityForm` because they are a dynamic array. The form composable handles scalar fields; contacts are a `ref` array with add/remove logic.

**Script pattern:**

```typescript
import { Button, Card, Input } from 'ant-design-vue';
import { IconifyIcon } from '@vben/icons';

// Contact interface matching the entity's contact structure
// e.g. { name: string; phone: string; email: string; position: string }

// Contacts state (managed separately from useEntityForm)
const contacts = ref<Array<{ name: string; phone: string }>>([]);

// Sync contacts when entity prop changes (for edit mode)
watch(
  () => props.{{ENTITY_NAME_LOWER}},
  (entity) => {
    contacts.value = entity?.contacts ? [...entity.contacts] : [];
  },
  { immediate: true },
);

// Contact management
const addContact = () => {
  contacts.value.push({ name: '', phone: '' }); // Match interface fields
};

const removeContact = (index: number) => {
  contacts.value.splice(index, 1);
};

// Submit: merge contacts into form values
const handleSubmit = async () => {
  const values = await submitForm();
  if (values) {
    values.contacts = contacts.value.filter((c) => c.name || c.phone);
    emit('submit', values);
  }
};

// Expose: custom isDirty checks both form + contacts
defineExpose({
  cancel: handleCancel,
  focus,
  isDirty: async () => {
    const formDirty = await isDirty();
    const originalContacts = props.{{ENTITY_NAME_LOWER}}?.contacts || [];
    const contactsDirty =
      JSON.stringify(contacts.value) !== JSON.stringify(originalContacts);
    return formDirty || contactsDirty;
  },
  resetForm: async () => {
    await resetForm();
    contacts.value = [];
  },
  submit: handleSubmit,
});
```

**Template pattern:**

```vue
<template>
  <div class="{{ENTITY_NAME_LOWER}}-form">
    <Form />

    <!-- Contacts Section -->
    <div class="mt-4">
      <Divider orientation="left" :orientation-margin="0">
        {{ $t('page.{{ENTITIES}}.form.contactInfo') }}
      </Divider>

      <div class="mb-2 flex items-center justify-end">
        <Button type="primary" size="small" @click="addContact">
          <template #icon>
            <IconifyIcon icon="lucide:plus" />
          </template>
        </Button>
      </div>

      <div v-if="contacts.length === 0" class="py-4 text-center text-gray-400">
        {{ $t('page.{{ENTITIES}}.form.noContacts') }}
      </div>

      <div class="space-y-3">
        <Card v-for="(contact, index) in contacts" :key="index" size="small">
          <div class="grid grid-cols-{{CONTACT_FIELD_COUNT}} gap-3">
            <!-- One div per contact field -->
            <div>
              <label class="mb-1 block text-sm text-gray-500">
                {{ $t('page.{{ENTITIES}}.form.contactName') }}
              </label>
              <Input
                v-model:value="contact.name"
                :placeholder="$t('page.{{ENTITIES}}.form.contactNamePlaceholder')"
                size="small"
              />
            </div>
            <!-- Last field column includes delete button -->
            <div class="flex items-end gap-2">
              <div class="flex-1">
                <label class="mb-1 block text-sm text-gray-500">
                  {{ $t('page.{{ENTITIES}}.form.contactPhone') }}
                </label>
                <Input
                  v-model:value="contact.phone"
                  :placeholder="$t('page.{{ENTITIES}}.form.contactPhonePlaceholder')"
                  size="small"
                />
              </div>
              <Button type="text" danger size="small" @click="removeContact(index)">
                <template #icon>
                  <IconifyIcon icon="lucide:trash-2" />
                </template>
              </Button>
            </div>
          </div>
        </Card>
      </div>
    </div>
  </div>
</template>
```

**Key rules:**
- `contacts` ref is separate from `useEntityForm`
- `emptyValues` includes `contacts: []` but `useEntityForm` manages all other fields
- `isDirty()` must check both form dirty AND contacts dirty (via JSON.stringify comparison)
- `resetForm()` must also reset contacts to `[]`
- On submit, filter out empty contacts before merging
- Grid cols matches number of contact fields (e.g. 2 for name+phone, 4 for name+position+phone+email)
- Delete button goes in the last column, aligned with `flex items-end gap-2`

### Reference Implementations

| Entity | Contact Fields | Grid Cols | File |
| --- | --- | --- | --- |
| Customer | name, jobPosition, telNo, emailAddress | 4 | `views/wms/customers/customer-form.vue` |
| TMS Vendor | name, position, phone, email | 4 | `views/tms/vendors/vendor-form.vue` |
| TMS Address Book | name, phone | 2 | `views/tms/address-book/address-form.vue` |

## Output Checklist

```
## Vue Component Generation Complete

New: views/{{ENTITIES}}/{{ENTITY_NAME_LOWER}}-list.vue
New: views/{{ENTITIES}}/{{ENTITY_NAME_LOWER}}-detail.vue
New: views/{{ENTITIES}}/{{ENTITY_NAME_LOWER}}-form.vue
New: views/{{ENTITIES}}/drawer/{{ENTITY_NAME_LOWER}}-create-drawer.vue
New: views/{{ENTITIES}}/drawer/{{ENTITY_NAME_LOWER}}-edit-drawer.vue
New: views/{{ENTITIES}}/drawer/{{ENTITY_NAME_LOWER}}-detail-drawer.vue
{{#if HAS_O2M}}
New: views/{{ENTITIES}}/drawer/{{ENTITY_NAME_LOWER}}-list-drawer.vue
{{/if}}
{{#if HAS_M2M}}
New: views/{{ENTITIES}}/drawer/{{ENTITY_NAME_LOWER}}-relation-drawer.vue
New: views/{{RELATED_ENTITIES}}/drawer/{{RELATED_ENTITY_LOWER}}-select-drawer.vue
{{/if}}

### Next Step
Run `/generate-route` to generate route configuration.
```

## FK Refresh Rules

If a list/detail displays FK labels via `CellFkLink` or flattened FK fields, watch the module's own data-refresh version plus every parent FK entity version. Example: a drivers list with `userId -> users` must watch `[driversVersion, usersVersion]`; a foreign-workers list with `nationalityId` and `agentId` must watch `[foreignWorkersVersion, nationalsVersion, agentsVersion]`. Otherwise linked labels can stay stale after editing the parent entity.

For creatable FK selects, after the nested parent drawer emits success, call `formApi.getFieldComponentRef<any>('<fkField>')?.refreshOptions?.()` before `formApi.setValues({ <fkField>: created.id })`.

