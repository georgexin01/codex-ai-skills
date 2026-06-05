---
name: faucet-solving-mastery
description: "V1.0 Faucet Antibot & Captcha Solving logic. Multi-agent orchestration for complex platform bypass."
triggers: ["solve", "captcha", "antibot", "bypass"]
phase: reference
version: 1.0
status: archived
auto_load: false
archived_date: "2026-04-24"
---

# `03-solving` — Faucet Solving Mastery V1.0

## Purpose
Executing multi-layer captcha and antibot resolution with 100% accuracy.

## 🚀 The Protocol

1. **Scene Scanning**: Use `browser_subagent` to find all interactive challenge elements.
2. **Antibot Sequence**: Resolve image-based or math-based antibots in the order required by the platform.
3. **Main Challenge**: Solve the primary Hcaptcha/Recaptcha.
4. **Verification**: Confirm "Solved" status (Green check) before moving to Step 04.

## 🛠️ Mandatory Logic
- **FAIL FAST**: If a captcha fails 3 times, abort mission to prevent account ban.

---
**Status**: V1.0 Active | **Requirement**: Resolution
