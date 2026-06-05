---
name: wrider-complete-recipe
description: "Full rebuild manifest for the wRider ecosystem (admin + rider Vue 3 apps). Read this AND wrider_design_senses.md to recreate the app at ≥ 90% fidelity in a future project."
triggers: ["wrider", "wrider rebuild", "wrider recipe", "delivery app", "rider app boilerplate", "fleet app boilerplate"]
phase: 0-orchestrator
version: 1.0.0
status: authoritative
date_authored: "2026-05-05"
project: "c:/Users/user/Desktop/wRider"
companions:
  - "./wrider_design_senses.md"
  - "./wrider_chat_mining.md"
  - "../../../Desktop/wRider/BLUEPRINT.md"
  - "../../../Desktop/wRider/api/schema.sql"
---

# 🏗️ wRider — Complete Rebuild Recipe (V1)

> Read this **once**, end to end, before generating any UI for a similar
> dispatch / delivery / rider-management app. Combined with
> [`wrider_design_senses.md`](./wrider_design_senses.md) (the *why*) and
> [`BLUEPRINT.md`](../../../Desktop/wRider/BLUEPRINT.md) (the *what*),
> this document is the *how*.

---

## 0 · TECH STACK (locked)

```
Vue 3.5 · TypeScript 5.8 · Vite 6 · Pinia 3 · vue-router 4
Tailwind CSS v4 (@theme + @layer)
DM Sans (Google Fonts, opsz axis 9..40, wght 400-900)
lucide-vue-next 0.473  → all icons except inline SVG decorations
gsap 3.15              → page-entry choreography only (not state-driven UI)
leaflet 1.9            → maps (Google tile URL, no API key)
swiper 12 · @capacitor/core 8 (mobile shell ready)
```

### Repo layout

```
{root}/
├── BLUEPRINT.md                          # architectural manifest (this project)
├── api/                                  # backend-ready data layer
│   ├── README.md
│   ├── schema.sql                        # canonical DDL
│   ├── webApp-wRider-admin/php/{...}.php # admin seeds (PHP 8+, return arrays)
│   └── webApp-wRider-app/php/{...}.php   # rider seeds (mirror; same content default)
├── webApp-wRider-admin/                  # Vue 3 admin app (5-tab footer)
│   └── src/
│       ├── App.vue · main.ts · style.css · vite-env.d.ts
│       ├── router/index.ts
│       ├── stores/{adminStore,toastStore}.ts
│       ├── composables/useRouting.ts
│       ├── components/{19 files}
│       └── views/{12 files}
└── webApp-wRider-app/                    # Vue 3 rider app (4 or 5-tab footer)
    └── src/{same structure, 14 views}
```

**Two physically isolated apps**, identical design system, structurally
separate stores so each side can independently swap to its own backend.

---

## 1 · DESIGN TOKENS

### 1.1 Tailwind v4 `@theme` block (paste into both `src/style.css`)

```css
@import "tailwindcss";
@import url('https://fonts.googleapis.com/css2?family=DM+Sans:opsz,wght@9..40,400;9..40,500;9..40,600;9..40,700;9..40,800;9..40,900&display=swap');

@theme {
  --font-sans: "DM Sans", "SF Pro Display", "Inter", "Segoe UI", system-ui, -apple-system, sans-serif;

  /* Surfaces */
  --color-paper:        #fbfbfb;
  --color-app-bg:       #eaf1ef;
  --color-line:         #edf0ef;

  /* Text */
  --color-ink:          #060b0c;
  --color-muted:        #7a8381;
  --color-ink-muted:    #515a58;

  /* Brand accents */
  --color-violet:       #8c3df4;   /* PRIMARY — CTAs, active nav, highlights */
  --color-violet-dark:  #17113d;   /* Hero gradient mid-stop */
  --color-violet-soft:  #f1e9ff;   /* Tinted bg, soft pills */
  --color-teal:         #098178;   /* Success / income */
  --color-teal-dark:    #032d2a;
  --color-teal-soft:    #eef9f7;
  --color-mint:         #c8dbd5;
  --color-mint-soft:    #eef6f3;
  --color-forest:       #295049;
  --color-orange:       #cb450b;
  --color-gold:         #e8af24;
  --color-pink:         #ff4d6a;

  /* Semantic */
  --color-danger:       #ff1d25;   /* Late, error */
  --color-income:       #00a66a;   /* Money in */

  /* Geometry */
  --radius-card:        18px;
  --radius-pill:        999px;
  --shadow-card:        0 14px 36px rgba(6, 11, 12, .12);
  --shadow-soft:        0 6px 18px rgba(6, 11, 12, .06);
  --shadow-cta:         0 10px 18px rgba(140, 61, 244, .24);
}
```

### 1.2 Body-level smoothing (mandatory)

```css
@layer base {
  html, body {
    -webkit-font-smoothing: antialiased;
    -moz-osx-font-smoothing: grayscale;
    text-rendering: optimizeLegibility;
    /* admin only — DM Sans alt set: */
    font-feature-settings: 'ss01' on, 'cv11' on;
  }
}
```

### 1.3 Hero gradient (locked — used 4 places)

```css
background:
  radial-gradient(circle at 86% 22%, rgba(140, 61, 244, .72), transparent 150px),
  radial-gradient(circle at 8% 10%,  rgba(9, 129, 120, .42), transparent 210px),
  linear-gradient(135deg, #07061f 0%, #17113d 52%, #2f176e 100%);
```

Used by: `.hero` (homepages), `.wr-header` (sub-pages), `WRCard tone="dark"`,
`WRBalanceCard` premium variant.

### 1.4 Typography hierarchy (refined)

| Element | Class | Weight | Size |
|---|---|---|---|
| Header h1 (`<WRHeader>` title) | `text-xl font-bold text-white` | 700 | 20 px |
| Hero amount / large numerics | `text-3xl font-bold` | 700 | 30 px |
| Card primary title | `text-sm font-bold text-ink` | 700 | 14 px |
| Section title (`.wr-section-title h2`) | inline 17px / 800 | 800 | 17 px |
| KPI cell value (boxed) | `text-base font-black text-ink` | 900 | 16 px (only inside boxes) |
| Eyebrow / label | `text-[10px]` or `[11px] font-bold uppercase tracking-widest` | 700 | 10–11 px |
| Body | 14 px / 500 | 500 | 14 px |

