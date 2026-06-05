---
name: claude-app-cookbook
description: "Reusable snippets referenced by multiple step files. Keeps per-step files lean; avoid duplicating these patterns. Linked from SKILL.md and individual steps."
triggers: ["cookbook", "app cookbook", "reusable snippets", "pagination", "seo head"]
phase: reference
version: 2.2
status: authoritative
last_updated: "2026-06-02"
---

# claude-app — Cookbook

Reusable snippets that span multiple step files. Each recipe lives here once; step files reference by anchor (e.g., Step 01 points at [§SEO-Head](#seo-head)).

---

## SEO-Head
<a name="seo-head"></a>

Full `index.html` head block with SEO + Open Graph + Twitter + JSON-LD. Step 01 Code Vault §4 ships the essentials; use this when a site needs full social + crawler metadata.

```html
<head>
  <meta charset="UTF-8">

  <!-- SEO -->
  <meta name="robots" content="noindex,nofollow">
  <meta name="description" content="PROJECT_DESCRIPTION">
  <meta name="keywords" content="KEYWORDS">
  <link rel="canonical" href="https://PROJECT_URL/">

  <!-- PWA + viewport (width=device-width per global rule) -->
  <meta name="viewport" content="width=device-width, initial-scale=1.0, viewport-fit=cover">
  <meta name="mobile-web-app-capable" content="yes">
  <meta name="apple-mobile-web-app-capable" content="yes">
  <meta name="apple-mobile-web-app-status-bar-style" content="black-translucent">
  <meta name="theme-color" content="#PRIMARY_HEX" media="(prefers-color-scheme: light)">
  <meta name="theme-color" content="#PRIMARY_DARK_HEX" media="(prefers-color-scheme: dark)">

  <!-- Open Graph -->
  <meta property="og:type" content="website">
  <meta property="og:url" content="https://PROJECT_URL/">
  <meta property="og:title" content="PROJECT_TITLE">
  <meta property="og:description" content="PROJECT_DESCRIPTION">
  <meta property="og:image" content="https://PROJECT_URL/assets/favicon/web-app-manifest-512x512.png">

  <!-- Twitter -->
  <meta name="twitter:card" content="summary_large_image">
  <meta name="twitter:url" content="https://PROJECT_URL/">
  <meta name="twitter:title" content="PROJECT_TITLE">
  <meta name="twitter:description" content="PROJECT_DESCRIPTION">

  <!-- JSON-LD -->
  <script type="application/ld+json">
  {
    "@context": "https://schema.org",
    "@type": "WebApplication",
    "name": "PROJECT_TITLE",
    "description": "PROJECT_DESCRIPTION",
    "url": "https://PROJECT_URL/",
    "applicationCategory": "education",
    "operatingSystem": "Any",
    "offers": {"@type": "Offer", "price": "0", "priceCurrency": "USD"}
  }
  </script>

  <link rel="manifest" href="/site.webmanifest">
  <link rel="icon" type="image/svg+xml" href="/assets/favicon/favicon.svg">
  <title>PROJECT_TITLE</title>
</head>
```

## Pagination
<a name="pagination"></a>

Cursor-style pagination over a Bakery store (Step 06). PostgREST uses `range()` — offset + limit inline.

```ts
// In a store action:
async getPage(userId: string, page = 1, pageSize = 20) {
  if (!userId) { this.items = []; return; }

  const from = (page - 1) * pageSize;
  const to   = from + pageSize - 1;

  try {
    // Parallel: data + count
    const [rowsRes, countRes] = await Promise.all([
      supabase.from('lessons')
        .select('*')
        .eq('userId', userId).eq('isDelete', false)
        .order('createdAt', { ascending: false })
        .range(from, to),
      supabase.from('lessons')
        .select('id', { count: 'exact', head: true })
        .eq('userId', userId).eq('isDelete', false),
    ]);
    if (rowsRes.error) throw rowsRes.error;

    this.items     = (rowsRes.data || []).map(dbToApp);
    this.total     = countRes.count ?? 0;
    this.page      = page;
    this.pageSize  = pageSize;
    this.hasMore   = to + 1 < this.total;
  } catch (err) {
    console.error('[lessons] getPage failed:', err);
    this.items = [];
  }
}
```

## Fail-Closed Guard (view-level)
<a name="fail-closed-guard"></a>

Standard `onMounted` for any protected route. Referenced from Steps 09 and 11.

```ts
onMounted(async () => {
  loading.value = true;
  try {
    await authStore.fetchUser();
    if (!authStore.user?.id) {
      return router.replace('/login');     // unauthed → login
    }

    const result = await store.getDetail(
      route.params.id as string,
      authStore.user.id,
    );
    if (!result) {
      return router.replace('/courses');   // missing or unassigned → list
    }
    item.value = result;
  } catch (err) {
    console.error('[view] onMounted failed:', err);
    router.replace('/courses');
  } finally {
    loading.value = false;
  }
});
```

## Soft-Delete Filter (store action snippet)
<a name="soft-delete-filter"></a>

Every query against a `quizLaa.*` business table includes `.eq('isDelete', false)`. Step 06 enforces it per-store; include in any new action.

```ts
const { data, error } = await supabase
  .from('<table>')
  .select('*')
  .eq('userId', userId)
  .eq('isDelete', false);    // ← always
```

## Bakery Store Template
<a name="bakery-store"></a>

See Step 06 Code Vault §1 for the canonical template. Condensed reminder:

```ts
export const useXStore = defineStore('x', {
  state: () => ({ items: [] as X[], current: null as X | null }),
  actions: {
    async getList(userId?: string): Promise<X[]> {
      if (!userId) { this.items = []; return []; }
      try {
        const { data, error } = await supabase
          .from('x_table').select('*')
          .eq('userId', userId).eq('isDelete', false);
        if (error) throw error;
        this.items = (data || []).map(dbToX);
        return this.items;
      } catch (err) { console.error(err); this.items = []; return []; }
    },
    $reset() { this.items = []; this.current = null; },
  },
});
```

## Two-Query Join (avoid embedded selects on local Docker)
<a name="two-query-join"></a>

Local Docker Supabase's FK schema cache is flaky — `.select('*, parent(name)')` often returns PGRST200. Always two-query + Map lookup.

```ts
// 1. Children
const { data: children } = await supabase.from('questions')
  .select('id, lessonId, text').eq('isDelete', false);

// 2. Parents (deduped)
const parentIds = [...new Set(children!.map((c) => c.lessonId))];
const { data: parents } = await supabase.from('lessons')
  .select('id, title').in('id', parentIds).eq('isDelete', false);

// 3. Fold via Map
const parentMap = new Map(parents!.map((p) => [p.id, p.title]));
return children!.map((c) => ({ ...c, parentTitle: parentMap.get(c.lessonId) ?? '' }));
```

## Intersection Filter (assignment + non-empty)
<a name="intersection-filter"></a>

Showing lessons that are BOTH assigned to this user AND have ≥1 question. Referenced from Steps 06 and 11.

```ts
// A: lessonIds with ≥1 question
const { data: q } = await supabase.from('questions')
  .select('lessonId').eq('isDelete', false);
const hasQs = new Set((q || []).map((r) => r.lessonId));

// B: lessonIds assigned to this user
const { data: a } = await supabase.from('user_lessons')
  .select('lessonId').eq('userId', userId).eq('isDelete', false);
const assigned = new Set((a || []).map((r) => r.lessonId));

// Intersect
const allowedIds = [...assigned].filter((id) => hasQs.has(id));
```

## JWT Decode (extract a single claim)
<a name="jwt-decode"></a>

Used in Step 04 auth store for project-context switching.

```ts
function getJwtClaim(token: string, claim: string): string | undefined {
  try {
    const payload = JSON.parse(atob(token.split('.')[1] ?? ''));
    return payload[claim];
  } catch {
    return undefined;
  }
}
```

## Toast via useUiStore
<a name="toast"></a>

Feedback for all user-visible success/error moments. Referenced from Steps 04 / 09.

```ts
import { useUiStore } from '@/stores';
const ui = useUiStore();

ui.addToast('Saved',   'Your changes were saved.',   'success');
ui.addToast('Error',   'Something went wrong.',      'error');
ui.addToast('Info',    'New version available.',     'info');
```

## Resetting Pinia on Logout
<a name="reset-all-stores"></a>

Every store must implement `$reset()`. `resetAllStores()` iterates the active Pinia registry. Called from `authStore.logout()`.

```ts
import { getActivePinia } from 'pinia';

export function resetAllStores() {
  const pinia: any = getActivePinia();
  pinia?._s?.forEach((store: any) => store.$reset?.());
}
```

## Mobile Shell (max-w-[480px] + sticky header + bottom nav)
<a name="mobile-shell"></a>

See Step 08 Code Vault §1. Condensed:

```vue
<div class="relative flex min-h-screen w-full flex-col max-w-[480px] mx-auto bg-white dark:bg-background-dark">
  <header class="sticky top-0 z-50 ..."></header>
  <main   class="flex-1 overflow-y-auto pb-24"></main>
  <nav    class="fixed bottom-0 w-full max-w-[480px] ..."></nav>
</div>
```

---

## Multi-Schema Supabase Auth (trash / multi-project pattern)
<a name="multi-schema-auth"></a>

Used when the Supabase instance hosts multiple projects on separate schemas (e.g. `trash`, `wms`, `quizLaa`) with a shared `public` auth bridge.

**Three clients needed:**
- `supabase` — business schema (e.g. `trash`)
- `publicClient` — `public` schema for project/role binding
- `demoClient` (optional) — session-free for demo/mock reads

```ts
// src/config/supabase.ts
export const supabase = createClient(url, key, { db: { schema: env.SUPABASE_SCHEMA } });
export const publicClient = createClient(url, key, { db: { schema: 'public' } });
```

**4-step auth flow (driver app example):**
```ts
// 1. Supabase sign-in
const { data: authData } = await supabase.auth.signInWithPassword({ email, password });
const authId = authData.user.id;

// 2. Project binding check (public.user)
const { data: publicUser } = await publicClient
  .from('user')
  .select('project_id')
  .eq('auth_id', authId)
  .eq('is_delete', false)
  .single();
if (publicUser.project_id !== env.PROJECT_ID) throw new Error('项目访问权限不足');

// 3. Business profile (trash.users) — camelCase columns
const { data: trashUser } = await supabase
  .from('users')
  .select('id, email, name, role, phone, avatar')
  .eq('email', email)
  .eq('isDelete', false)
  .single();
if (trashUser.role !== 'driver') throw new Error('此帐号无司机权限');

// 4. Driver profile (trash.drivers) — only for driver role
const { data: driverProfile } = await supabase
  .from('drivers')
  .select('id, name, phone, vehicleNo')
  .eq('userId', trashUser.id)
  .eq('isDelete', false)
  .single();
```

**env.ts pattern (throw on missing required vars):**
```ts
function readEnv(key: string, required = true): string {
  const val = import.meta.env[`VITE_${key}`] as string | undefined;
  if (required && (!val || val.trim() === '')) throw new Error(`[env] Missing VITE_${key}`);
  return val ?? '';
}
function readBoolEnv(key: string, fallback = false): boolean {
  const val = readEnv(key, false).trim().toLowerCase();
  if (!val) return fallback;
  return val === '1' || val === 'true' || val === 'yes' || val === 'on';
}
```

**Common mistakes to avoid:**
1. `IS_MOCK: true` hardcoded — always read from `VITE_IS_MOCK` env var
2. Using `public` schema for business tables — look in DATABASE.md first
3. Forgetting `publicClient` for project binding — `public.user` table is the bridge
4. Skipping schema name in `.env` — the trash project uses `trash`, not `sblf` or `public`
5. camelCase vs snake_case — `trash` schema uses `isDelete`, `createdAt`; `public` uses `is_delete`

**Getting the project ID:**
```sql
SELECT id FROM public.project WHERE schema_name = 'trash';
```

**For driver app, primary task feed is `trash.driver_tasks`, not `trash.orders`.**  
Driver reads tasks by `driverId`; admin reads orders with order joins.

---

## trash Schema — Key Column Name Reference
<a name="trash-schema-columns"></a>

The `trash` schema uses **camelCase** column names throughout (TypeScript-friendly):

| Table | Key columns |
|---|---|
| `trash.users` | `id, email, name, role, phone, avatar, isDelete, createdAt, updatedAt` |
| `trash.drivers` | `id, userId, name, phone, vehicleNo, isDelete` |
| `trash.customers` | `id, name, phone, email, address, balance, notes, isDelete` |
| `trash.orders` | `id, orderNo, customerId, driverId, binSizeId, binId, deliveryAddress, deliveryDate, status, totalAmount, isDelete` |
| `trash.driver_tasks` | `id, taskNo, orderId, driverId, type, scheduledDate, status, startPhotos, completePhotos, startedAt, completedAt, isDelete` |
| `trash.bin_sizes` | `id, name, description, defaultPrice, status` |
| `trash.bins` | `id, binCode, binSizeId, status, currentOrderId, notes, isDelete` |

**Order statuses**: `pending → assigned → delivering → delivered → pickingUp → completed | cancelled`  
**Task statuses**: `pending → inProgress → completed | cancelled`  
**Task types**: `delivery | pickup`  
**User roles**: `super_admin | driver` (NOT `admin` — it's `super_admin`)

---

## Vben Admin Recurring Patterns (battle-tested 2026-06-02, angel-interior)

High-frequency Vben + Ant Design + VXE patterns. Reach for these instead of re-deriving.

### ⚠️ Nested drawer conflict — use plain AntD Drawer, NOT useVbenDrawer
<a name="nested-drawer"></a>

**Symptom:** A drawer opened from *inside* another drawer (e.g. a file-picker launched from an Edit drawer) corrupts Vben's global drawer registry — after closing the inner one, the next "Edit" click re-opens the INNER drawer instead of the edit form.

**Cause:** `useVbenDrawer()` tracks the last-active drawer in a shared registry. Nesting two confuses it.

**Fix:** For any drawer that opens from inside another Vben drawer, use Ant Design's native `<Drawer v-model:open>` controlled by a plain `ref(false)`. It has no global registry, so it never interferes.

```vue
<script setup>
import { Drawer } from 'ant-design-vue';
const open = ref(false);
defineExpose({ open: () => { open.value = true; } });
</script>
<template>
  <Drawer v-model:open="open" title="..." placement="right" :width="540" :footer="null">
    <!-- content -->
  </Drawer>
</template>
```
Parent calls `childRef.value?.open()`. Vben's Create/Edit drawers stay untouched.

### VXE cell — thumbnail with hover-preview + click-lightbox
<a name="cell-image-hover"></a>

Register once in `adapter/vxe-table.ts`. Hover → Tooltip popup (lazy-loaded), click → AntD lightbox (backdrop closes). Use for image columns in list tables.

```ts
vxeUI.renderer.add('CellImageHoverPreview', {
  renderTableDefault(_o, params) {
    const { column, row } = params;
    const raw = row[column.field];
    if (!raw) return h('div', { style: { width: '44px', height: '44px', background: '#2a2a2a', display: 'flex', alignItems: 'center', justifyContent: 'center', color: '#555', fontSize: '10px' } }, '—');
    const src = getStorageUrl(raw);
    const hover = h('div', { style: { lineHeight: 0 } }, [
      h('img', { src, loading: 'lazy', decoding: 'async', style: { width: '220px', height: '220px', objectFit: 'cover', display: 'block' } }),
    ]);
    const thumb = h(Image, { src, width: 44, height: 44, loading: 'lazy', style: { objectFit: 'cover', cursor: 'zoom-in', display: 'block' }, preview: true });
    return h(Tooltip, { placement: 'rightTop', color: '#1a1a1a', mouseEnterDelay: 0.15, destroyTooltipOnHide: true }, { title: () => hover, default: () => thumb });
  },
});
// Column: { field: 'image_path', title: '', width: 60, align: 'center', cellRender: { name: 'CellImageHoverPreview' } }
```
Lazy-load on BOTH thumbnail and hover image (sovereign image rule).

**Gray placeholder for empty + broken images** — never show the browser's broken-image glyph. Inline SVG data URI (no network), used 3 ways:
```ts
const _phSvg = "<svg xmlns='http://www.w3.org/2000/svg' width='44' height='44' viewBox='0 0 44 44'><rect width='44' height='44' fill='#2a2a2a'/><g fill='none' stroke='#666' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'><rect x='12' y='12' width='20' height='20' rx='2'/><circle cx='18.5' cy='18.5' r='2'/><path d='m32 26-5-5-11 11'/></g></svg>";
const PLACEHOLDER_IMG = `data:image/svg+xml,${encodeURIComponent(_phSvg)}`;
// 1. empty cell → render <img src={PLACEHOLDER_IMG}>
// 2. broken thumbnail → AntD Image `fallback: PLACEHOLDER_IMG`
// 3. broken hover img → onError: (e) => { e.target.src = PLACEHOLDER_IMG; }
```

### Friendly unique-constraint error (Postgres 23505)
<a name="unique-error"></a>

Catch the DB unique violation in the store and rethrow a human message; the drawer composable shows `error.message` when it's short/user-facing.

```ts
// store create/update
if (error) {
  if (error.code === '23505') throw new Error('This title is already used. Please choose a different one.');
  throw error;
}
// useEditDrawer / useCreateDrawer catch block
const msg = error?.message && typeof error.message === 'string' && error.message.length < 200
  ? error.message : $t('page.common.updateFailed');
message.error(msg);
```
Pair with a pre-submit `checkTitleExists()` for the common case; the 23505 catch handles edge cases (different titles → same generated slug).

### Textarea char counter (maxlength + live "13/160")
<a name="char-counter"></a>

AntD Textarea renders the gray bottom-right counter automatically. In a Vben form schema:
```ts
{ component: 'Textarea', fieldName: 'excerpt',
  componentProps: { rows: 3, maxlength: 160, showCount: true, placeholder: '...' } }
```

### Copy-to-clipboard button
<a name="copy-url"></a>
```ts
const handleCopyUrl = async (item) => {
  const url = getStorageUrl(item.storagePath);
  try { await navigator.clipboard.writeText(url); message.success('URL copied!'); }
  catch { message.error('Copy failed — copy manually: ' + url); }
};
```

### Image crop modal — display ≠ output size
<a name="crop-scale"></a>

Show the crop panel BIGGER than the saved size for easier framing. Output stays at spec because `cropper.getResult().coordinates` are always in NATURAL image pixels — display scale never affects the file.
```ts
const DISPLAY_SCALE = 2; // panel shown 2x spec; output still spec-size
const scale = Math.min(DISPLAY_SCALE, maxW / spec.width, maxH / spec.height);
// freeHeight (portrait): width fills viewport (floor = 2x spec) so horizontal sources show wider
```
Hint label shows width only when height is dynamic: `Required: 400px width, JPG only`.
