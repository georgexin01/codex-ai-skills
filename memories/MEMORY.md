# AI Behavior Protocols (Core Rules — Always Active)
- [C-Unit Composition](1_core/C_UNIT_COMPOSITION.md) — Atomic functions only. Compose C+C+C. Scan before writing. No monoliths.
- [Scan-Before-Write](2_governance/SCAN_BEFORE_WRITE_PROTOCOL.md) — Always search existing code before writing new functions. Declare scan result.
- [Single Truth Source](2_governance/SINGLE_TRUTH_SOURCE_PROTOCOL.md) — Every value/logic lives in ONE place. Everything else imports it.
- [Contract-First](2_governance/CONTRACT_FIRST_PROTOCOL.md) — Define input+output shape before writing any function body.
- [Cross-Skill Ripple](2_governance/CROSS_SKILL_RIPPLE_PROTOCOL.md) — Schema/API changes in one track (claude/claude-app/claude-website) must flag sibling impacts.
- [Task Position Anchor](2_governance/TASK_POSITION_ANCHOR_PROTOCOL.md) — Always declare [TASK X/N — track] before acting. Never skip or jump.
- [Bilingual Gate](2_governance/BILINGUAL_GATE_PROTOCOL.md) — Only when _en/_cn pairs detected: gate fires if one half is missing from form/INSERT/store.
- [Read-Before-Answer](2_governance/READ_BEFORE_ANSWER_PROTOCOL.md) — Read the actual file before answering anything about existing code, schema, or config.
- [Constraint-First Thinking](2_governance/CONSTRAINT_FIRST_PROTOCOL.md) — List scope/locked/pattern/stack/schema constraints before proposing any solution.
- [Confidence Declaration](2_governance/CONFIDENCE_DECLARATION_PROTOCOL.md) — Rate HIGH/MEDIUM/LOW before acting. Never write code at LOW confidence.
- [Session Start](2_governance/SESSION_START_PROTOCOL.md) — Boot sequence: identify project → SHARED_DB_CONTRACT → anchor task position.