**Rule:** never `font-black` on flowing body text.

### 1.5 Status color table (apply everywhere — markers, badges, progress bars, route lines, pills)

| Status | Hex | Meaning | Anim |
|---|---|---|---|
| late | `#ff1d25` | past ETA | pulse |
| on-track | `#38bdf8` | within ETA | static |
| tight | `#e8af24` | ≤3min slack | static |
| proof | `#8c3df4` | photo gate | pulse |
| idle | `#06a65a` / `#098178` | available | static |
| offline | `#94a3b8` | off-duty | static |

### 1.6 Animation keyframes

```css
@keyframes wr-glow-pulse {
  0%   { box-shadow: 0 10px 20px rgba(140,61,244,.25), 0 0 0 4px rgb(240 210 255 / 70%); filter: brightness(1); }
  100% { box-shadow: 0 14px 36px rgba(140,61,244,.45), 0 0 0 7px rgb(240 210 255 / 30%); filter: brightness(1.15); }
}
@keyframes wr-pulse-late {
  0%   { transform: scale(1);    box-shadow: 0 0 0 0 rgba(255,29,37,.55); }
  70%  { transform: scale(1.18); box-shadow: 0 0 0 10px rgba(255,29,37,0); }
  100% { transform: scale(1);    box-shadow: 0 0 0 0 rgba(255,29,37,0); }
}
@keyframes wr-pulse-rider { /* same shape, gold colour, used for rider's own GPS pin */ }
@keyframes wr-spin { to { transform: rotate(360deg); } }
```

---

## 2 · LAYOUT SHELLS

### 2.1 `.wr-shell` wraps the router-view + global FlushFooter

```vue
<!-- App.vue -->
<template>
  <div class="wr-shell">
    <router-view v-slot="{ Component }">
      <transition name="fade" mode="out-in">
        <component :is="Component" />
      </transition>
    </router-view>
    <FlushFooter v-if="!route.meta?.hideFooter" />
  </div>
</template>
```

### 2.2 Two layout patterns

**Home pattern** (used by `DashboardView`, `HomeView` — top-level entry):

```vue
<main class="phone">
  <div class="status" aria-hidden="true"></div>
  <section class="hero">
    <div class="top-row">
      <div class="profile">
        <div class="avatar">A</div>
        <div><strong>{{ name }}</strong><span>{{ tagline }}</span></div>
      </div>
      <button class="bell"><svg>…</svg></button>
    </div>
  </section>
  <section class="content">
    <article class="balance-card">…</article>
    <article class="insight">…</article>
    <div class="section-title"><h2>…</h2><button>…</button></div>
    <div class="transactions">…</div>
    <article class="budget-card">…</article>
  </section>
</main>
```

**Sub-page pattern** (every other view):

```vue
<main class="flex flex-col">
  <WRHeader title="..." :subtitle="..." back />   <!-- back if children -->
  <div class="wr-content px-4 pt-4 space-y-3">
    <!-- 3 cards max, hairline dividers inside cards instead of new cards -->
  </div>
</main>
```

### 2.3 Critical CSS structure

```css
.wr-shell, .phone {
  width: 100%;
  max-width: 100vw;
  min-height: 100vh;
  position: relative;
  overflow-x: hidden;
}

.hero {                   /* home-page hero */
  position: fixed;        /* (was sticky/relative — fixed feels best on body scroll) */
  top: 0; left: 0; right: 0;
  padding: 48px 18px 74px;
  /* gradient from §1.3 */
}
.hero::after {            /* curved paper skirt */
  content: ""; position: absolute;
  inset: auto -44px -76px -44px;
  height: 128px;
  background: var(--color-paper);
  border-radius: 50% 50% 0 0 / 42% 42% 0 0;
}

.content {                /* home-page content */
  position: relative;
  margin-top: 90px;       /* clears the fixed hero */
  padding: 16px 14px 104px;
  z-index: 10;
  isolation: isolate;     /* paints above hero */
}

.wr-header {              /* sub-page fixed 70px band */
  position: fixed;
  top: 0; left: 0; right: 0;
  width: 100%; height: 70px;
  /* same hero gradient */
  z-index: 50;
}

.wr-content {             /* sub-page scrollable body */
  width: 100%;
  max-width: 100vw;
  margin-top: 70px;       /* clears the fixed header */
  padding-bottom: 96px;   /* clears the FlushFooter on tab pages */
}
```

### 2.4 Mobile viewport (in both `index.html`)

```html
<meta name="viewport" content="width=412, viewport-fit=cover" />
```

**Notice**: do **not** lock `initial-scale=1.0, maximum-scale=1.0, user-scalable=no` —
those force a 412 px layout to clip on narrower phones. Without the lock,
the browser auto-shrinks below 412 px while still designing at 412.

### 2.5 Overflow safety net (cross-cutting)

```css
html, body, #app, .wr-shell, .phone {
  max-width: 100vw;
  overflow-x: hidden;
}
.wr-actions, .actions {
  grid-template-columns: repeat(4, minmax(0, 1fr));   /* allow column shrink */
}
.wr-action, .action { min-width: 0; }
```

---

## 3 · COMPONENT LIBRARY (`src/components/`)

> All components prefixed `WR*`. Same set in both apps; rider-only adds `SwipeButton`, `WRProofModal`. Admin-only adds `WRQuickAssignDrawer`. Identical naming + props in both.

### 3.1 Atoms

