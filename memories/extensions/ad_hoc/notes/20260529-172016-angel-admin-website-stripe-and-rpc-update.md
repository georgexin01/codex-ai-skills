## Scope

Additive update for `C:\Users\user\Desktop\angel-interior` covering the latest work across:
- `admin-panel-angel`
- `website-angel-interior`

Keep older memory entries unchanged. This note extends them with the newer state and flow details below.

## 1) `admin-panel-angel` — local Supabase user creation RPC fix

### Problem observed

In the Angel admin panel, creating a user from the Users drawer failed with:

- PostgREST `400 Bad Request`
- RPC error `column "status" does not exist`

The failing path was:

1. Admin UI Create User drawer
2. `apps/web-antd/src/stores/users.ts`
3. `supabase.rpc('create_user', ...)`
4. `angelInterior.create_user(...)`
5. SQL looked up `public.role` with `status = 'active'`
6. Some environments did not actually have `public.role.status`

### Important repo findings

- `apps/web-antd/src/stores/users.ts` was not the bug source; the frontend caller was low-risk and isolated.
- `apps/web-antd/src/sql/migrations/053_angel_fix_create_user_rpc.sql` still assumed `public.role.status` exists.
- `apps/web-antd/src/sql/migrations/026_angel_public_project_auth.sql` is the bridge migration that adds `status` to `public.role` and `public."user"`.
- Real issue = schema drift between environments, not the Vue drawer itself.

### New fix added

New migration created:

- `apps/web-antd/src/sql/migrations/064_angel_make_user_rpc_role_status_agnostic.sql`

What it does:

1. Replaces `angelInterior.create_user`
2. Replaces `angelInterior.update_user`
3. Checks `information_schema.columns` to see whether `public.role.status` exists
4. Uses `status = 'active'` only when that column is present
5. Falls back to role lookup without `status` when the column is absent
6. Preserves the existing business-table insert flow into `angelInterior.users`

### Local apply / verification flow used

Local Supabase was confirmed running at:

- API: `http://127.0.0.1:54321`
- Studio: `http://127.0.0.1:54323`
- DB: `postgresql://postgres:postgres@127.0.0.1:54322/postgres`

Because Windows `psql` was not installed directly, the migration was applied through the running Docker DB container:

1. Copy SQL file into `supabase_db_local-supabase`
2. Run `psql -f /tmp/064_angel_make_user_rpc_role_status_agnostic.sql`
3. Confirm `CREATE FUNCTION` / `GRANT` succeeded
4. Confirm `angelinterior.create_user` and `angelinterior.update_user` exist
5. Confirm `create_user` definition now contains `information_schema.columns`

### Reuse guidance

When Angel admin user creation fails with `status`-column errors:

1. Check whether the error is coming from the RPC, not the Vue form
2. Compare `053` vs actual DB state
3. If the target environment may not have `public.role.status`, apply `064`
4. Treat `026` as the cleaner long-term schema alignment step
5. Keep the fix append-only with numbered migrations; do not rewrite prior migration history

## 2) `website-angel-interior` — Stripe flow advanced beyond placeholder stage

### Prior memory to preserve

Older memory correctly described a temporary placeholder flow:

- separate checkout route
- coming-soon messaging
- preservation-first edits
- redirect-chain concerns

That older history should remain. Newer state: the website work progressed from placeholder-only toward a real Stripe checkout + verified download flow.

### New Stripe-related state

Files updated:

- `template/checkout.php`
- `template/download.php`
- `lib/downloadData.php`
- `api/core/.env.production`
- `api/Config.php`
- `lib/initData.php`

### New flow now present

#### Checkout flow

`template/checkout.php` now behaves more like a real payment entrypoint:

1. Load resource from route params
2. Reject non-paid resources
3. Detect current host/scheme
4. If Stripe runtime config exists and request is not a cancelled return:
   - build success URL: `/download?session_id={CHECKOUT_SESSION_ID}`
   - build cancel URL back to the checkout route with `?cancelled=1`
   - call `createStripeCheckoutSession(...)`
   - redirect to Stripe Checkout if session creation succeeds
5. If cancelled:
   - show a retry-focused cancelled state
6. If Stripe session creation fails:
   - show a payment error state
7. If Stripe is not configured:
   - fall back to the non-live "coming soon" style UI

#### Download flow

`template/download.php` now expects real Stripe return data:

1. Read `session_id`
2. If preview mode is active and Stripe is absent, allow sample rendering
3. Otherwise fetch the Stripe Checkout session
4. Read `resource_type` + `resource_id` from Stripe metadata
5. Resolve the matching resource
6. Mark the purchase valid only when:
   - session exists
   - `payment_status` is `paid`
   - resource exists
   - metadata matches resource identity