# Task Group: VIPBillion root-doc orientation, bilingual settings migration, shared website wiring, and sort-order convention
scope: Use when the user wants VIPBillion understood from the real root/docs first, needs bilingual settings carried from schema to admin to website output, or wants reusable admin/data conventions for shared website settings work.
applies_to: cwd=\\?\C:\Users\user\Desktop\VIPBillion; reuse_rule=safe for this checkout family while `DATABASE.md`, `admin-vipbillion/apps/web-antd`, `website-vipbillion`, and the local Supabase workflow remain the truth sources
## Task 1: Read the project docs/runtime and identify the real source of truth, success
### rollout_summary_files
- rollout_summaries/2026-06-10T01-19-05-G8bT-vipbillion_bilingual_settings_and_shared_website_wiring.md (cwd=\\?\C:\Users\user\Desktop\VIPBillion, rollout_path=C:\Users\user\.codex\sessions\2026\06\10\rollout-2026-06-10T09-19-05-019eaf1c-91eb-7443-997c-2114d1555e81.jsonl, updated_at=2026-06-10T09:48:42+00:00, thread_id=019eaf1c-91eb-7443-997c-2114d1555e81, reconciled root docs against the live admin/website runtime files before edits)
### keywords
- VIPBillion, information.md, WORKSPACE.md, MASTER_PLAN.md, DATABASE.md, STATUS.md, QUICK_START.md, PRICING.md, website-vipbillion/index.php, website-vipbillion/router.php, admin-vipbillion/apps/web-antd
## Task 2: Add bilingual settings columns, backfill them, and wire admin + website loaders, success
### rollout_summary_files
- rollout_summaries/2026-06-10T01-19-05-G8bT-vipbillion_bilingual_settings_and_shared_website_wiring.md (cwd=\\?\C:\Users\user\Desktop\VIPBillion, rollout_path=C:\Users\user\.codex\sessions\2026\06\10\rollout-2026-06-10T09-19-05-019eaf1c-91eb-7443-997c-2114d1555e81.jsonl, updated_at=2026-06-10T09:48:42+00:00, thread_id=019eaf1c-91eb-7443-997c-2114d1555e81, added migration `111` plus EN/CN admin and website settings support)
### keywords
- marquee_text_en, marquee_text_cn, whatsapp_message_en, whatsapp_message_cn, 111_vipbillion_settings_bilingual_marquee_whatsapp.sql, setting-form.vue, setting-edit-drawer.vue, SettingsModel.php, local Supabase, docker cp, psql -f, supabase_db_local-supabase
## Task 3: Replace shared website contact/header/footer hardcoding with settings-driven localized values, partial
### rollout_summary_files
- rollout_summaries/2026-06-10T01-19-05-G8bT-vipbillion_bilingual_settings_and_shared_website_wiring.md (cwd=\\?\C:\Users\user\Desktop\VIPBillion, rollout_path=C:\Users\user\.codex\sessions\2026\06\10\rollout-2026-06-10T09-19-05-019eaf1c-91eb-7443-997c-2114d1555e81.jsonl, updated_at=2026-06-10T09:48:42+00:00, thread_id=019eaf1c-91eb-7443-997c-2114d1555e81, updated shared header/footer/contact surfaces but not the full template sweep)
### keywords
- header.php, footer.php, contacts.php, initData.php, getLocalizedSettingValue, formatPhoneDisplay, empty social icons, whatsapp_url, whatsapp_message_en, whatsapp_message_cn, php -l
## User preferences
- when the user asked to "understand my project reading all .md in my project root and other folder files" -> start VIPBillion work with root truth docs plus project-specific docs before making edits, then verify against the live code/state [Task 1]
- when the user said "make sure to check the 2 newly adde language update data that need to write to website" -> verify new language-specific data end to end from schema to admin form to visible website output, not just in the database [Task 2][Task 3]
- when the user kept confirming before deeper rewires -> pause at meaningful checkpoints before broad website-copy changes that affect live shared surfaces [Task 2][Task 3]
- for VIPBillion admin/database ordering fields, default sort values in steps of `1000` (`1000, 2000, 3000, 4000`) across services, attractions, slideshows, and similar admin-managed modules unless the user asks for a different scheme [ad-hoc note]
## Reusable knowledge
- `DATABASE.md` and runtime files are the main truth sources for VIPBillion, but some planning docs are stale or mixed with older Angel/WMS content, so code/schema reads outrank prose when they conflict [Task 1]
- The website front controller is `website-vipbillion/index.php`, clean routing lives in `website-vipbillion/router.php`, and `website-vipbillion/lib/initData.php` is the shared website data/config loader [Task 1]
- The live admin app area is `admin-vipbillion/apps/web-antd`; local development there uses `pnpm dev:local` from that workspace [Task 1]
- Migration `111_vipbillion_settings_bilingual_marquee_whatsapp.sql` adds `marquee_text_en/cn` and `whatsapp_message_en/cn`, then backfills them from the legacy single-language columns [Task 2]
- Safe SQL application on this environment used `docker cp` into `supabase_db_local-supabase` plus `psql -f`, not inline SQL; the verified settings row for project UUID `62696c17-235c-443c-93a9-c65d357b635b` had non-null bilingual values after the migration [Task 2]
- For settings-facing schema work, update the DB migration, admin settings form, admin save path, website settings model, and website loader in the same pass so the new fields can actually be edited and rendered [Task 2]
- Shared website settings now resolve by language via `getLocalizedSettingValue()` in `website-vipbillion/lib/initData.php`, with fallback to legacy single-value columns; `formatPhoneDisplay()` keeps the shared phone output readable [Task 3]
- Empty social URLs should be hidden rather than rendered as blank icons, and the floating WhatsApp button should use the stored WhatsApp URL plus the stored reply message [Task 3]
## Failures and how to do differently
- `WORKSPACE.md` referenced missing docs, and several docs were mixed-freshness; do not assume every referenced file exists or that root prose is current without checking code/schema/runtime evidence [Task 1]
- The initial settings schema only had single-language fields; future similar work should inspect the actual table before wiring website text or assuming bilingual columns already exist [Task 2]
- Schema-only changes were not enough because the user wanted website-facing behavior; future agents should treat wording like "need to write to website" as a loader/UI/output requirement, not just a migration request [Task 2][Task 3]
- This rollout only updated shared/header/footer/contact surfaces; many page-specific templates still contain hardcoded contact/WhatsApp/social text, so continue with a page-by-page sweep instead of assuming the whole website is done [Task 3]
- If the DB string already includes the working-hours label, render it once; the first contact-page patch duplicated the label and needed cleanup [Task 3]

