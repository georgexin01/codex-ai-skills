---
name: create-module
description: End-to-end CRUD module generator — SQL, types, store, mock API, views, routes, i18n, workflow tests in 14 steps.
triggers: ["create module", "new module", "ready next module", "full module pipeline"]
phase: 0-orchestrator
requires: []
unlocks: []
inputs: [module_name, field_table, relationships, balance_fields, menu_placement]
output_format: file_list
model_hint: gpt-5.3-codex
version: 2.0
---

# Create Module (create-module)

Generate a complete CRUD module end-to-end: SQL → types → store → mock API → views → routes → i18n → workflow tests.

## When to Trigger

User says: "create module [name]", "ready next module", "new module [name]", or provides a field table for a new entity.

## Input Required

1. **Module name** (singular, e.g. `worker`, `transaction`)
2. **Field table** with: Field, Type, Form component, Required
3. **Relationships** (FK to which table, 1:N parent info)
4. **Balance/money fields** (read-only or editable)
5. **Menu placement** (standalone or nested under parent)

## Pre-Check

Before executing, verify user's instruction covers:
- [ ] Module name
- [ ] Field list with types
- [ ] FK relationships (if any)
- [ ] Balance handling (editable vs read-only vs none)
- [ ] Menu placement: under existing parent (which one?) or create new parent group (name + icon)?
- [ ] Image upload fields: if any field is an image, ask for dimensions (e.g. avatar = 800x800px)
- [ ] If image upload: verify `vue-advanced-cropper` in package.json, `image-processor.ts` and `image-crop-modal.vue` exist
- [ ] If image upload: verify Supabase storage bucket exists (`SELECT id, name FROM storage.buckets`). If missing, create it + RLS policies before running migration

If anything is unclear, ask before proceeding.

## Execution Order (14 Steps)

### Step 1: Migration SQL
Create `apps/web-antd/src/sql/migrations/XXX_{module}_schema.sql`

```sql
-- Always drop first so migration can be re-run to fix issues
DROP TABLE IF EXISTS "labour"."{module}" CASCADE;

CREATE TABLE IF NOT EXISTS "labour"."{module}" (
  "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  -- fields --
  "isDelete" boolean NOT NULL DEFAULT false,
  "createdAt" timestamptz NOT NULL DEFAULT now(),
  "updatedAt" timestamptz NOT NULL DEFAULT now()
);
-- Trigger, indexes, RLS
```

**Important — Drop order:** Drop child tables before parent tables. If this table has children, drop them first:
```sql
DROP TABLE IF EXISTS "labour"."{child}" CASCADE;  -- drop children first
DROP TABLE IF EXISTS "labour"."{module}" CASCADE;  -- then drop this table
```

- FK constraints: `REFERENCES "labour"."{parent}"("id") ON DELETE CASCADE/SET NULL`
- Money fields: `numeric(12,2) NOT NULL DEFAULT 0`
- Enum fields: `text NOT NULL DEFAULT 'active' CHECK ("status" IN ('active', 'inactive'))`
- Image/file path fields: `text` (stores Supabase storage path, e.g. `"2603/260325-121229-photo.jpg"`)

**If table has image/file path columns:** Before running migration, verify TWO things exist in Supabase:

**1. Storage bucket:**
```sql
SELECT id, name, public FROM storage.buckets;
```
If the project's bucket (e.g. `labour`) is missing, create it:
```sql
INSERT INTO storage.buckets (id, name, public) VALUES ('labour', 'labour', true);
-- RLS policies for the bucket
CREATE POLICY "{schema}_upload_policy" ON storage.objects FOR INSERT TO authenticated WITH CHECK (bucket_id = '{schema}');
CREATE POLICY "{schema}_select_policy" ON storage.objects FOR SELECT TO authenticated, anon USING (bucket_id = '{schema}');
CREATE POLICY "{schema}_update_policy" ON storage.objects FOR UPDATE TO authenticated USING (bucket_id = '{schema}');
CREATE POLICY "{schema}_delete_policy" ON storage.objects FOR DELETE TO authenticated USING (bucket_id = '{schema}');
```

