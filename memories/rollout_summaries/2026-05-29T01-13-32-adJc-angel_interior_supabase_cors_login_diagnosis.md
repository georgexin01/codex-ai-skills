thread_id: 019e714b-2b15-7753-91c8-ecd0abe3a006
updated_at: 2026-05-29T01:23:16+00:00
rollout_path: C:\Users\user\.codex\sessions\2026\05\29\rollout-2026-05-29T09-13-32-019e714b-2b15-7753-91c8-ecd0abe3a006.jsonl
cwd: \\?\C:\Users\user\Desktop\angel-interior

# Diagnosed Angel Interior admin login failure as a production Supabase host/proxy misconfiguration, after reading the repo’s root docs and tracing the auth flow.

Rollout context: The user asked Codex to read the Angel Interior project root markdown docs and explain why the deployed admin login at `https://admin.interiordesign-angel.com` could not fetch Supabase auth from `https://supabase.interiordesign-angel.com/auth/v1/token?grant_type=password` (CORS / Failed to fetch / net::ERR_FAILED). The conversation was in `C:\Users\user\Desktop\angel-interior` and touched `admin-panel-angel` plus the root project docs.

## Task 1: Read project root docs and diagnose production Supabase login failure

Outcome: success

Preference signals:

- The user explicitly asked to “read my angel-interior project root folder .md” and wanted the explanation grounded in the repo docs before diagnosing the auth error -> future agents should start from the repo’s root handoff docs instead of jumping straight to code or guesses.
- The user included the exact browser console error and asked “can ai know how this gone wrong?” -> future agents should explain the root cause in plain language and connect it to deployment/proxy config, not just describe the auth stack.
- The user pointed to `.env.production` and the live URL they were using -> future agents should treat the active production env as first-class evidence and compare it against docs and built artifacts.

Key steps:

- Read `AI_START_HERE.md`, `STATUS.md`, `SOP_PUBLISH_ANGEL_ADMIN_VIA_CLOUDFLARE_TUNNEL.md`, `admin-panel-angel/DEPLOYMENT.md`, and `admin-panel-angel/SUPABASE.md` to establish the project’s intended root docs, active implementation target, and published Supabase endpoint guidance.
- Confirmed the repo’s active admin implementation target is `admin-panel-angel`, while `admin-panel-trash` is reference-only.
- Inspected `admin-panel-angel/apps/web-antd/.env.production` and `.env.development`; both pointed `VITE_GLOB_API_URL` and `VITE_SUPABASE_URL` at `https://supabase.interiordesign-angel.com`.
- Checked the built output under `admin-panel-angel/apps/web-antd/dist/_app.config.js` and confirmed the production bundle hardcoded `https://supabase.interiordesign-angel.com`, so the deployed build was indeed using that host.
- Traced the auth flow in code: `apps/web-antd/src/api/core/auth.ts` routes login to `supabaseLoginApi` when `VITE_NITRO_MOCK=false`, and `apps/web-antd/src/api/core/supabase-auth.ts` calls `supabase.auth.signInWithPassword(...)`.
- Used GitNexus to trace the auth path and confirm the key symbols: `authLogin`, `loginApi`, and `supabaseLoginApi`.
- Live-checked the host: `curl -I https://supabase.interiordesign-angel.com/auth/v1/health` returned `404 Not Found` HTML, while `OPTIONS` to `/auth/v1/token?grant_type=password` returned `200` but without a proper Supabase CORS response; this matched the browser’s CORS failure.
- Also checked `https://db-xin.aisolo.vip/auth/v1/health` and got Cloudflare `530` / `1033`, showing the documented alternate public endpoint was also unhealthy at the time.

Failures and how to do differently:

- The problem was not in the login form or the Supabase JS call itself; the failure happened before the request reached real Supabase auth handling.
- The misconfiguration was at the public host / reverse-proxy layer: `supabase.interiordesign-angel.com` behaved like a normal web server/cPanel site rather than a Supabase gateway, so `/auth/v1/health` 404’d and the browser preflight had no `Access-Control-Allow-Origin`.
- The build was likely stale relative to any host change unless `apps/web-antd/dist` was rebuilt after updating env values, because the bundle already embedded the current endpoint.
- The repo documentation itself was inconsistent about the intended public endpoint (`db-xin.aisolo.vip` in docs vs `supabase.interiordesign-angel.com` in env/bundle), so future troubleshooting should always compare docs, env, and built artifacts together before changing code.

Reusable knowledge:

- For production Supabase login failures in this repo, verify the public endpoint first with `/auth/v1/health` and an `OPTIONS` preflight before investigating app code.
- If `/auth/v1/health` returns HTML 404 or a generic web-server response, the issue is the proxy/host wiring, not the Vue auth store.
- The auth path is `login.vue` -> `stores/auth.ts` -> `api/core/auth.ts` -> `api/core/supabase-auth.ts` -> `supabase.auth.signInWithPassword(...)`.
- The built admin bundle can hardcode the Supabase host in `apps/web-antd/dist/_app.config.js`, so production URL changes require a rebuild.
- The repo’s published-doc guidance includes `SOP_PUBLISH_ANGEL_ADMIN_VIA_CLOUDFLARE_TUNNEL.md` and `admin-panel-angel/DEPLOYMENT.md`; both are useful cross-checks when the live host fails.

References:

- [1] `admin-panel-angel/apps/web-antd/.env.production` showed `VITE_SUPABASE_URL=https://supabase.interiordesign-angel.com` and `VITE_GLOB_API_URL=https://supabase.interiordesign-angel.com`.
- [2] `admin-panel-angel/apps/web-antd/dist/_app.config.js` contained `window._VBEN_ADMIN_PRO_APP_CONF_={"VITE_GLOB_API_URL":"https://supabase.interiordesign-angel.com"}`.
- [3] `admin-panel-angel/apps/web-antd/src/api/core/auth.ts` routes to Supabase mode when `VITE_NITRO_MOCK` is false.
- [4] `admin-panel-angel/apps/web-antd/src/api/core/supabase-auth.ts` calls `supabase.auth.signInWithPassword({ email: username, password })`.
- [5] `curl -I https://supabase.interiordesign-angel.com/auth/v1/health` returned `HTTP/1.1 404 Not Found` with `Server: cloudflare`.
- [6] `curl -i -X OPTIONS "https://supabase.interiordesign-angel.com/auth/v1/token?grant_type=password" ...` returned `HTTP/1.1 200 OK` but the browser still reported CORS failure because the response lacked the expected `Access-Control-Allow-Origin` header.
- [7] `curl -I https://db-xin.aisolo.vip/auth/v1/health` returned `HTTP/1.1 530 <none>` and `error code: 1033`, indicating that alternate endpoint was also down at the time.
