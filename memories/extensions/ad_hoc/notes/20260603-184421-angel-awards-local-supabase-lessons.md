Context: Angel Interior awards module build-out across admin, website, and local/VPS Supabase.

High-value operating rules:
- `C:\Users\user\Documents\local-supabase` is the protected canonical local Supabase Docker project for Angel local work.
- Do not silently switch local website/database testing from `local-supabase` to another Supabase project such as `website-angel-interior`.
- Before changing any env routing, Docker stack, or Supabase target for Angel localhost testing, confirm with the user if the change would alter which database the website/admin is reading.

Env and runtime lesson:
- The Angel website can appear "empty" even when data exists if localhost is still reading `.env.production` / VPS Supabase instead of local `.env`.
- For Angel website debugging, treat env file selection, runtime host detection, and the actual Supabase project URL as one evidence chain.
- If admin writes to local Supabase but website reads VPS Supabase, missing homepage content is expected and is not a frontend rendering bug.

Reusable PHP + Supabase content-module lesson:
- A new website/admin content module is not complete with only table creation and RLS.
- The minimum working stack is:
  1. business table
  2. index / trigger
  3. authenticated RLS policies
  4. anon website-read policy matching the public-site architecture
  5. explicit SQL GRANTs for `authenticated`, `anon` (when needed), and `service_role`
  6. business permission rows if the admin relies on a permissions table
  7. storage bucket/path compatibility for uploaded images

Critical SQL lesson:
- `permission denied for table awards` was caused by missing PostgreSQL table GRANTs, not by missing RLS alone.
- When a Supabase admin table exists and policies look correct but CRUD still fails, check `information_schema.role_table_grants` immediately.

Public website RLS lesson:
- For Angel public website content, anon-read policies that depend on `angelinterior.is_current_project(project_id)` can block public reads even when rows exist.
- If the website architecture already filters by `project_id` at query time and uses the anon key for public content, a simpler public policy like `deleted_at IS NULL` may be the correct pattern.
- This mismatch explained why VPS awards rows existed but homepage/about still rendered empty.

Admin UX lesson:
- For year-only fields like Awards `award_date`, prefer plain text input over a year picker if timezone/date-object conversion can corrupt the saved year.
- A year picker caused `2023` to be saved/displayed as `2022`/full date text; a plain input plus normalization to the first 4-digit year is safer for this field.

Content-display mapping lesson:
- In the Awards module, the database field names stayed `title` and `description`, but the admin UI labels were remapped to:
  - `title` -> `Heading`
  - `description` -> `Title`
- For Angel admin work, UI wording can change while DB columns remain stable; treat label remaps as a preferred low-risk approach when the user wants terminology changes without schema churn.
