Context: Angel Interior local Supabase workflow protection.

Rule:
- `C:\Users\user\Documents\local-supabase` is the user's canonical local Supabase Docker project.
- Treat `local-supabase` as the protected default local database stack for Angel-related local work unless the user explicitly says otherwise in the current turn.
- Do not switch the active local Supabase project to `website-angel-interior` or any other project by default.
- Do not stop, replace, reinitialize, migrate, relabel, or repoint the local Docker Supabase stack away from `local-supabase` without explicit user confirmation in that same turn.
- Even if the user requests a related environment/config change, double-check with the user before changing anything that could affect which Docker Supabase project is active.

Why:
- Switching the active local stack from `local-supabase` to `website-angel-interior` broke the user's working flow.
- The user considers `local-supabase` very important infrastructure and wants it preserved.

Operational guidance:
- When local Supabase is involved, verify which project is active before changing env files, CLI commands, Docker stacks, or local endpoints.
- If a task could affect the active local Supabase stack, pause and ask for confirmation first.
- Prefer adapting app/site config to the protected `local-supabase` stack rather than changing the stack itself.
