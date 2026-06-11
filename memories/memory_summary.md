v1

## User Profile
The user uses Codex as both a delivery agent and a local memory/routing maintainer. Their recurring work centers on `VIPBillion`, `angel-interior`, `.codex`, and Supabase backup/restore toolchains. They want real implementation, verification, and durable handoff memory rather than abstract advice. When they ask to understand a project, they expect docs-first orientation from the real root truth files, then runtime/code tracing that explains how the system actually behaves. They care about schema-backed behavior, local-vs-production env correctness, safe handling of Docker/Supabase state, and practical explanations of script/data flows. In UI and website tasks they often give explicit preservation boundaries and prefer surgical fixes. When they say to skip or stop, they want the agent to stop immediately rather than continue polishing the wrong direction. Some environment safety constraints come from extension notes and are marked `[ad-hoc note]`.

## User preferences
- When the user explicitly says to read `.codex` knowledge first, hydrate route-first Codex context before touching the workspace.
- When the user asks to read project `.md` files first, start with root truth docs and relevant project-folder markdown before code spelunking.
- In VIPBillion content/settings work, if the user says new language data "need to write to website", verify the full path from schema to admin form to visible website output.
- When the user asks to understand a shared system like `admin-panel-angel` + `website-angel-interior`, treat it as one connected app pair and map the real runtime/data flow, not just file lists.
- For new-project bootstrap work, turn the brief into root docs plus reusable startup routing instead of making the user restate setup context.
- In VIPBillion image CRUD, default to real upload/crop UI, not plain URL fields; use `Desktop Image (1200×630)` and `Mobile Image (400×300)` unless the field is really single-image.
- In VIPBillion admin/database work, default sort/order fields to `1000`-step spacing (`1000, 2000, 3000...`) for admin-managed modules unless the user asks otherwise [ad-hoc note]
- If the user asks for a rename without supplying the replacement label, stop and ask instead of guessing.
- In Angel website/admin cleanup, keep fixes surgical when the user says things like "no change to images... no change to my design".
- Treat env files, built artifacts, live endpoints, and actual console output as one evidence chain before proposing deployment/debug fixes.
- When the user says to skip or stop after a verification request, report the verified current state and stop implementation immediately.
- Protect local Docker / local Supabase state: never rename, stop, reset, prune, recreate, or reroute local DB stacks without explicit permission in that turn [ad-hoc note]
- In full-access sessions, avoid repetitive `Step X done - confirm or adjust?` pauses unless there is real risk or a non-obvious decision [ad-hoc note]

## General Tips
- `00_PULSE.md` is the single boot read; for skill-like requests, route through `2_governance/artifacts/skill_path_router.md` before scanning folders.
- For Angel orientation work, search `STATUS.md`, `DATABASE.md`, and `CROSSWALK.md` first; they are the root truth docs for the shared admin+website checkout.
- For Angel localhost website work, use direct `php -S 127.0.0.1:8000 index.php` and verify HTTP 200; `run-local.bat` is not the reliable non-interactive path [ad-hoc note]
- If Angel localhost content looks wrong, verify which `.env` file the runtime loaded before debugging frontend rendering [ad-hoc note]
- In Angel resource playback work, check website templates before changing admin inputs; TikTok embed normalization already lives on the website side.
- For VIPBillion local REST write failures like `PGRST301` or `42501`, verify the current key, `X-Project-Id`, and whether the PHP backend should use the service key.
- For VIPBillion settings/schema work, update the migration, admin form, save path, website model, and website loader together so new fields are both editable and rendered.
- In VIPBillion, `DATABASE.md` plus runtime files beat stale planning docs; `website-vipbillion/index.php`, `router.php`, and `lib/initData.php` are the fastest truth path for shared website behavior.
- In VIPBillion admin image work, reuse `slideshows` + `useSingleImageAttachment` before inventing a new upload pattern.
- In `supabase-project-backup-restore`, `vps-backup.bat` is only the launcher; trace `.bat` -> Git Bash -> `scripts/02-backup-vps.sh` -> remote `project-backup.sh` -> local `vps-backups/...` when explaining or debugging.
- If a VPS backup fails at `[1/10] Schema DDL...` with `pg_dump: error: no matching schemas were found`, check for mixed-case schema names and quoted `pg_dump -n` patterns before chasing SSH/project-resolution issues.
- In `.codex`, keep offline routing/benchmark validation separate from real provider token/cost measurement; true billed numbers still need API or client-side capture.
- In restore/backup work, keep `restore-single.bat` distinct from VPS sync, prefer import-only behavior, and use explicit SQL for one-schema cleanup.

## What's in Memory

### C:\Users\user\Desktop\angel-interior

#### 2026-06-09

- Angel shared project orientation and runtime map: STATUS.md, DATABASE.md, CROSSWALK.md, admin-panel-angel, website-angel-interior, auth.ts, material.ts, SupabaseClient.php, downloadData.php
  - desc: Search this first for `cwd=C:\Users\user\Desktop\angel-interior` when the user asks to "read and understand" the project or when a future edit needs the shared admin/website architecture before code changes.
  - learnings: root truth starts in `STATUS.md`/`DATABASE.md`/`CROSSWALK.md`; `admin-panel-angel` is the schema owner, `website-angel-interior` is the PHP runtime consumer, and SEO/download flow centers in `initData.php`, `SeoModel.php`, and `downloadData.php`.

#### 2026-06-08

