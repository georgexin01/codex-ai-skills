---
name: claude-app-working-progress
description: "Linear task executor for skills/claude-app — the mobile app Vue builder. 38 numbered micro-tasks: handshake -> foundation -> data -> UI -> deploy. Build-only: consumes the visual design from skills/design/app. Follow top to bottom, one task at a time. Built for low-effort Claude 4.6 / GPT 5.4."
triggers: ["claude-app working progress", "build mobile app", "ai claude app", "vue mobile app", "capacitor app"]
version: 1.0
date_updated: "2026-05-21"
status: authoritative
---

# 🟪 CLAUDE-APP — WORKING PROGRESS (Mobile App Vue Builder)

**How to run this file:** do ONE task, verify it, then go to the next number. Never skip. Never jump ahead.
Each task tells you exactly what to read — read only that.

## Rules you must follow (read once, keep in mind)

- **Build-only** — this skill builds the Vue code. The visual design, tokens, and `DESIGN.md` come from `skills/design/app`. Do NOT invent design here; consume it.
- **Handshake first** — if the app has a backend, `SHARED_DB_CONTRACT.md` decides schema/bucket/project_id. Default is **mock data**; Supabase is opt-in.
- **Drift Guard** — every 5 tasks, re-read the user's original request and re-anchor if drifted.
- **Karpathy** — surgical scope: touch only files the current task names.
- **Mobile viewport** — `width=device-width` (NEVER hardcode `width=412`); optional `max-width: 412px` clamp on the root container only.
- Code-vault detail lives in the 13 numbered step folders (`01-handshake-genesis/` … `13-native-pwa-deploy/`) — this file points into them; do not duplicate code here.

---

## PHASE A — HANDSHAKE (Tasks 1–6)

### Task 1 — Read the DB contract
Do: read the shared contract (only matters if the app has a backend).
Read: `../SHARED_DB_CONTRACT.md`
Verify: you know the mock-vs-Supabase decision is coming at Task 4.
Done? → Task 2

### Task 2 — Read the design contract
Do: read the visual design this app must follow.
Read: `../design/app/SKILL.md` and the project `DESIGN.md` if it exists.
Verify: you know the color tokens, fonts, radii, spacing. If no `DESIGN.md`, the design/app skill must run first — flag it.
Done? → Task 3

### Task 3 — Read the taste compass
Do: read the taste rules so the build matches the user's aesthetic.
Read: `memories/MOBILE_APP_DESIGN_RECIPE.md` → §0.5 Taste Compass.
Verify: you can state the CTA color, background style, tab/chip rule.
Done? → Task 4

### Task 4 — Data-mode decision
Do: decide — mock data (default) or Supabase backend?
Verify: written down. Mock → stores ship seed data. Supabase → continue to Task 5.
Done? → Task 5

### Task 5 — Confirm backend keys (Supabase only)
Do: if Supabase, confirm schema/bucket/project_id from the contract.
Verify: three keys known. If mock-mode, skip → Task 6.
Done? → Task 6

### Task 6 — Get the app spec from the user
Do: confirm the view list, the bottom-nav tabs, whether auth is needed, and the app name.
Verify: view count + tab count + auth answer are all known. If unclear, ASK before Task 7.
Done? → Task 7

---

## PHASE B — FOUNDATION (Tasks 7–15)

### Task 7 — Genesis: build configs
Do: create `package.json`, `vite.config.ts`, `tsconfig.json`.
Read: `01-handshake-genesis/skill.md`
Verify: Vue 3 + TS + Vite versions are set; configs parse.
Done? → Task 8

### Task 8 — Genesis: index.html
Do: create `index.html` with `<meta name="viewport" content="width=device-width, initial-scale=1.0, viewport-fit=cover" />`.
File: `index.html`
Verify: viewport is `device-width` — NOT `width=412`.
Done? → Task 9

### Task 9 — Genesis: main.ts
Do: create `src/main.ts` — mount App, register Pinia + router.
File: `src/main.ts`
Verify: `npm install` then `npm run dev` boots an empty shell.
Done? → Task 10

### Task 10 — Config: env.ts
Do: create `src/config/env.ts` — the only place `import.meta.env.VITE_*` is read.
Read: `02-config-hardening/skill.md`
Verify: no other file reads `import.meta.env` directly.
Done? → Task 11

### Task 11 — Config: supabase.ts + barrel
Do: create `src/config/supabase.ts` (exposes `supabaseEnabled` flag) and `src/config/index.ts` barrel.
File: `src/config/`
Verify: config is importable as `env.*` from the barrel.
Done? → Task 12

### Task 12 — API: apiClient
Do: create `src/api/apiClient.ts` — platform-aware HTTP wrapper.
Read: `03-api-connectivity/skill.md`
Verify: `php -l`-equiv — TypeScript compiles.
Done? → Task 13

### Task 13 — API: capacitorClient
Do: create `src/api/capacitorClient.ts` — Capacitor-aware client + Supabase wrapper.
File: `src/api/capacitorClient.ts`
Verify: web + native paths both resolve.
Done? → Task 14

### Task 14 — Auth: Supabase Auth (if auth needed)
Do: wire Supabase Auth, JWT extraction, refresh-token flow.
Read: `04-auth-architecture/skill.md`
Verify: login returns a session. If no auth, skip → Task 16.
Done? → Task 15

### Task 15 — Auth: fail-closed guards
Do: add route guards — unauthenticated → redirect to login.
File: `src/router/` guard file.
Verify: a guarded route bounces a logged-out user.
Done? → Task 16

