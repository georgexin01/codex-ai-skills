---
name: claude-app
description: "V8.0 mobile app Vue builder — 13-step orchestrator for Vue 3 + Supabase + Capacitor mobile/PWA apps. Build-only: consumes the visual design from skills/design/app (DESIGN.md). Each step is a self-sufficient code vault (copy-paste ready)."
triggers: ["claude app", "claude-app", "mobile app build", "vue mobile app", "build mobile app", "new app module", "capacitor app", "pwa app build"]
phase: 0-orchestrator
version: 8.0
status: authoritative
last_updated: "2026-05-21"
---

# `claude-app` — Mobile App Vue Builder V8.0

> **Linear executor**: for step-by-step task execution use [`WORKING_PROGRESS.md`](WORKING_PROGRESS.md). This SKILL.md is the code-vault reference the linear file points into.
> **Design input**: visual design, tokens, and `DESIGN.md` come from [`../design/app/SKILL.md`](../design/app/SKILL.md). This skill builds the Vue code; it does not invent the design.

## 🎯 When to Use

Building or refactoring a Vue 3 + Supabase + Capacitor mobile/PWA app. Use this as the clinical orchestrator for the **13-Step Industrial App Lifecycle**.

This skill is **self-sufficient** — every step contains its own copy-paste Code Vault. The reference template `webApp-bakery-v2/` is no longer required.

## 🤝 SEO Module Cooperation

When the user asks for:
- `seo tables`
- `seo tables in admin`
- SEO settings for App pages
- page-level `meta title / meta description / meta keywords`

coordinate first with:
- [`../claude/seo-tables-planner/skill.md`](../claude/seo-tables-planner/skill.md)

Use that planner to:
- classify the project as `App`, `User-App`, `Driver-App`, `Agent-App`, or other app surface
- inventory public App pages eligible for SEO storage
- exclude dynamic/custom-meta pages from baseline generation
- define the SEO table, permissions, and auto-generation/update workflow
- keep `route_path` as the authoritative runtime lookup key
- treat `page_name` as the read-only admin label/filter
- use shared fallback rows for dynamic listing families where appropriate
- prefer robots as a switch-backed field storing `index, follow` or `noindex, nofollow`
- align app SEO ordering to the shared drag-sort pattern when sort is exposed in admin

Then return to `claude-app` for app-specific route/view/store implementation work.

App-side SEO implementation rules:
- read the project SEO docs before planning reseed/sync work
- resolve SEO rows by `route_path`, not `page_name`
- exact-match rows should win before any shared dynamic-family fallback
- decide exclusion by meta ownership:
  - pages that already derive meta from a live record/custom source should stay outside SEO table lookup
  - names like blog/product/testimonial/listing are only examples, not the actual rule
- app/admin SEO UI may filter by `page_name`, but runtime lookup should stay route-keyed
- keep `page_name` and `route_path` system-managed/read-only when rows are seeded
- if rows are system-seeded, prefer hidden create and edit-in-place SEO flow
- if app SEO reads through Supabase/PostgREST, verify the same full stack:
  - RLS
  - permission seed rows
  - table grants
  - public/anon read strategy when applicable
- future app SEO modules must ship the SQL stack together:
  - authenticated CRUD RLS
  - `seo_settings` permission seed rows
  - anon/public read policy when the surface reads via anon REST
  - explicit grants for `anon`, `authenticated`, and `service_role`

## 🧭 Folder Anchors (the 6 pillars)

The webApp's `src/` layer has six load-bearing folders. Every step below anchors to one of them (plus foundational/deployment steps):

| `src/` Folder | Role | Owning Step |
|---|---|---|
| `src/api/` | Platform-aware HTTP + Supabase clients | **03** |
| `src/config/` | Single source of `import.meta.env.VITE_*` access | **02** |
| `src/types/` | TypeScript contracts used by stores + views | **05** |
| `src/stores/` | Pinia Bakery stores (most logic lives here) | **06** |
| `src/router/` | Dynamic + guarded routing | **10** |
| `src/views/` | Page components | **09** |

## 🚀 The 13-Step Industrial Protocol

