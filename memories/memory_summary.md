v1

## User Profile
The user is actively refining a local Codex memory/routing system while also shipping hands-on work across `angel-interior`, `VIPBillion`, `trash-container-app`, and Supabase backup/restore tooling. They want agents to implement, verify, and preserve operational context instead of stopping at abstract advice. They repeatedly care about the real evidence chain: read the right docs first when asked, then check env/build/runtime behavior, then change code. They prefer live-data alignment over dummy UI, schema-backed checks over assumptions, and small verifiable improvements over broad speculative rewrites. In website/admin bootstrap work, they like a tiny brief expanded into root docs, reusable startup routes, and verified working paths rather than repeated rediscovery. In website work, they often set preservation constraints very explicitly: keep design, images, and font behavior the same unless they ask otherwise. In ops work, they are sensitive to destructive scope and prefer import-only VPS sync or explicit SQL over broad replacement/UI actions. They also use Codex to improve Codex itself, and tend to want concrete policy files, measurable before/after results, and route-safe updates rather than loose recommendations. Some Angel implementation-state notes come from extension notes rather than rollout summaries and are marked `[ad-hoc note]`.

## User preferences
- When the user explicitly says to read `.codex` knowledge first, hydrate Codex routing/startup context before touching the workspace.
- When the user asks to read project `.md` files first, start with root truth docs plus each relevant project folder's top-level markdown before code spelunking.
- For new project bootstraps, prefer turning a small brief into root docs plus reusable startup routing instead of asking the user to restate setup context.
- For `.codex` improvements, default to measurable before/after reporting with token cost, speed, speed increase %, and rating.
- When the user asks how to optimize AI usage, token spend, or cache usage, turn it into concrete policy files and short trigger routes instead of loose discussion.
- When the user says "help me build this", create the real files/scripts instead of stopping at recommendations.
- When copied admin UI still shows the old project name, treat title/sidebar rebranding as part of the real fix.
- In `angel-interior`, start from root handoff docs and project notes before deep code digging.
- In `angel-interior` cleanup work, if a direct current command exists, prefer removing stale wrapper scripts/docs instead of preserving duplicate launch helpers.
- For Angel deployment/debug issues, treat env files, built artifacts, and live endpoints as one evidence chain before proposing fixes.
- For Angel local Supabase work, treat `C:\Users\user\Documents\local-supabase` as the protected default stack and confirm before any change that would repoint localhost to another Supabase project [ad-hoc note]
- In Angel ignore-file cleanup, only hide clearly local runtime noise; keep source, docs, migrations, env templates, and shared handoff files visible.
- In Angel website cleanup, honor preservation wording like "no change to images... no change to my design" and "make sure thefont work esactly the same as now" by keeping fixes surgical and avoiding visual redesign.
- When Lighthouse or site cleanup has a short remaining list, do only the smallest targeted fixes instead of broad refactors.
- For app audits, prefer page-by-page "dummy vs Supabase/live" analysis and use the newest user-provided SQL/schema as the authority.
- When cleaning UI tied to live data, prefer small verified steps and schema-driven values instead of arbitrary placeholders or filters.
- For restore/VPS schema work, preserve the distinction between local packaged restore and VPS sync, and default to import-only or explicit SQL instead of replace/broad UI actions.
- When documenting a folder for future AI use, produce a step-by-step flow map plus status/maintenance notes, not just a terse file list.
- In full-access sessions, avoid repetitive `Step X done - confirm or adjust?` pauses unless there is real risk or a non-obvious decision [ad-hoc note]

