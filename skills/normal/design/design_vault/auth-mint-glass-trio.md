---
name: auth-mint-glass-trio
description: "Auth trio (Login / Signup / OTP) — Dark + Mint glass blobs, big serif headline, glass fields"
triggers: ["auth mint glass trio", "auth-mint-glass-trio", "mint auth pages", "login signup otp glass dark", "policy doctor auth", "ecoworld auth"]
phase: reference
version: 1.0
status: authoritative
date_created: "2026-05-13"
---

# Auth Trio (Login / Signup / OTP) — Dark + Mint Glass

Score: 92 (S-CORE) | Source: insurance-CRM `LoginView.vue` / `SignUpView.vue` / `OtpView.vue` adapted into ecoworld-app

Full-bleed dark teal background with **3 atmospheric mint blur blobs**, big "Welcome **back.**" style headline where one word is the brand accent, glass-card form fields with leading icons + transparent inputs, **rounded-pill mint CTA** with right-arrow icon, and a small footer link ("Don't have an account? Sign up"). Variants: Login (no topbar), Signup (topbar + back), OTP (topbar + 6 aspect-square glass digit boxes that turn mint-tinted when filled).

## When to use
- Mobile-first app onboarding / auth flow
- Any product with a dark + single-accent brand identity (mint, teal, sky-blue, violet…)
- When you want a premium, calm, single-screen auth experience (no header chrome, no footer chrome)

## Customize These
- **Background** `#03241e` → your darkest brand surface (almost-black with a hint of brand hue)
- **Accent** `#00a68d` (mint) → your single brand accent — applies to: blobs, accent words in headline, focus rings, CTA fill, footer links, OTP filled state
- **Logo** swap `auth-logo` src + brand-name + brand-kicker
- **Headline copy** "Welcome **back.**" / "Welcome **on board.**" / "Enter **6-digit** code." — keep the two-line structure with one accent word
- **Field icons** swap lucide icons (Phone, Lock, UserRound, Sparkles, Mail…) to match your fields
- **CTA copy** "Sign in" / "Create Account" / "Verify & continue"
- **Footer link** "Don't have an account? Sign up" / "Already have an account? Sign in" / "Didn't get the code? Resend"
- **Region prefix** `+60` → drop entirely if not phone-based, or change country code

## Composition — 3 Pages

```
┌──────────────────────────┐  ┌──────────────────────────┐  ┌──────────────────────────┐
│  (no topbar)             │  │  ← back  CREATE ACCOUNT  │  │  ← back  VERIFICATION    │
│                          │  │                          │  │                          │
│  ◇ EcoWorld              │  │  ◇ EcoWorld              │  │  ┌─◇─┐  (sms icon card)  │
│      USER PORTAL         │  │      JOIN THE TOWNSHIP   │  │  └───┘                   │
│                          │  │                          │  │                          │
│  Welcome                 │  │  Welcome                 │  │  Enter 6-digit           │
│  back.                   │  │  on board.               │  │  code.                   │
│  Sign in to browse…      │  │  Set up your account…    │  │  Sent to +60 12-…        │
│                          │  │                          │  │                          │
│  PHONE NUMBER            │  │  FULL NAME               │  │  ┌─┐ ┌─┐ ┌─┐ ┌─┐ ┌─┐ ┌─┐ │
│  ┌──────────────────┐    │  │  ┌──────────────────┐    │  │  └─┘ └─┘ └─┘ └─┘ └─┘ └─┘ │
│  │ 📱 +60 │ 12-345…│    │  │  │ 👤 │ Anna Kovac  │    │  │                          │
│  └──────────────────┘    │  │  └──────────────────┘    │  │  [ Verify & continue → ] │
│                          │  │  PHONE / EMAIL / PWD…    │  │                          │
│  PASSWORD                │  │                          │  │  Didn't get? Resend 45s  │
│  ┌──────────────────┐    │  │  [ Create Account → ]    │  │                          │
│  │ 🔒 │ ••••••• │ 👁│    │  │                          │  │                          │
│  └──────────────────┘    │  │  Already? Sign in        │  │                          │
│                          │  │                          │  │                          │
│  [ Sign in → ]           │  │                          │  │                          │
│                          │  │                          │  │                          │
│  Don't have? Sign up     │  │                          │  │                          │
└──────────────────────────┘  └──────────────────────────┘  └──────────────────────────┘
```