### Phase 1 — Foundation (project plumbing)
1. **[01-handshake-genesis](01-handshake-genesis/skill.md)** — Project genesis: `package.json`, `vite.config.ts`, `tsconfig.json`, `index.html` (viewport=device-width), Pinia + router registration.
2. **[02-config-hardening](02-config-hardening/skill.md)** — `src/config/{env.ts, supabase.ts, index.ts}` — the only place `VITE_*` is read.
3. **[03-api-connectivity](03-api-connectivity/skill.md)** — `src/api/{apiClient.ts, capacitorClient.ts}` — platform-aware HTTP + Supabase wrapper.
4. **[04-auth-architecture](04-auth-architecture/skill.md)** — Supabase Auth, JWT extraction, fail-closed route guards, refresh-token flow.

### Phase 2 — Data Scaffolding (src/types + src/stores)
5. **[05-types-foundry](05-types-foundry/skill.md)** — `src/types/` — DB types, App types, request/response envelopes.
6. **[06-industrial-stores](06-industrial-stores/skill.md)** — `src/stores/` — Options-API Bakery pattern, identity filtering, `$reset` contract.
7. **[07-image-spec](07-image-spec/skill.md)** — Supabase Storage upload, `<AppImage>` fallback, Capacitor native image picker.

### Phase 3 — UI Foundry (src/views + styling)
8. **[08-ui-standardization](08-ui-standardization/skill.md)** — CSS variables, theme tokens, divider sections, EN UPPERCASE, contact-field pattern.
9. **[09-view-scaffolding](09-view-scaffolding/skill.md)** — `src/views/` — List / Detail / Form templates with loading + empty states.
10. **[10-routing-logic](10-routing-logic/skill.md)** — `src/router/index.ts` — guards, auto-import modules, redirect-to-login.
11. **[11-relational-sync](11-relational-sync/skill.md)** — M2M patterns, intersection filters, soft-delete, AnswerSnapshot-style history.

### Phase 4 — Locale + Native + Deploy
12. **[12-i18n-composables](12-i18n-composables/skill.md)** — vue-i18n auto-glob, `src/composables/` (Capacitor Clipboard/Share patterns).
13. **[13-native-pwa-deploy](13-native-pwa-deploy/skill.md)** — `capacitor.config.ts`, `manifest.json`, PWA service worker, staging + production deploy.

## 📖 Reference Vaults

- **Cookbook**: `_cookbook.md` — reusable snippets (pagination, fail-closed guard, Bakery store template, soft-delete filter). Linked from multiple steps.
- **Master Rules**: [`MASTER_RULES.md`](../SHARED_DB_CONTRACT.md) — Rule #1 (Supabase schema isolation) is the law.
- **Apex Kernel**: [`GROUND_KERNEL.md`](../../memories/0_apex/GROUND_KERNEL.md)
- **Project Snapshot**: [`LAA_PROJECT_SNAPSHOT.md`](../../memories/3_domains/claude/LAA_PROJECT_SNAPSHOT.md)

## 🛠️ Mandatory Execution Rules