## General Tips
- `run-local.bat` is not the reliable non-interactive launcher for Angel website localhost; use direct `php -S 127.0.0.1:8000 index.php` in a dedicated PowerShell window and verify with HTTP 200 [ad-hoc note]
- For `ai read .codex skills` or similar skill-routing requests, check `2_governance/artifacts/skill_path_router.md` first and only fall back to scanning `skills/` frontmatter when no trigger matches.
- For Angel production Supabase login failures, check `/auth/v1/health` and an `OPTIONS` preflight before investigating Vue auth code.
- If Angel localhost content looks empty, verify whether the website is reading local `.env` or falling back to `.env.production` / VPS Supabase before debugging frontend rendering [ad-hoc note]
- For Angel admin user-creation RPC errors mentioning `public.role.status`, inspect SQL migrations before Vue and keep numbered migration docs aligned with fixes like `064_angel_make_user_rpc_role_status_agnostic.sql` [ad-hoc note]
- For Angel content modules, remember that working RLS is not enough: check SQL `GRANT`s, anon-read policy shape, permission rows, and storage path compatibility too; `permission denied for table awards` came from missing table grants [ad-hoc note]
- For Awards `award_date`, plain text year input plus first-4-digit normalization is safer than a year picker; keep UI label remaps (`title` -> `Heading`, `description` -> `Title`) in the admin layer instead of changing DB columns [ad-hoc note]
- Do not assume Angel paid downloads are still placeholder-only; inspect `template/checkout.php`, `template/download.php`, and `lib/downloadData.php` together and verify Stripe session metadata gating before answering [ad-hoc note]
- After Angel head/preload/homepage edits, check include order for `getWebsiteSlideshows()`, run `php -l`, and verify `http://127.0.0.1:8000/` returns 200.
- Treat Stripe keys in `website-angel-interior/api/core/.env.production` as sensitive: confirm presence/shape only, never copy values into memory or summaries [ad-hoc note]
- In `.codex`, keep offline benchmark validation separate from real provider-cost measurement; real token/cached-token/cost numbers still need API or client-side capture.
- In `trash-container-app`, trust `STATUS.md` over stale `PROGRESS.md`, and treat `orders.latitude` / `orders.longitude` as real map fields rather than UI-only extras.
- `supabase db query --local` on this machine is easiest to verify with one statement per SQL file; quote camelCase identifiers and cast numerics to `text` if the CLI hits `unknown oid 2206`.
- In Angel backup/migration work, do not assume schema name, storage bucket id, and storage policy prefix match; `angelinterior`, `angel-interior`, and `angel_interior_*` were distinct.
- In nested batch flows, check child-script `pause` prompts early; `backup-local.bat` blocking a parent script looked like a restore failure but was only an interactive stop.
- In VIPBillion/local Supabase REST work, `PGRST301` or `42501` usually means the key/project-header/write-model contract is wrong; verify the current `sb_publishable_...` key, `X-Project-Id`, and whether backend writes should use the service key.
- If a settings/UI rewrite is heading the wrong way and the user says stop, preserve state and wait for the next session instead of continuing to polish it.

## What's in Memory

### C:\Users\user\Desktop\VIPBillion

#### 2026-06-05

- VIPBillion bootstrap, verified website order path, and paused settings/title rebrand: information.md, PROJECT_INFO.md, PROJECT_KNOWLEDGE.md, website-vipbillion/api, vipbillion.orders, VB-TEST-009, vipbillion.settings, Angel Interior Admin, slidemenu title
  - desc: Search this first for `cwd=C:\Users\user\Desktop\VIPBillion` when the user wants new-project bootstrap context, the root doc stack, PHP website-to-Supabase order creation, or the unfinished settings/title rebrand state.
  - learnings: the workspace bootstraps from route-first `.codex` reads plus root docs, backend order writes were verified through the PHP API into `vipbillion.orders`, and the settings rewrite should not continue without re-confirming the desired UI shape.

### C:\Users\user\Desktop\angel-interior

#### 2026-06-04

- Angel root cleanup, canonical localhost startup, and ignore-file hygiene: STATUS.md, start.ps1, stop.ps1, AI_START_HERE.md, BLUEPRINT.md, .gitignore, .codexignore, .claudeignore, .geminiignore, .openaiignore, php-seo-debug.log
  - desc: Search this first for `cwd=C:\Users\user\Desktop\angel-interior` when the user wants root cleanup, asks whether old scripts/docs can be removed, or wants ignore files tightened without hiding important project files.
  - learnings: the canonical website-local flow is direct `php -S 127.0.0.1:8000 index.php`, stale root wrappers/docs can be removed once `STATUS.md` is updated, and ignore changes should stay limited to safe local noise.