**2. Attachment table + Album page** (tracks all uploaded files):
```sql
SELECT tablename FROM pg_tables WHERE schemaname = '{schema}' AND tablename = 'attachment';
```
If missing, create it (the `uploadPhoto()` utility in `upload.ts` inserts a record after every upload):
```sql
CREATE TABLE IF NOT EXISTS "{schema}"."attachment" (
  "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  "storagePath" text,
  "originalName" text,
  "fileSize" bigint,
  "mimeType" text,
  "uploadedBy" uuid,
  "isDelete" boolean NOT NULL DEFAULT false,
  "createdAt" timestamptz NOT NULL DEFAULT now(),
  "updatedAt" timestamptz NOT NULL DEFAULT now()
);
-- Trigger, RLS policies (same pattern as other tables)
```
Also verify the **Album page** exists (image grid view for browsing/managing all uploaded files):
- `types/attachments.ts` — Attachment interface + PageParams
- `stores/attachments.ts` — getList, softDelete, restore, purgeDeleted
- `stores/index.ts` — re-export attachments store
- `views/attachments/attachment-list.vue` — Image grid with filter (all/active/deleted), soft delete, restore, purge
- Route under Master Data: `/attachments/album`
- i18n keys: `page.attachments.*`

Reference: `admin-panel-quizLaa/apps/web-antd/src/views/attachments/attachment-list.vue`

### Step 2: Seed SQL
Create `apps/web-antd/src/sql/migrations/XXX_{module}_seed.sql`

- **All data MUST be Malaysian**: Sdn Bhd companies, +60 phones, .com.my emails, MY addresses/cities
- Reference parent seed data via name-based JOIN for FK IDs

### Step 3: Types
Create `apps/web-antd/src/types/{module}.ts`

- Enum (e.g. `{Module}Status`)
- Entity interface (full DB record + FK display names like `clientName`)
- FormValues interface (subset for create/edit, excludes read-only fields like balance if managed by transactions)
- PageParams interface
- Centralized options array (e.g. `{module}StatusOptions`)

### Step 4: Store
Create `apps/web-antd/src/stores/{module}.ts`

- Pinia options API with `defineStore`
- Re-export types: `export * from '#/types/{module}'`
- CRUD methods using `supabase.from('{module}')`
- FK joins in getList/getDetail: `select('*, parent:parents!parentId(name)')`
- Flatten FK names in response: `clientName: row.client?.name ?? ''`
- Graceful errors on read ops: `console.warn` + return empty (no throw)
- `fetchOptions()` for ApiSelect usage
- Status helper methods: `getStatusColor()`, `getStatusLabel()`

### Step 5: Update Shared Files
- `stores/data-refresh.ts` — Add `{MODULE}_LIST` to TABLE_IDS, add `{module}sVersion` ref + `invalidate{Module}s()`
- `stores/index.ts` — Add `export * from './{module}s'`
- `utils/delete-actions.ts` — Add `showDelete{Module}Modal()` using store + dataRefreshStore

### Step 6: Mock Backend
Create 6 files:
- `apps/backend-mock/utils/{module}s-db.ts` — DB wrapper class
- `apps/backend-mock/utils/mock-db.ts` — Add interface + generateFn + mockDB entry (Malaysian data)
- `apps/backend-mock/api/{module}s/list.ts` — Filters, sorting, pagination, FK resolution
- `apps/backend-mock/api/{module}s/[id].ts` — Get by ID with FK resolution
- `apps/backend-mock/api/{module}s/index.post.ts` — Create with validation
- `apps/backend-mock/api/{module}s/[id].put.ts` — Update
- `apps/backend-mock/api/{module}s/[id].delete.ts` — Soft delete

### Step 7: Form Component
Create `apps/web-antd/src/views/{module}s/{module}-form.vue`

- Uses `useEntityForm` composable
- **≤3 options → RadioGroup** (optionType: 'button', buttonStyle: 'solid')
- **>3 options → Select**
- FK fields → `ApiSelectCreatable` with `fetchOptions` from parent store + instant create drawer
- **All FK ApiSelect fields MUST use `ApiSelectCreatable`** — allows "+ New" inline creation of the parent entity
- Pattern: import parent's create drawer → register with `useVbenDrawer` → set `createText` + `onCreate` in componentProps → handle `@success` to auto-select created entity → register `__workflow_instantCreate` for workflow testing
- Reference: `views/invoices/invoice-form.vue` (businessId), `views/agents/agent-form.vue` (nationalId)

