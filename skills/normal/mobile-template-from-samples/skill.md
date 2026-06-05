---
name: mobile-template-from-samples
description: "Build a Vue 3 mobile-app template from user-supplied reference screenshots. Use when the user provides a sample/ folder with 4+ screen designs and wants a buildable Vue 3 + Tailwind template that matches the visual language."
triggers: ["mobile template from samples", "build mobile app from screenshots", "sample-driven mobile template", "vue mobile template"]
phase: execution
model_hint: gpt-5.3-codex
version: 1.0
risk: "low"
source: "carMVP build retrospective 2026-05-08"
date_added: "2026-05-08"
---

# Mobile Template From Samples (V1.0)

> **Genesis**: Distilled from the carMVP template build at [`c:/Users/user/Desktop/carMVP/template/`](c:/Users/user/Desktop/carMVP/template/) — Malaysian used-car dealer Vue 3 PWA generated from 19 reference screenshots.

## Use this skill when

- User provides a `sample/` folder with ≥4 screen-design images (jpg / jfif / png).
- User wants a **buildable Vue 3 + Tailwind mobile-app template** that visually matches the references.
- User has supplied a `requirement.md` (in any language) specifying the pages and flows.
- User wants outputs in a non-English default language matching the references.

## Do NOT use this skill when

- User has only 1-2 reference images (use `frontend-design` skill instead).
- User wants a desktop-first or web-marketing site (use `claude-website` SKILL).
- User wants to extend an existing project (use `create-module` skill).

## Hard rules (locked at session start, MUST be carried into every phase)

1. **Viewport `width=device-width`** on `<meta name="viewport">` — responsive to every phone size; never hardcode `width=412`.
2. **Mount target `#root`** in `index.html` and `main.ts` — never `#app` (per LAA convention).
3. **Sample-image fidelity is the #1 design driver** — extract palette, typography, layout, components from references first; USER_DNA / DESIGN_SOP rules apply only where samples are silent.
4. **Locale default = sample-content language** unless user explicitly overrides — if samples are in Chinese, ship `zh.json` as default + fallback.
5. **Tailwind base + Headless UI Vue + CVA** for forms — never Element Plus / Naive UI / Vant.
6. **Form components built BEFORE views** — toast, login modal, 9 form primitives in Phase B.
7. **Pinia Options API stores with `$reset()`** — setup-style breaks Pinia 3 cross-store ref unwrapping.
8. **No `import.meta.env.*` outside `src/config/`** (config funnel rule).
9. **No raw `<img>`** — always `<AppImage>` with fallback + `loading="lazy"`.
10. **No `alert()` / `confirm()` / native `<select>`** — toast / drawer / lightbox only.
11. **APEX 0 gate** — never write to `.codex/memories/` or `.codex/skills/` without explicit per-file user authorization in chat.
12. **`replace_all` guardrail** — before every `replace_all` Edit, **grep first**. If the OLD name appears anywhere the NEW name will land (e.g. inside a computed that consumes the old as a source), the rename is unsafe → switch to scoped per-occurrence Edits. carMVP iteration-3 lost 1 hour to a self-referencing computed that was created by a careless `replace_all`. Never repeat.
13. **Tabs MUST swap content panels, not just the underline indicator** — `activeTab` must drive a downstream `<template v-if="activeTab === 'X'">` block OR a `computed` data slice. A tab strip that only changes its own visual state is a defect. Verified at Phase E (see verify checklist).
14. **Taste Commit BEFORE Phase A** — before scaffolding, output a "Taste Commit" block per [MOBILE_APP_DESIGN_RECIPE.md §0.5](../../../knowledge/MOBILE_APP_DESIGN_RECIPE.md). Restate the 7 taste rules in the project's own terms. Skipping this drives 5x feedback loops.

## The 6-phase workflow

### Phase 0 — Research (BEFORE writing any code)

Run 4 research streams **in parallel** (subagents recommended) to keep the main context clean:

1. **Sample-image vision study** — read every sample image, extract per-image: page type, layout (header/hero/content/footer), color palette (3-5 hex), typography hierarchy, key components, design language. Then synthesize: unified language, outliers, per-required-page mapping table, consensus color tokens.
2. **Mobile-design knowledge ingest** — read `MOBILE_APP_DESIGN_RECIPE.md`, `IMAGE_TO_MOBILE_APP_PIPELINE.md`, `HEADER_FOOTER_DESIGN_RULES.md`, `wrider_design_senses.md`, `USER_DNA.md`, `DESIGN_TOKENS.yaml`, `DESIGN_PSYCHOLOGY_2026.yaml`. Extract hard rules + tokens + component patterns + critical pitfalls.
3. **Engineering recipe ingest** — read `claude-app/SKILL.md` + 01–13 sub-skills + `vue3-fnb-framework/skill.md` + `tailwind-design-system/skill.md`. Output recommended stack + folder tree + folder conventions + tailwind config + routing structure + Pinia store list + i18n setup + step-by-step build order.
4. **Blueprint conventions ingest** — read `CLAUDE_BLUEPRINT_RECIPE.md`, `MASTER_BLUEPRINT.md`, `MASTER_DESIGN.md`, `BLUEPRINT_SAMPLES.md`, `SOVEREIGN_BLUEPRINT_PROTOCOL.md`. Extract the canonical BLUEPRINT.md outline.

### Phase 0.5 — Author `<project>/blueprint.md`

Write BEFORE any code. Required sections:
- **§0 USER REQUEST (VERBATIM)** — paste user's chat messages word-for-word so future AIs can read intent.
- §1 Identity & Value · §2 Tech Stack · §3 Routing Map · §4 App Shell ASCII diagram
- §5 Design DNA: 5.1 Color tokens · 5.2 Typography · 5.3 Surfaces · 5.4 Geometry · **5.6 Sample-Image Fidelity Mandate (per-sample mapping table + cross-sample layout signatures)**
- §6 State / Data Layer · §7 Domain Model · §8 PWA baseline · §9 Engineering protocols compliance
- §10 Step-by-step build plan · §11 Children pages / modals / alerts table
- §12 SIMULATION_LOG · §13 CHANGE LOG (append-only)

User must approve blueprint before code starts.

### Phase A — Foundations (sequential, ~8 files)

1. **Genesis scaffold** — `package.json`, `vite.config.ts`, `tsconfig.json`, `postcss.config.js`, `index.html` (viewport=device-width + Material Symbols + sample-language fonts via Google Fonts), `.env`, `.env.example`, `.gitignore`.
2. **Tailwind v4 `@theme` block** in `src/assets/global.css`. Pull color tokens from sample-image consensus. Add custom utilities (`.shadow-card`, `.glass-overlay`, `.tap`, `.skeleton`, `.h-scroll`, `.status-strip`, `.btn-yellow`, `.btn-red`, `.trust-card`).
3. **Config funnel** `src/config/{env,supabase,index}.ts` — only place `import.meta.env.*` is read.
4. **Types foundry** `src/types/*.ts` (one file per domain entity) + `index.ts` barrel.
5. **Utils** `src/utils/{format,loanMath,storage}.ts` — domain math helpers + locale-aware formatters.
6. **Entry** `src/main.ts` mounting to `#root`, `src/App.vue` with `<router-view>` + `<ToastContainer>` + global modals, `src/env.d.ts`.

### Phase B — Reusable systems (sequential)

7. **Toast + Modal system** — `useUiStore`, `ToastContainer.vue`, `ConfirmModal.vue`, `LoginModal.vue`. Build BEFORE any view.
8. **9 form components** — `AppButton` (CVA), `AppInput`, `AppSelect` (Headless Listbox), `AppDatePicker` (chip grid), `AppCheckbox` (svg tick), `AppSwitch`, `AppRangeSlider`, `AppChip`, `AppImage`. See [`tailwind-design-system/skill.md`](../design/systems/tailwind-design-system/skill.md) "Mobile Form-Component Pattern Library" for canonical recipes.
9. **Layout shells** — `BottomNav.vue` (4 tabs from requirement), `AppHeader.vue` (`position: fixed`, never sticky), `CarCard.vue` (or domain-equivalent: 16:11 photo + meta badge + 2-line title + meta row + big red price + strikethrough).
10. **Stores skeleton** — 5-7 Pinia Options API stores with `$reset()`. Add `mockData.ts` with ≥10 seed entities for demo.

