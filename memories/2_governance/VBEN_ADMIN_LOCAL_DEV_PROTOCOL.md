---
name: vben-admin-local-dev-protocol
description: "Reliable method to start and verify a Vben Admin (Vue 3 + Vite + pnpm) panel locally via dev:local. Windows-safe."
tier: 2_governance
version: 1.0
status: authoritative
date_updated: "2026-05-21"
triggers: ["pnpm dev", "pnpm run dev:local", "dev:local", "dev:vps", "vben dev", "admin panel local", "vite dev", "localhost 6006", "run admin panel"]
applies_to: ["codex-gpt", "claude-code"]
---

# Vben Admin — Local Dev Protocol (Tier-2)

How to start, keep alive, and verify a Vben Admin panel (Vue 3 + Vite + pnpm monorepo) on localhost. Companion to `LOCALHOST_PHP_TEST_PROTOCOL.md` (PHP sites).

## 1. The command

From the **panel root** (e.g. `admin-panel-angel/`):

```
pnpm.cmd run dev:local
```

- On Windows use `pnpm.cmd`, not bare `pnpm` — the PowerShell execution policy can block the `pnpm.ps1` wrapper. `pnpm.cmd` always works.
- Run from the monorepo root, not `apps/web-antd`. Root `dev:local` filters to the app: `pnpm -F @vben/web-antd run dev:local` → `pnpm vite --mode development.localhost`.

## 2. Modes

`--mode` selects the matching `.env.<mode>` file in `apps/web-antd/`:

| Script | Vite mode | Env file | Backend |
|---|---|---|---|
| `dev:local` | `development.localhost` | `.env.development.localhost` | local Docker Supabase (`localhost:54321`) |
| `dev:vps` | `development.supabase` | `.env.development.supabase` | remote / VPS Supabase |
| `dev:zeta` | `development` | `.env.development` | zeta stack |

## 3. Port & verification

- Vite picks the port from `apps/web-antd/vite.config.mts`. For `admin-panel-angel` it is **6006** (`http://localhost:6006/`). Do not assume 6007 or 5173 — read the Vite `Local:` line in the output.
- Cold start takes ~9-15 s. Wait for the `VITE vX ready` line before testing.
- Verify: `curl -s -o NUL -w "%{http_code}\n" http://localhost:6006/` → expect `200`.

## 4. Keeping it alive

The Vite dev server dies when the agent turn / command ends — same failure mode as a foreground `php -S`. Either start it as a BACKGROUND / detached process and verify, or hand the user a terminal command / launcher they keep open. Never start it foreground then tell the user to open the browser.

## 5. Windows / sandbox gotchas

- A sandboxed shell can fail Vite/esbuild workspace resolution with `Cannot read directory "...": Access is denied` or `Could not resolve "...vite.config.mts"`. Retry the launch outside the sandbox.
- `vue-tsc` typecheck can hit `EPERM` writing `.vue-global-types` into package folders on Windows — a pre-existing env issue, unrelated to the dev server; it does not block `dev:local`.
- Confirm success only after the owning `node.exe` Vite listener is up — do not trust unrelated listeners.

## 6. This machine

pnpm 10.22.0 on PATH. `admin-panel-angel` boots with `pnpm.cmd run dev:local` from the panel root → `http://localhost:6006/`. Login: `admin@interiordesignangel.com` / `123456`. Local Supabase API: `http://localhost:54321`.

---
**Vben Admin Local Dev Protocol V1.0 — 2026-05-21**