**ApiSelectCreatable pattern:**

```typescript
// 1. Import parent's create drawer
import BusinessCreateDrawer from '../businesses/drawer/business-create-drawer.vue';
const [BusinessCreateDrawerComponent, businessCreateDrawerApi] = useVbenDrawer({
  connectedComponent: BusinessCreateDrawer,
});

// 2. Schema field
{
  component: 'ApiSelectCreatable',
  componentProps: {
    api: () => businessesStore.fetchOptions(),
    createText: $t('page.businesses.drawer.createTitle'),
    onCreate: () => businessCreateDrawerApi.open(),
    // ... other props
  },
  fieldName: 'businessId',
}

// 3. Handle created entity — auto-select in dropdown
const handleBusinessCreated = async (business: Business) => {
  await formApi.setValues({ businessId: business.id });
};

// 4. DEV workflow bridge
if (import.meta.env.DEV) {
  (window as any).__workflow_instantCreate = {
    ...(window as any).__workflow_instantCreate,
    businessId: () => businessCreateDrawerApi.open(),
  };
}

// 5. Template
<template>
  <div>
    <Form />
    <BusinessCreateDrawerComponent @success="handleBusinessCreated" />
  </div>
</template>
```

- Money fields → `InputNumber` with `prefix: 'RM'`, `precision: 2`, `class: 'w-full'`
- Textarea fields → `Textarea` with `autoSize: { minRows: 2 }` (auto-expand on enter, minimum 2 rows). Do NOT use fixed `rows` prop.
- Date fields → `DatePicker` with `class: 'w-48'` (smaller width, NOT `w-full`)
- **Start/End date pairs** → Place in same row using `formItemClass: 'col-span-1'` inside a `grid-cols-2` wrapper, or wrap both in a 2-col sub-grid:
  ```typescript
  // Date pair divider (spans full width, groups the dates visually)
  {
    component: 'Divider',
    componentProps: { orientation: 'left', orientationMargin: 0, style: 'margin: 8px 0' },
    fieldName: '_divider_dates',
    formItemClass: 'col-span-full',
    hideLabel: true,
    renderComponentContent: () => ({ default: () => '合同期限' }),
  },
  // Start date
  {
    component: 'DatePicker',
    componentProps: { class: 'w-48', valueFormat: 'YYYY-MM-DD' },
    fieldName: 'startDate',
    label: '开始日期',
    formItemClass: 'col-span-1',
    rules: 'required',
  },
  // End date
  {
    component: 'DatePicker',
    componentProps: { class: 'w-48', valueFormat: 'YYYY-MM-DD' },
    fieldName: 'endDate',
    label: '结束日期',
    formItemClass: 'col-span-1',
    rules: 'required',
  },
  ```
  When the form uses single column (`grid-cols-1`), switch the wrapper to `grid-cols-2` so the date pair sits side by side. If the form already uses `grid-cols-2`, no extra work needed.
- `defaultParentId` prop for instant create from parent

**Image upload fields (avatar, photos, etc.):**

Image upload fields are managed OUTSIDE the form schema. Never put Upload in `useEntityForm` schema — it returns fileList arrays that break Supabase.

Before adding image upload:
1. Check `package.json` for `vue-advanced-cropper` and `sortablejs`
2. Ask user for image dimensions (e.g. avatar = 800x800)
3. Verify `image-processor.ts` and `image-crop-modal.vue` exist in the project

**Pattern (reference: `views/agents/agent-form.vue`):**