#### 2026-06-02

- Angel website homepage/global cleanup plus current paid-download/admin state: lighthouse, getWebsiteSlideshows, initData.php, angel_cookie_consent_v1, GTM-TTGGQX46, 064_angel_make_user_rpc_role_status_agnostic.sql, checkout.php, download.php
  - desc: Search this first for `cwd=C:\Users\user\Desktop\angel-interior` when work touches homepage fatals, Lighthouse cleanup, schema/consent updates, temp PHP logs, admin RPC drift, current Stripe download flow, protected local Supabase routing, or Awards-module website/admin mismatches.
  - learnings: keep Angel fixes surgical, verify include order and local HTTP 200 after head/homepage edits, inspect SQL migrations before Vue for `status` RPC errors, protect `local-supabase` from silent repointing, and do not assume Awards/content-module failures are frontend-only or paid downloads are still placeholder-only [ad-hoc note]

### C:\Users\user\.codex

#### 2026-06-02

- `.codex` model-cost policy, skill trigger routing, benchmark schema, and audit baseline: MODEL_COST_OPTIMIZATION_POLICY.md, skill_path_router.md, ai read .codex skills, ai mode lean, ai benchmark live, reasoning_effort, cached_tokens, estimated_cost_usd, Test-CodexPerfBenchmark.ps1
  - desc: Search this first for `cwd=C:\Users\user\.codex` when work involves route-safe optimization policy changes, benchmark schema updates, authoritative skill trigger mapping, or explaining what live measurement can and cannot prove.
  - learnings: keep PULSE as the single boot read, route skill requests through `skill_path_router.md` before scanning folders, expose optimization through short triggers, preserve the verified 10/10 audit/benchmark baseline, and pivot to API/manual capture for real provider cost numbers.

### Older Memory Topics

#### C:\Users\user\Desktop\angel-interior

- Earlier `/checkout/sketchup/` placeholder request for paid SketchUp downloads: /checkout/sketchup/, Stripe payment comming soon, 5 sec timer, Stripe return API, `<turn_aborted>`
  - desc: Use this when the user refers to the original temporary placeholder checkout idea; applies to `cwd=C:\Users\user\Desktop\angel-interior` and should be read alongside newer Stripe-flow state so old placeholder history is not mistaken for current implementation.

#### C:\Users\user\Desktop\trash-container-app

- `trash-container-app` schema sync plus live map/order UX cleanup: STATUS.md, DATABASE.md, web-admin-app, admin-panel-trash, MapView.vue, order-form.vue, order-detail.vue, supabase db query --local
  - desc: Search this first for `cwd=C:\Users\user\Desktop\trash-container-app` when work needs docs-first orientation, dummy-vs-live page audits, local map-coordinate verification, or desktop/admin map-order cleanup.

#### C:\Users\user\Documents\restore-local

- `restore-local` README, `.codex`-first hydration, import-only VPS sync, and safe schema cleanup: .codex knowledge, README.md, backup-local.bat, restore-single.bat, reset & restore-supabase.bat, NO_PAUSE, Failed to generate title, table_schema
  - desc: Use this for `cwd=C:\Users\user\Documents\restore-local` orientation, nested batch-script restore debugging, or safe one-schema delete guidance; keep `restore-single.bat` distinct from VPS sync and default option 3 to import-only.

#### C:\Users\user\Documents\supabase-project-backup-restore

- Angel local Supabase migration-readiness audit and backup completeness: public.project.schema_name, angelinterior, angel-interior, angel_interior_*, config.toml, custom_access_token_hook, local-backups/angelinterior-20260528-182503
  - desc: Use this before VPS migration or when local Angel backup warnings mention schema/storage mismatches; applies to `cwd=C:\Users\user\Documents\supabase-project-backup-restore` and covers the final backup artifact to trust.