- **CLINICAL SEQUENCING** — execute 01 → 13 in order for a new webApp. For targeted edits, you may enter at the step that owns the folder you're touching (see Folder Anchors above), but you MUST re-verify the `requires:` chain in that step's frontmatter.
- **SCHEMA ISOLATION (Rule #1)** — every query reads from the project schema (`quizLaa` for quizLaa-family webApps). Only `auth.users` is permitted cross-schema.
- **IDENTITY FILTERING** — all data retrieval is filtered by the authoritative `userId` (from auth store) and `projectId` (from `VITE_PROJECT_ID`). This is enforced in the store layer, not views.
- **CASING SYNC** — use `COALESCE(auth.jwt()->>'project_id', auth.jwt()->>'projectId')` in any RLS you touch from this skill.
- **CONFIG FUNNEL** — `import.meta.env.VITE_*` is read in `src/config/` ONLY. Everywhere else uses `env.*` from the barrel.

## 🗺️ Router — AI Navigation Map

AI routes here automatically based on what the user needs. No guessing required.

### Inbound — When to load claude-app
| Trigger / Situation | Action |
|---|---|
| New Vben Admin project starts | → Start at `02-config-hardening/skill.md` (Step 01 = handshake; skip if copying from reference) |
| User says "build admin module X" | → `09-view-scaffolding/skill.md` (after stores exist) |
| Env/VITE_* config issues | → `02-config-hardening/skill.md` |
| Auth login / token / JWT issue | → `04-auth-architecture/skill.md` |
| TypeScript types needed | → `05-types-foundry/skill.md` |
| Pinia store needed | → `06-industrial-stores/skill.md` |
| Image upload / storage | → `07-image-spec/skill.md` |
| UI design tokens / theme | → `08-ui-standardization/skill.md` |
| CRUD list/form/drawer views | → `09-view-scaffolding/skill.md` |
| Route guard / menu routing | → `10-routing-logic/skill.md` |
| M2M / relational data sync | → `11-relational-sync/skill.md` |
| Bilingual (i18n) | → `12-i18n-composables/skill.md` |
| PWA / deploy | → `13-native-pwa-deploy/skill.md` |
| Title → URL slug auto-gen | → See "Title → URL Slug Pattern" section in this SKILL.md |
| Drag sort on table | → See "Sort Drag Pattern" section in this SKILL.md |
| SEO tables needed | → `../claude/seo-tables-planner/skill.md` first, then return here |

### Outbound — What claude-app links to
| Need | → Path |
|---|---|
| PHP website paired to this admin | `../claude-website/SKILL.md` |
| New project bootstrap | `../starting-point/skill.md` |
| Shared DB contract | `../SHARED_DB_CONTRACT.md` |
| Visual design tokens | `../design/app/SKILL.md` |
| Progress tracking | `WORKING_PROGRESS.md` (in this folder) |
| Reusable code snippets | `_cookbook.md` (in this folder) |

### Step Entry Points (Fast Access)
```
02  src/config/       → 02-config-hardening/skill.md
03  src/api/          → 03-api-connectivity/skill.md
04  auth flow         → 04-auth-architecture/skill.md
05  src/types/        → 05-types-foundry/skill.md
06  src/stores/       → 06-industrial-stores/skill.md
07  image/storage     → 07-image-spec/skill.md
08  UI/theme          → 08-ui-standardization/skill.md
09  src/views/        → 09-view-scaffolding/skill.md
10  src/router/       → 10-routing-logic/skill.md
11  relational sync   → 11-relational-sync/skill.md
12  i18n              → 12-i18n-composables/skill.md
13  deploy/PWA        → 13-native-pwa-deploy/skill.md
```

### Auto-Trigger Rules (AI applies without being asked)
- **User edits a store** → check `06-industrial-stores` pattern before writing
- **User adds a new view** → follow `09-view-scaffolding` module structure
- **User adds i18n** → check `12-i18n-composables` for composable pattern
- **After any DB schema change** → update `05-types-foundry` TS types to match
- **VITE_* in wrong file** → fix immediately per `02-config-hardening` Rule #1

## ✅ Verify the Orchestrator

- `claude-app/` contains exactly 13 numbered sub-directories (01 → 13) + `SKILL.md` + `WORKING_PROGRESS.md` + `_cookbook.md` + `README.md`.
- Every sub-directory contains a `skill.md` with version ≥ 2.0 frontmatter and a 📦 Code Vault section.
- `SKILL.md` links every sub-directory exactly once.
- Zero references to `C:\Users\user\.claude\skills\*` (deprecated mirror path).

---
**Protocol Status**: V8.0 Active | **Architect**: Claude-App | **Self-Sufficient**: Yes (consumes design/app DESIGN.md)

## Title → URL Slug Pattern (2026-06-02)

For Vben Admin modules where a content entity needs a human-readable URL slug auto-generated from its title (e.g. blog posts, resources).

### TypeScript helper (store level)
```ts
export function titleToUrl(title: string): string {
  return title
    .toLowerCase()
    .replace(/[^a-z0-9\s]/g, '')   // remove symbols
    .trim()
    .replace(/\s+/g, '-')           // spaces → hyphens
    .replace(/^-+|-+$/g, '');       // trim leading/trailing hyphens
}
```

### Store — auto-generate on create + update
```ts
async create(values: FormValues): Promise<Entity> {
  const url = titleToUrl(values.title);
  const { data, error } = await supabase.from('table').insert({ ...values, url }).select().single();
  ...
}
async update(id: string, values: Partial<FormValues>): Promise<Entity> {
  const patch: any = { ...values, updated_at: new Date().toISOString() };
  if (values.title !== undefined) patch.url = titleToUrl(values.title);
  ...
}
async checkTitleExists(title: string, excludeId?: string): Promise<boolean> {
  let q = supabase.from('table').select('id').eq('project_id', PROJECT_ID).is('deleted_at', null).ilike('title', title.trim());
  if (excludeId) q = q.neq('id', excludeId);
  const { data } = await q;
  return (data ?? []).length > 0;
}
```

### Form — read-only URL preview synced from title
```ts
// In form component
const urlPreview = ref('');
watch(() => formApi.form?.values?.title, (title) => { urlPreview.value = titleToUrl(title ?? ''); });
watch(() => props.entity, (e) => { if (e?.url) urlPreview.value = e.url; }, { immediate: true });

// On submit — duplicate title check before emitting
const titleExists = await store.checkTitleExists(values.title, props.entity?.id);
if (titleExists) { message.error('Title already used.'); return; }
emit('submit', { ...values, url: titleToUrl(values.title) });
```

```html
<!-- Template: read-only preview -->
<div class="rounded border bg-gray-50 px-3 py-2 text-sm text-gray-500">
  <span class="text-gray-400">/blogs/</span>
  <span class="font-mono">{{ urlPreview || '—' }}</span>
</div>
```

### SQL
```sql
ALTER TABLE schema.table ADD COLUMN IF NOT EXISTS url TEXT;
UPDATE schema.table SET url = lower(regexp_replace(regexp_replace(regexp_replace(title,'[^a-zA-Z0-9\s]','','g'),'\s+','-','g'),'-+$|^-+','','g')) WHERE url IS NULL OR url = '';
ALTER TABLE schema.table ADD CONSTRAINT table_url_unique UNIQUE (url);
ALTER TABLE schema.table ALTER COLUMN url SET NOT NULL;
```
No extra grants needed — inherits table-level grants automatically.

### PHP website — lookup by url + UUID fallback
```php
// blogData.php
function getWebsiteBlogByUrl(string $url): ?array {
    try { return (new BlogPostModel(supabaseClient()))->findByUrl($url); }
    catch (\Throwable $e) { return null; }
}

// blog-details.php
$post = getWebsiteBlogByUrl($slug) ?? getWebsiteBlogById($slug); // UUID backward compat
```

**Reference:** `admin-panel-angel` blog module (angel-interior). Implemented 2026-06-02.

---

## Sort Drag Pattern (V2 — DESC, 2026-06-02)

Sovereign sort strategy for Vben Admin + VXE Table list pages. All tables in `admin-panel-angel` (angel-interior) implement this. Reference project for any future admin panel.

---

### Which tables get drag sort vs plain sort

| Table has `sort` field | Pattern | Default sort |
|---|---|---|
| ✅ Yes | `sort DESC` primary + `created_at DESC` secondary + drag handle | `sort DESC` |
| ❌ No | `created_at DESC` only | `created_at DESC` |

**angel-interior table map:**

| Module | Table | Has sort | Pattern |
|---|---|---|---|
| Slideshow | `slideshows` | ✅ | sort DESC + drag |
| Blog Posts | `blog_posts` | ✅ | sort DESC + drag |
| SketchUp Categories | `sketchup_categories` | ✅ | sort DESC + drag |
| SketchUp Resources | `sketchup_resources` | ✅ | sort DESC + drag |
| Material Categories | `material_categories` | ✅ | sort DESC + drag |
| Material Resources | `material_resources` | ✅ | sort DESC + drag |
| Contact Submissions | `contact_submissions` | ❌ | created_at DESC only |
| Users | `angelinterior.users` | ❌ | createdAt DESC only |
| Attachments | `angelinterior.attachments` | ❌ | image grid, createdAt DESC only |
| Workflow-test | N/A | N/A | card UI, no sort |

---

### 1. List view — `sortConfig` + `isDragSortMode`

```ts
// Tables WITH sort → default sort is sort DESC so drag handles show on load
sortConfig: { remote: true, trigger: 'default', defaultSort: { field: 'sort', order: 'desc' } }
const isDragSortMode = ref(true)  // true = drag handles visible at load

// Tables WITHOUT sort → default created_at DESC, no drag
sortConfig: { remote: true, trigger: 'default', defaultSort: { field: 'created_at', order: 'desc' } }
// no isDragSortMode needed
```

Drag handle visibility is controlled by `handleSortChange`:
```ts
const handleSortChange = ({ sortList }: any) => {
  const active = sortList?.[0];
  isDragSortMode.value = !active || active.field === 'sort';
};
```
User sorts by `sort` column → drag handles visible. Any other column → drag handles hidden.

---

### 2. Store `getList` — double sort pattern

```ts
// Tables WITH sort field
const primaryField = params?.sortBy || 'sort';           // ← default 'sort' not 'created_at'
const ascending = params?.sortOrder !== 'desc';
query = query.order(primaryField, { ascending });
query = query.order('created_at', { ascending: false }); // ← secondary always DESC, fixed

// Tables WITHOUT sort field
const primaryField = params?.sortBy || 'created_at';
const ascending = params?.sortOrder !== 'desc';
query = query.order(primaryField, { ascending });
// no secondary needed
```

Key: secondary `created_at` is **always `ascending: false`** regardless of primary sort direction. This ensures newest items appear first in ties at all times.

---

### 3. `resolveDraggedSort` — DESC-aware edge cases

Display is `sort DESC` → **highest sort value = top row**.
Drag logic must be inverted vs ASC:

```ts
export const SORT_GAP = 1000;

// TOP edge (prevRow = null): dragged item must exceed current top
if (!prevRow) {
  newSort = (nextRow?.sort ?? 0) + SORT_GAP;
// BOTTOM edge (nextRow = null): dragged item must go below current bottom
} else if (!nextRow) {
  newSort = Math.floor((prevRow.sort ?? SORT_GAP) / 2);
// MIDDLE: midpoint works for both ASC and DESC
} else {
  newSort = Math.floor((prevRow.sort + nextRow.sort) / 2);
}
// Collision → needsRenormalize = true → call renormalizeSort()
```

File: `apps/web-antd/src/utils/sort-drag.ts`

---

### 4. `getNextSort` — new items land at top

```ts
async function getNextSort(table) {
  const { data } = await supabase
    .from(table)
    .select('sort')
    .eq('project_id', PROJECT_ID)
    .is('deleted_at', null)
    .order('sort', { ascending: false })  // get MAX sort
    .limit(1)
    .maybeSingle();
  return ((data?.sort ?? 0) + SORT_GAP);  // new item gets highest value → top of DESC list
}
```

---

### 5. `renormalizeSort` — gap exhaustion repair

Fetches rows `ascending: true` → reassigns `1000, 2000, 3000...`. Display is DESC so relative visual order is preserved.

```ts
async renormalizeSort() {
  const { data } = await supabase
    .from(table).select('id')
    .order('sort', { ascending: true });  // stable order before renumber
  await Promise.all(data.map((row, i) =>
    supabase.from(table).update({ sort: (i + 1) * SORT_GAP }).eq('id', row.id)
  ));
}
```

---

### 6. Column setup

```ts
// No. column: enable drag handle
{ type: 'seq', field: '_seq', title: 'No.', dragSort: true }

// Sort column: visible on resource pages only
{ field: 'sort', title: 'Sort', width: 60, sortable: true }

// Row drag config
rowConfig: { ...defaultGridOptions.rowConfig, drag: true }
gridEvents: { rowDragend: handleRowDragend, sortChange: handleSortChange }
```

Sort column visibility rule (angel-interior):
- **Visible**: `/sketchup/resources`, `/material/resources`
- **Hidden** (sort stored internally, not shown): `/blog/posts`, `/slideshow/slides`, `/sketchup/categories`, `/material/categories`

---

### 7. What NOT to change (no sort field tables)

- `contact_submissions`, `angelinterior.users`, `angelinterior.attachments` — no `sort` column → no drag, no isDragSortMode, no getNextSort. Keep plain `created_at DESC`.
- `workflow-test` — card UI, no data table, no sort at all.

---

**Reference:** `admin-panel-angel` (angel-interior project). Fully applied 2026-06-02.
**File:** `apps/web-antd/src/utils/sort-drag.ts` — canonical DESC-aware implementation.
