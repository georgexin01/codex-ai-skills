---
name: laa-ecosystem-api-protocol
description: "JIT-loaded protocol for any work touching the LAA ecosystem's Supabase/API/deployment layer. Routes AI to the project-root API_CONNECTION.md (single source of truth) and inlines the irreducible gotchas so they survive even if that file isn't read."
tier: 2_governance
version: 1.0.0
status: authoritative
last_updated: "2026-04-30"
applies_to: ["claude", "claude-code", "codex-gpt-5.3"]
triggers:
  # Concept
  - "supabase"
  - "api connection"
  - "cors"
  - "allowedOrigins"
  - "PGRST"
  - "PGRST_DB_SCHEMAS"
  - "zeta-groups"
  - "api.zeta-groups.com"
  - "quizLaa schema"
  - "Cloudflare proxy"
  - "kong"
  - "postgrest"
  - "mixed content"
  - "webmanifest"
  - "deployment"
  - "cpanel"
  - "subfolder deploy"
  - "asset path"
  - "base path"
  # Domains
  - "laa.aisolo.vip"
  - "quiz-laa.aisolo.vip"
  - "admin-laa.aisolo.vip"
  # Env files
  - ".env.production"
  - ".env.development.localhost"
  - ".env.development.supabase"
  - "vite mode"
  - "APP_ENV"
  # Dev/build commands — broad on purpose
  - "npm run dev"
  - "npm run build"
  - "pnpm run dev"
  - "pnpm run build"
  - "pnpm dev"
  - "pnpm build"
  - "pnpm dev:local"
  - "pnpm dev:antd"
  - "pnpm dev:supabase"
  - "pnpm build:antd"
  - "pnpm build:supabase"
  - "pnpm build:production"
  - "php -S localhost"
  - "localhost:8001"
  - "localhost:8002"
  - "localhost:5666"
  - "localhost:54321"
  - "localhost + supabase"
  - "run dev"
  - "run build"
  - "build production"
  - "build for cpanel"
  - "deploy to cpanel"
  - "upload to cpanel"
  # Project names
  - "admin-panel-quizLaa"
  - "webApp-LAA-quiz-v2"
  - "website-LAA-agent"
  - "website-LAA-website"
  # Symptoms
  - "Invalid schema"
  - "Failed to fetch"
  - "Mixed Content"
  - "ERR_BLOCKED_BY"
  - "406 Not Acceptable"
  - "401 Unauthorized"
  - "404 Not Found"
  - "Manifest: Line"
  - "site.webmanifest"
---

# LAA ECOSYSTEM — API PROTOCOL (Tier-2 Governance)

## Activation

Any of these triggers a MANDATORY read of the project-root `API_CONNECTION.md`:

- User mentions Supabase, PostgREST, Kong, Cloudflare, schema, CORS, allowedOrigins, anon key, .env, env.production, deployment, cPanel, mixed content, "Invalid schema", 406, 401, manifest, webmanifest.
- File touched is in `api/core/`, `api/Config.php`, `api/Helper.php`, any `.env*`, `docker-compose.yml`, `.htaccess`.
- Context is one of the 4 LAA projects (`admin-panel-quizLaa`, `webApp-LAA-quiz-v2`, `website-LAA-agent`, `website-LAA-website`) under `c:\Users\user\Desktop\quizLAA\`.

## Authoritative Source

**`c:\Users\user\Desktop\quizLAA\API_CONNECTION.md`** — read this first. It contains:

1. Project map (4 projects → schemas → URLs)
2. Backend infrastructure (VPS, ports, Cloudflare proxy)
3. Schema whitelist procedure
4. Per-project env-resolution mechanisms (Vite `--mode` for Vue, runtime `HTTP_HOST` for PHP)
5. Deployment subdomain map
6. CORS canonical allowlist
7. Verification commands
8. Incident log (§9.1 – §9.10) — the actual bugs hit, root causes, fixes
9. Standard runbook procedures
10. AI pre-flight checklist

## Irreducible Gotchas (in case the project file is unreachable)

These are the patterns that have been hit repeatedly — survive them out-of-band:

### G1 — Production API URL is HTTPS via Cloudflare

For any frontend served over HTTPS (e.g. `https://laa.aisolo.vip`), the Supabase URL **must** be `https://api.zeta-groups.com` — NOT `http://zeta-groups.com:8000`. The latter triggers browser mixed-content blocking. The Cloudflare layer provides the HTTPS, then proxies to Kong on port 8000 internally.

### G2 — `PGRST_DB_SCHEMAS` is in `docker-compose.yml`, not `.env`

