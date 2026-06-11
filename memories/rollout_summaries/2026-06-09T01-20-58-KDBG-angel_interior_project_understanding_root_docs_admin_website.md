thread_id: 019ea9f7-efa2-7410-9caa-b02bab86976c
updated_at: 2026-06-09T01:30:19+00:00
rollout_path: C:\Users\user\.codex\sessions\2026\06\09\rollout-2026-06-09T09-20-58-019ea9f7-efa2-7410-9caa-b02bab86976c.jsonl
cwd: \\?\C:\Users\user\Desktop\angel-interior

# Read and mapped the Angel Interior workspace from root docs, admin-panel-angel, website-angel-interior, and GitNexus.

Rollout context: The user asked to “read and understand my project” for the shared `angel-interior` checkout, specifically covering `admin-panel-angel` and `website-angel-interior`. The assistant treated `STATUS.md`, `DATABASE.md`, `CROSSWALK.md`, and the app-local docs as the source of truth, then used GitNexus and selective file reads to map architecture and runtime seams.

## Task 1: Read `.codex` knowledge and root docs, then understand the project layout

Outcome: success

Preference signals:
- When the user asked to understand Angel Interior, they had previously requested “read my angel-interior project root folder .md” first -> future Angel runs should start from root handoff docs / project notes before code spelunking.
- The user’s request “admin-panel-angel website-angel-interior ai read and understand my project” indicates they want both apps understood together, not as isolated repositories.

Key steps:
- Read `.codex` PULSE and the Angel-related memory entries to pick up routing/history.
- Read root handoff docs: `STATUS.md`, `DATABASE.md`, `CROSSWALK.md`.
- Read app docs: `admin-panel-angel/CLAUDE.md`, `admin-panel-angel/README.md`, `admin-panel-angel/DOCS.md`, `admin-panel-angel/SUPABASE.md`, `website-angel-interior/CLAUDE.md`, `website-angel-interior/index.php`, `website-angel-interior/lib/initData.php`, `website-angel-interior/api/core/SupabaseClient.php`, `website-angel-interior/api/Models/SeoModel.php`, `website-angel-interior/lib/downloadData.php`.
- Used GitNexus `list_repos`, `query`, and `context` to confirm the checkout is indexed and to map auth / SEO / download-related symbols.

Failures and how to do differently:
- `Get-Content` against `C:\Users\user\.codex\skills\gitnexus-exploring\SKILL.md` failed because the path was wrong; the correct file was under `C:\Users\user\.agents\skills\gitnexus-exploring\SKILL.md`.
- `project_notes/ANGEL_INTERIOR_LOCAL_DEV.md` was not found at the root path queried; if needed, re-check the actual location before assuming it is in the checkout root.

Reusable knowledge:
- The shared Angel workspace is split into a Vben admin (`admin-panel-angel`) and a PHP website (`website-angel-interior`) that both consume the same Supabase project / schema.
- Root truth currently lives in `STATUS.md`, `DATABASE.md`, and `CROSSWALK.md`; they are the best entry point for future understanding tasks.
- The website runtime is PHP server-rendered with a Sovereign REST/Supabase helper layer; the admin is Vben Admin 5.x + Vue 3 + TypeScript + Pinia.
- The website router in `index.php` exposes public pages plus JSON endpoints, and `initData.php` applies route-aware SEO with `/blogs/{slug}` excluded from SEO table lookup.
- `SupabaseClient.php` sends `Accept-Profile` / `Content-Profile` headers to the configured schema when talking to PostgREST.
- Download behavior is centralized in `lib/downloadData.php`: free resources go to `/download-file/...`, paid resources use `/checkout/...`, and Stripe session creation is handled there.