### Phase C — Views (parallelizable batches)

Split into 5 batches that can run in parallel within phase:
11. **Auth batch** — Splash, Login.
12. **Main-tabs batch** — Home, List, Favorites, Profile (4 tabs).
13. **Sub-page batch** — Detail (with hero gallery + sticky bottom action bar matching sample), Inspection / Trust subpage, Calculator subpage.
14. **Booking batch** — Form (date-picker + time-slots), Confirm.
15. **Profile sub-pages** — MyBookings, MyLoans / domain-saved-records, About, Settings.

### Phase D — Routing + i18n (sequential)

16. **Router** — `createWebHistory`, lazy-loaded views, `meta.layout` (`bare | main-tabs | sub`), auth guard, `document.title` injection.
17. **i18n** — `vue-i18n` 9 with `legacy: false`. **Default = sample-content language**. Author all UI strings in default first; mirror to other locales.

### Phase E — Polish (verify checklist becomes RUNNABLE, not advisory)

18. Wire dead-end CTAs (every `@click` navigates / toasts / opens modal).
19. Skeleton loaders.
20. PWA assets — `public/site.webmanifest` (theme color from primary token, `purpose: "any maskable"` icons), `public/sw.js` (network-first), `public/favicon.svg`.
21. README.md with quick-start + page index.
22. **MANDATORY smoke-walk** — every `.vue` file MUST return HTTP 200 from Vite. Run:
    ```bash
    cd template
    for f in $(find src/views -name '*.vue') $(find src/components -name '*.vue') src/App.vue; do
      status=$(curl -s -o /dev/null -w "%{http_code}" "http://localhost:3000/$f")
      [ "$status" != "200" ] && echo "FAIL [$status] $f"
    done
    ```
    Any FAIL line blocks Phase F. (Catches SFC compile errors that HMR alone misses.)
23. **MANDATORY click-target audit** — every clickable surface MUST be functional. Run:
    ```bash
    grep -n -E '<(button|AppChip|AppButton)' src/views/**/*.vue
    ```
    Manual review: every match must have an `@click` handler whose body references `router`, a store action, OR a `useUiStore().addToast(...)` call. Pure local-ref toggles need a `computed` consumer downstream that re-renders content. Any chip / button without a handler = defect.
24. **MANDATORY tab-swap audit** — for any view with multi-tab navigation, grep:
    ```bash
    grep -n 'activeTab\b' src/views/**/*.vue
    ```
    Every match must show EITHER a `v-if="activeTab === ..."` template branch OR a `computed` that switches on `activeTab`. Tab strips that only update the underline = defect.
25. Verify viewport=device-width in `index.html`, mount target `#root` in main.ts.

### Phase F — Knowledge feedback (APEX 0 GATED)

Per `.codex/memories/0_apex/GROUND_KERNEL.md` Phase 0 (Sovereign Knowledge Freeze), AI is FORBIDDEN from writing to `.codex/` without per-file authorization. The ASK pattern:

> "Authorize Phase F write #N: [describe specific append/create] to [absolute path]?" with options: Yes / Show diff first / Skip.

Common Phase F outputs:
- Append §N to `MOBILE_APP_DESIGN_RECIPE.md` capturing the build's lessons.
- Append §N to `DESIGN_SOP.md` if a new design rule emerged.
- Extend `tailwind-design-system/skill.md` with new component recipes if any were generalized.
- Create new domain-specific skill (e.g. `mobile-template-from-samples/skill.md` was the Phase F output of the carMVP build).

## Common pitfalls

