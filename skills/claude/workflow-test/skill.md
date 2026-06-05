---
name: workflow-test
description: Generate workflow-test configs and Playwright specs for automated CRUD flows with DEV bridge hooks.
triggers: ["workflow test", "playwright", "automated crud test", "workflow config"]
phase: 3-testing
requires: [generate-views]
unlocks: []
inputs: [entity_definition, relationships]
output_format: typescript_config
model_hint: gpt-5.3-codex
version: 2.0
---

# Workflow Test (workflow-test)

Generate a workflow test config and Playwright spec for automated CRUD testing of a module.

## Overview

This skill generates:
1. **Workflow config** (`views/workflow-test/configs/{entity}-workflows.ts`) — defines the test steps
2. **Playwright spec** (`__tests__/e2e/workflow-test.spec.ts`) — runs the workflow and reports results
3. **Registers** the new workflow in `configs/index.ts`

## Architecture

```
Playwright (terminal)              Browser (workflow store)           Supabase DB
─────────────────────             ──────────────────────────         ────────────
1. Navigate to /workflow-test
2. Click "Run" on suite card
                                  3. Execute steps via setTimeout chain:
                                     - navigate: router.push()
                                     - click-button: find button by text
                                     - fill-form: formApi.setValues()     ← DEV bridge
                                     - submit-form: formRef.submitForm()  ← DEV bridge
                                     - set-answers: window.__workflow_setAnswers()
                                     - call-row-action: window.__workflow_rowActions[id]
                                     - confirm-modal: click .ant-btn-primary
                                     - assert: waitForElement(selector)
                                     - assert-db: supabase.from().select() ──→ SELECT
                                     - cleanup-db: supabase.from().delete() ──→ DELETE
3. Poll progress panel DOM
4. Log step pass/fail in terminal
5. Hard delete via docker exec psql ──────────────────────────────────→ DELETE (bypass RLS)
```

## DEV Bridges (import.meta.env.DEV only)

| Bridge | Registered by | Purpose |
|--------|---------------|---------|
| `window.__workflow_formApi` | `useEntityForm` | `formApi.setValues()` to fill forms without DOM |
| `window.__workflow_formSubmit` | `useCreateDrawer` / `useEditDrawer` | Trigger form submit from store |
| `window.__workflow_rowActions[rowId][title]` | `CellActions` renderer in `vxe-table.ts` | Call edit/delete handlers by row ID |
| `window.__workflow_setAnswers` | `question-form.vue` | Set JSONB answer arrays for questions |
| `localStorage.__workflow_lastCreated` | `useCreateDrawer` on success | Store last created entity |
| `localStorage.__workflow_created_{name}` | Store `saveAs` | Named slots for multi-entity workflows |

## Available Step Actions

| Action | Required Fields | Description |
|--------|----------------|-------------|
| `navigate` | `route` | `router.push(route)` |
| `wait` | `delay` (default 2000) | Pause execution |
| `click-button` | `buttonText` | Find button by visible text and click |
| `fill-form` | `formValues: FormValuesMap` | `formApi.setValues()` — fills all fields at once |
| `submit-form` | — | Calls `formRef.submitForm()` via bridge |
| `set-answers` | `answerCount` (default 4) | Generate N answers (1 random correct) via `__workflow_setAnswers` |
| `call-row-action` | `actionTitle`, `useCreated?` | Reads entity from localStorage, calls `rowActions[id][title]()` |
| `confirm-modal` | — | Clicks the primary button in `.ant-modal-confirm` |
| `assert` | `expectedSelector` | Waits for CSS selector to exist |
| `assert-db` | `dbTable` (snake_case), `dbAssert`, `useCreated?` | Queries Supabase to verify record |
| `cleanup-db` | — | Deletes test data via Supabase client (soft delete) |

**Important:** `dbTable` in `assert-db` and `dataTargets[].table` must use **snake_case** table names (e.g., `question_answers`, not `questionAnswers`). This matches the DB naming convention.

## Multi-Entity: saveAs / useCreated

For workflows that create multiple entities (e.g., 1 lesson + 5 questions), use `saveAs` and `useCreated` to track each entity independently:

