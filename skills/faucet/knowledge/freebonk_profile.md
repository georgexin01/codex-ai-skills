---
name: freebonk-profile
description: "Free-Bonk Profile — V1.0 (Focus-Lock Active)"
triggers: ["free-bonk profile", "freebonk_profile"]
phase: reference
model_hint: gpt-5.3-codex
version: 1.0
status: active
---

# Free-Bonk Profile — V1.0 (Focus-Lock Active)

PURPOSE: Provide detailed context and operational strategy for Free-Bonk PTC harvesting.
SOURCE: https://free-bonk.com/ptc
AUTHORIZED EMAIL: `nelesp3@gmail.com`

## 1. PAGE LOGIC (V1.0)

### PTC Page (`/ptc`)
- **PTC Ad Buttons**: `button.btn-primary.btn-block` (Text: "Visit For [X] sec")
- **Balance Element**: `span.p-2` (Header)
- **Countdown Timer**: `button#ptcCountdown`
- **Verification Trigger**: `button#verify` (Appears in modal after timer)
- **Captcha System**: IconCaptcha (Odd-One-Out)

## 2. MISSION EXECUTION STRATEGY
- **Focus-Lock**: Priority 100.0. Ignore all other platforms.
- **Verification Protocol**: 
    1. Click "Visit" button.
    2. Wait for `#ptcCountdown` to reach zero.
    3. Click `#verify` button.
    4. Solve IconCaptcha (Least Frequent Icon).
    5. Return to `/ptc` and verify balance delta.

---
V1.0 Free-Bonk Profile — 2026-05-02