This Supabase install hardcodes the schema list literally inside `docker-compose.yml` at the `rest:` service env block. Editing `.env` does nothing. After editing `docker-compose.yml`, recreate with `docker compose up -d rest` (NOT `restart` — restart preserves the existing container's env).

### G3 — PHP host-detection must be applied in BOTH config layers

For LAA-agent and LAA-website, BOTH `api/core/SupabaseConfig.php::loadEnv()` AND (for LAA-agent only) `api/Helper.php::getConfig()` need the same `$_SERVER['HTTP_HOST']` regex (`localhost|127\.0\.0\.1` → `.env`, else → `.env.production`). Missing the second one means production runs with dev CORS origins.

### G4 — Schema names + email values are case-sensitive

PostgreSQL: schema `quizLaa` (mixed case) is not the same as `quizlaa`. PostgREST `email=eq.x` is case-sensitive on text. Use `ilike` or normalize on insert.

### G5 — Vue/Vite uses `--mode`, PHP uses runtime host

Don't conflate. Vue projects pick env at **build time** (`pnpm build:antd` → `.env.production`). PHP projects pick env at **request time** based on `HTTP_HOST`. Different bug surfaces, different fixes.

### G6 — `.htaccess` must whitelist non-obvious extensions

`.webmanifest`, `.xml`, `.txt`, `.map` files (and the `/favicon` directory) must be in the static-extension/exclusion list, or PHP's front-controller rewrite will return its 404 page as `text/html`, causing manifest parse errors.

### G7 — CORS Origin = scheme://host[:port], path stripped

`https://laa.aisolo.vip/agents` is the SAME origin as `https://laa.aisolo.vip`. Don't add path entries to `allowedOrigins`. The 5 canonical origins are: `https://laa.aisolo.vip`, `https://quiz-laa.aisolo.vip`, `https://admin-laa.aisolo.vip`, `https://laa.com.my`, `https://www.laa.com.my`.

### G8 — Subfolder-deployed PHP projects: use Apache fallback rewrite, NOT PHP path prefixing

When LAA-agent deploys under `laa.aisolo.vip/agents/` (subfolder of LAA-website), root-relative asset paths (`/assets/...`, `/css/...`, `/js/...`, `/images/...`, `/uploads/...`, `/favicon/...`) point at the parent site's root — not the agent's folder.

**Solution (current, server-side):** outer site's `.htaccess` rewrites missing-at-root requests to `/agents/...`:

```apache
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule ^(uploads|assets|css|js|images|favicon|fonts)/(.+)$ /agents/$1/$2 [L]
```

Browser URL stays `/uploads/reviews/x.jpg`. Outer site's own assets (file exists) are served directly; agent assets fall through. No PHP template changes needed; works for static markup AND PHP-generated URLs.

**Anti-pattern (rejected):** prefixing every `<link>`/`<script>`/`<img>` with `<?= $assetBase ?>` derived from `SCRIPT_NAME`. Works but doesn't help dynamic URLs (review images, storage URLs) and pollutes templates. The Apache rewrite is the single-point fix.

Add `/agents` to the outer site's front-controller exclusion list so prefixed paths aren't re-routed to `index.php`.

## Pre-flight Checklist (Required Before Any Mutation)

1. ☐ Open `c:\Users\user\Desktop\quizLAA\API_CONNECTION.md` and confirm the relevant section is still current.
2. ☐ Identify which project + which mechanism the change applies to.
3. ☐ For server-side change: `grep -n VARNAME .env docker-compose.yml` to find where the value actually lives before editing.
4. ☐ For Vue: identify `--mode`, edit matching `.env.{mode}`, rebuild, redeploy.
5. ☐ For PHP: BOTH `SupabaseConfig::loadEnv()` and `Helper.php::getConfig()` (where present) need host detection.
6. ☐ Server-side: prefer `docker compose up -d <service>` over `restart`.
7. ☐ Verify from outside the VPS using §8 curl commands in the project doc.
8. ☐ If a new failure mode is hit, append to API_CONNECTION.md §9 incident log.

## Cooperative Behavior

When AI in either Claude or Gemini mode lands a change in this scope:

- **Bias to read** the project-root file even if knowledge of the gotchas seems sufficient — the file is updated as new incidents are added.
- **Update the project file's incident log** when a new failure surfaces and is fixed; do NOT update only this governance file (the project doc is authoritative; this is a JIT pointer).
- **Do not duplicate** content from `API_CONNECTION.md` into per-project BLUEPRINTs — they only carry pointers.