- Angel TikTok helper-copy cleanup and embed verification: TikTok, video_url, toEmbedUrl, sketchup-resource-form.vue, material-resource-form.vue, tiktok.com/embed/v2
  - desc: Search this when the user points at TikTok helper copy, asks whether a saved TikTok URL already plays on the website, or wants a surgical video-field cleanup.
  - learnings: the visible helper copy lived in form-schema `description:` fields in two sibling admin forms, while TikTok embed conversion already happens in website templates, not in admin input handling.

### C:\Users\user\Desktop\VIPBillion

#### 2026-06-10

- VIPBillion bilingual settings migration and first shared website wiring pass: marquee_text_en, marquee_text_cn, whatsapp_message_en, whatsapp_message_cn, 111_vipbillion_settings_bilingual_marquee_whatsapp.sql, getLocalizedSettingValue, header.php, footer.php, contacts.php
  - desc: Search this first for `cwd=C:\Users\user\Desktop\VIPBillion` when the user asks to read the project first, wire new language-specific settings into the website, or continue the shared contact/social/header/footer cleanup.
  - learnings: `DATABASE.md` plus runtime files are the truth path, bilingual settings work must update DB/admin/website together, shared surfaces now pull localized settings data, and the rest of the website still needs a page-by-page hardcoded-text sweep.

#### 2026-06-08

- VIPBillion responsive image rollout and unresolved `Lesson Articles` rename: upload, crop modal, Desktop Image (1200×630), Mobile Image (400×300), useSingleImageAttachment, thumbnail_url_mobile, reviews, Lesson Articles
  - desc: Search this first for `cwd=C:\Users\user\Desktop\VIPBillion` when the user wants image-bearing admin CRUD moved from URL fields to upload/crop, needs the standard responsive sizes, or refers to the unfinished `Lesson Articles` rename.
  - learnings: reuse the slideshow upload pattern, add schema/type/store changes together when a table only has one image column, keep avatar-style fields single-image, and ask for the exact replacement label before rename work.

#### 2026-06-05

- VIPBillion bootstrap, verified website order path, and paused settings/title rebrand: information.md, PROJECT_INFO.md, PROJECT_KNOWLEDGE.md, website-vipbillion/api, vipbillion.orders, VB-TEST-009, vipbillion.settings, slidemenu title
  - desc: Search this when the task needs VIPBillion root onboarding docs, the PHP website-to-Supabase order path, or the unfinished settings/title rebrand state.
  - learnings: bootstrap from route-first `.codex` reads plus root docs, verify backend writes through the PHP API into `vipbillion.orders`, and do not continue the settings rewrite without re-confirming the desired UI shape.

### C:\Users\user\Documents\supabase-project-backup-restore

#### 2026-06-08

- VPS backup flow and mixed-case `pg_dump` diagnosis: vps-backup.bat, scripts/02-backup-vps.sh, scripts/vps-side/project-backup.sh, vps-backups, quizLaa, PG_DUMP_SCHEMA_PATTERN, pg_dump: error: no matching schemas were found
  - desc: Search this first for `cwd=C:\Users\user\Documents\supabase-project-backup-restore` when the user asks what the backup workspace/scripts do or when a VPS schema backup fails early.
  - learnings: explain the full launcher-to-VPS-to-local copy flow, and if failure hits `[1/10] Schema DDL...`, inspect quoted schema patterns for mixed-case names before assuming the wrapper or SSH path is broken.

### Older Memory Topics

#### C:\Users\user\Desktop\angel-interior

- Angel root cleanup and ignore-file hygiene: start.ps1, stop.ps1, AI_START_HERE.md, BLUEPRINT.md, .gitignore, .codexignore, php-seo-debug.log
  - desc: Use this when the user wants old root wrappers/docs removed or wants ignore files tightened without hiding important project files; applies to `cwd=C:\Users\user\Desktop\angel-interior`.

- Angel auth/runtime triage, checkout history, and localhost safety notes: auth.v1.health, dist/_app.config.js, checkout.php, download.php, local-supabase, consent mode, getWebsiteSlideshows
  - desc: Use this for deployed login failures, homepage/runtime cleanup, checkout/download behavior, env-routing mistakes, or protected local Supabase routing in `cwd=C:\Users\user\Desktop\angel-interior`.

#### C:\Users\user\.codex

- `.codex` routing, benchmark schema, and cost-policy boundaries: MODEL_COST_OPTIMIZATION_POLICY.md, skill_path_router.md, ai mode lean, ai benchmark live, cached_tokens, estimated_cost_usd
  - desc: Use this for `cwd=C:\Users\user\.codex` when work involves route-safe optimization policy changes, benchmark schema updates, or clarifying what live measurement can and cannot prove.

#### C:\Users\user\Documents\restore-local

- `restore-local` README, `.codex`-first hydration, import-only VPS sync, and safe schema cleanup: .codex knowledge, README.md, backup-local.bat, restore-single.bat, reset & restore-supabase.bat, NO_PAUSE, table_schema
  - desc: Use this for `cwd=C:\Users\user\Documents\restore-local` orientation, nested batch-script restore debugging, or safe one-schema delete guidance; keep `restore-single.bat` distinct from VPS sync and default option 3 to import-only.

#### C:\Users\user\Documents\supabase-project-backup-restore

- Angel local migration-readiness and backup completeness: public.project.schema_name, angelinterior, angel-interior, angel_interior_*, config.toml, custom_access_token_hook, local-backups/angelinterior-20260528-182503
  - desc: Use this before VPS migration or when local Angel backup warnings mention schema/storage mismatches; applies to `cwd=C:\Users\user\Documents\supabase-project-backup-restore` and covers the final local backup artifact to trust.
