<!-- AI GOVERNANCE: MAX 300 LINES. When adding new task groups, trim oldest from bottom. Auto-trim fires on rot-audit when line count exceeds 300. -->
# Task Group: angel-interior root cleanup, canonical handoff docs, and ignore-file hygiene
scope: Use when cleaning the Angel Interior root, deciding whether legacy wrapper scripts/docs can be removed, or tightening ignore files across root/admin/website without hiding important project assets.
applies_to: cwd=\\?\C:\Users\user\Desktop\angel-interior; reuse_rule=safe for this checkout family while `STATUS.md`, root handoff docs, ignore files, and `website-angel-interior` / `admin-panel-angel` remain the truth sources
## Task 1: Remove stale root docs/scripts and standardize localhost startup guidance, success
### rollout_summary_files
- rollout_summaries/2026-06-03T03-12-29-Pwa0-angel_root_cleanup_and_ignore_hygiene.md (cwd=\\?\C:\Users\user\Desktop\angel-interior, rollout_path=C:\Users\user\.codex\sessions\2026\06\03\rollout-2026-06-03T11-12-29-019e8b77-e02a-7982-851a-1b00ab985674.jsonl, updated_at=2026-06-04T08:09:46+00:00, thread_id=019e8b77-e02a-7982-851a-1b00ab985674, removed stale wrapper scripts/docs and updated root handoff to direct PHP localhost flow)
### keywords
- angel-interior, cleanup, STATUS.md, start.ps1, stop.ps1, AI_START_HERE.md, BLUEPRINT.md, php -S 127.0.0.1:8000 index.php, php-seo-debug.log
## Task 2: Tighten ignore files across root, admin, and website without hiding important files, success
### rollout_summary_files
- rollout_summaries/2026-06-03T03-12-29-Pwa0-angel_root_cleanup_and_ignore_hygiene.md (cwd=\\?\C:\Users\user\Desktop\angel-interior, rollout_path=C:\Users\user\.codex\sessions\2026\06\03\rollout-2026-06-03T11-12-29-019e8b77-e02a-7982-851a-1b00ab985674.jsonl, updated_at=2026-06-04T08:09:46+00:00, thread_id=019e8b77-e02a-7982-851a-1b00ab985674, synchronized root/admin/website ignore rules around safe local noise only)
### keywords
- angel-interior, .gitignore, .codexignore, .claudeignore, .geminiignore, .openaiignore, .dockerignore, .codex-dev-local.log, .tmp-*.json, run-local-*.log, *.temp
## User preferences
- when the user questioned whether `start.ps1` / `stop.ps1` were "really necessary" and asked "can be removed?" -> prefer deleting stale wrapper scripts when a direct current command already exists, instead of preserving duplicate launch helpers [Task 1]
- when the user said to ask if anything is hard to decide -> pause on ambiguous deletions instead of guessing [Task 1]
- when the user asked to clean old/duplicate root `.md` files -> consolidate guidance into canonical state docs instead of keeping redundant root handoff files [Task 1]
- when the user asked to review ignore files in root/admin/website to "save more space" but not affect working space -> only ignore clearly local runtime noise and keep source, docs, migrations, env templates, and shared handoff files visible [Task 2]
## Reusable knowledge
- Related skill: skills/angel-interior-local-dev/SKILL.md
- The current website-local command of record is `php -S 127.0.0.1:8000 index.php` from `website-angel-interior/`; `STATUS.md` was updated so the root handoff points there instead of stale wrappers [Task 1]
- `start.ps1` and `stop.ps1` were stale root wrappers because they hardcoded the old admin port `6007`; they were safe to remove once `STATUS.md` reflected the direct workflow [Task 1]
- `AI_START_HERE.md` and `BLUEPRINT.md` were removed from the root because their active guidance already lived in `STATUS.md`, `DATABASE.md`, `CROSSWALK.md`, `CLAUDE.md`, and `.codex` skills [Task 1]
- `php-seo-debug.log` was left in place only because a running process still held the file lock; the hygiene fix was to ignore it so it stops polluting status checks until the process is stopped [Task 1]
- Root ignore files now cover `**/.tmp-*.json` and `php-seo-debug.log`, and the four AI ignore files were kept in sync so they no longer keep the deleted `BLUEPRINT.md` path visible [Task 2]
- `admin-panel-angel/.gitignore` now ignores `.codex-dev-local.log` plus `.codex/`, `.gemini/`, and `.openai/`; `admin-panel-angel/.dockerignore` was also corrected to the active project name and the same local AI-state folders [Task 2]
- `website-angel-interior/.gitignore` now ignores `run-local-*.log` and `*.temp`, preserving the existing source/docs/migration visibility [Task 2]
## Failures and how to do differently
- If a root temp/debug log like `php-seo-debug.log` is locked, stop the owning process first if physical deletion matters; otherwise ignore it and move on with the cleanup [Task 1]
- After deleting root docs/scripts, update `STATUS.md` and any other handoff references immediately so the workspace does not point at removed files [Task 1]
- Broad multi-file ignore patches can fail when the AI ignore files are not structurally identical -> patch smaller per-file chunks instead of assuming one shared hunk will apply cleanly [Task 2]
- Keep ignore updates conservative: do not add patterns that would hide migrations, docs, env templates, source, or shared handoff files just to reduce workspace noise [Task 2]
# Task Group: angel-interior admin-panel-angel and website-angel-interior auth, paid-download flow, homepage maintenance, and website warning triage
scope: Use when working inside the Angel Interior checkout on deployed auth failures, admin RPC drift, paid-download behavior, homepage/global include fixes, consent/schema work, or website-owned warning cleanup; keep admin and website runtime assumptions separate.
applies_to: cwd=\\?\C:\Users\user\Desktop\angel-interior; reuse_rule=safe for this checkout family while `admin-panel-angel`, `website-angel-interior`, root docs, and `project_notes/ANGEL_INTERIOR_LOCAL_DEV.md` remain current
## Task 1: Diagnose production Supabase login/CORS failure for admin-panel-angel, success
### rollout_summary_files
- rollout_summaries/2026-05-29T01-13-32-adJc-angel_interior_supabase_cors_login_diagnosis.md (cwd=\\?\C:\Users\user\Desktop\angel-interior, rollout_path=C:\Users\user\.codex\sessions\2026\05\29\rollout-2026-05-29T09-13-32-019e714b-2b15-7753-91c8-ecd0abe3a006.jsonl, updated_at=2026-05-29T01:23:16+00:00, thread_id=019e714b-2b15-7753-91c8-ecd0abe3a006, traced login failure to public Supabase host/proxy behavior rather than Vue auth code)
### keywords
- angel-interior, admin-panel-angel, auth.v1.health, auth.v1.token, VITE_SUPABASE_URL, dist/_app.config.js, Cloudflare, db-xin.aisolo.vip, signInWithPassword
## Task 2: Temporary `/checkout/sketchup/` coming-soon checkout flow request for paid SketchUp downloads, uncertain
### rollout_summary_files
- rollout_summaries/2026-05-26T04-17-01-yLXA-website_stripe_coming_soon_checkout_flow.md (cwd=\\?\C:\Users\user\Desktop\angel-interior, rollout_path=C:\Users\user\.codex\sessions\2026\05\26\rollout-2026-05-26T12-17-01-019e6280-1614-70f1-a92c-7d956db49cda.jsonl, updated_at=2026-05-28T02:03:35+00:00, thread_id=019e6280-1614-70f1-a92c-7d956db49cda, rollout aborted before implementation)
### keywords
- website-angel-interior, /checkout/sketchup/, Stripe payment comming soon, 5 sec timer, paid download, Stripe return API, resource handoff, `<turn_aborted>`
## Task 3: Website homepage/global cleanup for Lighthouse, include-order stability, consent/schema refresh, and temp-log cleanup, success
### rollout_summary_files
- rollout_summaries/2026-06-02T03-06-25-82B0-website_angel_interior_lighthouse_consent_schema_lazyload_de.md (cwd=\\?\C:\Users\user\Desktop\angel-interior, rollout_path=C:\Users\user\.codex\sessions\2026\06\02\rollout-2026-06-02T11-06-25-019e864b-f3d6-7841-b58b-ebe0e6de1f1e.jsonl, updated_at=2026-06-02T10:20:25+00:00, thread_id=019e864b-f3d6-7841-b58b-ebe0e6de1f1e, homepage fatal fixed, Lighthouse cleanup stayed surgical, and schema/consent/lazyload updates verified with HTTP 200)
### keywords
- website-angel-interior, lighthouse, heading-order, target-size, label-content-name-mismatch, getWebsiteSlideshows, initData.php, consent mode, angel_cookie_consent_v1, GTM-TTGGQX46, schema.php, lazyload, .tmp-php-8000
## User preferences
- when diagnosing Angel Interior issues, the user asked to "read my angel-interior project root folder .md" first -> start from root handoff docs and project notes before code digging [Task 1]
- when the user pasted the exact console failure and asked "can ai know how this gone wrong?" -> explain the root cause in plain language and tie it to env/build/live-host evidence, not just source-code flow [Task 1]
- when the user pointed at `.env.production` and the live login URL -> treat env files, built artifacts, and live endpoints as one evidence chain before proposing fixes [Task 1]
- when Angel localhost work could change which database stack is active, the user-captured rule was to protect `C:\Users\user\Documents\local-supabase` -> do not silently switch the active local Supabase project to `website-angel-interior` or another stack; confirm first if env/Docker/Supabase routing would change [ad-hoc note]
- when the user said paid download clicks should visit `/checkout/sketchup/`, show "Stripe payment comming soon ..." plus a button, and wait for a "5 sec timer" -> keep temporary checkout UX minimal and transitional rather than building a full payment screen immediately [Task 2]
- when the user said to keep "all the nessasary return api from Stripe" pointing to the resource/download page -> preserve resource-specific handoff data even in temporary checkout flows [Task 2]
- when the user said "no change to images, no reupload images, no change to my design, no change to div section card.." -> keep homepage/global fixes surgical and avoid visual/layout redesign [Task 3]
- when the user said "make sure thefont work esactly the same as now. leave image heavy work stay the same no change now." -> preserve current font appearance and avoid image-heavy changes during performance/accessibility work [Task 3]
- when the user asked for the "3" remaining accessibility fixes only -> do only the smallest targeted fixes when Lighthouse has a short remaining list [Task 3]
- when the user asked that the "ld-json schema meta (old version)" be updated and to "add UI accept the cookies for getting data" -> keep schema/JSON-LD synced to the current site and add small consent gating around existing GTM/GA instead of rebuilding analytics [Task 3]
- in full-access sessions, avoid repetitive `Step X done - confirm or adjust?` pauses unless there is real risk, a destructive action, or a non-obvious product decision [ad-hoc note]
## Reusable knowledge
- Related skill: skills/angel-interior-local-dev/SKILL.md
- Verified localhost startup note lives in `project_notes/ANGEL_INTERIOR_LOCAL_DEV.md`: `run-local.bat` can exit silently when spawned non-interactively, so use direct `php -S 127.0.0.1:8000 index.php` for `website-angel-interior` and `pnpm run dev:local` for `admin-panel-angel`, then verify the website with HTTP 200 [ad-hoc note]
- `C:\Users\user\Documents\local-supabase` is the protected canonical local Supabase Docker project for Angel local work; prefer adapting app/site config to that stack instead of switching the active stack by default [ad-hoc note]
- For production login failures, verify `/auth/v1/health` and an `OPTIONS` preflight first; if the public host returns HTML `404` or generic web-server output, the problem is proxy/host wiring, not the Vue auth store [Task 1]
- The auth path is `login.vue` -> `stores/auth.ts` -> `api/core/auth.ts` -> `api/core/supabase-auth.ts` -> `supabase.auth.signInWithPassword(...)`, and the built admin bundle can hardcode the host in `apps/web-antd/dist/_app.config.js`, so host changes require a rebuild [Task 1]
- For admin user-creation failures with `column "status" does not exist`, inspect SQL migrations before touching Vue; the durable fix was append-only migration `apps/web-antd/src/sql/migrations/064_angel_make_user_rpc_role_status_agnostic.sql`, and `apps/web-antd/src/sql/README.md` should stay aligned with numbered migrations [ad-hoc note]
- Older validated checkout history: the user explicitly wanted paid SketchUp downloads to route through `/checkout/sketchup/`, show a centered "Stripe payment comming soon ..." page, and auto-forward after 5 seconds while keeping Stripe return data compatible with the final download page [Task 2]
- Newer repo state moved beyond placeholder-only checkout: inspect `template/checkout.php`, `template/download.php`, and `lib/downloadData.php` together, confirm Stripe runtime config exists, and verify that unlocked downloads are gated by Stripe session metadata plus `payment_status = paid` [ad-hoc note]
- If the Angel website looks empty while admin/local data exists, trace env file selection, runtime host detection, and the actual Supabase project URL as one evidence chain; localhost can silently read `.env.production` / VPS Supabase instead of local `.env` [ad-hoc note]
- `website-angel-interior/template/home.php` must load `../lib/initData.php` before calling `getWebsiteSlideshows()`; `lib/htmlHead.php` can safely use `require_once __DIR__ . '/initData.php';` to avoid duplicate-load issues [Task 3]
- The low-risk Lighthouse fixes that worked were: remove the extra wrapper click behavior around the menu, enlarge only the real `.btn-menu` hit area to `32x32`, and change `h4.award-name-text` to a non-heading tag while keeping the same class/CSS [Task 3]
- GTM already lived in `lib/htmlHead.php` with the noscript iframe in `lib/header.php`; consent mode was added with default-denied posture and `localStorage` key `angel_cookie_consent_v1`, while the small banner lived in `lib/footer.php` and behavior in `assets/js/main.js` [Task 3]
- `lib/schema.php` was refreshed to match the current site structure with stronger org/contact metadata, breadcrumb support for Privacy/Terms, CollectionPage handling for listing pages, and ItemList support for material pages; verify `/` and `/privacy` after head-level or schema edits [Task 3]
- Most homepage content images already used the lazyload contract (`src` placeholder + `data-src` + `class="lazyload"`); the sponsored modal ad image was the only direct-loaded homepage content image left, and hero slideshow images are CSS backgrounds rather than normal `<img>` lazyload targets [Task 3]
- For a new Angel website/admin content module, the minimum working stack is business table, index/trigger, authenticated RLS, anon website-read policy, explicit SQL `GRANT`s for `authenticated`/`anon`/`service_role` as needed, business permission rows if admin checks them, and storage bucket/path compatibility for uploads [ad-hoc note]
- `permission denied for table awards` was caused by missing PostgreSQL table `GRANT`s, not missing RLS alone; when policies look right but CRUD still fails, check `information_schema.role_table_grants` immediately [ad-hoc note]
- For public website content, an anon-read policy using `angelinterior.is_current_project(project_id)` can overconstrain reads when the query already filters `project_id`; for that pattern, a simpler public policy like `deleted_at IS NULL` may be the correct fit [ad-hoc note]
- For Awards `award_date`, a plain text input plus normalization to the first 4-digit year is safer than a year picker, which caused `2023` to save/display as `2022` or full-date text [ad-hoc note]
- In the Awards module, keep DB columns `title` and `description` stable while remapping admin labels to `Heading` and `Title` when the user wants terminology changes without schema churn [ad-hoc note]
- Temporary `.tmp-php-*` files are debug artifacts from local PHP checks; keep the live `8000` server intact if the user is still testing, stop extra debug servers first, then remove the extra logs [Task 3]
- Treat `website-angel-interior/api/core/.env.production` Stripe keys as sensitive; confirm presence/shape only and never copy values into memory or summaries [ad-hoc note]
- Treat `website-angel-interior/data/resource-downloads.json` as likely runtime/test counter data unless the user explicitly says it is durable business state, and inspect `sendEmail.php`, `send-notification.php`, `template/contact.php`, and `api/Config.php` together before assuming which notification path is active [ad-hoc note]
## Failures and how to do differently
- If `supabase.interiordesign-angel.com/auth/v1/health` returns HTML `404` and preflight lacks usable CORS headers, do not burn time inside the login form or store first; the failure is upstream of real Supabase auth handling [Task 1]
- Repo docs, env files, and built artifacts can disagree on the intended public Supabase endpoint (`db-xin.aisolo.vip` vs `supabase.interiordesign-angel.com`) -> compare all three before changing code or infra assumptions [Task 1]
- If a localhost/env change would repoint Angel from `C:\Users\user\Documents\local-supabase` to another Supabase project, stop and confirm with the user before touching env files, Docker stack selection, or local endpoints [ad-hoc note]
- The rollout for `/checkout/sketchup/` was aborted before implementation, so do not claim any code path was verified from that task alone; restate the intended route, timer, and final download target before editing if the user returns to this exact placeholder request [Task 2]
- Do not assume Angel paid downloads are still placeholder-only; older memory preserved the temporary flow request, but newer work advanced into real Stripe checkout and verified download gating [Task 2][ad-hoc note]
- If admin writes to local Supabase but the website still reads VPS Supabase, missing homepage/about content is expected and is not a frontend rendering bug; verify env selection and active project before debugging templates [ad-hoc note]
- A preload tweak can break the homepage by moving `getWebsiteSlideshows()` ahead of its defining include; after head/preload changes, check include order, run `php -l`, and verify `http://127.0.0.1:8000/` returns `200` [Task 3]
- Do not try to lazyload CSS background hero slides the same way as standard `<img>` tags, and do not delete temp logs before stopping the debug PHP processes that still hold them open [Task 3]
- For website warning cleanup, separate first-party PHP/modal issues from extension or third-party embed noise such as `contentscript.js`, `ObjectMultiplex`, TikTok `webmssdk`, and permissions-policy warnings; patch only the website-owned issues unless the user asks for broader embed changes [ad-hoc note]
# Task Group: .codex routing, benchmark maintenance, model-cost policy, and route-integrity cleanup
scope: Reuse when the user wants `.codex` improved, benchmarked, or audited without breaking routing; especially useful for route-first boot flow, benchmark harness changes, cost-optimization policy work, and final verification passes.
applies_to: cwd=\\?\C:\Users\user\.codex; reuse_rule=safe for the `.codex` knowledge/routing workspace while `codex-router/`, `00_PULSE.md`, `00_CODEX_PERF_BENCHMARK.md`, and the route/audit scripts remain the truth sources
## Task 1: Build the offline benchmark harness and live prompt pack, success
### rollout_summary_files
- rollout_summaries/2026-05-29T08-21-29-dnYJ-codex_benchmark_live_prompts_routing_cleanup.md (cwd=\\?\C:\Users\user\.codex, rollout_path=C:\Users\user\.codex\sessions\2026\05\29\rollout-2026-05-29T16-21-37-019e72d2-f758-76b2-9ae4-e7ef3508d269.jsonl, updated_at=2026-05-29T10:08:42+00:00, thread_id=019e72d2-f758-76b2-9ae4-e7ef3508d269, added deterministic benchmark cases plus live prompt measurement pack)
### keywords
- .codex, codex-router, perf-benchmark.json, live-benchmark-prompts.json, Test-CodexPerfBenchmark.ps1, 00_CODEX_PERF_BENCHMARK.md, comparison tables, speed increase %, rating
## Task 2: Align routing/audit exclusions and remove active legacy-reference noise, success
### rollout_summary_files
- rollout_summaries/2026-05-29T08-21-29-dnYJ-codex_benchmark_live_prompts_routing_cleanup.md (cwd=\\?\C:\Users\user\.codex, rollout_path=C:\Users\user\.codex\sessions\2026\05\29\rollout-2026-05-29T16-21-37-019e72d2-f758-76b2-9ae4-e7ef3508d269.jsonl, updated_at=2026-05-29T10:08:42+00:00, thread_id=019e72d2-f758-76b2-9ae4-e7ef3508d269, audit exclusions aligned with router config and active docs modernized)
### keywords
- Audit-CodexRouting.ps1, router-config.json, raw_memories.md, rollout_summaries, archive exclusion, legacy_ref_count, route integrity, Update-CodexRouting.ps1, skill_path_router.md, ai read .codex skills, ai starting point, ai clean module, ai personality, seo-tables-planner
## Task 3: Regenerate routing and verify the final benchmark/audit state, success
### rollout_summary_files
- rollout_summaries/2026-05-29T08-21-29-dnYJ-codex_benchmark_live_prompts_routing_cleanup.md (cwd=\\?\C:\Users\user\.codex, rollout_path=C:\Users\user\.codex\sessions\2026\05\29\rollout-2026-05-29T16-21-37-019e72d2-f758-76b2-9ae4-e7ef3508d269.jsonl, updated_at=2026-05-29T10:08:42+00:00, thread_id=019e72d2-f758-76b2-9ae4-e7ef3508d269, final audit and benchmark both passed cleanly)
### keywords
- CODEX_DYNAMIC_ROUTING.md, missing_mandatory_count=0, missing_fallback_count=0, missing_roots_count=0, legacy_ref_count=0, Passed: 12, Failed: 0, Safe indexed files: 346, Knowledge routes: 75
## Task 4: Add model-cost optimization policy, boot triggers, cost fields, and live-measurement boundary notes, partial
### rollout_summary_files
- rollout_summaries/2026-06-02T07-58-55-zdnt-codex_model_cost_optimization_policy_benchmark_hook.md (cwd=\\?\C:\Users\user\.codex, rollout_path=C:\Users\user\.codex\sessions\2026\06\02\rollout-2026-06-02T15-59-04-019e8757-bf98-75d2-a0c0-396c8ac6b29b.jsonl, updated_at=2026-06-02T10:20:54+00:00, thread_id=019e8757-bf98-75d2-a0c0-396c8ac6b29b, policy and benchmark schema landed, but real provider token/cost capture still requires API or client-side measurement)
### keywords
- MODEL_COST_OPTIMIZATION_POLICY.md, ai mode lean, ai mode deep, ai reply terse, ai benchmark live, reasoning_effort, cached_tokens, estimated_cost_usd, gpt-5.4, Sonnet 4.6
## User preferences
- when the user asked for "comparison tables before and after" and then asked "how much improve now" / "how to become 10/10 rating", default `.codex` improvement work to measurable before/after reporting with token cost, speed, speed increase %, and rating instead of vague claims [Task 1][Task 3]
- when the user said "ok help me build this", treat benchmark-related requests as implementation work by default and create the actual files/scripts rather than stopping at advice [Task 1]
- when the user emphasized the system should know the "router route path of the changes or merged content or files and folder route", treat route/reference updates as mandatory whenever knowledge paths are merged, renamed, archived, or deleted [Task 2]
- when the user asked for ways to optimize AI usage, token spend, cache usage, and memory/rule design -> turn it into concrete policy files and short trigger routes instead of loose discussion [Task 4]
- when the user repeated "live benchmark run? can ai run?" -> answer directly about measurement limits and give the shortest path to real numbers [Task 4]
- when the user selectively approved only some cleanup items, keep `.codex` maintenance tightly scoped and skip speculative extras that do not clearly improve routing, audit quality, or benchmark results [Task 2][Task 4]
## Reusable knowledge
- The split that worked was deterministic offline checks in `codex-router/perf-benchmark.json` plus real-model measurements in `codex-router/live-benchmark-prompts.json`; keep those lanes separate so routing health and live quality can be judged independently [Task 1]
- `Test-CodexPerfBenchmark.ps1` is the offline runner and should report pass/fail plus rating; benchmark acceptance should require both a passing routing audit and a passing benchmark run, not one without the other [Task 1][Task 3]
- `Audit-CodexRouting.ps1` must share the same exclusion logic as `router-config.json`, or cold-history files like `raw_memories.md`, `rollout_summaries/`, and `archive/` will inflate legacy counts and make the audit noisy [Task 2]
- `2_governance/artifacts/skill_path_router.md` is now an authoritative route-first index for `ai read .codex skills`: match the trigger first, then read only the mapped skill/doc entry point, and fall back to `skills/` directory plus frontmatter `description` only when no trigger matches [Task 2]
- Current router coverage now explicitly includes `ai starting point`, `ai clean module`, `ai personality`, and the `skills/claude/seo-tables-planner/skill.md` sub-skill, so future skill-routing maintenance should update this file before scanning folders or changing path references [Task 2]
- Final verified state before the new policy work was `missing_mandatory_count=0`, `missing_fallback_count=0`, `missing_roots_count=0`, `legacy_ref_count=0`, `Rating: 10/10`, `Passed: 12`, `Failed: 0`, `Safe indexed files: 346`, `Knowledge routes: 75` [Task 3]
- `memories/2_governance/MODEL_COST_OPTIMIZATION_POLICY.md` is the durable home for Lean/Balanced/Deep lane rules; the policy says to reduce context volume, improve route precision, and shorten outputs before increasing reasoning effort [Task 4]
- `00_PULSE.md` remains the single boot read; the new trigger routes `ai mode lean`, `ai mode deep`, `ai reply terse`, and `ai benchmark live` all point to the policy file, so future optimization controls should stay route-first and hot-path minimal [Task 4]
- `codex-router/live-benchmark-prompts.json` v1.1 and `00_CODEX_PERF_BENCHMARK.md` now capture `provider`, `lane`, `reasoning_effort`, `cached_tokens`, and `estimated_cost_usd` in addition to the earlier token/quality/time fields [Task 4]
- There is a hard boundary between local `.codex` validation and provider-side runtime usage measurement: local scripts can verify routing and benchmark structure, but real prompt-token/cached-token/cost data still requires API-based runs or manual client capture [Task 4]
## Failures and how to do differently
- If optional JSON arrays are treated like one empty item in PowerShell, the benchmark runner can fail falsely -> guard optional properties explicitly before iterating [Task 1]
- Broad patches against older memory/governance docs can fail on encoding or line-shape mismatches -> re-read exact live lines and use smaller patches [Task 1]
- If the audit exclude matcher is more complex than the router logic, it can miss exclusions like `memories/raw_memories.md` and overcount legacy refs -> normalize paths and keep the matcher simple enough to mirror `router-config.json` behavior [Task 2]
- For skill-routing upkeep, do not scan the full `skills/` tree first when the trigger is already known; check `2_governance/artifacts/skill_path_router.md` first so added routes like `ai starting point` or `ai personality` do not get missed behind folder noise [Task 2]
- Do not imply that the assistant can self-measure the current Codex or Claude Code session for real billed token/cost usage; once the user asks for true live numbers, pivot immediately to API benchmarking or manual client capture [Task 4]
# Task Group: restore-local documentation, Codex-first orientation, VPS import-only safety, and Supabase schema cleanup
scope: Use when working in the `restore-local` ops workspace, documenting its scripts, or changing how local backups are pushed into VPS; also reuse for safe single-schema deletion guidance inside Supabase SQL Editor.
applies_to: cwd=\\?\C:\Users\user\Documents\restore-local; reuse_rule=safe for this restore workspace while the batch scripts, packaged restore layout, and root README remain the truth sources
## Task 1: Read `.codex` knowledge first, then map `restore-local`, success
### rollout_summary_files
- rollout_summaries/2026-05-28T09-10-01-IND5-restore_local_readme_and_codex_hydration.md (cwd=\\?\C:\Users\user\Documents\restore-local, rollout_path=C:\Users\user\.codex\sessions\2026\05\28\rollout-2026-05-28T17-10-01-019e6dd9-0d7a-7281-ad36-a6163c86d01b.jsonl, updated_at=2026-05-28T09:13:18+00:00, thread_id=019e6dd9-0d7a-7281-ad36-a6163c86d01b, loaded Codex routing before folder analysis)
### keywords
- restore-local, .codex knowledge, 00_CODEX_START_HERE.md, CODEX_DYNAMIC_ROUTING.md, workspace-orientation, secret-like scratch file
## Task 2: Build root README for `restore-local`, success
### rollout_summary_files
- rollout_summaries/2026-05-28T09-10-01-IND5-restore_local_readme_and_codex_hydration.md (cwd=\\?\C:\Users\user\Documents\restore-local, rollout_path=C:\Users\user\.codex\sessions\2026\05\28\rollout-2026-05-28T17-10-01-019e6dd9-0d7a-7281-ad36-a6163c86d01b.jsonl, updated_at=2026-05-28T09:13:18+00:00, thread_id=019e6dd9-0d7a-7281-ad36-a6163c86d01b, created AI-oriented root README)
- rollout_summaries/2026-05-28T09-17-33-enR7-restore_local_readme_and_safe_vps_import_hardening.md (cwd=\\?\C:\Users\user\Documents\restore-local, rollout_path=C:\Users\user\.codex\sessions\2026\05\28\rollout-2026-05-28T17-17-33-019e6ddf-f0df-7311-9f73-b76444e6e4a9.jsonl, updated_at=2026-05-28T09:52:30+00:00, thread_id=019e6ddf-f0df-7311-9f73-b76444e6e4a9, expanded README and preserved packaged-restore distinctions)
### keywords
- README.md, backup-local.bat, restore-local.bat, restore-single.bat, restore-trash.bat, reset & restore-supabase.bat, manifest.json, vps comand.txt, p%
## Task 3: Harden local/VPS restore behavior and remove blocking pauses, partial
### rollout_summary_files
- rollout_summaries/2026-05-28T09-17-33-enR7-restore_local_readme_and_safe_vps_import_hardening.md (cwd=\\?\C:\Users\user\Documents\restore-local, rollout_path=C:\Users\user\.codex\sessions\2026\05\28\rollout-2026-05-28T17-17-33-019e6ddf-f0df-7311-9f73-b76444e6e4a9.jsonl, updated_at=2026-05-28T09:52:30+00:00, thread_id=019e6ddf-f0df-7311-9f73-b76444e6e4a9, kept option 3 import-only and removed nested-batch pause blocking)
### keywords
- NO_PAUSE, SAFE MODE aborted, import-only mode never replaces existing VPS schemas, stop half way, call backup-local.bat, selected schema SQL validation
## Task 4: Investigate schema removal and Supabase UI alerts, partial
### rollout_summary_files
- rollout_summaries/2026-05-28T09-17-33-enR7-restore_local_readme_and_safe_vps_import_hardening.md (cwd=\\?\C:\Users\user\Documents\restore-local, rollout_path=C:\Users\user\.codex\sessions\2026\05\28\rollout-2026-05-28T17-17-33-019e6ddf-f0df-7311-9f73-b76444e6e4a9.jsonl, updated_at=2026-05-28T09:52:30+00:00, thread_id=019e6ddf-f0df-7311-9f73-b76444e6e4a9, separated UI noise from actual schema-delete results and clarified case-sensitive cleanup)
### keywords
- Failed to generate title, SQL Editor, DROP SCHEMA CASCADE, angelInterior, angelinterior, table_schema, pg_toast, quoted identifiers
## User preferences
- when the user said "ai read .codex knowledge first then do above request in chat" -> first hydrate the local Codex routing/knowledge context before analyzing the workspace [Task 1]
- when the user asked for the README to help "ai to quickly understanding this restore-local folder" and to "write down every information... save in a new files call readme.md" -> default to a root-level AI-oriented guide with a step-by-step flow map plus status/maintenance notes [Task 1][Task 2]
- when the user repeatedly clarified `restore-single.bat` is not the same as `reset & restore-supabase.bat`, preserve the distinction between local packaged restore and VPS sync in future guidance [Task 3]
- when the user wanted option 3 to "only restore 1 schema from local into vps... will not touch a single content in vps what project unrelated", default to import-only or hard abort, not replace mode [Task 3]
- when the user asked for the safest way to remove only one schema and not touch other projects, prefer SQL Editor plus explicit SQL over broad UI actions [Task 4]
## Reusable knowledge
- `restore-local` is an operations workspace for Supabase backup/restore, not app source [Task 1][Task 2]
- `.codex` startup/routing docs are the right first read when the user explicitly asks to read Codex knowledge before continuing; route-first selective loading mattered here [Task 1]
- `backup-local.bat` creates timestamped backups under `C:\Users\user\Documents\supabase-backup-restore`, `restore-local.bat` is the destructive full local restore, `restore-single.bat` is the safer targeted restore path, and `reset & restore-supabase.bat` is the VPS/local sync orchestrator [Task 2]
- The packaged `trash` snapshot under `restore-single\trash-20260522-140801\trash-20260522-140801` includes `01-schema.sql` through `08-public-functions.sql`, `edge-functions/`, `storage-files/`, and `manifest.json` with `projectName=Trash`, `schema=trash`, and `projectId=fddcc8d4-2f70-4cdc-b5a4-b2fee7b9d8f6` [Task 2]
- `vps comand.txt` is the shell payload that installs `/home/zetatech/full_backup.sh` on the VPS and backs up full SQL, custom schemas, auth, storage metadata, physical files, grants, env, and metadata [Task 2]
- A root file named `p%` contains secret-like material and should be excluded from future summaries/docs [Task 1][Task 2]
- Final saved option 3 behavior is import-only: if the target schema already exists on VPS, abort instead of replacing it, and validate extracted schema SQL so only the selected schema is pushed [Task 3]
- A Supabase Studio popup like `Failed to generate title: API error happened while trying to communicate with the server.` is likely UI/network/session noise, not proof that SQL failed [Task 4]
- When cleaning duplicate-casing schemas, quoted identifiers are case-sensitive: `"angelInterior"` and `"angelinterior"` are different schemas, even if they carry the same table set [Task 4]
## Failures and how to do differently
- The folder contained a loose scratch file with secret-like values (`p%`); do not echo its contents into docs or memory [Task 1]
- `restore-trash.bat` was path-stale relative to the actual packaged snapshot -> verify the real `restore-single\...` package path before trusting hardcoded restore scripts [Task 2]
- If a parent batch file stops "half way", inspect child-script `pause` / interactive prompts before assuming the VPS or SQL path failed; here the blocker was `backup-local.bat` pausing inside a parent flow [Task 3]
- The root mixes `install-supabase\supabase\docker` and `local-supabase\supabase` path conventions, so future edits should re-check hardcoded paths before assuming portability [Task 2]
- Do not use project-linked delete scripts until exact schema casing, dependency shape, and live row presence are confirmed; the initial delete plan did not match a VPS that had both `angelInterior` and `angelinterior` and no matching `public.project` row [Task 4]
- `information_schema.tables` uses `table_schema`, not `schema_name` [Task 4]
# Task Group: supabase-project-backup-restore Angel Interior migration-readiness and backup completeness
scope: Use when the user wants the local Angel Interior Supabase project audited or packed for VPS migration; this covers schema/bucket/policy naming drift, local completeness checks, and the final backup artifact to trust.
applies_to: cwd=\\?\C:\Users\user\Documents\supabase-project-backup-restore; reuse_rule=safe for this backup workspace and the paired `C:\Users\user\Documents\local-supabase` environment while the same local container naming and backup scripts remain in use
## Task 1: Diagnose and repair local Angel project backup/migration setup, success
### rollout_summary_files
- rollout_summaries/2026-05-28T10-11-02-xAs7-angelinterior_local_supabase_backup_storage_config_fix.md (cwd=\\?\C:\Users\user\Documents\supabase-project-backup-restore, rollout_path=C:\Users\user\.codex\sessions\2026\05\28\rollout-2026-05-28T18-11-10-019e6e10-e86a-73a1-9ba8-2119cccef3d7.jsonl, updated_at=2026-05-28T10:25:39+00:00, thread_id=019e6e10-e86a-73a1-9ba8-2119cccef3d7, repaired schema-name, storage, and config capture mismatches before final backup)
### keywords
- supabase-project-backup-restore, angelinterior, public.project.schema_name, storage.buckets.id, angel-interior, angel_interior_auth_insert, custom_access_token_hook, config.toml, verify-backup.sh
## Task 2: Confirm local completeness for migration readiness, success
### rollout_summary_files
- rollout_summaries/2026-05-28T10-11-02-xAs7-angelinterior_local_supabase_backup_storage_config_fix.md (cwd=\\?\C:\Users\user\Documents\supabase-project-backup-restore, rollout_path=C:\Users\user\.codex\sessions\2026\05\28\rollout-2026-05-28T18-11-10-019e6e10-e86a-73a1-9ba8-2119cccef3d7.jsonl, updated_at=2026-05-28T10:25:39+00:00, thread_id=019e6e10-e86a-73a1-9ba8-2119cccef3d7, validated local schema, storage, policies, and auth hook state)
### keywords
- moving from local to vps soon, complete those missing policies and others setting, supabase_db_local-supabase, supabase_storage_local-supabase, api.schemas, storage.objects 449, 43 app policies, Verification PASSED
## User preferences
- when the user said they were "moving from local to vps soon" and wanted the local setup "complete", treat it as a migration-readiness audit, not a narrow backup symptom [Task 1][Task 2]
- when the user asked to "complete those missing policies and others setting", proactively audit DB schema, storage, config, and policies together before declaring the backup ready [Task 1]
## Reusable knowledge
- For this Angel project, the three identities are distinct: business schema `angelinterior`, storage bucket `angel-interior`, and storage policy prefix `angel_interior_*`; backup/restore logic should not assume they match [Task 1]
- Compare `public.project.schema_name` with `information_schema.schemata` before backing up; the original failure came from `schema_name = angel` while the real schema was `angelinterior` [Task 1]
- The backup flow should also check the shared local config path `C:\Users\user\Documents\local-supabase\supabase\config.toml` when per-project config is absent [Task 1]
- Verified healthy local state included `public.custom_access_token_hook`, RLS enabled on all Angel tables, 43 app policies, 449 storage objects, and `angelinterior` exposed in `api.schemas` [Task 1][Task 2]
- The final backup artifact to trust for VPS migration is `local-backups/angelinterior-20260528-182503` [Task 1][Task 2]
## Failures and how to do differently
- If storage warnings appear, do not assume the bucket name and policy prefix match the business schema; resolve schema name, bucket id, and policy prefix independently [Task 1]
- In this Windows/Git Bash environment, the too-clever `psql`-heavy resolver was less reliable than direct container queries plus simpler shell handling [Task 1]
- A backup is not "complete" just because SQL dumped; confirm storage files, storage policies, shared config, and verification output too [Task 1][Task 2]
# Task Group: trash-container-app schema alignment, live-data audits, and map/order UX cleanup
scope: Use when the user wants `trash-container-app` aligned to the latest SQL contract, especially for `web-admin-app`, `admin-panel-trash`, and local Supabase-backed map/order behavior; keep docs, schema, and live-data verification tied together.
applies_to: cwd=\\?\C:\Users\user\Desktop\trash-container-app; reuse_rule=safe for this checkout while `STATUS.md`, `DATABASE.md`, `web-admin-app`, `admin-panel-trash`, and the local `trash` Supabase schema remain the truth sources
## Task 1: Read `.codex` knowledge, refresh root docs, and align `DATABASE.md` to the latest `trash` SQL, success
### rollout_summary_files
- rollout_summaries/2026-05-25T07-58-16-GDPj-trash_container_app_map_and_schema_synchronization.md (cwd=\\?\C:\Users\user\Desktop\trash-container-app, rollout_path=C:\Users\user\.codex\sessions\2026\05\25\rollout-2026-05-25T15-58-16-019e5e24-4782-7c71-9092-7ebf267a3d69.jsonl, updated_at=2026-05-26T03:43:29+00:00, thread_id=019e5e24-4782-7c71-9092-7ebf267a3d69, root docs and newer SQL were used as the authority before UI cleanup)
### keywords
- trash-container-app, STATUS.md, DATABASE.md, SYSTEM_MAP.md, PATH_ROUTER.md, admin-panel-trash/CLAUDE.md, web-admin-app/README.md, trash.orders.latitude, trash.orders.longitude, failed
## Task 2: Audit `web-admin-app` for dummy vs live Supabase usage and replace schema-misaligned map/order UI, success
### rollout_summary_files
- rollout_summaries/2026-05-25T07-58-16-GDPj-trash_container_app_map_and_schema_synchronization.md (cwd=\\?\C:\Users\user\Desktop\trash-container-app, rollout_path=C:\Users\user\.codex\sessions\2026\05\25\rollout-2026-05-25T15-58-16-019e5e24-4782-7c71-9092-7ebf267a3d69.jsonl, updated_at=2026-05-26T03:43:29+00:00, thread_id=019e5e24-4782-7c71-9092-7ebf267a3d69, page-by-page dummy-data audit led to live bin-size filtering and neutral fallbacks)
### keywords
- web-admin-app, MapView.vue, OrderDetailModal.vue, CustomersView.vue, ProfileView.vue, PayrollView.vue, DriversView.vue, driverTasksStore.items, bin_sizes, green, blue, npm.cmd run type-check
## Task 3: Seed local Johor Bahru coordinates and align `admin-panel-trash` order/map UX to live data, success
### rollout_summary_files
- rollout_summaries/2026-05-25T07-58-16-GDPj-trash_container_app_map_and_schema_synchronization.md (cwd=\\?\C:\Users\user\Desktop\trash-container-app, rollout_path=C:\Users\user\.codex\sessions\2026\05\25\rollout-2026-05-25T15-58-16-019e5e24-4782-7ebf267a3d69.jsonl, updated_at=2026-05-26T03:43:29+00:00, thread_id=019e5e24-4782-7c71-9092-7ebf267a3d69, local coordinate seeding plus desktop order form/detail/list map-readiness improvements)
### keywords
- admin-panel-trash, order-form.vue, order-detail.vue, order-list.vue, Coordinate Helper, Open Map, Map Status, hasCoordinates, supabase db query --local, ORD-TR-0001, Johor Bahru, EPERM, --ignoreDeprecations
## User preferences
- when the user said `ai read .codex knowledge` -> route-first selective loading; do not broad-crawl knowledge trees before working in this repo [Task 1]
- when the user said `read my project trash-container-app 3x project folder inside .md and also read root .md to understand what the latest situation` -> read root docs plus each project folder's top-level markdown before code spelunking [Task 1]
- when the user asked which pages were `not conencted to supabase and still connect to dummy data in vue` and wanted `very accurate data` that `really fit is suitable to use in pages` -> do a page-by-page live-vs-dummy audit and distinguish real data paths from presentation-only copy [Task 2]
- when the user pasted newer SQL and asked to update `database.md` to use it -> treat the newest user-provided schema as the authority for app/UI checks [Task 1][Task 2]
- when the user said `use my database setting to filter this` -> derive UI filters from live schema-backed values, not arbitrary categories like `green` / `blue` [Task 2]
- when the user kept confirming each cleanup and said `yes can try to do so` for coordinate UX -> prefer small, verifiable map/order improvements over one large speculative rewrite [Task 2][Task 3]
## Reusable knowledge
- `STATUS.md` and `DATABASE.md` were the root truth docs for current state; `PROGRESS.md` lagged and the mobile app README files were mostly boilerplate [Task 1]
- `trash.orders.latitude` and `trash.orders.longitude` are real scalar `numeric` fields; `deliveryAddress` is display data, while coordinates are the map-specific data needed for pins [Task 1][Task 3]
- Local Supabase verification worked through `supabase db query --local` with targeted SQL files, and the Johor Bahru test rows proved the map data path is usable for `ORD-TR-0001` through `ORD-TR-0005` [Task 3]
- In `web-admin-app`, the remaining fake/live mismatches were mostly static copy and presentation layers; the important cleanup was replacing hardcoded `green` / `blue` map filters with live `bin_sizes` reached through `driverTasks` joins [Task 2]
- `OrderDetailModal.vue` had fake fallback values like `012-345 6789`, `Unknown Customer`, `Not Assigned`, and `Location Pending`; neutral `-` fallbacks were safer than dummy-seeming text [Task 2]
- The desktop admin already preserved `deliveryAddress`, `latitude`, and `longitude`; the schema-compatibility gap was that order status also needed `failed` [Task 3]
- `Coordinate Helper`, `Map Status`, `Open Map`, and a list-level `Map` readiness column were all valid UX extensions because they write/read the real coordinate fields instead of introducing a side channel [Task 3]
## Failures and how to do differently
- `trash-container-app` is not itself a git repo root, so `git status` at the workspace root can fail and is not a reliable first check there [Task 1]
- If root docs disagree, trust `STATUS.md` ahead of `PROGRESS.md` for current-state routing [Task 1]
- `supabase db query` on this machine is effectively one statement per file/statement path -> split update and verification into separate SQL files, quote camelCase identifiers like `"orderNo"` / `"deliveryAddress"`, and cast numerics to `text` if the CLI hits `unknown oid 2206` during verification [Task 3]
- Direct patches can miss when file encoding or exact text differs from the rendered snippet -> re-read exact live lines or replace the affected file wholesale when incremental patching keeps failing [Task 1][Task 2]
- `pnpm typecheck` in `admin-panel-trash/apps/web-antd` had pre-existing workspace/tooling failures (`invalid --ignoreDeprecations`, `EPERM` creating `.vue-global-types`), so do not misattribute those to small order-status or map-UX edits [Task 3]