7. Show unlocked download CTA only for verified sessions

### Stripe runtime/config details

`lib/downloadData.php` now reads Stripe settings via:

- `\Sovereign\Core\SupabaseConfig::loadEnv()`

instead of plain `getenv(...)`.

Expected keys:

- `STRIPE_SECRET_KEY`
- `STRIPE_PUBLISHABLE_KEY`
- `STRIPE_CURRENCY`

Production env file was updated to include those keys in:

- `website-angel-interior/api/core/.env.production`

### Pricing behavior added

Stripe session creation now includes a minimum-charge safeguard:

1. Read listed resource price
2. Convert to cents
3. Apply a floor amount (`$0.55` equivalent in the current code comments)
4. If listed price is below the floor:
   - prepend a notice into the Stripe product description
   - add a Stripe `custom_text[submit][message]` notice above the pay button

This is important because the user wanted a real Stripe path, but tiny-card-charge limits can otherwise break checkout.

### Reuse guidance

When the user asks about Angel paid downloads:

1. Do not assume it is still placeholder-only
2. Check whether Stripe runtime config is actually present
3. Confirm the full chain:
   - paid resource CTA
   - `/checkout/{type}/{id}`
   - Stripe Checkout session
   - `/download?session_id=...`
   - verified unlocked download
4. Preserve fallback behavior for missing config / cancelled payment / Stripe error
5. Keep download verification tied to Stripe session metadata, not just query params

## 3) `website-angel-interior` — website-side warning cleanup and accessibility hardening

### Header / route safety

`lib/header.php` was hardened because PHP deprecation warnings appeared around:

- `strpos(): Passing null to parameter #1 ($haystack)`

New behavior:

1. Normalize `$_SERVER['REQUEST_URI']`
2. Guard `strtok(...)` false cases
3. Cast `$current` safely before route comparisons
4. Protect the Material and Blogs active-nav checks from null values

### Mobile/meta warning cleanup

`lib/htmlHead.php` now includes:

- `<meta name="mobile-web-app-capable" content="yes">`

This was added alongside the older Apple meta tag to reduce the deprecation warning without removing older behavior.

### Modal / iframe warning cleanup

Files updated:

- `template/home.php`
- `template/about.php`
- `template/sketchup-free-resources.php`
- `template/material-free-resources.php`
- `template/download.php`

Changes made:

1. Removed redundant `allowfullscreen` where `allow="... fullscreen"` already exists
2. On modal close, blur the currently focused element if it is inside the dialog
3. Then set `aria-hidden="true"`

Reason:

- browser console was showing `aria-hidden` / focused descendant warnings on asset modals
- user wanted reduction of website-owned warnings, not broad third-party console noise

### Important filtering lesson

Many console warnings seen during this session were not first-party website problems:

- `contentscript.js`
- `ObjectMultiplex`
- `MaxListenersExceededWarning`
- `Injection blocked for this domain`
- TikTok `webmssdk` / `accelerometer` / `devicemotion` / permissions-policy warnings

Treat those as extension or third-party embed noise unless the user explicitly wants to redesign/remove the embed behavior.

## 4) `website-angel-interior` — download page hero UX polish

Latest visible page polish happened in:

- `template/download.php`

New behavior:

1. Under the purchased resource title, show a short muted gray note
2. Source it from the resource `description`
3. Collapse whitespace
4. Trim to a compact length so the hero stays clean
5. Keep it visually simple, small, and low contrast

This reflects the user’s preference for:

- small
- gray
- short
- under-title supporting text only

When similar requests come in later, preserve the restrained hero style rather than expanding into long marketing copy.

## 5) Contact/email config updates

Additional site config changes worth remembering:

- contact email changed to `hello@interiordesign-angel.com`
  - updated in `api/Config.php`
  - updated in `lib/initData.php`
- `sendEmail.php` was pointed at a new Apps Script ID
- `send-notification.php` is present as a new untracked file and may represent new notification work not yet fully normalized into the main website flow

## 6) Best future-agent workflow for this repo pair

For future work touching both Angel admin and Angel website:

1. Treat `admin-panel-angel` and `website-angel-interior` as related but separate runtime systems
2. For admin RPC/auth issues:
   - inspect SQL migrations before touching Vue
   - compare local Supabase schema vs intended migration contract
3. For website paid-download work:
   - inspect checkout route, download route, and `lib/downloadData.php` together
   - verify env-backed Stripe config before assuming placeholder mode
4. For console-warning cleanup:
   - separate first-party website warnings from extension/TikTok noise
   - only patch the website-owned issues unless the user explicitly wants third-party embed changes
5. For memory continuity:
   - retain the older placeholder Stripe history
   - add that newer work moved into real Stripe session creation and verified download gating