| Pitfall | Symptom | Fix |
|---|---|---|
| Hardcoding `width=412` viewport | Clips the right edge on phones narrower than 412px | Use `width=device-width` |
| `position: sticky` on header | Breaks under any ancestor `transform` | Use `position: fixed` |
| `font-black` on flowing text | Looks heavy / unbalanced | Reserve for hero RM price only |
| Element Plus / Vant alongside Tailwind | CSS-variable conflicts | Use Headless UI + CVA only |
| Decorative chips | Filter UI doesn't actually filter | Every chip drives a `computed` |
| Locale defaulted to English | UI mismatches reference language | Locale = sample-content language |
| Native `<select>` / `alert()` | Looks non-mobile / blocks iOS PWA | Custom Select + Toast |
| Card-in-card | Visual mush | Replace inner with hairline divider `<div class="h-px bg-(--color-border)">` |
| Hardcoded hex in components | Theme swap requires grep | All tokens via `@theme` + `bg-(--color-primary)` |
| Missing `$reset()` on store | Stale data after logout | Every store has `$resetCustom()` |
| Skipping `blueprint.md` §0 | Future AI loses original intent | Verbatim user request preservation |

## Verify checklist (MANDATORY — every box must be ticked before Phase F)

**Foundation**
- [ ] `index.html` has `viewport=device-width`
- [ ] `index.html` has `<div id="root">`, `main.ts` mounts to `#root`
- [ ] `src/config/` is the only place `import.meta.env.*` appears
- [ ] All Pinia stores have `$resetCustom()`
- [ ] `i18n.locale` matches sample-content language; `fallbackLocale` matches
- [ ] PWA manifest theme color matches `--color-primary`
- [ ] Header is `position: fixed`, not sticky

**No-anti-patterns (grep gates — see Phase E #22-24)**
- [ ] Smoke-walk grep: zero FAIL lines from the `curl` loop
- [ ] No `<img>` outside `AppImage.vue` (`grep -rn '<img' src/views src/components | grep -v AppImage.vue` returns empty)
- [ ] No `alert()` / `confirm()` (except Headless `Listbox` underlying) (`grep -rn 'alert\(\|confirm\(' src/`)
- [ ] No raw `<select>` (`grep -rn '<select' src/`)
- [ ] Every clickable surface has a real handler — click-target audit passes
- [ ] Every `activeTab` reference has a downstream consumer — tab-swap audit passes
- [ ] No hardcoded hex in components (`grep -rnE '#[0-9a-fA-F]{6}' src/components src/views` only matches comments / fallback SVGs)

**Taste compliance (per MOBILE_APP_DESIGN_RECIPE.md §0.5)**
- [ ] Taste Commit block was output BEFORE Phase A (preserved in `blueprint.md §13`)
- [ ] Brand logos default to color (no `/000000` suffix) unless an explicit override is justified
- [ ] No decorative chips / tabs — every clickable surface is functional
- [ ] Toast cadence: `useUiStore().addToast()` defaults to ≤1500ms duration

**Documentation**
- [ ] `blueprint.md §0` carries verbatim user-request blocks
- [ ] `blueprint.md §13 CHANGE LOG` has dated entries for every modifying turn
- [ ] `pnpm dev` boots cleanly on port 3000

## Reference implementation

[`c:/Users/user/Desktop/carMVP/template/`](c:/Users/user/Desktop/carMVP/template/) — Malaysian used-car dealer MVP, 78 files, ~3800 lines, generated 2026-05-08. Read its [`blueprint.md`](c:/Users/user/Desktop/carMVP/template/blueprint.md) first whenever this skill is ambiguous.

## Resources

- [`MOBILE_APP_DESIGN_RECIPE.md §N`](../../../knowledge/MOBILE_APP_DESIGN_RECIPE.md) — full carMVP feedback section
- [`DESIGN_SOP.md §5`](../../../memories/1_core/DESIGN_SOP.md) — Form Components principle
- [`tailwind-design-system/skill.md`](../design/systems/tailwind-design-system/skill.md) — 9-component CVA recipes
- [`CLAUDE_BLUEPRINT_RECIPE.md`](../../../knowledge/CLAUDE_BLUEPRINT_RECIPE.md) — blueprint.md authoring spec
- [`USER_DNA.md`](../../../memories/0_apex/USER_DNA.md) — Trusta Industrial taste fingerprint
- [`HEADER_FOOTER_DESIGN_RULES.md`](../../../memories/1_core/HEADER_FOOTER_DESIGN_RULES.md) — header/footer hard rules