| File | Props (verbatim) | What it renders |
|---|---|---|
| **WRStatusBar.vue** | `{ time?: string }` (default `"9:41"`) | 28 px decorative status row with optional time + signal SVGs |
| **WREyebrow.vue** | (slot) | `<span class="wr-eyebrow">` — uppercase 10 px muted label, 0.06em tracking, 700 |
| **WRBadge.vue** | `{ variant: 'pending'\|'pickup'\|'transit'\|'dropoff'\|'done'\|'danger'\|'info' }` | 22 px pill badge with semantic bg + text colour |
| **WRButton.vue** | `{ variant?: 'primary'\|'secondary'\|'danger'\|'ghost'; size?: 'sm'\|'md'\|'lg'; loading?: false; disabled?: false; type?: 'button'\|'submit'; block?: true }` | Width-100% button with spinner state and `active:scale-[0.98]`. **Slot wraps in `inline-flex` so icon + text never wrap.** |
| **WREmpty.vue** | `{ title?: string; hint?: string; icon?: any }` | Centred grid: 16 px violet-soft icon chip + bold title + grey hint, 32 px padding |
| **AppImage.vue** | `{ src: string; alt?: string; customClass?: string; asBg?: boolean }` | Lazy `<img>` with `loading="lazy" decoding="async"` + grey "NO IMAGE" fallback box on error. **No raw `<img>` allowed in `src/views/` — always wrap.** |

### 3.2 Composites

| File | Props | Renders |
|---|---|---|
| **WRHeader.vue** | `{ title: string; subtitle?: string; back?: boolean }` + `actions` slot | Fixed 70 px dark hero band, `text-xl font-bold` title, translucent eyebrow subtitle, conditional back button (`bg-white/15 text-white border-white/15`), actions slot on right |
| **WRCard.vue** | `{ padded?: true; flush?: false; tone?: 'paper'\|'mint'\|'violet'\|'dark'; variant?: 'flat'\|'floating'; clickable?: false }` + `@click` | White rounded card; `floating` adds bigger shadow, `clickable` adds cursor + active scale |
| **WRBalanceCard.vue** | `{ eyebrow: string; value: string; unit?: string }` + slot | Hero card: eyebrow + 30 px bold amount + eye icon + 4-action grid slot |
| **WRStatCard.vue** | `{ label: string; value: string; delta?: string; tone?: 'violet'\|'teal'\|'gold'\|'mint' }` | Compact stat tile: eyebrow + 18 px 800 value + optional delta |
| **WRActionChip.vue** | `{ icon: Component; label: string; tone?: 'violet'\|'teal'\|'gold'\|'orange' }` + `@click` | 42 px circular gradient icon + label below, `active:scale-95` |
| **WRSectionTitle.vue** | `{ title: string; actionLabel?: string }` + `@action` | Row: 17 px 800 h2 left, optional violet "View more" button right |
| **WRTransactionRow.vue** | `{ icon?: Component; iconText?: string; iconTone?: ...; title: string; subtitle: string; amount: string; meta?: string; income?: boolean }` | 3-col grid: prism-conic icon, title+subtitle (ellipsis), right amount with income tone |
| **WRBudgetCard.vue** | `{ eyebrow: string; title: string; badge: string; progress: number (0..1) }` | Mint-soft card: eyebrow, title, mint badge pill, 6 px progress (teal→violet gradient) |
| **WRInsightCard.vue** | `{ text: string }` + `@click` | Lavender pill panel: conic-gradient coin icon + text + chevron right |

### 3.3 Specials (cross-cutting overlays)

| File | Where | What |
|---|---|---|
| **FlushFooter.vue** | always rendered globally by App.vue (gated by `!hideFooter`) | Fixed bottom-nav with floating glow orb under active tab. **5 tabs admin / 4 tabs rider.** Lucide icons + animated `left:` clamped `clamp(37px, …, calc(100% - 37px))`. |
| **WRImageLightbox.vue** | `<v-model="open">`, used in `JobDetailView.vue` | Fullscreen lightbox: dark backdrop, prev/next chevrons, keyboard `← → Esc`, thumbnail strip, download button. Locks body scroll. |
| **WRQuickAssignDrawer.vue** *(admin only)* | Dashboard "Assign" chip + Smart-match insight + DriverDetail "Assign Job" | Slide-up drawer: rider picker (idle only) + job picker (with "+ Create new job" first row that routes to `/jobs/new?driver={id}`) + haversine preview + Confirm. Emits `assigned`. |
| **WRProofModal.vue** *(rider only)* | TaskDetail proof-gate triggers | Camera viewfinder modal with file input (FileReader → data-URL), retake → submit flow. |
| **SwipeButton.vue** *(rider only)* | TaskDetail bottom CTA when status is mid-flow | 56 px violet pill with pointer-driven knob. Emits `complete` at ~95 % drag, snaps back if released. |
| **WRToast.vue** | always mounted in App.vue | Reads `toastStore.toasts`, fixed bottom toast with type-specific colour, auto-dismiss after 3 s. |

### 3.4 Custom-picker contract (replaces native `<select>`)

**Used in**: `WRQuickAssignDrawer.vue` (rider + job pickers), `JobDetailView.vue` (driver picker for unassigned jobs).

```vue
<!-- Trigger button (60 px tall, violet ring on focus/open) -->
<button :class="['wr-picker-trigger', open ? 'is-open' : '']" @click="toggle">
  <span class="wr-picker-icon"><Lucide :size="14" /></span>
  <span class="wr-picker-value">
    <strong>{{ selected?.name ?? 'Choose…' }}</strong>
    <small>{{ selected?.subtitle ?? `${count} available` }}</small>
  </span>
  <ChevronDown :class="['wr-picker-chev', open ? 'is-flipped' : '']" />
</button>

<!-- Animated panel (rounded list, max-height 240, internal scroll) -->
<Transition name="picker">
  <ul v-if="open" class="wr-picker-list">
    <li v-for="opt in options" :class="['wr-picker-option', opt.id === selectedId ? 'is-active' : '']" @click="select(opt.id)">
      <span class="wr-picker-avatar">{{ opt.initial }}</span>
      <span class="wr-picker-meta"><strong>{{ opt.title }}</strong><small>{{ opt.subtitle }}</small></span>
      <Check v-if="opt.id === selectedId" class="wr-picker-tick" />
    </li>
  </ul>
</Transition>
```

