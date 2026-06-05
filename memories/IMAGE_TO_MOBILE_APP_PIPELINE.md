---
name: image-to-mobile-app-pipeline
description: "Turnkey skill — when the user provides a folder of mobile-design images (screenshots, mockups, palette swatches) and asks to clone them into a Vue mobile app, run this end-to-end pipeline. Captures every refinement from the 2026-05-07 wallet-template build session: 23+ canonical pages, easy auth, animated FAB BottomNav, Tailwind toast system, Design Kit showcase. The user prepares the images; this recipe does the rest."
type: procedure
tier: 2
phase: 1-execution
priority: HIGH
model_hint: codex-gpt-5.3
applies_to: ["claude", "claude-code", "codex-gpt-5.3", "antigravity"]
authored_by: claude-opus-4-7
authored_for: "shared cross-AI use"
requires: ["MOBILE_APP_DESIGN_RECIPE.md", "CLAUDE_BLUEPRINT_RECIPE.md", "0_apex/USER_DNA.md", "1_core/DESIGN_SOP.md", "0_apex/SOVEREIGN_BLUEPRINT_PROTOCOL.md"]
unlocks: []
related: ["1_core/DESIGN_PSYCHOLOGY_2026.yaml", "1_core/INDUSTRIAL_INTERACTION_LIBRARY.md", "wrider_design_senses.md"]
reference_implementation: "c:/Users/user/Desktop/insurance-CRM/template/"
session_source: "2026-05-07 wallet-template build (full chat history)"
companion_blueprint: "BLUEPRINT.md"
companion_design: "DESIGN.md"
version: 1.1
date: 2026-05-07
status: authoritative
triggers:
  - "I have images, build me a mobile app"
  - "convert these mockups to vue"
  - "turn this folder of images into a mobile app"
  - "clone these designs into a mobile template"
  - "I prepared images in [folder] — build the app"
  - "make me an app like the one in these screenshots"
  - "build a vue app from these png mockups"
  - "ai design this app from picture"
---

## Gemini 3 Flash reading notes

- **Phase 0 is mandatory** before any code: read every image with the `Read` tool.
- **Decompose** each phase into ≤ 3 sub-tasks per turn.
- **Verify** with the §13 checklist before declaring `[🟢 STATUS: CRYSTAL]`.
- **Tables over prose** — visual extraction goes into structured rows, not paragraphs.
- **Permission boundaries**: writes only inside `<project_root>/`. Never modify `.codex/memories/0_apex/` or `2_governance/` without explicit per-turn user authorization.


# 🖼️ → 📱 IMAGE-TO-MOBILE-APP PIPELINE (v1.0)

> **Goal:** When the user prepares a folder containing mobile-app design images (screenshots, mockups, optionally a palette swatch), this skill builds a complete 23-view Vue mobile app cloning that aesthetic. Zero questions asked when the trigger fires — the recipe is turnkey.

---

## 0. Trigger detection

**Activate this skill when ALL of these are true:**

1. The user references a folder containing image files (`.png`, `.jpg`, `.jpeg`, `.webp`)
2. The user asks for a mobile app, Vue template, mockup conversion, or design clone
3. The folder location is given (or implied — e.g., "the template folder", "this folder")

**Ambiguous cases — ask before activating:**
- If only 1-2 images and unclear if app or single page
- If images include desktop layouts (this skill is mobile-only)
- If user wants Flutter/React Native instead of Vue

**Soft activation phrases to listen for:**

> "ai i prepared X images in [folder], build me an app"
> "convert these mockups"
> "make this look like the screenshots"
> "design this app from picture / images"
> "i want to build [an app] like in these screenshots"

---

## 1. Pre-flight checklist (run BEFORE any code)

| Check | Action |
|---|---|
| Folder exists? | `Glob <folder>/**/*.{png,jpg,jpeg,webp}` |
| Image count | 4+ images = full app; 1-3 = single page set |
| Color palette image present? | Often filenamed differently or visibly is just colored swatches — read it last |
| Existing project at folder? | If `package.json` exists, ASK whether to scaffold inside or alongside |
| User specified target stack? | Default = Vue 3 + TS + Vite 8 + Tailwind 4 (per [MOBILE_APP_DESIGN_RECIPE.md](MOBILE_APP_DESIGN_RECIPE.md)) |
| Sister projects on same machine? | Check `c:/Users/user/Desktop/` for related apps to mine for design DNA |

---

## 2. Phase 0 — Image analysis

Read **every** image with the `Read` tool. For each image, record:

| Attribute | What to capture |
|---|---|
| **Page identity** | Onboarding / Login / Home / Cards / Wallet / Analytics / Profile / Detail / Other |
| **Layout type** | Header + scroll body / hero + actions / list / grid / form / splash |
| **Background** | Light (default snow) or dark (ink) |
| **Hero element** | Big number, card stack, donut chart, headline, avatar+greeting, etc. |
| **Action elements** | Primary button (pill?), secondary, icon-only, FAB, segmented tabs, filter chips |
| **List rows** | If present: icon-circle + title/sub + amount/chevron pattern present? |
| **Charts** | Donut / bar / progress / circular gauge |
| **Bottom nav present?** | If yes, count tabs (3 / 4 / 4+FAB / 5) and identify icons |
| **Color hits** | Any non-neutral color used (mint/gold/sky/red/purple) |
| **Special elements** | QR scanner, calendar grid, OTP boxes, password field, social-login row |

If a **palette swatch image** is present (visibly just colored squares with hex codes), prefer those exact hexes for the Tailwind config. Otherwise, infer the palette from the screenshots.

**Mandatory minimum palette to extract or assign:**

| Token | Default if missing |
|---|---|
| `ink` (dark anchor) | `#10171c` |
| `snow` (light anchor) | `#f7f7f7` |
| One warm accent (`gold` / `amber` / `coral`) | `#f2da1b` |
| One cool accent (`mint` / `sky` / `lavender`) | `#a7e8d1` |
| (optional) Second cool | `#97cff3` |
| `active` (success) | `#22c55e` |

> **Hard rule:** never introduce a third accent color beyond one warm + one cool. If the screenshots seem to show three, group them under `mint` (cool) + `gold` (warm) + `sky` (additional optional cool variant).

---

## 3. Phase 1 — Project scaffold

Use [MOBILE_APP_DESIGN_RECIPE.md §Phase 1](MOBILE_APP_DESIGN_RECIPE.md) verbatim. The 7 root files are:

1. `package.json` — Vue 3.5 + Vite 8 + TS 6 + Tailwind 4
2. `vite.config.ts` — `@vitejs/plugin-vue`
3. `tsconfig.json` — `target: ES2023`, strict
4. `postcss.config.js` — `@tailwindcss/postcss`
5. `src/env.d.ts` — Vue SFC + Vite types
6. `src/main.ts` — single-line Vue mount
7. `tailwind.config.js` — populate with extracted palette
8. `index.html` — DM Sans + Material Symbols + viewport `width=device-width, initial-scale=1.0, viewport-fit=cover`
9. `src/style.css` — `@import "tailwindcss"` + `.tnum`, `.fill-1`, `.shadow-toast`, `.shadow-nav`, `.fab-float`, `.no-scrollbar`

**MANDATORY — never skip:**
- viewport meta `content="width=device-width, initial-scale=1.0, viewport-fit=cover"` (per [CLAUDE.md](C:/Users/user/.claude/CLAUDE.md))
- container `max-width: 412px` in inline `<style>`
- DM Sans + Material Symbols `wght 300` default

Run `npm install` in background while you continue writing.

---

## 4. Phase 2 — Design tokens

Populate `tailwind.config.js` with the palette extracted in Phase 0. Template:

```js
/** @type {import('tailwindcss').Config} */
export default {
  content: ["./index.html", "./src/**/*.{vue,ts}"],
  darkMode: "class",
  theme: {
    extend: {
      colors: {
        ink:    { DEFAULT: "<HEX>",  soft: "<DERIVED>" },
        snow:   { DEFAULT: "<HEX>",  warm: "<DERIVED>" },
        sky:    { DEFAULT: "<HEX>",  soft: "<DERIVED>" },
        mint:   { DEFAULT: "<HEX>",  soft: "<DERIVED>", deep: "<DERIVED>" },
        gold:   { DEFAULT: "<HEX>",  soft: "<DERIVED>" },
        active: "<HEX>",
      },
      fontFamily: { sans: ['"DM Sans"', "sans-serif"] },
      borderRadius: { "4xl": "2rem", "5xl": "2.5rem" },
      boxShadow: {
        card: "0 18px 40px -16px rgba(<INK_RGB>, 0.18)",
        soft: "0 8px 24px -8px rgba(<INK_RGB>, 0.08)",
      },
    },
  },
};
```

Replace `<HEX>` with extracted values; replace `<DERIVED>` with lighter/darker variants (`color-mix` or hand-tune).

---

## 5. Phase 3 — App shell + Toast system

> **Build the toast system FIRST** — every form/CTA gets clean feedback for free. This is non-negotiable per the 2026-05-07 session lesson.

Create in this order:

1. `src/composables/useToast.ts` — reactive toast queue, 4 helpers (`success` / `error` / `warning` / `info`)
2. `src/components/ToastContainer.vue` — Teleport to body, `<TransitionGroup>`, 4 variants