# Task Group: VIPBillion admin responsive image uploads, vehicle mobile-image support, review avatar flow, and unresolved lesson-articles rename
scope: Use when the user wants VIPBillion admin image CRUD changed from URL fields to upload/crop flows, needs the responsive image standard, or refers to the unresolved `Lesson Articles` rename request.
applies_to: cwd=\\?\C:\Users\user\Desktop\VIPBillion; reuse_rule=safe for this checkout family while `admin-vipbillion`, `website-vipbillion`, and the existing upload helper stack remain the truth sources
## Task 1: Roll out responsive upload/crop UI across image-bearing content modules, success
### rollout_summary_files
- rollout_summaries/2026-06-08T03-10-08-2t4a-vipbillion_admin_responsive_image_uploads_and_lesson_article.md (cwd=\\?\C:\Users\user\Desktop\VIPBillion, rollout_path=C:\Users\user\.codex\sessions\2026\06\08\rollout-2026-06-08T11-10-08-019ea535-8424-7d53-8335-e274edd59b46.jsonl, updated_at=2026-06-08T09:13:45+00:00, thread_id=019ea535-8424-7d53-8335-e274edd59b46, standardized content modules on upload/crop instead of URL fields)
### keywords
- VIPBillion, admin-vipbillion, website-vipbillion, upload, crop modal, Desktop Image (1200×630), Mobile Image (400×300), useSingleImageAttachment, slideshows, services, attractions, insights, TS5103
## Task 2: Extend vehicles with `thumbnail_url_mobile` and match the new responsive image flow, success
### rollout_summary_files
- rollout_summaries/2026-06-08T03-10-08-2t4a-vipbillion_admin_responsive_image_uploads_and_lesson_article.md (cwd=\\?\C:\Users\user\Desktop\VIPBillion, rollout_path=C:\Users\user\.codex\sessions\2026\06\08\rollout-2026-06-08T11-10-08-019ea535-8424-7d53-8335-e274edd59b46.jsonl, updated_at=2026-06-08T09:13:45+00:00, thread_id=019ea535-8424-7d53-8335-e274edd59b46, added vehicle mobile-image schema + form wiring)
### keywords
- vehicles, thumbnail_url_mobile, 059_vipbillion_vehicle_mobile_image.sql, vehicle.ts, vehicle-form.vue, store, Desktop Image (1200×630), Mobile Image (400×300)
## Task 3: Convert reviews avatar input to a single square upload flow, success
### rollout_summary_files
- rollout_summaries/2026-06-08T03-10-08-2t4a-vipbillion_admin_responsive_image_uploads_and_lesson_article.md (cwd=\\?\C:\Users\user\Desktop\VIPBillion, rollout_path=C:\Users\user\.codex\sessions\2026\06\08\rollout-2026-06-08T11-10-08-019ea535-8424-7d53-8335-e274edd59b46.jsonl, updated_at=2026-06-08T09:13:45+00:00, thread_id=019ea535-8424-7d53-8335-e274edd59b46, kept reviews on a single avatar upload instead of forcing a desktop/mobile pair)
### keywords
- reviews, avatar_url, review-form.vue, review.ts, store, 400×400, testimonial avatar, single upload
## Task 4: Pause the `Lesson Articles` rename until the new label is provided, uncertain
### rollout_summary_files
- rollout_summaries/2026-06-08T03-10-08-2t4a-vipbillion_admin_responsive_image_uploads_and_lesson_article.md (cwd=\\?\C:\Users\user\Desktop\VIPBillion, rollout_path=C:\Users\user\.codex\sessions\2026\06\08\rollout-2026-06-08T11-10-08-019ea535-8424-7d53-8335-e274edd59b46.jsonl, updated_at=2026-06-08T09:13:45+00:00, thread_id=019ea535-8424-7d53-8335-e274edd59b46, rename request left unresolved because the source text and new label were both missing)
### keywords
- Lesson Articles, change name, homepage introductions, no exact match, rename request, ask for exact new label
## User preferences
- when the user kept rejecting plain URL inputs for image fields as "wrong" and wanted the blog/admin-panel behavior -> default to real upload/crop UI for VIPBillion image CRUD, not text URL fields [Task 1]
- when the user explicitly standardized on `Desktop Image (1200×630)` and `Mobile Image (400×300)` -> use that responsive pair as the content-module default unless the real field semantics show an exception [Task 1][Task 2]
- when the user wanted all image tables updated but `reviews.avatar_url` was really a testimonial/avatar field -> classify the image usage before choosing a dual-image pattern [Task 3]
- when the user asked `Lesson Articles > change name` without supplying the replacement -> do not guess names; ask for the exact new label before editing [Task 4]
## Reusable knowledge
- `slideshows` already had the working reference pattern for dual upload cards, crop modal, submit-time path resolution, and cleanup of removed attachments; reuse that before inventing a new image flow [Task 1]
- `useSingleImageAttachment` already handles file-list state, staged upload, crop, resolved storage path, and soft-delete cleanup, so most content-form work is wiring rather than new attachment logic [Task 1]
- Website templates already consume responsive image pairs for slideshow/service-style layouts, so the admin change aligned with real frontend behavior rather than a speculative standard [Task 1]
- `vehicles` originally had only `thumbnail_url` and `images`; matching the responsive pattern required DB migration, type updates, store updates, and form updates together [Task 2]
- `reviews` only exposes `avatar_url` in the type/store layer and the site search did not reveal a separate mobile/desktop variant, so the correct UX there is a single square avatar upload (`400×400`) [Task 3]
- Local Docker / local Supabase state is protected across these related stacks: never rename, reset, prune, stop, recreate, or modify local Docker database state, schema exposure, routing, startup target, or DB-related behavior without explicit user permission in that turn; if Docker seems to point at another project such as `admin-vipbillion`, stop and ask first [ad-hoc note]
## Failures and how to do differently
- The first patch attempt was brittle because the live files had drift/encoding noise; re-read the actual file before large replacements on this repo [Task 1]
- Do not force a desktop/mobile pair onto every image field; first check whether the website actually renders a distinct mobile variant or whether the field is semantically a single avatar/logo image [Task 3]
- For copy/label rename requests with no exact workspace match and no replacement text, stop and ask for the new label instead of guessing or doing a broad blind rename [Task 4]

