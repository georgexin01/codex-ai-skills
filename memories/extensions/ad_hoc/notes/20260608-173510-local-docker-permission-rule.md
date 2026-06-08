## Absolute rule: local Docker database protection

User instruction recorded on 2026-06-08 for `quizLAA` and related local stacks:

- Local Docker database / local Supabase state is protected.
- Never rename local Docker projects, containers, schemas, databases, or stacks.
- Never remove, clean, reset, prune, stop, recreate, or modify local Docker database state without explicit user permission in that turn.
- Any change to local Docker / local Supabase config, schema exposure, routing, startup target, or database-related behavior requires explicit confirmation from the user first.
- Do not assume a different Docker stack is the correct one.
- If Docker appears to be opening another project such as `admin-vipbillion`, stop and ask before making any local Docker-related change.
- Treat this as a high-priority safety rule.