**Refined toast design (from today's session):**

- Container: `rounded-3xl shadow-toast border border-white/10 p-3.5 flex items-start gap-3`
- **Left accent strip** (status-strip-card pattern from insurance apps): `absolute left-0 top-3 bottom-3 w-1 rounded-r-full`
- **Icon coin** (size-10, rounded-2xl, inverted color from variant)
- **Mint blob accent** on the dark `info` variant only (matches dark featured card pattern)
- Auto-dismiss 3s, tap to dismiss

| Variant | Body | Icon coin | Strip | Blob |
|---|---|---|---|---|
| `success` | `bg-mint text-ink` | `bg-ink text-mint` | `bg-ink/20` | — |
| `error` | `bg-red-500 text-white` | `bg-white/20 text-white` | `bg-white/30` | — |
| `warning` | `bg-gold text-ink` | `bg-ink text-gold` | `bg-ink/20` | — |
| `info` | `bg-ink text-white` | `bg-mint/20 text-mint` | `bg-mint` | mint blur top-right |

Then create:

3. `src/App.vue` — `currentPage` state machine (start at `onboarding`)
4. `src/components/BottomNav.vue` — 4 tabs + animated dark center FAB

**BottomNav refined (from today's session):**

- 4 tabs: `home` · `cards` · `analytics` · `profile`
- Active state: `text-ink` + `.fill-1` icon (else `text-slate-300`)
- Container: `fixed bottom-0 left-0 right-0 z-40 max-w-[412px] mx-auto bg-snow shadow-nav`
- **Center FAB** (added in today's session refinement):
  - `size-12 rounded-full bg-ink text-white border-4 border-snow`
  - Position: `absolute left-1/2 -translate-x-1/2 -top-6`
  - Wrapped in `.fab-float` keyframe — 6 px translateY, 2.6 s ease-in-out infinite (< 10 px movement, slow)
  - Taps to `scan` page

**Required CSS (in `src/style.css`):**

```css
@keyframes float-fab {
  0%, 100% { transform: translateY(0); }
  50%      { transform: translateY(6px); }
}
.fab-float { animation: float-fab 2.6s ease-in-out infinite; }

.shadow-nav {
  box-shadow: 0 -4px 16px -8px rgba(16, 23, 28, 0.08),
              0 -1px 0 rgba(16, 23, 28, 0.04);
}

.shadow-toast {
  box-shadow: 0 14px 40px -12px rgba(16, 23, 28, 0.22),
              0 4px 12px -6px rgba(16, 23, 28, 0.10);
}
```

---

## 6. Phase 4 — Auth flow (6 views, EASY MODE)

> **Refined from today's session — auth is intentionally easy in templates.**
> User: *"the login to be able to login easily no need any password or username, otp is also enter 6 number then can pass through, signup also can easily signup and go to homepage"*

Build in this order: Onboarding → Login → Signup → OTP → ForgotPassword → Terms.

### 6.1 Validation rules (EASY MODE)

| View | Behaviour |
|---|---|
| `Login` submit | **No validation.** Always toast.success → home. Same for social buttons. |
| `Signup` submit | **No validation.** Always toast.success → **home** (skip OTP). |
| `OTP` verify | **No completion check.** Always toast.success → home. |
| `Forgot password` submit | Show toast.success even with empty input. |
| `Terms` accept | Toast.success → signup. |

### 6.2 Terms checkbox separation (refined today)

> User: *"terms and condition checkbox can be clicked easily not opening the tnc pages. only tnc word will go to tnc pages."*

Use a `<div>` (not `<label>`) wrapping the row, with `@click` on the wrapper to toggle, AND `@click.stop` on the inline "Terms of Service" button so it ONLY navigates without bubbling to the row toggle.

```vue
<div @click="accepted = !accepted" class="flex items-start gap-2 cursor-pointer select-none">
  <span class="size-5 rounded-md grid place-items-center" :class="accepted ? 'bg-ink text-white' : 'bg-white border border-slate-200 text-transparent'">
    <span class="material-symbols-outlined text-[14px] fill-1">check</span>
  </span>
  <span class="text-[12px] text-slate-600 leading-snug">
    I agree to the
    <button type="button" @click.stop="$emit('navigate', 'terms')" class="font-semibold text-ink underline">Terms of Service</button>.
  </span>
</div>
```

### 6.3 OTP boxes

6 inputs, `aspect-square rounded-2xl bg-white border-2`, auto-advance focus on input, Backspace jumps back. 45-second countdown for resend.

### 6.4 Toast triggers (auth flow)

| Trigger | Type | Title | Message |
|---|---|---|---|
| Login submit | `success` | "Welcome back!" | "You're signed in as Anna K." |
| Login social | `info` | "Continue with X" | "Signing you in…" |
| Signup submit | `success` | "Account created" | "Welcome to Wallet!" |
| OTP verify | `success` | "Verified" | "Welcome to Wallet!" |
| OTP resend | `info` | "Code sent" | "Check your messages" |
| Forgot password submit | `success` | "Reset link sent" | "Check ${email} for instructions" |
| Terms accept | `success` | "Terms accepted" | "Continue creating your account" |

---

## 7. Phase 5 — Main tabs (5 views)

Build: Home → Cards → Wallet → Analytics → Profile.

Each page follows the **anatomy template**:

```
1. Header row (px-6 pt-12) — left action, title/pill center, right actions
2. Hero (px-6 mt-6) — primary value, big bold tnum number
3. Quick actions (4-up icon-circles or 3-up cards)
4. Secondary content sections — h2 + tappable link
5. List rows (rounded-2xl bg-white border border-slate-100 p-3)
6. Optional dark "AI insight" or promo card
```

| Tab | Hero | Notable sections |
|---|---|---|
| Home | Wallet card with mint SVG wave | 4 quick actions · Activities · Spending bar · Subscriptions · Savings goals · Cashback promo |
| Cards | 3-card stack `-mt-8` overlap | Add-card · Limit gauge · Activity · Rewards · Benefits |
| Wallet | $X centered with `.00` faded | Favorites · 3-action grid · Transactions · Nov summary · Upcoming bills |
| Analytics | SVG donut + center amount | Brand transactions · Trend bars · Top categories · Insight card |
| Profile | Dark hero + 3-stat strip | 10-item menu · Settings CTA |

### Donut formula (Analytics)

```ts
const r = 70;
const c = 2 * Math.PI * r;
let acc = 0;
const stroked = segments.map((s) => {
  const len = (s.pct / 100) * c;
  const dasharray = `${len} ${c - len}`;
  const dashoffset = c * 0.25 - acc;
  acc += len;
  return { ...s, dasharray, dashoffset };
});
```

Render: `<svg viewBox="0 0 200 200" class="size-full -rotate-90">` + track circle + per-segment circles with `:stroke-dasharray` + `:stroke-dashoffset`.

---

## 8. Phase 6 — Account management (4 views)

ProfileEdit · Settings · Invite · Report.

Each must include the BACK button (`size-11 rounded-full bg-white border border-slate-100`) in the sub-page header. **No BottomNav** on these (whitelist excludes them in App.vue).

| View | Highlights |
|---|---|
| ProfileEdit | Avatar with edit-camera button (size-9 rounded-full bg-ink border-4 border-snow), 6 form fields (name/email-with-Verified-pill/phone/dob/country/address), KYC mint card, sticky bottom Save |
| Settings | 5 sections (Account/Notifications/Appearance/Preferences/About) + 4 toggle switches + 3-up theme picker + danger zone (Logout fires `info` toast → login, Delete account fires `warning`) |
| Invite | Dark hero + dashed-border code card with copy button + 4 share circles (WhatsApp `#25D366`, Email sky, SMS mint, More ink) + 3-step how-it-works + 3-up stats + recent referrals |
| Report | Dark `rounded-b-[40px]` hero header + $X net + 2-up income/spent + 6-month bars + 4-row breakdown + goals with status pills + AI insight + PDF export button |

---

## 9. Phase 7 — Sub-pages (5 views)

History · Calendar · Products · TransactionDetail · Notifications.

| View | Highlights |
|---|---|
| History | Search input + 4 filter chips (`bg-ink/white` for active) + 3-up summary chips (Spent / Earned / Net) + date-grouped transactions (Today / Yesterday / This week) — each row tappable → transaction-detail |
| Calendar | Month nav chevrons + 6×7 day grid + today (`bg-mint/40`) / selected (`bg-ink text-white`) / regular states + colored event dots (gold/mint/sky) + selected-day events list with `w-1 h-12` accent bar |
| Products | Featured dark hero (Wallet Black) + 6-product 2-col grid (mint/ink/gold/sky/white surfaces) + "Why us?" benefits list with green check_circle |
| TransactionDetail | Hero `size-20 rounded-full bg-mint/40` icon + 40 px `font-bold tnum` amount + status pill + 6-row details list + receipt breakdown with dashed total + 3 action buttons (Receipt/Repeat/Report) |
| Notifications | All / Unread / Promo segmented tabs (red `2` badge) + Today + Earlier groups + unread red dot + inline "Verify" CTA pill |

---

## 10. Phase 8 — Send/Scan utility pages (2 views)

> Added in today's session refinement to fix dead-end CTAs (Home Send button, Wallet Transfer/Scan, Center FAB).

| View | Highlights |
|---|---|
| SendMoney | Recipient picker (horizontal-scroll avatars, selected gets `ring-4 ring-mint` + green check badge) + huge centered amount input (text-[56px] font-bold tnum) + 5 preset chips ($10/25/50/100/250) + source-card row + optional note + sticky bottom Send pill (toast → wallet) |
| Scan | Full-screen dark camera viewfinder with 4 mint corner brackets + animated horizontal scan line + bottom sheet (`rounded-t-[32px] bg-snow`) with 3 quick actions (My code / Gallery / Send) + recent payees list. Reached from BottomNav center FAB. |

---

## 11. Phase 9 — Design Kit showcase (mandatory)

> The killer feature for cloning. Build a single scrollable view showcasing every reusable card pattern. The user copies from this page when porting designs into other projects.

Sections (organized by `◆ Section Name` uppercase eyebrow):

1. **Heroes** — greeting hero · dark hero with blob accents · centered total balance
2. **Card surfaces** — 4-color swatch (ink / mint / gold / sky)
3. **Status strip card** — colored 1.5 px left bar (insurance app pattern)
4. **List rows** — standard transaction · avatar with WhatsApp button
5. **KPI displays** — 2×2 grid with floating icon (`-top-7`) · 3-up summary chips
6. **Charts & bars** — donut (4 segments) · stacked multi-color · coverage bars (Life/Illness/Medical/Accident — insurance) · monthly bars
7. **Tabs & filters** — segmented (with red badge) · horizontal status chips (`scale-105 ring` active)
8. **Form controls** — text input · search input · toggle switch · custom checkbox · terms checkbox with link separation · password strength meter
9. **Buttons** — 6-color pill grid · icon-only round · mint FAB · WhatsApp green floating
10. **Avatars** — single · with status badge · with edit-camera · letter initial · group stack
11. **Dates & timeline** — calendar date badge (size-12 month/day) · vertical timeline with ringed dots
12. **Insurance domain** — insurance policy card · subscription plan tiers · article card with image · family member card with protection bar
13. **Toast variants** — 4 trigger buttons firing each variant live
14. **Empty state** — circle icon + title + sub + CTA

Place in `src/views/DesignKitView.vue`. Wire from Profile menu (`{ icon: 'palette', title: 'Design Kit', target: 'design-kit' }`).

---

## 12. Phase 10 — Wire ALL dead-end CTAs

> **No silent buttons.** Every button must do something — navigate or fire a contextual toast.

### Required wiring matrix

| View | Element | Action |
|---|---|---|
| Home | Search button | `toast.info("Search", "Type anything to find people, cards, transactions")` |
| Home | Notification bell | navigate `notifications` |
| Home | Swap quick action | `toast.info("Swap", "Currency swap is coming soon")` |
| Home | Freeze quick action | `toast.success("Card frozen", "No new charges will be authorised")` |
| Home | Send quick action | navigate `send-money` |
| Home | Receive quick action | navigate `scan` |
| Home | Activate cashback | `toast.success("5% Friday cashback active", "All spending today earns 5% back")` |
| Home | Activities + button | navigate `wallet` |
| Cards | Create New Card | `toast.success("Card requested", "Your new card will arrive in 5-7 days")` |
| Cards | Redeem points | `toast.success("Points unlocked", "12,480 points ready to redeem")` |
| Cards | See all activity | navigate `history` |
| Wallet | Hamburger menu | `toast.info("Menu", "Side menu coming soon")` |
| Wallet | Notification bell | navigate `notifications` |
| Wallet | Transfer card | navigate `send-money` |
| Wallet | Request card | `toast.info("Request money", "Send a payment request to anyone")` |
| Wallet | Scan card | navigate `scan` |
| Wallet | Transaction tap | navigate `transaction-detail` |
| Wallet | View full history | navigate `history` |
| Wallet | Calendar link | navigate `calendar` |
| Wallet | Pay bill button | `toast.success("${name} paid", "${amount} debited from Wallet •••• 5312")` |
| Analytics | See all transactions | navigate `history` |
| Profile | Every menu item | navigate to its target (or fallback to `toast.info`) |
| Profile | Open Settings CTA | navigate `settings` |
| ProfileEdit | Save | `toast.success("Profile updated", "Your changes are live")` |
| Settings | Logout | `toast.info("Signed out", "See you again soon, Anna")` → navigate `login` |
| Settings | Delete account | `toast.warning("Delete account?", "Tap again within 5s to confirm")` |
| Settings | Coming-soon items | `toast.info("<item>", "This setting is coming soon")` |
| Invite | Copy code | `navigator.clipboard.writeText(code)` + `toast.success("Code copied", ...)` |
| Invite | Share buttons | `toast.info("Sharing via X", "Send your link to friends")` |
| Report | Export PDF | `toast.success("Report ready", "PDF saved to your Downloads folder")` |
| History | Tap row | navigate `transaction-detail` |
| Calendar | Add `+` | `toast.info("New event", "Schedule a transfer, bill, or reminder")` |
| Products | Apply / Get started | `toast.info("Applying for X", ...)` or `toast.success("Welcome to Wallet Black", ...)` |
| Notifications | Verify CTA | `toast.success("Device verified", "Sign-in approved on iPhone 15")` |
| Notifications | Mark all read | `toast.info("All marked read", "Inbox cleared")` |
| TransactionDetail | Receipt | `toast.success("Receipt downloaded", ...)` |
| TransactionDetail | Repeat | `toast.info("Repeat transaction", ...)` |
| TransactionDetail | Report | `toast.warning("Report submitted", ...)` |
| SendMoney | Send | `toast.success("Sent successfully", ...)` → navigate `wallet` |
| Scan | All actions | `toast.info(...)` or navigate `send-money` |
| BottomNav | Center FAB | navigate `scan` |

---

## 13. Phase 11 — Verify

Run `npm run dev`. Then verify against this 30-item checklist:

- [ ] Onboarding loads as default page
- [ ] Onboarding `→` arrow navigates to Login
- [ ] Login submits with empty fields → success toast → Home
- [ ] Login social buttons fire info toast → Home
- [ ] Signup submits regardless of input → success toast → Home (NOT OTP)
- [ ] Signup terms checkbox row toggles only
- [ ] Signup "Terms of Service" word ONLY navigates to Terms (not toggle)
- [ ] OTP verifies regardless of digits filled
- [ ] OTP countdown ticks from 45 to 0
- [ ] OTP boxes auto-advance focus, Backspace jumps back
- [ ] Forgot password submits with empty input → success
- [ ] Terms accept fires success → Signup
- [ ] BottomNav shows on Home/Cards/Wallet/Analytics/Profile only
- [ ] BottomNav center FAB has shallow nav shadow + slow vertical bobbing animation (< 10 px)
- [ ] Center FAB navigates to Scan
- [ ] Each main tab's icon `fill-1` activates correctly
- [ ] All Profile menu items navigate to correct page
- [ ] Each sub-page has working back button → previous main tab
- [ ] Settings → Logout → success toast → Login
- [ ] Wallet Pay button fires success toast
- [ ] Home Activate cashback fires success toast
- [ ] Home Send → SendMoney; Receive → Scan
- [ ] Wallet Transfer → SendMoney; Scan → Scan
- [ ] Invite copy code fires success toast
- [ ] Report Export PDF fires success toast
- [ ] Profile → Design Kit opens DesignKitView
- [ ] DesignKit Toast variant buttons fire all 4 colors
- [ ] All amounts use `.tnum` (no width shifting)
- [ ] No native browser alerts (`grep -r "alert(" src/` returns empty)
- [ ] No horizontal scrollbar on any page

---

## 14. Phase 12 — Write BLUEPRINT.md

Use [CLAUDE_BLUEPRINT_RECIPE.md](CLAUDE_BLUEPRINT_RECIPE.md) shape but include:

- All 23 views (24 if DesignKit counts) in 4 categories (Auth · Main · Account · Sub)
- Toast variants table with all triggers wired
- BottomNav animated FAB documented
- Reusable primitives library (12 patterns)
- Lessons learned section
- Roadmap section listing what's intentionally not built (real backend, dark mode toggle, i18n, a11y)

---

## 15. Complete page list (canonical 23+ views)

```
src/views/
├── OnboardingView.vue          ← image 1 (splash) — DARK
├── LoginView.vue               ← auth (easy mode)
├── SignupView.vue              ← auth (easy mode, terms checkbox separation)
├── OtpView.vue                 ← auth (any 6 digits passes)
├── ForgotPasswordView.vue      ← auth
├── TermsView.vue               ← auth / settings
├── HomeView.vue                ← main tab 1
├── CardsView.vue               ← main tab 2
├── WalletView.vue              ← main flow (reached from Home +)
├── AnalyticsView.vue           ← main tab 3
├── ProfileView.vue             ← main tab 4
├── ProfileEditView.vue         ← account
├── SettingsView.vue            ← account
├── InviteView.vue              ← growth
├── ReportView.vue              ← reporting
├── HistoryView.vue             ← sub-page
├── CalendarView.vue            ← sub-page
├── ProductsView.vue            ← sub-page
├── TransactionDetailView.vue   ← sub-page
├── NotificationsView.vue       ← sub-page
├── SendMoneyView.vue           ← utility (added in v1.0 refinement)
├── ScanView.vue                ← utility (added in v1.0 refinement)
└── DesignKitView.vue           ← showcase (added in v1.0 refinement)

src/components/
├── BottomNav.vue               ← 4 tabs + animated dark FAB
└── ToastContainer.vue          ← Teleport + TransitionGroup + 4 variants

src/composables/
└── useToast.ts                 ← reactive queue + 4 helpers
```

---

## 16. Reusable primitives library (copy-paste blocks)

### Sub-page header

```html
<header class="px-6 pt-12 flex items-center justify-between">
  <button @click="$emit('back')" class="size-11 rounded-full bg-white border border-slate-100 grid place-items-center">
    <span class="material-symbols-outlined text-[22px]">arrow_back</span>
  </button>
  <h1 class="text-[18px] font-bold">{{ title }}</h1>
  <button class="size-11 rounded-full bg-white border border-slate-100 grid place-items-center">
    <span class="material-symbols-outlined text-[22px]">{{ rightIcon }}</span>
  </button>
</header>
```

### Card list row

```html
<li class="rounded-2xl bg-white border border-slate-100 p-3 flex items-center gap-3 active:scale-[0.99] transition cursor-pointer">
  <span class="size-11 rounded-full bg-snow border border-slate-100 grid place-items-center">
    <span class="material-symbols-outlined text-[20px]">{{ icon }}</span>
  </span>
  <div class="flex-1">
    <p class="text-[14px] font-semibold">{{ title }}</p>
    <p class="text-[11px] text-slate-400">{{ sub }}</p>
  </div>
  <p class="text-[14px] font-bold tnum">{{ amount }}</p>
</li>
```

### Form input with leading icon

```html
<label class="text-[12px] font-semibold text-slate-500">{{ label }}</label>
<div class="mt-1.5 rounded-2xl bg-white border border-slate-100 px-4 py-3 flex items-center gap-2">
  <span class="material-symbols-outlined text-[20px] text-slate-400">{{ icon }}</span>
  <input v-model="value" :type="type" :placeholder="placeholder"
    class="flex-1 bg-transparent outline-none text-[14px] placeholder:text-slate-300" />
</div>
```

### Featured dark card with blobs

```html
<div class="rounded-3xl bg-ink text-white p-5 relative overflow-hidden shadow-card">
  <div class="absolute -right-12 -top-12 size-44 rounded-full bg-mint/15 blur-2xl"></div>
  <div class="absolute -left-6 -bottom-12 size-40 rounded-full bg-gold/15 blur-2xl"></div>
  <div class="relative">
    <!-- content -->
  </div>
</div>
```

### Toggle switch

```html
<button @click="x = !x" class="w-11 h-6 rounded-full transition relative" :class="x ? 'bg-active' : 'bg-slate-200'">
  <span class="absolute top-0.5 size-5 rounded-full bg-white shadow transition-all" :class="x ? 'left-5' : 'left-0.5'"></span>
</button>
```

### Stacked progress bar

```html
<div class="flex h-2.5 rounded-full overflow-hidden">
  <div v-for="c in cats" :key="c.label" :class="c.color" :style="{ width: c.pct + '%' }"></div>
</div>
```

### Sticky bottom action bar

```html
<div class="fixed bottom-0 left-0 right-0 max-w-[412px] mx-auto bg-snow/90 backdrop-blur-md border-t border-slate-100 px-6 py-4">
  <button class="w-full py-3.5 rounded-full bg-ink text-white text-[14px] font-bold active:scale-[0.99] transition shadow-soft">
    {{ ctaLabel }}
  </button>
</div>
```

Add `pb-24` or `pb-32` on the parent so the last item isn't covered.

### Toast trigger

```ts
import { useToast } from "../composables/useToast";
const toast = useToast();
toast.success("Title", "Optional message");
toast.error("Title", "Optional message");
toast.warning("Title", "Optional message");
toast.info("Title", "Optional message");
```

### Status strip card (insurance app pattern)

```html
<div class="rounded-2xl bg-white border border-slate-100 flex overflow-hidden">
  <div class="w-1.5 shrink-0 bg-active"></div>
  <div class="flex-1 p-4">
    <!-- card content -->
  </div>
</div>
```

### Animated FAB on BottomNav

```html
<div class="absolute left-1/2 -translate-x-1/2 -top-6 z-10 fab-float pointer-events-none">
  <button @click="emit('tabChange', 'scan')"
    class="pointer-events-auto size-12 rounded-full bg-ink text-white grid place-items-center shadow-[0_8px_20px_rgba(16,23,28,0.28)] active:scale-95 transition-transform border-4 border-snow">
    <span class="material-symbols-outlined text-[22px]">qr_code_scanner</span>
  </button>
</div>
```

---

## 17. Always-do / Never-do (hard rules from today's session)

### ✅ Always

1. Build the **toast system FIRST** before any view
2. Use viewport `width=device-width, initial-scale=1.0, viewport-fit=cover` (CLAUDE.md mandate)
3. Use Material Symbols `wght 300` default + `.fill-1` for active states
4. Add `.tnum` to every monetary amount
5. Use one warm + one cool accent + ink + snow only
6. Wire EVERY button to a navigate or toast — no silent buttons
7. Build the Design Kit showcase page (mandatory for cloning)
8. Add 2 blob accents on every dark featured card
9. Animate the BottomNav center FAB with `.fab-float` (6 px translateY, 2.6 s)
10. Add `.shadow-nav` shallow shadow to the BottomNav
11. Easy auth — no required field validation in the template
12. Terms checkbox row click toggles, ONLY linked words navigate
13. Sticky bottom action bars get `bg-snow/90 backdrop-blur-md` + `max-w-[412px] mx-auto`
14. Write a BLUEPRINT.md at the project root (per APEX 5)
15. **Headers use `position: fixed`** + `max-w-[412px] mx-auto` + `pt-[80px]` on page wrapper — NEVER `sticky` (too many ancestor failure modes)
16. **Pure `bg-white` + `.shadow-header`** on all fixed headers — never translucent backdrop-blur
17. Header icon buttons use **`bg-mint/30 text-ink`** (no border) — soft theme tint, visible on white
18. Brand logo loaded via **Vite import** (`import logoUrl from "../assets/<file>.png"`) then `<img :src="logoUrl">` — never direct `/path` strings
19. Every header flex item gets **`shrink-0`** and brand/title text gets **`leading-none`** for pixel-clean alignment
20. Variant B (dashboard) uses **dual-header pattern** — in-flow greeting that scrolls away + separate hidden fixed header that fades in after `scrollY > 80`
21. Listen to **BOTH `<main>.scroll` AND `window.scroll`** for scroll-aware headers (App wrapper's `min-h-screen` makes either potentially the scroll container)
22. Tab navigators (filter chips, segmented tabs) MUST actually filter the rendered list via `computed` — never decorative
23. Page-stack for back navigation (`pageStack: ref<string[]>`), pop on back, clear when entering Home from auth — single `previousPage` ref breaks chained sub-pages
24. OTP boxes use theme-aligned border colors (`border-mint/30` empty, `border-mint` filled, `border-mint + bg-mint/10 + 4 px halo` focused)

### ❌ Never

1. Use `width=device-width` viewport
2. Use native `alert()` / `confirm()` / `prompt()` — always use the toast system
3. Use `font-black` (900) on flowing list/paragraph text — only on boxed currency totals + brand wordmarks
4. Introduce a 3rd accent color beyond the warm + cool pair
5. Add Pinia, vue-router, or other state libs to a template (keep it pure for clone-ability)
6. Hardcode hex values in component classes — always go through `tailwind.config.js`
7. Skip the toast system because "the form is simple"
8. Create a sub-page without a back button
9. Show BottomNav on auth pages or detail/form sub-pages
10. Validate auth fields in a template (intentionally easy)
11. Wrap a checkbox in `<label>` if you need separate toggle vs link click behaviour — use `<div>` + `@click.stop`

---

## 18. User-refinement notes (from 2026-05-07 chat history)

These are direct preferences captured from the original chat — encode them into every clone:

| Preference | Source quote |
|---|---|
| Easy auth | *"the login to be able to login easily no need any password or username"* |
| Skip OTP step in signup | *"signup also can easily signup and go to homepage"* |
| Any 6 digits OTP passes | *"otp is also enter 6 number then can pass through"* |
| Terms checkbox separation | *"terms and condition checkbox can be clicked easily not opening the tnc pages. only tnc word will go to tnc pages."* |
| All buttons must do something | *"those without routing try to find a way to connect pages or create related new pages needed"* |
| Sub-pages → back button only | *"all inside children pages... mostly are without footer and header has a back button"* |
| Animated FAB on footer | *"add 1 more button at center color themes dark color an is circle floating at center... slow animation moving top to bottom repeat... lesser than 10px"* |
| Footer shallow shadow | *"add a shallow shadow at box-shadow"* |
| Tailwind alerts not native | *"using tailwind added all possible notification alert system... try not using the original alert prompt message popup alert modal"* |
| Design Kit page mandatory | *"create at template folder somewhere suitable inside any pages so that when i want to copy this template design into any 2 app project i could copy 100% exact same design easier"* |
| Cards must have borders + radius | *"add more card with border + border radius"* |
| Pages should be content-rich | *"its not bad just quite empty, add more card... list data, report"* |
| Match images 100% exact | *"all design css must be 100% exact same looking as the sample images design look"* |
| AI-readable knowledge format | *"using ai readable most easiest reading language for ai to record these"* |
| Save for copy/duplicate use | *"the sample stored in knowledge or skills.. for copy and duplicate usage"* |

---

## 19. Quick-launch invocation

When the user fires the trigger:

```
1. ack briefly: "Studying images, scaffolding mobile app at <path>."
2. read every image in parallel via Read tool
3. identify pages, extract palette
4. write 7 root configs + style.css in parallel
5. npm install (background)
6. write toast composable + container + App.vue + BottomNav (parallel)
7. write 6 auth views (parallel)
8. write 5 main tab views (parallel)
9. write 4 account views (parallel)
10. write 5 sub-page views (parallel)
11. write 2 utility views (SendMoney, Scan) (parallel)
12. write DesignKitView (final)
13. wire all dead-ends per §12 matrix
14. write BLUEPRINT.md at project root
15. npm run dev (background) → confirm port → tell user the URL
```

**Total time budget: 30-45 minutes for a 23-view clone.**

---

## 20. Permission boundaries

- **Writes confined to**: `<project_root>/` only (configs, src/, BLUEPRINT.md). Nothing in `.codex/` unless user explicitly authorizes a recipe update (per APEX 0 lockdown).
- **Tier-0/1 governance** (`.codex/memories/0_apex/`, `2_governance/`) is read-only without per-turn user authorization.
- **Backups** — if the project root has existing files, propose `robocopy` to a `backup/` folder first (excluding `node_modules`).

---

_Reference template: [c:/Users/user/Desktop/insurance-CRM/template/](c:/Users/user/Desktop/insurance-CRM/template/) — 23 views built in the 2026-05-07 session, fully documented in its [BLUEPRINT.md](c:/Users/user/Desktop/insurance-CRM/template/BLUEPRINT.md). Read its source views whenever this recipe is ambiguous._
