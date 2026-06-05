## Scope

Small addendum to the broader `20260529-172016-angel-admin-website-stripe-and-rpc-update.md` note. Keep that larger note as the main source; this file captures smaller details that are still useful for future agents.

## 1) `admin-panel-angel` login demo credential cleanup

Current working tree includes an edit in:

- `admin-panel-angel/apps/web-antd/src/views/_core/authentication/login.vue`

The demo account map for the admin quick-select was changed from a real-looking default:

- username previously looked like the Angel admin email
- password previously had a default sample value

to blank values:

- `username: ''`
- `password: ''`

Future agents should treat this as intentional privacy/security cleanup unless the user explicitly asks to restore quick-fill credentials. If login convenience is requested later, prefer a non-sensitive placeholder or an env-driven/dev-only helper rather than hardcoding real-looking credentials.

## 2) SQL README migration index is part of the RPC fix

Alongside creating `064_angel_make_user_rpc_role_status_agnostic.sql`, the migration index was updated in:

- `admin-panel-angel/apps/web-antd/src/sql/README.md`

The index now mentions both:

- `053_angel_fix_create_user_rpc.sql`
- `064_angel_make_user_rpc_role_status_agnostic.sql`

Future agents should keep this SQL README aligned when adding numbered migrations. This repo relies on the README as a human migration order map, not just the SQL files themselves.

## 3) `website-angel-interior` download counter data changed during testing

Current working tree includes a data mutation in:

- `website-angel-interior/data/resource-downloads.json`

It added one download count entry for a SketchUp resource. This appears to be runtime/test counter data, not hand-authored application logic.

Future agents should avoid overinterpreting this as a schema or code change. If preparing a clean commit, ask whether file-based runtime counters should be included or ignored/reset.

## 4) Stripe env keys are present but should be treated as sensitive

`website-angel-interior/api/core/.env.production` now contains Stripe-related keys:

- `STRIPE_SECRET_KEY`
- `STRIPE_PUBLISHABLE_KEY`
- `STRIPE_CURRENCY`

Do not quote or expose the secret key in summaries, PR text, or memory. When checking Stripe setup, confirm presence/shape only, and avoid copying key values into chat.

## 5) Notification work is present but not fully classified

`website-angel-interior/send-notification.php` exists as a new untracked file. It should be inspected before future agents assume how contact notifications are routed.

Related known change:

- `sendEmail.php` was pointed at a new Google Apps Script ID

Future agents working on contact/email should read:

1. `sendEmail.php`
2. `send-notification.php`
3. `template/contact.php`
4. `api/Config.php`

before deciding which notification path is active.