CSS scoped under `wr-picker-*` — full block in
[`WRQuickAssignDrawer.vue`](file:///c:/Users/user/Desktop/wRider/webApp-wRider-admin/src/components/WRQuickAssignDrawer.vue).

---

## 4 · ROUTE & PAGE ARCHITECTURE

### 4.1 Three buckets per app

| Bucket | hideFooter | Header pattern | Examples |
|---|---|---|---|
| **Login** | `true` | full-bleed, no header | `/login` |
| **Footer tab** | `false` (default) | `<main class="phone">` w/ hero (homes) OR `<WRHeader>` (other tabs) | `/`, `/jobs`, `/map`, `/wallet`, `/profile`, `/payroll`, `/settings`, `/dashboard` |
| **Children** | `true` | `<WRHeader … back />` | `/jobs/:id`, `/jobs/new`, `/drivers`, `/drivers/:id`, `/task/:id`, `/proof/:id/:kind`, `/withdraw`, `/notifications`, `/profile/edit`, `/bank-details`, `/terms` |

### 4.2 Admin router (5 footer tabs + 5 children)

```ts
const routes: RouteRecordRaw[] = [
  { path: '/login',         component: () => import('@/views/LoginView.vue'),     meta: { hideFooter: true } },

  // Footer tabs
  { path: '/',              component: () => import('@/views/DashboardView.vue') },
  { path: '/map',           component: () => import('@/views/MapView.vue') },
  { path: '/jobs',          component: () => import('@/views/JobsView.vue') },
  { path: '/payroll',       component: () => import('@/views/PayrollView.vue') },
  { path: '/settings',      component: () => import('@/views/SettingsView.vue') },

  // Children
  { path: '/drivers',       component: () => import('@/views/DriversView.vue'),       meta: { hideFooter: true } },
  { path: '/drivers/:id',   component: () => import('@/views/DriverDetailView.vue'), props: true, meta: { hideFooter: true } },
  { path: '/jobs/new',      component: () => import('@/views/JobFormView.vue'),      meta: { hideFooter: true } },
  { path: '/jobs/:id',      component: () => import('@/views/JobDetailView.vue'),    props: true, meta: { hideFooter: true } },
  { path: '/notifications', component: () => import('@/views/NotificationsView.vue'), meta: { hideFooter: true } },

  { path: '/:pathMatch(.*)*', redirect: '/' }
]
```

### 4.3 Rider router (4 footer tabs + 7 children — `/vault` ABSENT in router)

```ts
const routes: RouteRecordRaw[] = [
  { path: '/login',     component: () => import('@/views/LoginView.vue'),       meta: { hideFooter: true } },

  // Footer tabs
  { path: '/',          component: () => import('@/views/HomeView.vue') },
  { path: '/wallet',    component: () => import('@/views/WalletView.vue') },
  { path: '/map',       component: () => import('@/views/MapView.vue') },
  { path: '/profile',   component: () => import('@/views/ProfileView.vue') },

  // Children
  { path: '/task/:id',         component: () => import('@/views/TaskDetailView.vue'), props: true, meta: { hideFooter: true } },
  { path: '/proof/:id/:kind',  component: () => import('@/views/ProofView.vue'),      props: true, meta: { hideFooter: true } },
  { path: '/withdraw',         component: () => import('@/views/WithdrawView.vue'),     meta: { hideFooter: true } },
  { path: '/notifications',    component: () => import('@/views/NotificationsView.vue'),meta: { hideFooter: true } },
  { path: '/profile/edit',     component: () => import('@/views/ProfileEditView.vue'),  meta: { hideFooter: true } },
  { path: '/bank-details',     component: () => import('@/views/BankDetailsView.vue'),  meta: { hideFooter: true } },
  { path: '/terms',            component: () => import('@/views/TermsView.vue'),        meta: { hideFooter: true } },

  { path: '/:pathMatch(.*)*', redirect: '/' }
]
```

### 4.4 Page templates (one row per known view)

| App | View | Layout shell | Anchors data |
|---|---|---|---|
| Admin | LoginView | Full-bleed form | mock auth |
| Admin | DashboardView | `<main class="phone">` + hero + "Today operation" balance + smart-match insight + Rider Table + Active Job Timing list + WRQuickAssignDrawer mounted | `adminStore.drivers / activeJobs / settings` |
| Admin | DriversView | sub-page with search + status filter pills + driver list | `adminStore.drivers` |
| Admin | DriverDetailView | sub-page: identity card + verdict-pilled active mission + **SVG donut income chart** + recent completions + WRQuickAssignDrawer | `adminStore.findDriver / completedJobs` |
| Admin | JobsView | sub-page with tab nav (Pending / Active / Completed) + clickable WRCard rows | `adminStore.{pending,active,completed}Jobs` |
| Admin | JobFormView | sub-page form, Assign Driver promoted to top, then Job Info → Route → Schedule → ETA estimator | `adminStore.idleDrivers + settings.kmPerMin` |
| Admin | JobDetailView | sub-page **3 merged cards**: Overview (verdict + KPI strip) · Mission Brief (5-step timeline + proof galleries → WRImageLightbox) · Driver + Time Tracking; Mark Completed CTA (hidden when `pending`) | `adminStore.findJob` |
| Admin | MapView | full-screen Leaflet + glass header + verdict-stats stack + filter toggle + recenter + active-jobs scroller; auto-routes per active driver via OSRM | `adminStore.drivers + activeJobs + settings.hqLat/Lng` |
| Admin | PayrollView | sub-page with **two tabs** (Outstanding / Settled) + hero summary swapping per tab + driver rows + Settle modal | `adminStore.drivers + settlements + settledIdsToday` |
| Admin | SettingsView | sub-page **3-stat-card hero** (Total riders / Done today / Total jobs) + Dispatch Rules + Pricing & Payout + Organisation + HQ Origin + Compliance + Sign Out | `adminStore.settings + driver/job counts` |
| Admin | NotificationsView | sub-page list of late + proof-pending + settled events | computed from jobs + settlements |
| Admin | LogisticsView (orphan, not in router) | sub-page mock map + KPI strip — kept for reference | `adminStore.drivers` |
| Rider | LoginView | Full-bleed form | mock auth |
| Rider | HomeView | `<main class="phone">` + hero + Today earning balance + "Active Job / Navigate / Proof / Wallet" 4-action grid + ShieldCheck status insight + Active Job card with KPIs + audit footer | `driverStore.activeJob + driverStats` |
| Rider | WalletView | sub-page wallet hero + KPI 3-strip + transactions list | `driverStore.driverStats + completedJobs + withdrawals` |
| Rider | WithdrawView | sub-page form: dark balance hero + bank-account card → `/bank-details` + amount input + submit | `driverStore.driverStats.walletBalance + bankDetails` |
| Rider | BankDetailsView | sub-page form: bank name dropdown + account number + account holder | `driverStore.bankDetails` + `updateBankDetails()` |
| Rider | ProfileView | sub-page identity card + 3 prism stat cards + daily-target progress + account list (Contact / Bank) + Sign Out | `driverStore.driverStats` |
| Rider | ProfileEditView | sub-page form: 80 px avatar w/ edit badge + name + fleet + disabled Rider ID | `driverStore.driverStats` + `updateProfile()` |
| Rider | TermsView | static info: 4 numbered sections w/ icons + last-updated metadata + © footer | hard-coded markup |
| Rider | NotificationsView | sub-page list of mission alerts + settled toasts | computed from completedJobs |
| Rider | TaskDetailView | sub-page status hero + KPIs + 5-step Mission Brief timeline + SwipeButton CTA + audit footer | `driverStore.activeJob` + state-machine `advanceJobStatus(photoUrl?)` |
| Rider | ProofView | full-screen viewfinder + capture/retake/submit | route props + `driverStore.advanceJobStatus(url)` |
| Rider | MapView | full-screen Leaflet + 3-pin route (pickup → driver → drop) + 2-leg polyline (active 90 % / pending 35 % opacity, OSRM bike profile) + GPS opt-in (`watchPosition`) + recenter | `driverStore.activeJob + useRouting + Geolocation` |
| Rider | JobsView | sub-page tabs (Today / Completed) + clickable WRCard rows | `driverStore.completedJobs + activeJob` |
| Rider | VaultView (orphan, not in router) | sub-page hero + transactions — kept for reference | `driverStore.driverStats + completedJobs` |

---

## 5 · DATA LAYER

### 5.1 Folder

```
api/
├── README.md
├── schema.sql                              # canonical DDL — both apps apply
├── webApp-wRider-admin/php/
│   ├── index.php                           # require → unified dataset
│   ├── profiles.php · jobs.php · proofs.php
│   ├── settlements.php · transactions.php · settings.php
└── webApp-wRider-app/php/{same files}      # identical default content
```

Each `*.php` returns a plain PHP `return [...]` array. Loadable with `require __DIR__ . '/index.php'`.

### 5.2 Tables (camelCase + soft-delete + UTC timestamps)

| Table | Purpose | Soft-delete |
|---|---|---|
| `profiles` | admins + drivers (role-discriminated). Wallet + KPIs denormalised | yes |
| `jobs` | delivery missions. Status state machine | yes |
| `proofs` | 1:N pickup/dropoff photos per job, kind enum, optional admin approval | yes |
| `settlements` | admin-driver wallet payouts | yes |
| `transactions` | wallet ledger (earning / withdraw / settle) | yes |
| `settings` | singleton `id=1`, all admin knobs | n/a |
| `notifications` | optional, future-ready | yes |

**Key constraints:**
- Every FK indexed.
- `WHERE isDelete = FALSE` always present in reads.
- `jobs.status` ∈ `pending | pickup | transit | dropoff | completed | cancelled`.
- `profiles.status` ∈ `idle | busy | offline | NULL` (NULL = admin row).

### 5.3 Pinia stores mirror the schema

```ts
// webApp-wRider-admin/src/stores/adminStore.ts
export interface Driver { id, name, status, walletBalance, earningsToday,
                         missionsToday, lat, lng, location, trustIndex, activeJobId? }
export interface Job    { id, title, description, pickup, destination,
                         pickupLat, pickupLng, dropLat, dropLng,
                         scheduledAt, reward, distanceKm, estimatedMin,
                         status, driverId?, startedAt?, completedAt? }
export interface SettlementRecord { id, driverId, amount, at }

state:    drivers, jobs, settings, settlements
getters:  idleDrivers, busyDrivers, offlineDrivers,
          pendingJobs, activeJobs, completedJobs,
          todayEarnings, driverPayout,
          settledIdsToday, totalSettledToday
actions:  findDriver, findJob, jobOfDriver,
          createJob, assignDriver, assignJob,
          completeJob, settleDriver
```

```ts
// webApp-wRider-app/src/stores/driverStore.ts
state:    activeJob, driverStats, completedJobs, withdrawals, bankDetails
getters:  driver, isWorking
actions:  advanceJobStatus(photoUrl?),  // state machine
          withdraw(amount), updateProfile(p), updateBankDetails(b)
```

### 5.4 Field mapping (Pinia ↔ SQL)

| Pinia field | Schema column |
|---|---|
| `Driver.id` | `profiles.id` |
| `Driver.lat / lng` | `profiles.currentLat / currentLng` |
| `Driver.location` | `profiles.locationLabel` |
| `Driver.activeJobId` | `profiles.activeJobId` |
| `Job.pickup` | `jobs.pickupAddress` |
| `Job.destination` | `jobs.destinationAddress` |
| `Job.reward` | `jobs.rewardAmount` |
| `SettlementRecord.at` | `settlements.settledAt` |
| `Settings.kmPerMin` | `settings.kmPerMin` |
| `Settings.payoutPerJob` | `settings.payoutPerJob` |

### 5.5 Audit verdict (computed at read-time, NOT stored)

```ts
function jobVerdict(job: Job, kmPerMin: number): Verdict {
  if (job.status === 'pending') return 'pending'
  if (job.status === 'completed') {
    const taken = (new Date(job.completedAt!).getTime()
                 - new Date(job.startedAt!).getTime()) / 60000
    return taken <= job.estimatedMin ? 'success' : 'completed-late'
  }
  const elapsed = (Date.now() - new Date(job.startedAt!).getTime()) / 60000
  const remaining = job.estimatedMin - elapsed
  if (remaining < 0)  return 'late'
  if (remaining <= 3) return 'tight'
  return 'on-track'
}
```

---

## 6 · DOMAIN RULES

### 6.1 Job state machine

```
pending → pickup (📷 GATE) → transit → dropoff (📷 GATE) → completed
                                                            ↘ wallet += payoutPerJob
```

Photo gates fire `WRProofModal` (rider) → `advanceJobStatus(url)` → next state.
Settings flags `requirePickupPhoto` / `requireDropoffPhoto` can disable the gate
(default both `true`).

### 6.2 Audit rule

`distanceKm × kmPerMin ≈ estimatedMin` (default `1km ≈ 1min`).
Re-tunable in `SettingsView` → `adminStore.settings.kmPerMin`. All verdicts
recompute automatically because they're computed at read time.

### 6.3 Settlement flow

```
Admin → Payroll → Settle (driver) → modal → confirm
  → adminStore.settleDriver(driverId, amount):
      driver.walletBalance -= amount
      settlements.unshift({ id: STL-{ts}, driverId, amount, at: now })
  → driver moves from "Outstanding" tab → "Settled" tab (computed via settledIdsToday Set)
```

### 6.4 Smart-match (admin Dashboard insight)

```ts
const smartMatch = computed(() => {
  const driver = idleDrivers.value[0]
  const job    = pendingJobs.value[0] ?? activeJobs.value[0]
  if (!driver || !job) return null
  const km   = haversine(driver.lat, driver.lng, job.dropLat, job.dropLng)
  const min  = Math.max(5, Math.round(km / settings.kmPerMin))
  return { driver, job, km: km.toFixed(1), min, destination: ... }
})
```

Tap insight → `openQuickAssign({ driverId: driver.id, jobId: job.id })` —
prefills both pickers.

---

## 7 · MAP RECIPE

### 7.1 Library + tile source (locked)

```ts
import L from 'leaflet'
import 'leaflet/dist/leaflet.css'

const map = L.map(el, {
  zoomControl: false, attributionControl: false,
  fadeAnimation: true, markerZoomAnimation: true, inertia: true
}).setView([1.6004, 103.8225], 12)

L.tileLayer('https://mt1.google.com/vt/lyrs=m&x={x}&y={y}&z={z}', {
  maxZoom: 22,
  attribution: '&copy; Google Maps'
}).addTo(map)
```

No API key. Free for demo / low-traffic.

### 7.2 Custom HTML divIcons

Driver pin:

```ts
L.divIcon({
  className: 'wr-marker',
  html: `<div style="
    width: ${selected ? 30 : 26}px; height: …;
    border-radius: 50%;
    background: ${VERDICT_COLOR[verdict]};
    border: 3px solid #fff;
    box-shadow: ${selectedRing} 0 4px 10px rgba(0,0,0,.3);
    opacity: ${matchesFilter ? 1 : .35};
    ${pulsing ? 'animation: wr-pulse-' + verdict + ' 2s infinite;' : ''}
  "></div>`,
  iconSize: [size, size], iconAnchor: [center, center]
})
```

CSS:
```css
.wr-marker { background: none !important; border: none !important; }
```

### 7.3 Routing composable (both apps)

```ts
// src/composables/useRouting.ts
export type LatLng = [number, number]
export interface RouteResult { coordinates: LatLng[]; distanceKm: number; durationMin: number }