References:
- [1] `STATUS.md`: admin panel at `admin-panel-angel/`, website at `website-angel-interior/`, local admin `http://localhost:6006/`, local website `http://127.0.0.1:8000/`, and the current work is in implementation/verification mode.
- [2] `DATABASE.md`: canonical schema facts for `angelInterior.*`, including `blog_posts`, `slideshows`, `sketchup_resources`, `material_resources`, `seo_settings`, and `contact_submissions`.
- [3] `CROSSWALK.md`: mapping from business entity to admin route, e.g. Blog Post -> `/blog/posts`, Material Resource -> `/material/resources`, Contact Submission -> `/contact/submissions`, Attachments -> `/attachments/album`.
- [4] `admin-panel-angel/apps/web-antd/src/stores/auth.ts:46-83`: `authLogin()` calls `loginApi()`, stores the access token, then fetches user info / access codes.
- [5] `admin-panel-angel/apps/web-antd/src/api/core/auth.ts:24-120`: auth switches between mock and Supabase mode via `VITE_NITRO_MOCK`.
- [6] `website-angel-interior/index.php:19-54`: router includes `/material-free-resources` redirect, public routes, and API endpoints like `/api/v1/seo`, `/api/v1/contact-submissions`, `/api/v1/track-download`.
- [7] `website-angel-interior/lib/initData.php:39-65`: site meta, contact/social fallbacks, and per-route SEO override logic.
- [8] `website-angel-interior/api/Models/SeoModel.php:17-40`: SEO rows are filtered by `project_id`, `source_surface='website'`, `deleted_at is null`, and `published_at not null`, then keyed by `route_path`.
- [9] `website-angel-interior/lib/downloadData.php:61-104,199-281`: free vs paid CTA resolution, Stripe checkout session creation, and download normalization.

## Task 2: Build a practical architecture map for future edits

Outcome: success

Preference signals:
- The user asked to “read and understand my project,” which implies they want a usable map of how the system fits together, not just a file list.
- The assistant’s final reply showed that this kind of request should be answered with the project’s current shape plus any remaining gaps, not only with source citations.

Key steps:
- Confirmed the admin routes / modules that are active: users, blog, slideshow, sketchup, seo, material, contact, attachments, workflow-test.
- Confirmed the website routes and data flow: homepage, about, SketchUp resources, material resources, blog list/detail, contact, checkout/download, SEO JSON, and tracking endpoints.
- Confirmed the admin-side material store directly talks to Supabase and supports list/create/update/remove/reorder for both categories and resources.
- Confirmed the website uses Supabase-backed PHP helpers and a schema-aware REST client, while SEO rows are served from DB-backed `seo_settings`.
- Confirmed the download flow is split between resource metadata, Stripe checkout, and file streaming.

Failures and how to do differently:
- GitNexus `query` for auth and SEO returned mostly definitions rather than rich processes; for deeper path tracing, future agents should target specific symbol names via `context()` or ask a narrower flow question.

Reusable knowledge:
- `admin-panel-angel` is the schema owner and editing surface; `website-angel-interior` is the runtime consumer.
- The project is no longer at discovery stage; it is in implementation/verification, with the root docs explicitly stating the main unfinished work is live verification of admin CRUD, workflow tests, and some website paths.
- For future work in this checkout, the safe default is: read root handoff docs first, then app-local docs, then the relevant store/model/router files.

References:
- [10] `admin-panel-angel/apps/web-antd/src/stores/material.ts:36-306`: material category/resource stores implement the full Supabase CRUD + reorder API.
- [11] `admin-panel-angel/apps/web-antd/src/router/routes/modules/*.ts`: active feature routes include `workflow-test.ts`, `users.ts`, `slideshow.ts`, `sketchup.ts`, `seo.ts`, `material.ts`, `contact.ts`, `blog.ts`, `attachments.ts`.
- [12] `STATUS.md:79-85, 158-178, 188-207`: app roles, implemented website/API surfaces, and remaining verification work.
- [13] `DATABASE.md:338-371, 381-424`: relationships, JWT contract, and migration index for the Angel schema.
