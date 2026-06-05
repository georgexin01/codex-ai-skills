---
name: 03-config-hardening
description: "V1.0 Config Hardening: Vite, Tailwind v4, and Capacitor environmental locking."
step: 3
version: 1.0
---

# 🛡️ [03] Config Hardening — The Sovereign App Protocol

> [!NOTE]
> **TIER-0 COMPLIANCE**: Viewport and SPA Routing rules have been moved to the **[Sovereign App Introduction](../SKILL.md)**. Ensure you have read them line-by-line.

## 🎯 Objective
To ensure the build environment is stable and correctly configured for modern web app development.

## ⚙️ Configuration Standards
1.  **Vite**: Enable port locking (5173/5174) and `@` path aliasing.
2.  **Tailwind v4**: Direct CSS imports with `@theme` token definitions.
3.  **Capacitor**: Initialize with App ID and prepare for native API simulation.

## 🛠️ Validation Checklist
- [ ] Do `package.json` scripts include `dev`, `build`, and `type-check`?
- [ ] Is `tsconfig.json` correctly aliasing `src` to `@`?
- [ ] Are Tailwind theme colors synced with the `BLUEPRINT.md`?
- [ ] Is the `.htaccess` (or equivalent) present in `public/`?

---
*Premium App Design Node 03 — V1.1 Config Hardening*