export async function fetchRoute(waypoints: LatLng[], profile: 'car'|'bike'|'foot' = 'bike') {
  const coords = waypoints.map(([lat, lng]) => `${lng},${lat}`).join(';')
  const url = `https://router.project-osrm.org/route/v1/${profile}/${coords}?overview=full&geometries=geojson`
  const res = await fetch(url)
  if (!res.ok) return null
  const data = await res.json()
  if (!data.routes?.length) return null
  const r = data.routes[0]
  return {
    coordinates: r.geometry.coordinates.map(([lng, lat]) => [lat, lng]),
    distanceKm: r.distance / 1000,
    durationMin: r.duration / 60
  }
}
```

**Provider swap path**: replace OSRM URL block with GraphHopper / HERE / Google.
Same `RouteResult` shape; no view code changes.

### 7.4 Admin map cache + version guard (avoids OSRM rate-limit)

```ts
const routeCache = new Map<string, LatLng[]>()
function cacheKey(d: Driver, j: Job): string {
  return `${d.id}|${j.id}|${d.lat.toFixed(3)}|${d.lng.toFixed(3)}|...`
}

let routesVersion = 0
async function rebuildActiveRoutes() {
  const myVersion = ++routesVersion
  // … remove old polylines
  for (const d of drivers) {
    if (myVersion !== routesVersion) return     // abort if newer rebuild started
    const route = await fetchRoute(...)
    if (myVersion !== routesVersion) return     // abort after await
    L.polyline(route.coordinates, { color, weight, dashArray }).addTo(map)
  }
}
```

### 7.5 Rider 2-leg dimming

`legPickup` (pickup → driver) and `legDropoff` (driver → drop) drawn as
separate polylines. Active leg `opacity: 0.9, weight: 4`; upcoming leg
`opacity: 0.35, weight: 4`. Computed by `pastPickup` (`status ∈ transit/dropoff/completed`).

### 7.6 GPS opt-in

```ts
function startTracking() {
  watchId = navigator.geolocation.watchPosition(
    pos => { driverPos.value = [pos.coords.latitude, pos.coords.longitude]; refreshRoute() },
    err => { tracking.value = false; trackError.value = err.code === err.PERMISSION_DENIED
              ? 'Location permission denied. Using demo coordinates.' : `Couldn't read location.` },
    { enableHighAccuracy: true, maximumAge: 5000, timeout: 10000 }
  )
}
function stopTracking() { if (watchId !== null) navigator.geolocation.clearWatch(watchId) }
```

`onBeforeUnmount(() => stopTracking())` mandatory.

### 7.7 Map overlay widget set

| Widget | Position | Behaviour |
|---|---|---|
| Glass header | `top: 12px; left/right: 12px` | title + subtitle + Eye/EyeOff toggle (hides every other overlay) |
| Verdict-stats stack | `top: 92px; left: 12px` | colored pills with click-to-cycle (`jumpToNext(verdict)`) |
| Filter toggle | `top: 92px; right: 12px` | collapsed = 48 px Filter button; expanded = vertical color stack |
| Filter status pill | `bottom: 156px; centered` | shown when filter ≠ 'all', tap to clear |
| Recenter | `bottom: 156px; right: 12px` | violet circle, `LocateFixed`, calls `flyTo` |
| Active jobs strip | `bottom: 86px; left/right: 0` | horizontal scroller of WRCard-style job rows, click → `/jobs/{id}` |

---

## 8 · FORM TEMPLATES

Common skeleton:

```vue
<main class="flex flex-col">
  <WRHeader title="…" :subtitle="…" back />
  <form class="wr-content px-4 pt-4 space-y-4" @submit.prevent="submit">
    <WRCard>
      <p class="wr-eyebrow mb-3 flex items-center gap-1"><Icon /> Section</p>
      <label class="block">
        <span class="wr-eyebrow mb-1.5 ml-1">Field</span>
        <div class="relative">
          <Icon class="absolute left-4 top-1/2 -translate-y-1/2 text-muted" :size="16" />
          <input v-model="form.field" class="wr-input pl-11!" />
        </div>
      </label>
    </WRCard>
    <WRButton type="submit" variant="primary" size="lg" :loading="submitting">…</WRButton>
  </form>