```typescript
// After create succeeds, save to named localStorage slot
{ id: '2.4', label: 'Assert success', action: 'assert',
  expectedSelector: '.ant-message-success', saveAs: 'lesson' },

// Later steps reference by name
{ id: '4', label: 'Click edit', action: 'call-row-action',
  actionTitle: $t('page.table.actions.edit'), useCreated: 'lesson' },

// assert-db also supports useCreated
{ id: '4.5', label: 'Verify DB', action: 'assert-db',
  dbTable: 'lessons', dbAssert: 'exists', useCreated: 'lesson' },
```

**Important:** Put `saveAs` on the **assert** step (after submit's 2000ms delay), NOT on submit-form. The `useCreateDrawer` saves to `__workflow_lastCreated` asynchronously — by the time assert runs, localStorage is populated.

## FormValuesMap

Each field can be a static string, `InputGenConfig`, or `CreatedEntityRef`:

```typescript
formValues: {
  // Faker + marker (for text fields)
  title: { fakerMethod: 'lorem.sentence', appendMarker: true },
  // Faker only
  description: { fakerMethod: 'lorem.paragraph' },
  // Number with max value
  duration: { fakerMethod: 'number.int', maxValue: 120 },
  // Static value
  password: '123456',
  role: 'agent',
  // Reference a previously created entity's field
  lessonId: { fromCreated: 'lesson', field: 'id' },
}
```

- `appendMarker: true` — appends marker. For emails: inserts before `@` (e.g. `john.mark2103@example.com`)
- `maxValue` — when `abnormalMode` is on, generates values exceeding this limit
- `fromCreated` + `field` — reads a field from a previously saved entity (via `saveAs`)

## Test Run Marker

Format: `mark{DDMMYYHHmm}` (e.g. `mark2103211530`)

- Appended to primary fields (title, name) via `appendMarker: true`
- For emails: inserted before `@` (e.g. `user.mark2103211530@example.com`)
- Used in SQL: `WHERE title LIKE '%mark2103211530%'`
- Cleanup removes all `__workflow_created_*` and `__workflow_lastCreated` keys

## Reference Implementations

### 1. Simple CRUD: Lesson

File: `apps/web-antd/src/views/workflow-test/configs/lesson-workflows.ts`

Flow: Navigate → Create → Verify DB → Edit → Verify DB → Delete → Verify DB → Cleanup

### 2. Parent + Children CRUD: Lesson + 5 Questions

File: `apps/web-antd/src/views/workflow-test/configs/lesson-question-workflows.ts`

Flow:
- Create lesson (`saveAs: 'lesson'`)
- Create 5 questions (`saveAs: 'q1'...'q5'`, each with `lessonId: { fromCreated: 'lesson', field: 'id' }`)
- Each question gets 4 answers via `set-answers` action
- Edit 5 questions (`useCreated: 'q1'...'q5'`)
- Delete 5 questions in reverse (`useCreated: 'q5'...'q1'`)
- Delete lesson (`useCreated: 'lesson'`)
- Cleanup

Uses helper functions to generate repetitive steps:
```typescript
const createQuestionSteps = (baseId, qNum, saveAs) => ({ ... });
const editQuestionSteps = (baseId, qNum, useCreated) => [ ... ];
const deleteQuestionSteps = (baseId, qNum, useCreated) => [ ... ];
```

### 3. RPC-based CRUD: User

File: `apps/web-antd/src/views/workflow-test/configs/user-workflows.ts`

**Special considerations for User CRUD:**
- User store uses `supabase.schema('public').rpc('create_user', ...)` — RPC is in `public` schema, not business schema
- RPC creates across 3 layers: `auth.users` + `public.user` + `quizLaa.users`
- `create_user` RPC sets `temp_password: true` — new users need OTP verification on first login
- Hard delete must clean all 3 tables (quizLaa.users, public.user, auth.users)
- `get_current_role_level()` reads `role_level` from JWT — requires `custom_access_token_hook` enabled
- `create_user` RPC uses `gen_salt()` from pgcrypto — function `search_path` must include `extensions` schema

## One-to-Many: Layer Icon → Top Drawer Pattern

When a parent entity has child records (e.g., lessons → questions), the parent table includes a **layer icon** (`lucide:layers`) in `CellActions`. Clicking it opens a **top-sliding drawer** that embeds the child entity's list in `embedded` mode.

### Reference Files

| File | Role |
|------|------|
| `views/lessons/lesson-list.vue` | Parent list — `lucide:layers` action button |
| `views/lessons/drawer/lesson-questions-drawer.vue` | Top drawer wrapper — `placement: 'top'` |
| `views/questions/question-list.vue` | Child list — `embedded` mode with `lessonId` prop |

## Playwright Spec Pattern

File: `apps/web-antd/__tests__/e2e/workflow-test.spec.ts`

Key elements:
- **`hardDeleteTestData(marker, tables)`** — `docker exec supabase-db psql ...` with optional `schema` param
- **`monitorWorkflow(page, timeoutMs)`** — polls every 500ms, default 60s timeout
- **Always hard deletes** after test (success or fail)

```typescript
// Simple entity
test('Lesson CRUD', async ({ page }) => {
  await runWorkflowSuite(page, 'Lesson Full CRUD', [
    { table: 'lessons', field: 'title' },
  ]);
});

// Multi-entity with longer timeout
test('Lesson + Questions', async ({ page }) => {
  test.setTimeout(180_000);
  await runWorkflowSuite(page, 'Lesson + 5 Questions CRUD',
    [{ table: 'questions', field: 'title' }, { table: 'lessons', field: 'title' }],
    150_000,  // monitor timeout
  );
});

// User CRUD (3-layer cleanup with schema param)
test('User CRUD', async ({ page }) => {
  await runWorkflowSuite(page, 'User CRUD (RPC)', [
    { table: 'users', field: 'name' },
    { table: 'users', field: 'email' },
    { table: 'user', field: 'email', schema: 'public' },
    { table: 'users', field: 'email', schema: 'auth' },
  ]);
});
```

Docker container: `supabase-db`, default schema: `quizLaa` (case-sensitive)

## How to Generate for a New Entity

### Input Required

1. **Entity name** (e.g. `questions`)
2. **Supabase table name** and schema
3. **Primary field** for marker (e.g. `title`)
4. **Form fields** with types
5. **Route path**
6. **i18n keys** for toolbar button and action labels
7. **FK relationships** (if any — need `saveAs`/`useCreated`/`fromCreated`)

### Steps

1. Read `views/{entity}/{entity}-form.vue` — get field names
2. Read `views/{entity}/{entity}-list.vue` — get toolbar button text
3. Create `views/workflow-test/configs/{entity}-workflows.ts`
4. Register in `configs/index.ts`
5. Add test case in `__tests__/e2e/workflow-test.spec.ts`
6. Run: `cd apps/web-antd && pnpm exec playwright test workflow-test.spec.ts -g "Suite Name" --headed`

## Supabase Local Docker Setup

Required for workflow tests to pass:

1. **custom_access_token_hook enabled** — injects `role_level`, `project_id`, `user_role` into JWT
   - Docker compose env: `GOTRUE_HOOK_CUSTOM_ACCESS_TOKEN_ENABLED=true`
   - Docker compose env: `GOTRUE_HOOK_CUSTOM_ACCESS_TOKEN_URI=pg-functions://postgres/public/custom_access_token_hook`
   - Grants: `GRANT EXECUTE ON FUNCTION public.custom_access_token_hook(jsonb) TO supabase_auth_admin`
   - Grants: `GRANT SELECT ON public."user", public.role, public.project TO supabase_auth_admin`

2. **pgcrypto extension** — `create_user` RPC uses `gen_salt()`
   - Functions using pgcrypto must have `SET search_path = public, extensions`

3. **RPC schema** — User CRUD RPCs are in `public` schema, must use `supabase.schema('public').rpc()`

4. **Dev server** — Playwright uses `pnpm dev:local` (`.env.development.localhost` → `http://localhost:8000`)

## Dev Server Modes

| Command | Supabase URL | Schema | Usage |
|---------|-------------|--------|-------|
| `pnpm dev:local` | `http://localhost:8000` (Docker) | `quizLaa` | Local dev + Playwright tests |
| `pnpm dev:zeta` | `https://supabase.aisolo.vip` | `quizLaa` | Zeta remote |
| `pnpm dev:vps` | SSH tunnel `localhost:8000` | `wms` | VPS remote |

**Important:** No generic `pnpm dev` — always use a specific mode.

## Resume from Step (Step Tree Click)

When a workflow is **not running** and has a `testRunMarker`, users can click any step in the step tree to restart execution from that point. The clicked step and all subsequent steps are reset to `pending`, then execution resumes.

- **Store method:** `resumeFromStep(stepId: string)`
- **UI:** Step tree rows become clickable (`cursor-pointer hover:bg-gray-100`) when `canRestart` is true
- **Condition:** `!isRunning && !!testRunMarker` — only available after a run has started/completed
- Resets the target step + all subsequent steps to `pending` state before running

## Error Handling

- Duplicate record error (code `23505`) shows "Record already exists (duplicate)" in UI
- `useCreateDrawer` catches this in the `catch` block and shows `$t('page.common.duplicateRecord')`

## Naming Conventions

| Layer | Convention | Examples |
|-------|-----------|---------|
| **DB table names** | `snake_case` | `question_answers`, `attachment` |
| **DB column names** | `camelCase` | `isDelete`, `createdAt`, `lessonId` |
| **Frontend code** | `camelCase` | Matches DB column names |
| **Supabase `.from()`** | `snake_case` table name | `.from('question_answers')` |

## Image Upload & Attachment System

### Upload Flow

1. User selects image → immediate upload via `customRequest` to Supabase Storage
2. Storage path: `{BUCKET}/{YYMM}/{YYMMDD-HHMMSS}-{filename}` (bucket = schema name, e.g. `quizLaa`)
3. After upload, record inserted into `attachment` table
4. Form stores `string[]` of storage paths in entity's JSONB field (e.g. `lessons.images`)

### Key Files

| File | Purpose |
|------|---------|
| `utils/upload.ts` | `uploadPhoto()` (customRequest), `insertAttachmentRecord()`, `urlsToFileList()`, `fileListToUrls()`, `getStorageUrl()`, `purgeDeletedAttachments()` |
| `stores/attachments.ts` | `getList()`, `softDelete()`, `restore()`, `purgeDeleted()` |
| `views/attachments/attachment-list.vue` | Album page — grid view, filter (all/active/deleted), soft delete, restore, purge |

### Form Upload Pattern (reference: lesson-form.vue)

Images managed **outside** the form schema (for drag reorder with sortablejs):

```typescript
import { Upload } from 'ant-design-vue';
import Sortable from 'sortablejs';
import { uploadPhoto, urlsToFileList, fileListToUrls } from '#/utils/upload';

// fileList managed as ref, not in form schema
const fileList = ref<UploadFile[]>([]);

// Edit mode: convert string[] to UploadFile[]
const transformedEntity = computed(() => ({
  ...props.entity,
  images: urlsToFileList(props.entity.images ?? []) as any,
}));

// Submit: convert UploadFile[] back to string[]
values.images = fileListToUrls(fileList.value);
```

### Attachment Table Schema

```sql
CREATE TABLE "quizLaa".attachment (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  "storagePath" TEXT NOT NULL,
  "originalName" TEXT NOT NULL,
  "fileSize" BIGINT,
  "mimeType" TEXT,
  "uploadedBy" UUID REFERENCES auth.users(id),
  "isDelete" BOOLEAN DEFAULT false,
  "createdAt" TIMESTAMPTZ DEFAULT now(),
  "updatedAt" TIMESTAMPTZ DEFAULT now()
);
```

### Supabase Storage Setup

```sql
-- Create bucket (name = schema name)
INSERT INTO storage.buckets (id, name, public) VALUES ('quizLaa', 'quizLaa', true);

-- RLS policies
CREATE POLICY "Authenticated upload" ON storage.objects FOR INSERT TO authenticated WITH CHECK (bucket_id = 'quizLaa');
CREATE POLICY "Public read" ON storage.objects FOR SELECT TO public USING (bucket_id = 'quizLaa');
CREATE POLICY "Authenticated update" ON storage.objects FOR UPDATE TO authenticated USING (bucket_id = 'quizLaa');
CREATE POLICY "Authenticated delete" ON storage.objects FOR DELETE TO authenticated USING (bucket_id = 'quizLaa');
```

## Important Notes

- All workflow test code is **DEV only** (`import.meta.env.DEV`) — excluded from production builds
- Route `/workflow-test` only exists in DEV mode
- Progress panel in `app.vue` only renders in DEV mode (lazy loaded via `defineAsyncComponent`)
- `cleanup-db` does soft delete via Supabase client; Playwright does hard delete via `docker exec psql`
- Workflow configs must be **functions** (not constants) so `$t()` resolves correctly at runtime
- `formValues` field names must match the form schema's `fieldName` exactly
- `saveAs` must be on the **assert** step, not submit-form (timing issue)
- When creating users via RPC, clear `temp_password` flag and confirm email for test accounts