All three share: 3 ambient mint blobs, brand row, headline (one accent word), glass fields, mint pill CTA, footer link.

## Step-by-Step Creation

### Step 1 — Auth shell + atmospheric blobs

Every auth page wraps in `.auth-shell` (full-bleed dark linear gradient) + 3 absolutely-positioned blur blobs.

```html
<section class="auth-shell">
  <div class="auth-blob auth-blob-a"></div>
  <div class="auth-blob auth-blob-b"></div>
  <div class="auth-blob auth-blob-c"></div>
  <!-- content here -->
</section>
```

### Step 2 — Topbar (signup + otp only, omit on login)

```html
<header class="auth-topbar">
  <button class="auth-back" @click="goBack" aria-label="Back"><ChevronLeft :size="18" /></button>
  <span class="auth-kicker">Create Account</span>   <!-- or "Verification" -->
  <div class="auth-topbar-slot"></div>
</header>
```

### Step 3 — Brand row (login + signup, omit on OTP)

```html
<div class="auth-brand">
  <img :src="logoUrl" class="auth-logo" alt="brand" />
  <div>
    <span class="auth-brand-name">EcoWorld</span>
    <span class="auth-brand-kicker">User Portal</span>
  </div>
</div>
```

### Step 4 — Headline (every page, one accent word in `<em>`)

```html
<div class="auth-headline">
  <h1>Welcome<br /><em>back.</em></h1>
  <p>Sign in to browse listings,<br />blueprints and the township map.</p>
</div>
```

OTP variant adds an icon avatar above the h1:

```html
<div class="auth-headline auth-headline-otp">
  <span class="auth-otp-icon"><MessageSquare :size="26" /></span>
  <h1>Enter <em>6-digit</em><br />code.</h1>
  <p>We sent a verification code to<br /><strong>{{ contact }}</strong>. It expires in 10 minutes.</p>
</div>
```

### Step 5 — Glass fields

```html
<form class="auth-form" @submit.prevent="submit">
  <label class="auth-label">Phone Number</label>
  <div class="auth-field">
    <Phone :size="18" class="auth-field-icon" />
    <span class="auth-prefix">+60</span>
    <input v-model="phone" type="tel" placeholder="12-345 6789" />
  </div>

  <label class="auth-label">Password</label>
  <div class="auth-field">
    <Lock :size="18" class="auth-field-icon" />
    <input v-model="password" :type="show ? 'text' : 'password'" placeholder="••••••••" />
    <button type="button" class="auth-eye" @click="show = !show">
      <EyeOff v-if="show" :size="18" /><Eye v-else :size="18" />
    </button>
  </div>

  <p v-if="error" class="auth-error">{{ error }}</p>

  <button type="submit" class="auth-cta">
    Sign in <MoveRight :size="16" />
  </button>

  <p class="auth-footer-link">
    Don't have an account?
    <button type="button" @click="goSignup">Sign up</button>
  </p>
</form>
```

### Step 6 — OTP digit grid (replaces normal fields on OTP page)

```html
<form class="auth-form" @submit.prevent="verify">
  <div class="auth-otp-grid">
    <input
      v-for="(_, i) in digits"
      :key="i"
      v-model="digits[i]"
      maxlength="1"
      inputmode="numeric"
      :class="{ filled: digits[i] }"
      @input="onOtpInput(i, $event)"
    />
  </div>
  <button type="submit" class="auth-cta">Verify &amp; continue <MoveRight :size="16" /></button>
  <p class="auth-footer-link">
    Didn't get the code?
    <button type="button" :disabled="countdown > 0" @click="resend">
      {{ countdown > 0 ? `Resend in ${countdown}s` : 'Resend code' }}
    </button>
  </p>
</form>
```

OTP input handler:

```js
function onOtpInput(i, e) {
  const v = e.target.value;
  digits[i] = v.slice(-1);
  if (v && i < 5) inputs[i + 1]?.focus();
}
```

Resend countdown (45s default):

```js
function startCountdown() {
  countdown.value = 45;
  const t = setInterval(() => {
    countdown.value--;
    if (countdown.value <= 0) clearInterval(t);
  }, 1000);
}
```

## Full CSS

```css
/* tune these 2 vars per brand */
:root {
  --auth-bg: #03241e;       /* dark surface */
  --auth-accent: #00a68d;   /* single brand accent (mint) */
}

.auth-shell {
  position: relative;
  width: 100%;
  min-height: 100%;
  background: linear-gradient(180deg, var(--auth-bg) 0%, #052b22 50%, #04201a 100%);
  color: #fff;
  overflow: hidden;
  display: flex;
  flex-direction: column;
}

.auth-blob {
  position: absolute;
  border-radius: 999px;
  pointer-events: none;
  filter: blur(60px);
}
.auth-blob-a { left: -80px; top: 32%; width: 320px; height: 320px; background: rgba(0, 166, 141, 0.15); }
.auth-blob-b { left: -36px; bottom: 80px; width: 170px; height: 170px; background: rgba(0, 166, 141, 0.35); }
.auth-blob-c { right: -60px; top: -40px; width: 240px; height: 240px; background: rgba(0, 130, 180, 0.12); }

/* topbar */
.auth-topbar { position: relative; z-index: 2; display: flex; align-items: center; justify-content: space-between; padding: 24px 22px 0; }
.auth-back { width: 42px; height: 42px; border-radius: 999px; background: rgba(255,255,255,0.08); backdrop-filter: blur(10px); border: 1px solid rgba(255,255,255,0.1); color: #fff; display: grid; place-items: center; cursor: pointer; transition: transform 0.12s; }
.auth-back:active { transform: scale(0.9); }
.auth-kicker { font-size: 11px; font-weight: 600; letter-spacing: 0.2em; text-transform: uppercase; color: var(--auth-accent); }
.auth-topbar-slot { width: 42px; height: 42px; }

/* brand */
.auth-brand { position: relative; z-index: 2; padding: 32px 30px 0; display: flex; align-items: center; gap: 12px; }
.auth-logo { width: 48px; height: 48px; border-radius: 14px; object-fit: contain; background: rgba(255,255,255,0.06); padding: 6px; border: 1px solid rgba(255,255,255,0.08); box-shadow: 0 8px 22px rgba(0,166,141,0.2); }
.auth-brand-name { font-size: 18px; font-weight: 700; letter-spacing: -0.02em; color: #fff; display: block; }
.auth-brand-kicker { margin-top: 5px; font-size: 9px; font-weight: 600; letter-spacing: 0.2em; text-transform: uppercase; color: var(--auth-accent); display: block; }

/* headline */
.auth-headline { position: relative; z-index: 2; padding: 26px 30px 0; }
.auth-headline h1 { margin: 0; font-size: 38px; line-height: 1.05; font-weight: 700; letter-spacing: -0.02em; color: #fff; }
.auth-headline h1 em { font-style: normal; color: var(--auth-accent); }
.auth-headline p { margin: 10px 0 0; font-size: 13.5px; line-height: 1.5; color: rgba(255,255,255,0.55); }
.auth-headline-otp .auth-otp-icon { display: inline-grid; place-items: center; width: 56px; height: 56px; border-radius: 16px; background: var(--auth-accent); color: var(--auth-bg); box-shadow: 0 12px 26px rgba(0,166,141,0.32); margin-bottom: 18px; }
.auth-headline-otp h1 { font-size: 32px; }
.auth-headline-otp p strong { color: #fff; font-weight: 700; }

/* form */
.auth-form { position: relative; z-index: 2; padding: 28px 30px 26px; flex: 1; display: flex; flex-direction: column; }
.auth-label { font-size: 11px; font-weight: 600; letter-spacing: 0.08em; text-transform: uppercase; color: rgba(255,255,255,0.55); margin-top: 14px; }
.auth-label:first-child { margin-top: 0; }

.auth-field { margin-top: 6px; display: flex; align-items: center; gap: 8px; padding: 13px 14px; border-radius: 16px; background: rgba(255,255,255,0.05); backdrop-filter: blur(10px); border: 1px solid rgba(255,255,255,0.1); transition: border-color 0.15s, background 0.15s; }
.auth-field:focus-within { border-color: rgba(0,166,141,0.6); background: rgba(0,166,141,0.05); }
.auth-field-icon { color: rgba(255,255,255,0.55); flex-shrink: 0; }
.auth-prefix { font-size: 14px; font-weight: 700; color: #fff; border-right: 1px solid rgba(255,255,255,0.12); padding-right: 8px; }
.auth-field input { flex: 1; border: 0; background: transparent; outline: none; font-size: 14px; color: #fff; min-width: 0; font-family: inherit; }
.auth-field input::placeholder { color: rgba(255,255,255,0.35); }
.auth-eye { border: 0; background: none; color: rgba(255,255,255,0.55); display: grid; place-items: center; cursor: pointer; padding: 0; }

.auth-error { margin: 14px 0 0; text-align: center; font-size: 12px; font-weight: 600; color: #ff8b8b; }

.auth-cta {
  margin-top: 26px; width: 100%; height: 52px;
  border: 0; border-radius: 999px;
  background: var(--auth-accent); color: var(--auth-bg);
  font-size: 14px; font-weight: 700;
  display: inline-flex; align-items: center; justify-content: center; gap: 6px;
  box-shadow: 0 14px 30px rgba(0,166,141,0.28);
  cursor: pointer; transition: transform 0.12s, opacity 0.15s;
}
.auth-cta:active { transform: scale(0.99); }
.auth-cta:disabled { opacity: 0.55; cursor: default; }

.auth-footer-link { margin: auto 0 0; padding: 30px 0 16px; text-align: center; font-size: 12.5px; color: rgba(255,255,255,0.55); }
.auth-footer-link button { border: 0; background: none; font-weight: 700; color: var(--auth-accent); margin-left: 4px; cursor: pointer; font-size: inherit; padding: 0; }
.auth-footer-link button:disabled { color: rgba(255,255,255,0.35); cursor: default; }

/* OTP grid */
.auth-otp-grid { display: grid; grid-template-columns: repeat(6, 1fr); gap: 8px; }
.auth-otp-grid input {
  aspect-ratio: 1 / 1; width: 100%;
  border: 2px solid rgba(255,255,255,0.15); border-radius: 16px;
  background: rgba(255,255,255,0.05); backdrop-filter: blur(10px);
  text-align: center; font-size: 24px; font-weight: 700; color: rgba(255,255,255,0.55);
  outline: none; font-family: inherit; transition: all 0.15s;
}
.auth-otp-grid input.filled { border-color: var(--auth-accent); background: rgba(0,166,141,0.15); color: #fff; }
.auth-otp-grid input:focus { border-color: var(--auth-accent); background: rgba(0,166,141,0.1); box-shadow: 0 0 0 4px rgba(0,166,141,0.18); }
```

## Anti-patterns

- Don't add header chrome (back button, title bar) on the **login** page — only signup/otp get the slim glass topbar
- Don't put the form inside a centered card — the form fills full width with 30px side padding; the **dark background itself** is the canvas
- Don't use more than ONE accent color — the entire design relies on a single mint hue popping against the dark
- Don't reduce blob blur below 50px or they become hard edges instead of atmosphere
- Don't centre the headline horizontally — it sits left-aligned at 30px padding

## Done-checks

- [ ] 3 blobs visible but soft (blur ≥ 50px, opacity 0.12–0.35)
- [ ] Headline has exactly ONE accent word, in `<em>` styled as `color: var(--auth-accent)`
- [ ] Glass fields show focus state (border turns accent at 0.6 opacity)
- [ ] CTA is rounded-full (border-radius: 999px), not rounded-rectangle
- [ ] OTP filled state changes both border AND background AND text colour
- [ ] Footer link button is plain text + mint colour, no underline by default
