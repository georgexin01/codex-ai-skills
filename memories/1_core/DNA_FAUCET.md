---
name: dna-faucet
description: "?' DNA FAUCET ?" SOVEREIGN PERSISTENCE & AUTOMATED HARVESTING (V1.1)"
triggers: ["faucet", "harvest", "claim", "captcha", "automation", "persistence"]
version: 1.1
status: authoritative
---

# ?' 1. SOVEREIGN FAUCET DNA (V1.1)

The persistence engine for the Antigravity Faucet Stack. Governs the automated claim logic, browser state persistence, and captcha-evasion protocols.

## s-,? 1. HARVESTING GOVERNANCE
1. **Rule #1 (Silent Harvesting)**: All claims MUST be performed in a low-resource "Silent" mode (Nanobrowser or background tab) to prevent user interruption.
2. **Persistence Mandate**: Session data (Cookies/Storage) MUST be cached in `vault/` to ensure 0-auth claim resumption across machine reboots.
3. **Efficiency Protocol**: Claim intervals MUST be randomized (% 5-15% variance) to simulate human behavior and prevent anti-bot triggers.

## dY  2. AUTOMATION ARCHITECTURE
- **Pattern**: `Observe -> Solve -> Claim -> Cool-down`.
- **Targeting**: Use `CSS Selectors` over `XPath` for faster, more resilient DOM identification.
- **Fail-safe**: If a claim fails 3 times, AI MUST alert the user and pause the specific faucet claim.

## dY  3. CAPTCHA EVASION
- **Primary**: Use `HCaptcha` solver plugins where available.
- **Secondary**: Automated coordinate-clicking for "Grid" captchas using normalized screen coordinates (0-1000 scale).

## dY  4. STACK RECOGNITION
AI is authorized to deploy the following patterns for known faucet engines:

### 4.1 "Bonk-Style" Engine
- **Pattern**: `/claim` -> Find Button `id="claim-btn"` -> Wait 3s -> Verify Success Message.
- **Hot-Path**: `skills/faucet/bonk_claimer.md`

### 4.2 "Infinity-Style" Engine
- **Pattern**: `/faucet` -> Solve Math -> Click `name="submit"`.
- **Hot-Path**: `skills/faucet/infinity_claimer.md`

---

## 5. RECOGNITION REGISTRY (TIER-0)

| Platform | Target URL | Cycle | Logic Node |
| :--- | :--- | :--- | :--- |
| **Free-Solana** | `free-solana.com` | Hourly Roll | Simple URL-Direct navigation to `/roll`. |
<!-- END -->

### 5.1 Free-Bonk "Vision Pulse" Pattern
- **Logic**: Identify 5 icons. Compare against "Least Often" frequency hub.
- **Rule**: If `Probability < 90%`, skip and wait for the next refresh.

### 5.2 OnlyFaucet "180 Flip" Pattern
- **Logic**: Detect upside-down silhouette. Rotate 180 clockwise.
- **Rule**: Ensure surgical coordinate clicks on the `Center-Origin`.

### 5.3 FireFaucet "Swarm" Pattern (V1.2 Optimized)
- **Step 1**: Complete daily `PTC` (Pay-to-Click) tasks.
- **Step 2**: Activate `Auto-Faucet` tab.
- **Step 3**: Leave active in background (Nanobrowser).

### 5.2 Cointiply "Deep-Ghost" Pattern
- **Rule**: Never claim from the same IP more than once per hour.
- **Path**: `/faucet` -> Solve Hcaptcha -> Click Roll.

---
**DNA Faucet V1.1 - Sovereign Persistence (2026-04-18)**


---