# Task Group: VIPBillion workspace bootstrap, website order-path verification, and admin title/settings rebrand
scope: Use when a future run needs the VIPBillion root doc stack, PHP website consume layer, local Supabase order-create path, or the paused settings/title rebrand context.
applies_to: cwd=\\?\C:\Users\user\Desktop\VIPBillion; reuse_rule=safe for this checkout family while `admin-vipbillion`, `website-vipbillion`, root onboarding docs, and the shared local Supabase contract remain the truth sources
## Task 1: Read `.codex` knowledge, bootstrap root docs, and scaffold the website API layer, success
### rollout_summary_files
- rollout_summaries/2026-06-04T08-25-01-i1Lw-vipbillion_bootstrap_order_path_settings_rebrand.md (cwd=\\?\C:\Users\user\Desktop\VIPBillion, rollout_path=C:\Users\user\.codex\sessions\2026\06\04\rollout-2026-06-04T16-25-01-019e91bc-5e60-7063-99d3-669c03c77036.jsonl, updated_at=2026-06-05T10:06:37+00:00, thread_id=019e91bc-5e60-7063-99d3-669c03c77036, established root onboarding docs and a minimal PHP + Supabase REST consume layer)
### keywords
- VIPBillion, information.md, PROJECT_INFO.md, PROJECT_KNOWLEDGE.md, STATUS.md, website-vipbillion/api, starting-point, SHARED_DB_CONTRACT
## Task 2: Verify and fix the first website order-create path into local Supabase, success
### rollout_summary_files
- rollout_summaries/2026-06-04T08-25-01-i1Lw-vipbillion_bootstrap_order_path_settings_rebrand.md (cwd=\\?\C:\Users\user\Desktop\VIPBillion, rollout_path=C:\Users\user\.codex\sessions\2026\06\04\rollout-2026-06-04T16-25-01-019e91bc-5e60-7063-99d3-669c03c77036.jsonl, updated_at=2026-06-05T10:06:37+00:00, thread_id=019e91bc-5e60-7063-99d3-669c03c77036, verified a real `vipbillion.orders` insert as `VB-TEST-009`)
### keywords
- VIPBillion, vipbillion.orders, SupabaseClient.php, PGRST301, 42501, sb_publishable_, X-Project-Id, service key, VB-TEST-009, 057_vipbillion_anon_project_header_fallback.sql
## Task 3: Rebrand the admin title/settings path, then stop when the settings direction was wrong, partial
### rollout_summary_files
- rollout_summaries/2026-06-04T08-25-01-i1Lw-vipbillion_bootstrap_order_path_settings_rebrand.md (cwd=\\?\C:\Users\user\Desktop\VIPBillion, rollout_path=C:\Users\user\.codex\sessions\2026\06\04\rollout-2026-06-04T16-25-01-019e91bc-5e60-7063-99d3-669c03c77036.jsonl, updated_at=2026-06-05T10:06:37+00:00, thread_id=019e91bc-5e60-7063-99d3-669c03c77036, settings rewrite remained partial after the user stopped the direction)
### keywords
- VIPBillion Admin, Angel Interior Admin, slidemenu title, vipbillion.settings, setting-list.vue, setting-form.vue, preferences.ts, authentication.vue, logo.vue, this is not how i wanted for setting stop
## User preferences
- when the user said `ai read .codex knowledge` and asked to "read the project plan and build from there" -> start VIPBillion work with route-first `.codex` hydration plus the root brief/docs before code spelunking [Task 1]
- when the user asked for a reusable `skills/starting-point` flow and wanted future AI to auto-read it -> prefer bootstrap docs and reusable startup routing over repeated hand-holding on new projects [Task 1]
- when the user said `this ai make sure to change slidemenu title of the project to correct vipbillion name` -> treat visible project-title rebranding as part of copied-admin cleanup, not a cosmetic afterthought [Task 3]
- when the user said `this is not how i wanted for setting stop... i will continue next day` -> stop immediately when a settings/UI direction is off instead of polishing the wrong shape [Task 3]
## Reusable knowledge
- The root onboarding contract for this workspace is `PROJECT_INFO.md`, `PROJECT_RESEARCH.md`, `PROJECT_KNOWLEDGE.md`, `WORKSPACE.md`, `DATABASE.md`, `CROSSWALK.md`, and `STATUS.md`; `information.md` is the raw brief they were derived from [Task 1]
- `admin-vipbillion` is the Vben/schema owner and `website-vipbillion` is the PHP + Supabase REST consumer; `skills/starting-point` is the durable place for future bootstrap expectations [Task 1]
- For server-side website writes in this stack, the PHP API should use the local Supabase service key; the verified order-create path required the current `sb_publishable_...` key, `X-Project-Id`, and a backend write model rather than older anon/JWT assumptions [Task 2]
- `vipbillion.settings` is a live key/value table, not the older single-row `app_settings` model; title rebranding must stay aligned across env, preferences, and shared logo/layout components [Task 3]
## Failures and how to do differently
- If local PostgREST returns `PGRST301` or `42501` on VIPBillion writes, check the active publishable key, project-header resolution, and whether the endpoint should use the backend service key before touching frontend flow assumptions [Task 2]
- The settings rewrite was partial and the user explicitly stopped it; do not continue that implementation path without re-confirming the desired settings-page layout/behavior first [Task 3]

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