```typescript
// 1. Define imageSpec
const imageSpec: ImageSpec = { width: 800, height: 800, accept: ['jpg', 'jpeg', 'png'], outputType: 'image/jpeg', outputQuality: 0.9 };

// 2. Manage fileList outside schema
const fileList = ref<UploadFile[]>([]);
const cropModalRef = ref<InstanceType<typeof ImageCropModal>>();

// 3. beforeUpload: validate → load → check crop → resize or open crop modal
// 4. handleCropConfirm: manually upload cropped file with progress
// 5. watch(props.entity): convert string→fileList on edit
// 6. handleSubmit: convert fileList→string via fileListToUrls()
// 7. Override isDirty() and resetForm() to include upload state

// DEV: register __workflow_uploadTargets.{fieldName} for workflow tests
```

**Template:** Upload component is rendered ABOVE `<Form />` at FIRST position:
```vue
<template>
  <div>
    <!-- Upload (first position) -->
    <Upload v-model:file-list="fileList" :before-upload="handleBeforeUpload" ... />
    <ImageCropModal ref="cropModalRef" :spec="imageSpec" @confirm="handleCropConfirm" />
    <!-- Form (below upload) -->
    <Form />
  </div>
</template>
```

### Step 8: Drawers
Create 3 drawer components:
- `drawer/{module}-create-drawer.vue` — `useCreateDrawer`, emit `success`, `processOpenData` for default FK
- `drawer/{module}-edit-drawer.vue` — `useEditDrawer`
- `drawer/{module}-detail-drawer.vue` — `useVbenDrawer` with `footer: false`

### Step 9: List Component
Create `apps/web-antd/src/views/{module}s/{module}-list.vue`

- `useVbenVxeGrid` with `defaultGridProps`, `defaultFormOptions`, `defaultGridOptions`
- `CellFkLink` for FK columns → clickable blue text that opens parent detail drawer
- `CellStatus` for status column
- `formatMoneyCell` for money columns
- `formatDateTimeCell` for date columns
- DEV `__workflow_listActions` registration (create, edit, delete + layer icon title if 1:N)
- Watch `dataRefreshStore` versions (own + **all parent FK entity versions** so FK names refresh)

**CellFkLink setup (for each FK column):**

Each FK that should be clickable blue text needs: (1) import parent's detail drawer, (2) register it, (3) click handler, (4) column config with `CellFkLink` renderer.

```typescript
// 1. Import parent's detail drawer
import ClientDetailDrawer from '../clients/drawer/client-detail-drawer.vue';

// 2. Register drawer
const [ClientDetailDrawerComponent, clientDetailDrawerApi] = useVbenDrawer({
  connectedComponent: ClientDetailDrawer,
});

// 3. Click handler
const handleShowClientDetail = (row: any) => {
  if (row.clientId) {
    clientDetailDrawerApi.setData({ clientId: row.clientId }).open();
  }
};

// 4. Column config — display FK name as clickable blue link
{
  field: 'clientName',
  title: $t('page.{module}s.table.client'),
  width: 'auto',
  align: 'left',
  cellRender: {
    name: 'CellFkLink',
    props: {
      nameField: 'clientName',              // Field containing display name
      onClick: handleShowClientDetail,       // Handler receives full row object
    },
  },
}

// 5. DEV workflow bridge — register FK link handler for workflow tests
if (import.meta.env.DEV) {
  window.__workflow_fkLinkActions = {
    ...window.__workflow_fkLinkActions,
    clientName: handleShowClientDetail,      // Key = field name used in 'fk:clientName'
  };
}

// 6. Template — render the drawer component
// <ClientDetailDrawerComponent />
```

