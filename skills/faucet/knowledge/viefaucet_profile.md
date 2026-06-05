---
name: viefaucet-profile
description: "Viefaucet Profile — V4.0 (Universal Optimizer)"
triggers: ["viefaucet profile", "viefaucet_profile", "viefaucet profile universal"]
phase: reference
model_hint: gpt-5.3-codex
version: 42.0
_ohdy_wrapper: |-
  # OHDY COMPRESSED NODE (V42.0)
  <dna_node>
  v: 42.0
  n: viefaucet_profile
  graph:
    req: []
    rel: []
  l: |-
  </dna_node>
status: archived
auto_load: false
archived_date: "2026-04-24"
---

# Viefaucet Profile — V4.0 (Universal Optimizer)

PURPOSE: Provide detailed context and operational strategy for AI Faucet V4.0.
SOURCE: https://viefaucet.com/
AUTHORIZED EMAIL: `nelesp3@gmail.com`

## 1. USER AUTHENTICATION
- Primary Method: Login with Google (OAuth).
- Authorized Email: `nelesp3@gmail.com`
- Rule: AI inserts email and WAITS for User password/MFA entry if required.

## 2. MISSION EXECUTION STRATEGY (V4.0)
- Turbo Mode: Enabled (30s Cool Gap between browser calls).
- Watchdog: Active (Checks timer every 3-5 seconds).
- Single Session: Strictly one persistent browser instance.

## 3. PAGE LOGIC (V4.0)

### Faucet Page (`/app/faucet`)
- Antibot: Order-based selection.
- Verification: reCAPTCHA checkbox.

### PTC Page (`/app/ptc/window`)
- Stay Outside Mechanic: Must stay on the external ad window.
- Verification: "Least Often" captcha icon modal.
- Trigger: "View" button -> External Tab -> Wait + Buffer -> Returns to Viefaucet -> Solving captcha.

### Bonus Page (`/app/bonus`)
- Action: "Claim" in the streak table.

---

V4.0 Universal Optimizer Profile — 2026-04-01