# Task Group: angel-interior project orientation, admin-panel-angel and website-angel-interior runtime, paid-download flow, homepage maintenance, and website triage
scope: Use when working inside the Angel Interior checkout to understand the shared admin+website system, diagnose deployed/runtime issues, verify resource rendering behavior, or make surgical website/admin cleanup changes.
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
- website-angel-interior, /checkout/sketchup/, Stripe payment comming soon, 5 sec timer, paid download, Stripe return API, resource handoff, <turn_aborted>
## Task 3: Website homepage/global cleanup for Lighthouse, include-order stability, consent/schema refresh, and temp-log cleanup, success
### rollout_summary_files
- rollout_summaries/2026-06-02T03-06-25-82B0-website_angel_interior_lighthouse_consent_schema_lazyload_de.md (cwd=\\?\C:\Users\user\Desktop\angel-interior, rollout_path=C:\Users\user\.codex\sessions\2026\06\02\rollout-2026-06-02T11-06-25-019e864b-f3d6-7841-b58b-ebe0e6de1f1e.jsonl, updated_at=2026-06-02T10:20:25+00:00, thread_id=019e864b-f3d6-7841-b58b-ebe0e6de1f1e, homepage fatal fixed, Lighthouse cleanup stayed surgical, and schema/consent/lazyload updates verified with HTTP 200)
### keywords
- website-angel-interior, lighthouse, heading-order, target-size, label-content-name-mismatch, getWebsiteSlideshows, initData.php, consent mode, angel_cookie_consent_v1, GTM-TTGGQX46, schema.php, lazyload, .tmp-php-8000
## Task 4: Read root docs and map the shared Angel Interior architecture, success
### rollout_summary_files
- rollout_summaries/2026-06-09T01-20-58-KDBG-angel_interior_project_understanding_root_docs_admin_website.md (cwd=\\?\C:\Users\user\Desktop\angel-interior, rollout_path=C:\Users\user\.codex\sessions\2026\06\09\rollout-2026-06-09T09-20-58-019ea9f7-efa2-7410-9caa-b02bab86976c.jsonl, updated_at=2026-06-09T01:30:19+00:00, thread_id=019ea9f7-efa2-7410-9caa-b02bab86976c, mapped root docs, admin modules, website routes, SEO flow, and download flow)
### keywords
- angel-interior, STATUS.md, DATABASE.md, CROSSWALK.md, admin-panel-angel, website-angel-interior, GitNexus, auth.ts, material.ts, SupabaseClient.php, downloadData.php
## Task 5: Remove duplicated TikTok helper copy and verify website embed handling, success
### rollout_summary_files
- rollout_summaries/2026-06-08T06-37-17-i1HH-remove_helper_text_and_skip_tiktok_embed_change.md (cwd=\\?\C:\Users\user\Desktop\angel-interior, rollout_path=C:\Users\user\.codex\sessions\2026\06\08\rollout-2026-06-08T14-37-17-019ea5f3-2c21-7e62-a288-39b8101c0029.jsonl, updated_at=2026-06-08T06:51:23+00:00, thread_id=019ea5f3-2c21-7e62-a288-39b8101c0029, removed duplicate helper copy and confirmed TikTok embed conversion already exists on the website)
### keywords
- TikTok, video_url, toEmbedUrl, sketchup-resource-form.vue, material-resource-form.vue, description field, tiktok.com/embed/v2, skip deeper change
## User preferences
- when diagnosing Angel Interior issues, the user asked to "read my angel-interior project root folder .md" first -> start from root handoff docs and project notes before code digging [Task 1]
- when the user asked `admin-panel-angel website-angel-interior ai read and understand my project` -> treat both apps as one connected system and start from `STATUS.md`, `DATABASE.md`, and `CROSSWALK.md` before app-level code reads [Task 4]
- when the user pasted the exact console failure and asked "can ai know how this gone wrong?" -> explain the root cause in plain language and tie it to env/build/live-host evidence, not just source-code flow [Task 1]
- when the user pointed at `.env.production` and the live login URL -> treat env files, built artifacts, and live endpoints as one evidence chain before proposing fixes [Task 1]
- when Angel localhost work could change which database stack is active, the user-captured rule was to protect `C:\Users\user\Documents\local-supabase` -> do not silently switch the active local Supabase project to `website-angel-interior` or another stack; confirm first if env/Docker/Supabase routing would change [ad-hoc note]
- when the user said paid download clicks should visit `/checkout/sketchup/`, show "Stripe payment comming soon ..." plus a button, and wait for a "5 sec timer" -> keep temporary checkout UX minimal and transitional rather than building a full payment screen immediately [Task 2]
- when the user said to keep "all the nessasary return api from Stripe" pointing to the resource/download page -> preserve resource-specific handoff data even in temporary checkout flows [Task 2]
- when the user said "no change to images, no reupload images, no change to my design, no change to div section card.." -> keep homepage/global fixes surgical and avoid visual/layout redesign [Task 3]
- when the user asked that the "ld-json schema meta (old version)" be updated and to "add UI accept the cookies for getting data" -> keep schema/JSON-LD synced to the current site and add small consent gating around existing GTM/GA instead of rebuilding analytics [Task 3]
- when the user said "can ai help me remove this text no need anymore" and pointed at one helper string -> make the copy cleanup surgical and stop once the exact text is gone [Task 5]
- when the user said "ai i want to skip this" after asking to verify a TikTok URL path -> stop implementation immediately and report only the verified current state [Task 5]
- in full-access sessions, avoid repetitive `Step X done - confirm or adjust?` pauses unless there is real risk, a destructive action, or a non-obvious product decision [ad-hoc note]
## Reusable knowledge
- Related skill: skills/angel-interior-local-dev/SKILL.md
- Verified localhost startup note lives in `project_notes/ANGEL_INTERIOR_LOCAL_DEV.md`: `run-local.bat` can exit silently when spawned non-interactively, so use direct `php -S 127.0.0.1:8000 index.php` for `website-angel-interior` and `pnpm run dev:local` for `admin-panel-angel`, then verify the website with HTTP 200 [ad-hoc note]
- `C:\Users\user\Documents\local-supabase` is the protected canonical local Supabase Docker project for Angel local work; prefer adapting app/site config to that stack instead of switching the active stack by default [ad-hoc note]
- For production login failures, verify `/auth/v1/health` and an `OPTIONS` preflight first; if the public host returns HTML `404` or generic web-server output, the problem is proxy/host wiring, not the Vue auth store [Task 1]
- The auth path is `login.vue` -> `stores/auth.ts` -> `api/core/auth.ts` -> `api/core/supabase-auth.ts` -> `supabase.auth.signInWithPassword(...)`, and the built admin bundle can hardcode the host in `apps/web-antd/dist/_app.config.js`, so host changes require a rebuild [Task 1]
- `STATUS.md`, `DATABASE.md`, and `CROSSWALK.md` are the best first reads for this checkout; `admin-panel-angel` is the schema owner/editing surface and `website-angel-interior` is the PHP runtime consumer [Task 4]
- Active admin routes include `users`, `blog`, `slideshow`, `sketchup`, `seo`, `material`, `contact`, `attachments`, and `workflow-test`; website runtime flow is centered in `index.php`, `initData.php`, `SupabaseClient.php`, `SeoModel.php`, and `downloadData.php` [Task 4]
- Website templates already normalize standard TikTok video URLs into `https://www.tiktok.com/embed/v2/<id>...`; the embed helpers live in `template/sketchup-free-resources.php`, `template/material-free-resources.php`, `template/about.php`, `template/home.php`, and `template/download.php` [Task 5]
- For admin user-creation failures with `column "status" does not exist`, inspect SQL migrations before touching Vue; the durable fix was append-only migration `apps/web-antd/src/sql/migrations/064_angel_make_user_rpc_role_status_agnostic.sql`, and `apps/web-antd/src/sql/README.md` should stay aligned with numbered migrations [ad-hoc note]
- Older validated checkout history: the user explicitly wanted paid SketchUp downloads to route through `/checkout/sketchup/`, show a centered "Stripe payment comming soon ..." page, and auto-forward after 5 seconds while keeping Stripe return data compatible with the final download page [Task 2]
- Newer repo state moved beyond placeholder-only checkout: inspect `template/checkout.php`, `template/download.php`, and `lib/downloadData.php` together, confirm Stripe runtime config exists, and verify that unlocked downloads are gated by Stripe session metadata plus `payment_status = paid` [ad-hoc note]
- If the Angel website looks empty while admin/local data exists, trace env file selection, runtime host detection, and the actual Supabase project URL as one evidence chain; localhost can silently read `.env.production` / VPS Supabase instead of local `.env` [ad-hoc note]
- Local Docker / local Supabase state is protected across these related stacks: never rename, reset, prune, stop, recreate, or modify local Docker database state, schema exposure, routing, startup target, or DB-related behavior without explicit user permission in that turn; if Docker seems to point at another project such as `admin-vipbillion`, stop and ask first [ad-hoc note]
- `website-angel-interior/api/core/.env.production` contains the live Stripe config; confirm presence/shape only and do not copy key values into memory or summaries [ad-hoc note]
- `website-angel-interior/api/core/.env.production` also controls whether localhost can accidentally read production Supabase/Stripe settings, so env selection must be checked before assuming the website is on local data [ad-hoc note]
- Awards/content-module website issues can span SQL grants, anon-read policies, `permissions` rows, and storage paths; working RLS alone is not enough when the site says `permission denied for table awards` or uploads disappear [ad-hoc note]
- `award_date` should stay a plain text year input with first-4-digit normalization; the admin layer can relabel `title` -> `Heading` and `description` -> `Title` without changing DB columns [ad-hoc note]
## Failures and how to do differently
- If a localhost/env change would repoint Angel from `C:\Users\user\Documents\local-supabase` to another Supabase project, stop and confirm with the user before touching env files, Docker stack selection, or local endpoints [ad-hoc note]
- Production login failures can look like frontend auth bugs even when the real issue is public-host/proxy wiring; verify live endpoint behavior before rewriting auth code [Task 1]
- If the website/admin data path seems wrong, verify which `.env` file the runtime actually loaded before chasing schema or component bugs [ad-hoc note]
- Homepage/global cleanup should stay surgical: preserve fonts/design/image behavior, verify include order around `getWebsiteSlideshows()`, run `php -l`, and confirm `http://127.0.0.1:8000/` returns HTTP 200 before calling it done [Task 3]
- When a user says to skip after a verification request, do not keep exploring or patching; stop after reporting the verified state [Task 5]