**Self-referencing CellFkLink (own entity's ID/No column, e.g. invoiceNo):**

When a column links to the entity's own detail (not a parent FK), open a **detail drawer** (consistent with all other CellFkLink patterns — always use drawers, never router.push):

```typescript
import InvoiceDetailDrawer from './drawer/invoice-detail-drawer.vue';
const [InvoiceDetailDrawerComponent, invoiceDetailDrawerApi] = useVbenDrawer({ connectedComponent: InvoiceDetailDrawer });
const handleView = (row: any) => { invoiceDetailDrawerApi.setData({ invoiceId: row.id }).open(); };

// Column config
{ field: 'invoiceNo', cellRender: { name: 'CellFkLink', props: { nameField: 'invoiceNo', onClick: handleView } } }

// Template: <InvoiceDetailDrawerComponent />
```

Reference: `views/invoices/invoice-list.vue` (invoiceNo column)

**Multiple FK columns:** A list can have multiple CellFkLink columns (e.g., business list has `clientName` + `salesmanName`). Each needs its own drawer import, registration, handler, and column config.

**Data refresh watcher must include parent entity versions:**
```typescript
// Watch own version + all parent FK entity versions
watch(
  () => [dataRefreshStore.{module}sVersion, dataRefreshStore.clientsVersion],
  () => { gridApi.query(); },
);
```

**If this module is a child (1:N)**: Support embedded mode:
- Props: `{parentId}?: string`, `embedded?: boolean`
- `autoLoad: !props.embedded`
- `height: props.embedded ? 350 : undefined`
- Different table ID: `props.embedded ? 'embedded-{module}-list' : TABLE_IDS.{MODULE}_LIST`
- Priority FK filtering: `if (props.{parentId}) params.{parentId} = props.{parentId}`
- Exposed `query()` method for parent drawer to call
- Pass `default{Parent}Id` to create drawer when embedded

### Step 10: Detail Component
Create `apps/web-antd/src/views/{module}s/{module}-detail.vue`

- Dual mode: page (route param) / drawer (prop)
- Ant Design `Descriptions` component
- Edit + Delete buttons
- "New Child" button if this entity has children (instant create)
- Watch `dataRefreshStore` for auto-refresh
- **Embedded child list (if entity has O2M children):** Import and reuse the child's list component below the Card. The child list must support `embedded` mode with FK prop. Pattern:
  ```typescript
  import ChildList from "../children/child-list.vue";
  const childListRef = ref<InstanceType<typeof ChildList>>();
  // In fetchDetail, after data loads:
  await nextTick();
  childListRef.value?.query();
  ```
  ```vue
  <!-- In template, below Card -->
  <div v-if="entity" class="mt-4">
    <ChildList ref="childListRef" :parent-id="currentEntityId" embedded />
  </div>
  ```
  Examples: client-detail embeds business-list, business-detail embeds contract-list, contract-detail embeds contract-foreign-worker-list, agent-detail embeds foreign-worker-list, foreign-worker-detail embeds worker-salary-list, national-detail embeds agent-list

### Step 11: Parent List — Layer Icon (if this module has 1:N children)
Update the **parent** list component:
- Add `lucide:layers` as **FIRST** action button
- Title = `$t('page.{child}.title')`
- Handler opens top drawer: `{child}DrawerApi.setData({ {parentId}: row.id }).open()`
- Register in `__workflow_listActions`: `[$t('page.{child}.title')]: (row) => handleShow{Child}(row)`
- Create `{parent}/drawer/{parent}-{child}-drawer.vue`:
  - `placement: 'top'`, `class="h-[500px]"`, `footer: false`
  - **Drawer title must show parent's primary field first** (e.g. `parentName + ' > ' + $t('page.businesses.title')` → "Syarikat Jaya Sdn Bhd > Businesses")
  - On open: read parent data (`drawerApi.getData<{ parentId, parentName }>()`), set title dynamically
  - Handler in parent list passes both ID and name: `setData({ clientId: row.id, clientName: row.name })`
  - Passes FK to embedded child list, calls `listRef.value?.query()`
  - **DEV bridge**: Register `window.__workflow_closeTopDrawer = () => drawerApi.close()` on open, delete on close — used by `close-drawers` workflow action

### Step 12: Route Module
Create or update `apps/web-antd/src/router/routes/modules/{parent}.ts`

- If standalone: new route file with `order: N`
- If nested under parent: add as children, parent icon → `lucide:layers`
- List: `keepAlive: true`
- Detail: `hideInMenu: true`

### Step 13: i18n Translations
Update both locale files:
- `apps/web-antd/src/locales/langs/en-US/page.json`
- `apps/web-antd/src/locales/langs/zh-CN/page.json`

Sections: `title`, `list`, `detail.*`, `table.*`, `form.*`, `toolbar.create`, `drawer.*`

### Step 14: Workflow Tests
Create `views/workflow-test/configs/{module}-workflows.ts`

There are **3 types** of FK-related workflow tests. Generate whichever apply to the module:

#### Key Actions Reference

| Action | Purpose |
|--------|---------|
| `query-first` | Pick random existing record from DB, `saveAs` to localStorage |
| `fromCreated` | Read a saved record's field for FK form value |
| `saveAs` | Save created/queried record for later reference |
| `call-row-action` with `fk:fieldName` | Click CellFkLink column — looks up `__workflow_fkLinkActions[fieldName]` |
| `call-detail-action` | Click button inside detail drawer (edit/delete) |
| `close-drawers` | Close top drawer only |
| `close-all-drawers` | Close all open drawers |
| `upload-image` | Generate test image (canvas) + send to `__workflow_uploadTargets[target]` |
| `upload-file` | Generate test PDF + send to `__workflow_uploadTargets[target]` |
| `cleanup-db` | Remove all test marker data |

#### FK Mechanism: `query-first` + `fromCreated`

`query-first` queries a random record from a parent table and saves it under a name. `fromCreated` reads the saved record's field to fill FK selects:

```typescript
// Step 0: Query existing parents
{ action: 'query-first', queryTable: 'clients', queryFilter: { isDelete: false }, saveAs: 'randomClient' }
{ action: 'query-first', queryTable: 'users', queryFilter: { isDelete: false, role: 'salesman' }, saveAs: 'randomSalesman' }

// In form: reference saved record's field
formValues: {
  clientId: { fromCreated: 'randomClient', field: 'id' },     // FK → clients
  salesmanId: { fromCreated: 'randomSalesman', field: 'id' },  // FK → users
}
```

#### Shared Step Helpers Pattern

Extract create/edit/delete as **parameterized functions** to avoid duplication between standalone and instant workflows. The FK ref name is a parameter:

```typescript
const create{Module}Steps = (baseId: string, parentRef: string): WorkflowStep => ({
  id: baseId,
  label: 'Create {module}',
  action: 'open-create',
  delay: 500,
  children: [
    { id: `${baseId}.1`, label: 'Wait for drawer', action: 'wait', delay: 500 },
    {
      id: `${baseId}.2`,
      label: 'Fill form',
      action: 'fill-form',
      formValues: {
        parentId: { fromCreated: parentRef, field: 'id' },  // parameterized FK ref!
        // ... other fields
      },
    },
    { id: `${baseId}.2.1`, label: 'Wait for form to settle', action: 'wait', delay: 500 },
    { id: `${baseId}.3`, label: 'Submit create', action: 'submit-form', delay: 3000 },
    {
      id: `${baseId}.4`,
      label: 'Assert create success',
      action: 'assert',
      expectedSelector: '.ant-message-success',
      saveAs: '{module}',
    },
    {
      id: `${baseId}.5`,
      label: 'Verify in DB',
      action: 'assert-db',
      dbTable: '{module}s',
      dbAssert: 'exists',
      useCreated: '{module}',
    },
  ],
});

const edit{Module}Steps = (baseId: string, parentRef: string): WorkflowStep => ({
  id: baseId,
  label: 'Click edit',
  action: 'call-row-action',
  actionTitle: $t('page.table.actions.edit'),
  useCreated: '{module}',
  delay: 500,
  children: [
    { id: `${baseId}.1`, label: 'Wait for edit drawer', action: 'wait', delay: 1000 },
    {
      id: `${baseId}.2`,
      label: 'Update all fields (except status)',
      action: 'fill-form',
      formValues: {
        parentId: { fromCreated: parentRef, field: 'id' },
        // ... ALL editable fields with new values
      },
    },
    { id: `${baseId}.3`, label: 'Submit update', action: 'submit-form', delay: 2000 },
    { id: `${baseId}.4`, label: 'Assert update success', action: 'assert', expectedSelector: '.ant-message-success' },
    { id: `${baseId}.5`, label: 'Verify updated in DB', action: 'assert-db', dbTable: '{module}s', dbAssert: 'exists', useCreated: '{module}' },
  ],
});

const delete{Module}Steps = (baseId: string): WorkflowStep => ({
  id: baseId,
  label: 'Click delete',
  action: 'call-row-action',
  actionTitle: $t('page.table.actions.delete'),
  useCreated: '{module}',
  delay: 500,
  children: [
    { id: `${baseId}.1`, label: 'Confirm delete modal', action: 'confirm-modal', delay: 2000 },
    { id: `${baseId}.2`, label: 'Assert delete success', action: 'assert', expectedSelector: '.ant-message-success' },
    { id: `${baseId}.3`, label: 'Verify deleted from DB', action: 'assert-db', dbTable: '{module}s', dbAssert: 'not-exists', useCreated: '{module}' },
  ],
});

// Standalone: FK from existing DB record
create{Module}Steps('2', 'randomParent')

// Instant: FK from record we just created in this workflow
create{Module}Steps('4', 'parent')  // 'parent' was saveAs'd in phase 1
```

#### Type A: Standalone CRUD (`{module}-crud`)

Tests basic CRUD where FK values come from **existing DB records** via `query-first`.

```
query-first (pick random parents from DB, saveAs 'randomClient', 'randomSalesman')
  ↓
Navigate to list → Wait
  ↓
create{Module}Steps('2', 'randomParent') → Wait
  ↓
edit{Module}Steps('4', 'randomParent') → Wait
  ↓
delete{Module}Steps('6')
  ↓
cleanup-db
```

**Edit step**: Must update ALL input fields except status/role enums. Don't just update name — fill every editable field with new values to fully test the update flow. **If module has upload fields, the edit step MUST also replace the uploads** (new avatar + new attachments).

#### Upload fields in workflow tests

**If a module has image/file upload fields, BOTH create and edit steps must include upload steps.**

Create step children order:
```
Wait for drawer → upload-image (avatar) → upload-file (attachments) → fill-form → wait → submit
```

Edit step children order:
```
Wait for edit drawer → upload-image (replace avatar) → upload-file (replace attachments) → fill-form → submit
```

**Upload step examples:**
```typescript
// Avatar image (generates 800x800 test image via canvas)
{ action: 'upload-image', uploadTarget: 'avatar', uploadWidth: 800, uploadHeight: 800, delay: 3000 }

// PDF/document attachment (generates minimal test PDF)
{ action: 'upload-file', uploadTarget: 'attachments', delay: 1000 }
```

**Submit delay**: When form has uploads, increase submit delay to `5000` (deferred upload happens during submit).

**DEV upload targets** registered in form component:
- `avatar`: clears + replaces with new processed image
- `attachments`: clears existing + replaces with new file (not append)

**Date fields**: The `fill-form` action auto-converts `YYYY-MM-DD` strings to dayjs objects for DatePicker compatibility. Just use plain date strings:
```typescript
formValues: { passportExpiredDate: '2028-12-31' }  // auto-converted to dayjs
```

#### Type B: Instant CRUD (`{module}-instant`, if 1:N child)

Tests the 1:N parent→child flow via **layer icon → top drawer → embedded list**.

```
query-first (pick random grandparents if needed)
  ↓
Navigate to PARENT list → Create PARENT → saveAs 'parent'
  ↓
Wait → Click layer icon on parent row (actionTitle = $t('page.{child}.title'))
  ↓  (top drawer opens with embedded child list)
create{Module}Steps('4', 'parent') → Wait    ← FK refs the just-created parent
  ↓
edit{Module}Steps('5.1', 'parent') → Wait
  ↓
delete{Module}Steps('6.1')
  ↓
close-drawers → Wait
  ↓
Wait for actions to restore (delay: 3000)    ← embedded list restores parent's __workflow_listActions on unmount
  ↓
Delete PARENT (call-row-action → confirm-modal → assert-db)
  ↓
cleanup-db
```

**Critical gotchas:**
1. **`close-drawers`** action must come before deleting parent
2. After closing, **wait 3s** for `__workflow_listActions` to restore (embedded child list saves/restores parent's actions on unmount)
3. Then delete the parent entity
4. If actions don't restore properly, add a `navigate` step back to parent list to re-trigger `onActivated`

**Gotcha:** When a top drawer opens with an embedded child list, the child's `__workflow_listActions` overwrites the parent's. The embedded list saves and restores parent actions on unmount, but a wait is needed for the restore to complete.

#### Type C: FK Link Click (`fk-{parentModule}-via-{childModule}`)

Tests **CellFkLink** columns — clicking an FK name in a child list opens the parent's detail drawer where you can edit/delete.

**Standalone variant** (`fk-{parent}-via-{child}`):
```
Create parent → Navigate to child list → Create child (with FK to parent)
  ↓
Wait → Click FK link column (actionTitle: 'fk:{parentName}Field') on child row
  ↓  (parent detail drawer opens)
Assert drawer opened (expectedSelector: '[data-state="open"]')
  ↓
call-detail-action 'edit' → Fill edit form → Submit → Assert success → Assert DB
  ↓
close-all-drawers → Navigate to parent list
  ↓
Delete parent → cleanup-db
```

**Embedded variant** (`fk-{parent}-via-{child}-drawer`):
```
Create parent → Click layer icon → embedded child list in top drawer
  ↓
Create child in embedded list
  ↓
Click FK link on child row in embedded list → parent detail drawer opens
  ↓
Edit parent via detail drawer → Submit
  ↓
close-all-drawers → Navigate to parent list → Delete parent → cleanup-db
```

**Key action — `actionTitle: 'fk:{fieldName}'`:**
```typescript
// The 'fk:' prefix tells the engine to click the CellFkLink column
{ action: 'call-row-action', actionTitle: 'fk:clientName', useCreated: 'business', delay: 1500 }
// Then assert the detail drawer opened
{ action: 'assert', expectedSelector: '[data-state="open"]' }
// Then click Edit inside the detail drawer
{ action: 'call-detail-action', actionTitle: 'edit', delay: 500 }
```

**Multiple FK columns:** A list can have multiple CellFkLink columns pointing to different parent entities. Each needs its own FK link workflow test.

#### Which Types to Generate

| Module has... | Generate |
|---------------|----------|
| Any FK fields | Type A (standalone CRUD with `query-first`) |
| Is a 1:N child (parent has layer icon) | Type A + Type B (instant) |
| Has CellFkLink columns | Type A + Type C (one per FK link column) |
| Is a 1:N child with CellFkLink | Type A + Type B + Type C (standalone + embedded variants) |

#### Malaysian Form Values

- **Personal names** (clients/people): `prefix: 'Ali bin'` or `prefix: 'Ahmad bin'`
- **Company names** (businesses): `prefix: 'Syarikat'` or `prefix: 'Projek'`
- **Important**: Clients = personal names, Businesses = company names (Sdn Bhd)
- Phone: static `'+60 12-345 6789'`
- Address: static Malaysian address
- Email: `{ fakerMethod: 'internet.email', appendMarker: true }`
- Date: plain string `'2028-12-31'` (auto-converted to dayjs by workflow engine)
- Money: string `'2400'` (InputNumber accepts string)
- Avatar: `{ action: 'upload-image', uploadTarget: 'avatar', uploadWidth: 800, uploadHeight: 800 }`
- Attachments: `{ action: 'upload-file', uploadTarget: 'attachments' }`

Register all workflows in `configs/index.ts`.

## Data Conventions

- **All mock/seed data**: Malaysian context (Sdn Bhd, +60, .com.my, MY cities)
- **Soft delete**: `isDelete` boolean, never hard delete from frontend
- **Money**: `numeric(12,2)`, formatted as `RM X,XXX.XX` via `formatMoney()`/`formatMoneyCell()`
- **Status ≤3 options**: RadioGroup with button style
- **Status >3 options**: Select dropdown
- **Graceful errors**: Read ops return empty on error, write ops throw

## Verification Checklist

After all 14 steps:
1. `pnpm dev:local` compiles without errors (uses Docker local Supabase)
2. Menu shows correct icon and nesting
3. List page loads with data (mock or Supabase)
4. Create → form validation → success message → list refreshes
5. Edit → pre-filled form → success → list refreshes
6. Delete → confirm modal → success → list refreshes
7. Layer icon (if 1:N) → top drawer → embedded child list → CRUD works
8. Workflow test runs all steps: CRUD + instant (if 1:N) + FK link click (if CellFkLink)