</main>
```

| Form | Special |
|---|---|
| **JobFormView** | Assign Driver promoted to TOP card (variant="floating"). Pickup is hardcoded HQ. ETA card auto-renders below Schedule & Payment using `haversine(dropLat, dropLng) / kmPerMin`. |
| **WithdrawView** | Dark hero balance card → bank-account card (clickable → `/bank-details`) → amount input → "Available RM X" hint → submit `WRButton`, simulated 1.5 s API. Toast + `router.back()` on success. |
| **BankDetailsView** | Bank name `<select>` (yes — this one stays native; only the QuickAssignDrawer-style picker replaces selects in flows where `<select>` looks ugly), account number (mono font), holder name. `updateBankDetails()` + toast + back. |
| **ProfileEditView** | 80 px teal-gradient avatar with violet edit badge (decoration only), name + fleet inputs, **rider ID disabled** with `opacity-60`. `updateProfile()` + toast + back. Footer note explains ID is dispatch-managed. |
| **SettingsView** | Multi-section: 3-stat hero, Dispatch Rules (kmPerMin + autoAssign toggle), Pricing (deliveryBasePrice + payoutPerJob), Organisation (name, tagline, phone, email), HQ (label + lat/lng), Compliance (toggles), Sign Out. All inputs bind directly to `adminStore.settings.{field}` (no separate form state needed). |

---

## 9 · STATIC INFO PAGES

### TermsView template

```vue
<main class="flex flex-col">
  <WRHeader title="Terms & Conditions" subtitle="Legal & Privacy" back />
  <div class="wr-content px-4 pt-4 space-y-4">
    <!-- Metadata header -->
    <div class="flex items-center gap-3 px-1">
      <div class="size-10 rounded-xl bg-violet/10 text-violet grid place-items-center">
        <Scale :size="20" />
      </div>
      <div>
        <p class="text-sm font-bold text-ink">User Agreement</p>
        <p class="text-[11px] font-bold text-muted">Last updated: May 05, 2026</p>
      </div>
    </div>

    <!-- Single WRCard wraps every section, hairline divides between -->
    <WRCard class="space-y-6">
      <section v-for="(s, i) in sections" :key="i" class="space-y-2">
        <h3 class="text-sm font-bold text-ink flex items-center gap-2">
          <component :is="s.icon" :size="14" :class="s.tone" /> {{ i + 1 }}. {{ s.heading }}
        </h3>
        <p class="text-[12px] font-bold text-ink-muted leading-relaxed opacity-90">{{ s.body }}</p>
      </section>
    </WRCard>

    <p class="text-center text-[11px] font-bold text-muted uppercase tracking-widest py-4">
      © 2026 wRider Logistics
    </p>
  </div>
