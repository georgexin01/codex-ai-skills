---
name: screenshot-hygiene
description: "Screenshot lifecycle rule — capture only when needed, reference by path, purge after use. Recreated 2026-06-11 (was dangling ref from claude-meta skills)."
triggers: ["screenshot hygiene"]
version: 1.0
status: authoritative
date_updated: "2026-06-11"
---

# Screenshot Hygiene

Purpose: screenshots are evidence, not knowledge. They bloat context and can leak PII/secrets — treat them as disposable.

## Rules

1. **Capture only on demand** — take a screenshot only when visual evidence is required (UI verification, design audit, bug proof). Never speculatively.
2. **Crop to the claim** — capture the smallest region that proves the point; full-desktop captures are a privacy risk.
3. **Secret scan before save** — if a capture shows tokens, env values, emails, or live data, redact or discard it. Never commit such an image.
4. **Reference by path, never inline** — knowledge/skill files link the image path; do not paste base64 or duplicate copies.
5. **Purge after use** — once the task that needed the screenshot is verified and summarized in text, delete the image. Text conclusions live in memory; pixels do not.
6. **Storage location** — transient captures go to the project `tmp/` (already ignored), never into `memories/` or `skills/`.

Validation hook: `skills/claude-meta/validate-knowledge/skill.md` counts stale screenshots as violations.