# Task Group: .codex routing, benchmark maintenance, model-cost policy, and route-integrity cleanup
scope: Reuse when the user wants `.codex` improved, benchmarked, or audited without breaking routing; especially useful for route-first boot flow, benchmark harness changes, cost-optimization policy work, and final verification passes.
applies_to: cwd=\\?\C:\Users\user\.codex; reuse_rule=safe for the `.codex` knowledge/routing workspace while `codex-router/`, `00_PULSE.md`, `00_CODEX_PERF_BENCHMARK.md`, and the route/audit scripts remain the truth sources
## Task 1: Build the offline benchmark harness and live prompt pack, success
### rollout_summary_files
- rollout_summaries/2026-05-29T08-21-29-dnYJ-codex_benchmark_live_prompts_routing_cleanup.md (cwd=\\?\C:\Users\user\.codex, rollout_path=C:\Users\user\.codex\sessions\2026\05\29\rollout-2026-05-29T16-21-29-019e7393-a7dd-7300-b35e-7a12d7dc8dd3.jsonl, updated_at=2026-05-30T06:19:33+00:00, thread_id=019e7393-a7dd-7300-b35e-7a12d7dc8dd3, added benchmark runner, prompt pack, and structured reporting)
### keywords
- .codex, benchmark, Test-CodexPerfBenchmark.ps1, benchmark_prompts, benchmark-results, prompt_length, reasoning_effort, response_api, Pass/Fail
## Task 2: Align routing/audit exclusions and remove active legacy-reference noise, success
### rollout_summary_files
- rollout_summaries/2026-05-29T08-21-29-dnYJ-codex_benchmark_live_prompts_routing_cleanup.md (cwd=\\?\C:\Users\user\.codex, rollout_path=C:\Users\user\.codex\sessions\2026\05\29\rollout-2026-05-29T16-21-29-019e7393-a7dd-7300-b35e-7a12d7dc8dd3.jsonl, updated_at=2026-05-30T06:19:33+00:00, thread_id=019e7393-a7dd-7300-b35e-7a12d7dc8dd3, cleaned active routes/exclusions and synced router/audit behavior)
### keywords
- skill_path_router.md, route exclusions, raw_memories.md, legacy_ref_count, Audit-CodexRouting.ps1, Update-CodexRouting.ps1
## Task 3: Regenerate routing and verify the final benchmark/audit state, success
### rollout_summary_files
- rollout_summaries/2026-06-02T07-58-55-zdnt-codex_model_cost_optimization_policy_benchmark_hook.md (cwd=\\?\C:\Users\user\.codex, rollout_path=C:\Users\user\.codex\sessions\2026\06\02\rollout-2026-06-02T15-58-55-019e8754-67b2-7c52-86fd-dc5ef1559ea8.jsonl, updated_at=2026-06-02T08:05:54+00:00, thread_id=019e8754-67b2-7c52-86fd-dc5ef1559ea8, benchmark and route audit ended clean with the new schema fields)
### keywords
- routing audit, passed_count, missing_roots_count, legacy_ref_count, cached_tokens, estimated_cost_usd, Rating: 10/10
## Task 4: Add model-cost optimization policy, boot triggers, cost fields, and live-measurement boundary notes, partial
### rollout_summary_files
- rollout_summaries/2026-06-02T07-58-55-zdnt-codex_model_cost_optimization_policy_benchmark_hook.md (cwd=\\?\C:\Users\user\.codex, rollout_path=C:\Users\user\.codex\sessions\2026\06\02\rollout-2026-06-02T15-58-55-019e8754-67b2-7c52-86fd-dc5ef1559ea8.jsonl, updated_at=2026-06-02T08:05:54+00:00, thread_id=019e8754-67b2-7c52-86fd-dc5ef1559ea8, added routeable cost policy and clarified the live-measurement boundary)
### keywords
- MODEL_COST_OPTIMIZATION_POLICY.md, ai mode lean, ai mode deep, ai reply terse, ai benchmark live, cached_tokens, estimated_cost_usd, live benchmark
## User preferences
- when the user asked how to optimize AI usage, speed, and token spend -> turn the answer into concrete policy files and routeable short triggers, not loose advice [Task 4]
- when the user asked for a "benchmark live" path -> include the real measurement boundary instead of implying the chat can self-report billed provider usage [Task 4]
- when the user wanted quality/time/token improvements shown directly -> report measurable before/after fields such as token cost, speed, % increase, and rating [Task 1][Task 4]
## Reusable knowledge
- `00_PULSE.md` is the single boot read; route skill requests through `2_governance/artifacts/skill_path_router.md` before scanning `skills/` frontmatter or folder trees [Task 2][Task 4]
- The benchmark/report schema now includes `prompt_tokens`, `completion_tokens`, `total_tokens`, `cached_tokens`, and `estimated_cost_usd` in addition to the earlier quality/time fields [Task 1][Task 4]
- Local `.codex` scripts can validate routing integrity and benchmark structure, but real provider prompt-token/cached-token/cost measurements still require API-based runs or manual client capture [Task 4]
## Failures and how to do differently
- If the audit exclude matcher is more complex than the router logic, it can miss exclusions like `memories/raw_memories.md` and overcount legacy refs -> normalize paths and keep the matcher simple enough to mirror `router-config.json` behavior [Task 2]
- For skill-routing upkeep, do not scan the full `skills/` tree first when the trigger is already known; check `2_governance/artifacts/skill_path_router.md` first so added routes like `ai starting point` or `ai personality` do not get missed behind folder noise [Task 2]
- Do not imply that the assistant can self-measure the current Codex or Claude Code session for real billed token/cost usage; once the user asks for true live numbers, pivot immediately to API benchmarking or manual client capture [Task 4]