</main>
```

`sections` is a hard-coded local array of `{ icon, tone, heading, body }`. Reuse pattern for any legal / about / help page.

---

## 10 · MODAL / DRAWER / LIGHTBOX PATTERNS

| Pattern | Use cases | Mounting | Key behaviour |
|---|---|---|---|
| **Bottom drawer** (slide-up) | WRQuickAssignDrawer | `<v-model>` | `position: fixed; inset: 0; z-50; flex; align-items: flex-end;` Card has `border-top-radius: 28px`. Transition: `cubic-bezier(0.16, 1, 0.3, 1) 300ms`. Click backdrop to close. |
| **Centred modal** | WRProofModal, Settle modal in PayrollView | inline in view | Same backdrop, but `align-items: center`. |
| **Fullscreen lightbox** | WRImageLightbox (proof galleries) | `<v-model>` | Dark backdrop `rgba(6,11,12,.94)`. Top bar: counter + download + close. Stage: image + chevrons. Bottom: thumbnail strip. Keyboard `← → Esc`. Body scroll lock. |
| **Toast** | toastStore | App.vue mount | Fixed bottom; auto-dismiss 3 s; type-coloured. |

---

## 11 · CI / HARD RULES

| Gate | Command | Rule |
|---|---|---|
| TS strict | `pnpm vue-tsc --noEmit` | must pass; no `any` in views |
| No raw `<img>` | `grep -rn "<img " src/views/` | must be empty; use `<AppImage>` |
| Viewport | `grep -n "width=412" index.html` | must match exactly |
| Footer present | `grep -rn "FlushFooter" src/App.vue` | must render in App.vue |
| No raw hex in views | manual review | tokens or scoped classes only |
| No native `<select>` in flows | manual review | use `wr-picker-*` pattern |
| Children pages hide footer | router meta | `meta: { hideFooter: true }` |
| `font-black` on body text | manual review | forbidden — use `font-bold` |
| Card-in-card | manual review | merge with `.wr-divider` instead |
| Script block order | manual review | imports → props/emits → store → state → lifecycle → handlers |
| `.gemini/skills` reads | runtime | only on explicit "run/use .gemini" |

---

## 12 · COPY / BRAND VOICE

| Pattern | Example | Where |
|---|---|---|
| Brand tagline | "Hardware car accessories" | settings.organizationTagline, hero subtitles |
| Vision | "Ultimate Speed & Transparent Logistics (极致速度与透明物流)" | BLUEPRINT.md |
| Audit rule | "Audit rule: 1km ≈ 1min" | SettingsView, Dashboard, JobDetail |
| Status | "Heading to Pickup" / "In Transit" / "At Drop-off" / "Completed" | Map, Task |
| Verdict label | "Late · 8min over" / "On-track · 11min left" / "Tight · 2min left" | Map, Dashboard, JobDetail |
| Action ladder | "Accept Mission" → "Capture Pickup Proof" → "Mark In Transit" → "Capture Drop-off Proof" | TaskDetail SwipeButton |
| Empty | "Awaiting capture" / "No images uploaded yet" / "All drivers settled today" / "No active route. Awaiting dispatch." | Mission Brief, Payroll, Map |
| Error | "Pick both a rider and a job." / "Location permission denied. Using demo coordinates." | QuickAssign drawer, Map |
| Confirmation | "Mark completed" / "Confirm assign" / "Confirm settlement" / "Sign Out" | various submit CTAs |
| Microcopy unit | RM (Malaysian Ringgit), `min` (no period), `km` (no period) | money + duration + distance |

---

## 13 · QUICK START — Rebuild this app from scratch

A future AI rebuilding a similar dispatch / fleet app should execute the steps in this order. Each step is a phase; complete + verify before moving on.

### Step 0 — scaffold

```bash
npm create vite@latest webApp-{name}-admin -- --template vue-ts
npm create vite@latest webApp-{name}-app   -- --template vue-ts
# in each:
npm i pinia vue-router lucide-vue-next leaflet @types/leaflet
npm i -D tailwindcss @tailwindcss/vite @tailwindcss/postcss
```

### Step 1 — design tokens
Paste §1.1–§1.4 verbatim into both `src/style.css`. Set viewport meta per §2.4.

### Step 2 — layout shells
Author `App.vue` per §2.1. Add the home + sub-page layout patterns per §2.2. Implement CSS for `.phone`, `.hero`, `.content`, `.wr-header`, `.wr-content` per §2.3.

### Step 3 — component library
Build atoms first (§3.1), then composites (§3.2), then specials (§3.3). Use the typography hierarchy from §1.4. Lock the picker pattern from §3.4.

### Step 4 — router
Author both routers per §4.2 / §4.3. Three buckets: login / footer-tab / children. `meta.hideFooter` on login + every child page.

### Step 5 — data + stores
Drop `api/schema.sql` per §5.2. Author `adminStore.ts` and `driverStore.ts` per §5.3. Wire seed PHP files per `api/README.md`.

### Step 6 — page templates
For each row in §4.4, scaffold the view using the appropriate layout shell. Bind to the right Pinia store. Use real seed data, no hardcoded text.

### Step 7 — domain logic
Implement the audit verdict (§5.5), the state machine + photo gates (§6.1), the settlement flow (§6.3), and the smart-match (§6.4).

### Step 8 — maps
Add `useRouting.ts` per §7.3. Build admin map (markers, verdict colours, auto-routes with cache + version guard) and rider map (3-pin route, 2-leg dimming, GPS opt-in) per §7.

### Step 9 — modals + drawers
WRQuickAssignDrawer (admin) + WRProofModal (rider) + WRImageLightbox (shared) per §10.

### Step 10 — forms + static
Forms per §8 (JobFormView, WithdrawView, BankDetailsView, ProfileEditView, SettingsView). Static per §9 (TermsView template).

### Step 11 — CI
Wire the gates from §11. Run `vue-tsc --noEmit && vite build` on both apps; both must build clean.

### Step 12 — polish (the senses)
Read `wrider_design_senses.md` end-to-end. Apply each SENSE retroactively across the app: weight migration, header to 70 px, status colour table, card consolidation, KPI strip, picker pattern, GPS opt-in, lightbox photo evidence, brand voice copy.

---

## 14 · KNOWN LIMITATIONS / FUTURE WORK

- **OSRM** is the public demo server — replace with GraphHopper / HERE / Google for production.
- **Pinia stores** mock today; swap each action body for a `fetch(VITE_WRIDER_API_URL/...)` once the PHP backend lands.
- **Auth** is mock (LoginView no-op). Wire real auth before shipping.
- **GPS** uses browser Geolocation; the rider Capacitor wrapper needs a native plugin override for background-location.
- **Notifications** is a stub list; needs a real notifications table + push channel.
- **i18n** not implemented; all copy is hard-coded English. Add `vue-i18n` and externalise §12 strings.

---

## 15 · COMPANION FILES

- [`wrider_design_senses.md`](./wrider_design_senses.md) — the 15 SENSEs (the *why*, the aesthetic).
- [`wrider_chat_mining.md`](./wrider_chat_mining.md) — protocol for keeping the senses doc fresh.
- [`BLUEPRINT.md`](../../../Desktop/wRider/BLUEPRINT.md) — architectural manifest (typography, tokens, routes).
- [`api/schema.sql`](../../../Desktop/wRider/api/schema.sql) — canonical DDL.
- [`api/README.md`](../../../Desktop/wRider/api/README.md) — data layer architecture.

---

**Authored:** 2026-05-05 · v1.0.0
**Use:** read once before generating any UI for a new dispatch / delivery / rider-management app.
**Update:** see `wrider_chat_mining.md` for the auto-evolution protocol.