---

## PHASE C — DATA (Tasks 16–22)

### Task 16 — Types foundry
Do: create `src/types/` — DB types, App types, request/response envelopes.
Read: `05-types-foundry/skill.md`
Verify: types compile; stores + views will import these.
Done? → Task 17

### Task 17 — Stores: Bakery pattern
Do: create `src/stores/` — Options-API Bakery stores with the `$reset` contract.
Read: `06-industrial-stores/skill.md`
Verify: one store per entity; identity filtering in the store layer.
Done? → Task 18

### Task 18 — Stores: mock seed data
Do: add self-erasing demo seed data so first-load pages are not empty (mock/Supabase seam).
Read: `memories/MOBILE_APP_DESIGN_RECIPE.md` → §N.6 + §N.11.3.
Verify: stores read mock data unless `supabaseEnabled` is true.
Done? → Task 19

### Task 19 — Stores: identity filtering
Do: confirm every data read is filtered by the authoritative user/project id.
File: `src/stores/`
Verify: no view fetches unfiltered data.
Done? → Task 20

### Task 20 — Image: Supabase Storage upload
Do: wire image upload to Supabase Storage (or local `/uploads/` in mock-mode).
Read: `07-image-spec/skill.md`
Verify: an upload returns a usable path (no leading `/`).
Done? → Task 21

### Task 21 — Image: AppImage fallback
Do: create `<AppImage>` with an error-fallback SVG.
File: `src/components/AppImage.vue`
Verify: a broken URL shows the fallback, not a broken icon.
Done? → Task 22

### Task 22 — Image: Capacitor picker
Do: add the Capacitor native image picker path.
File: `src/api/capacitorClient.ts` / image util.
Verify: native build can pick a photo; web falls back to `<input type=file>`.
Done? → Task 23

---

## PHASE D — UI (Tasks 23–32)

### Task 23 — Apply DESIGN.md tokens
Do: derive `tailwind.config` / CSS variables from the project `DESIGN.md` — never hand-write hex.
Read: `../design/_spec/EXPORT_GUIDE.md`
Verify: every color/spacing token traces back to `DESIGN.md`.
Done? → Task 24

### Task 24 — UI standardization
Do: set CSS variables, theme tokens, divider sections per the standardization step.
Read: `08-ui-standardization/skill.md`
Verify: tokens match the taste compass (CTA color, light bg).
Done? → Task 25

### Task 25 — View: List template
Do: build the List view template — loading + empty states.
Read: `09-view-scaffolding/skill.md`
Verify: list renders mock data, shows skeleton while loading.
Done? → Task 26

### Task 26 — View: Detail template
Do: build the Detail view template.
File: `src/views/`
Verify: detail renders all fields.
Done? → Task 27

### Task 27 — View: Form template
Do: build the Form view template — toast on submit.
File: `src/views/`
Verify: empty submit → warning toast; valid submit → success toast.
Done? → Task 28

### Task 28 — Bottom-nav + toast system
Do: build the bottom-nav (functional tabs that swap panels, not just underline) + the toast system.
Read: `memories/MOBILE_APP_DESIGN_RECIPE.md` → Reusable primitives + §N.12.13 (toast cadence 1500ms).
Verify: every tab swaps content; toast fades at 1500ms.
Done? → Task 29

### Task 29 — Routing: guards + auto-import
Do: build `src/router/index.ts` — guards, auto-import route modules.
Read: `10-routing-logic/skill.md`
Verify: all views are reachable.
Done? → Task 30

### Task 30 — Routing: redirect-to-login
Do: confirm the redirect-to-login flow + `returnTo` after login.
File: `src/router/`
Verify: a guarded deep-link survives the login hop.
Done? → Task 31

### Task 31 — Relational sync
Do: apply M2M / intersection-filter / soft-delete patterns where the data model needs them.
Read: `11-relational-sync/skill.md`
Verify: relations resolve; soft-deleted rows are filtered out.
Done? → Task 32

### Task 32 — UI verify
Do: check the app at mobile width.
Verify: no horizontal scrollbar; `width=device-width` holds on a 320px screen; tabs all drive content.
Done? → Task 33

---

## PHASE E — LOCALE + DEPLOY (Tasks 33–38)

### Task 33 — i18n
Do: wire `vue-i18n` with auto-glob locale files.
Read: `12-i18n-composables/skill.md`
Verify: locale switch works; default locale matches the user's language.
Done? → Task 34

### Task 34 — Composables
Do: add `src/composables/` — Capacitor Clipboard / Share patterns.
File: `src/composables/`
Verify: copy + share work on web and native.
Done? → Task 35

### Task 35 — PWA manifest + service worker
Do: create `manifest.json` + PWA service worker.
Read: `13-native-pwa-deploy/skill.md`
Verify: the app is installable; offline shell loads.
Done? → Task 36

### Task 36 — Capacitor config
Do: create `capacitor.config.ts` for native builds.
File: `capacitor.config.ts`
Verify: `npx cap sync` succeeds.
Done? → Task 37

### Task 37 — Build + deploy
Do: production build; deploy to staging then production.
Read: `13-native-pwa-deploy/skill.md` → deploy section.
Verify: the deployed app boots and the bundle hash is fresh.
Done? → Task 38

### Task 38 — Final report
Do: report what changed, what was verified, what remains uncertain.
Verify: report covers all three. Note the data-mode (mock or Supabase) used.
Done? → ✅ COMPLETE
