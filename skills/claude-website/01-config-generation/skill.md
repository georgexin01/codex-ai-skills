---
name: website-01-config-generation
description: "Step 01 — project genesis: folder layout + api/core/.env + api/core/.env.production. First step before any PHP code."
triggers: ["website config", "generate env", "php .env", "project genesis", "new website"]
phase: 1-foundation
requires: []
unlocks: [website-02-env-loader, website-03-composer-autoload]
output_format: mixed
version: 2.0
status: authoritative
last_updated: "2026-04-20"
---

# Step 01 — Config Generation (folder layout + env)

## 🎯 When to Use
First step of a new Sovereign PHP + Supabase website. Establishes the skeleton folder tree and secret-bearing env files.

## ⚠️ Dependencies
None — this is Step 1.

## 📋 Procedure

1. **Create project root** folder (e.g., `website-<name>/`). All paths below are relative to it.
2. **Create the folder tree** (Code Vault §1). `api/core/`, `api/Models/`, `api/Controllers/`, `api/Lib/`, `api/v1/`, plus top-level `css/`, `js/`, `images/`, `uploads/`, `lib/`, `template/`.
3. **Create `api/core/.env`** — Code Vault §2. Local dev secrets.
4. **Create `api/core/.env.production`** — Code Vault §3. Production secrets. Keep blank placeholders until deploy.
5. **Update `.gitignore`** — add `api/core/.env` and `api/core/.env.production` (Code Vault §4).
6. **Create placeholder `.env.example`** — redacted keys, committed to git. Onboarding signal.

## 📦 Code Vault

### §1. Folder tree
```
website-<name>/
├── api/
│   ├── core/                      # SupabaseClient, SovereignQuery, SupabaseConfig, .env
│   │   ├── .env                   # gitignored — local dev
│   │   └── .env.production        # gitignored — prod secrets
│   ├── Models/                    # BaseModel + entity Models
│   ├── Controllers/               # BaseController + entity Controllers
│   ├── Lib/                       # ErrorHandler, JWT (if needed)
│   ├── v1/                        # endpoint adapters — one .php per resource
│   ├── Config.php                 # Sovereign\Config constant (non-secret defaults)
│   └── Helper.php                 # Sovereign\* procedural helpers
├── css/
├── js/
├── images/
├── uploads/                       # dev file uploads (gitignored subfolders)
├── lib/                           # vendored 3rd-party (if any)
├── template/                      # PHP partials (header, footer)
├── composer.json                  # step 03 fills this
├── index.php                      # step 11
├── router.php                     # step 11
├── home.php                       # step 12
└── .gitignore
```

### §2. `api/core/.env` (local dev — gitignored)
```bash
# App mode — switches the Sovereign\Config block (dev | production)
APP_ENV=dev

# Supabase — local Docker (supabase start)
SUPABASE_URL=http://localhost:54321
SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.<local-dev-anon-jwt>
SUPABASE_SCHEMA=quizLaa

# Project binding — UUID of the public.project row for this site
PROJECT_ID=00000000-0000-0000-0000-000000000000
```

### §3. `api/core/.env.production` (prod — gitignored)
```bash
APP_ENV=production

# Supabase — production project
SUPABASE_URL=https://<project-ref>.supabase.co
SUPABASE_ANON_KEY=<prod-anon-jwt>
SUPABASE_SCHEMA=quizLaa

PROJECT_ID=<prod-uuid>
```

### §4. `.gitignore` (critical additions)
```gitignore
# Sovereign secrets
api/core/.env
api/core/.env.production
api/core/.env.local

# Composer
vendor/
composer.lock

# Logs + dev artifacts
api/logs/
uploads/**/*
!uploads/.gitkeep

# IDE
.vscode/
.idea/
.DS_Store
```

### §5. `api/core/.env.example` (committed — redacted)
```bash
APP_ENV=dev

SUPABASE_URL=http://localhost:54321
SUPABASE_ANON_KEY=<anon-jwt-from-supabase-status>
SUPABASE_SCHEMA=quizLaa

PROJECT_ID=<uuid-from-public.project>
```

## 🛡️ Guardrails

- **`.env` never in git** — double-check `.gitignore` before first commit. A leaked anon key is recoverable (just rotate it) but leaked service-role would be catastrophic (this stack uses anon only — see Guardrail below).
- **Anon JWT only in client code** — the Sovereign stack runs public-facing PHP with the anon key. Service-role never reaches the PHP process. Admin mutations go through the admin panel's authenticated RPCs, not this backend.
- **`.env` lives INSIDE `api/core/`** (not at project root). This keeps it adjacent to the consumer (`SupabaseConfig::loadEnv()` in Step 07). The file lookup in `SupabaseConfig.php` searches `api/core/.env` first, falls back up two levels — but co-locating is the canonical path.
- **APP_ENV gate** — the `dev` vs `production` switch is read from this file and selects the Config block in Step 02. Never hardcode `'production'` in PHP.
- **Schema isolation (Rule #1)** — `SUPABASE_SCHEMA` is locked to the project schema (`quizLaa` for this family). Never point it at `public` — the PHP layer is business-only.
- **No trailing slash on SUPABASE_URL** — `SupabaseClient` does `rtrim($url, '/')` defensively, but don't rely on that. Paste the URL exactly as Supabase prints it.

## ✅ Verify

```bash
# 1. Folder structure exists
ls -R api/
# Expect: core/ Models/ Controllers/ Lib/ v1/ Config.php Helper.php

# 2. .env is git-ignored
git check-ignore api/core/.env
# Expected: api/core/.env (i.e., it's ignored)

# 3. Env file reads
php -r "
  \$lines = file('api/core/.env', FILE_IGNORE_NEW_LINES);
  foreach (\$lines as \$l) if (strpos(\$l, 'SUPABASE_URL=') === 0) echo \$l;
"
# Expected: prints the URL line (no trailing newline drama)
```

## ♻️ Rollback
```bash
rm -rf api/
rm -f .gitignore   # only if you just created it and want to start over
```

## → Next Step
**[02-env-loader](../02-env-loader/skill.md)** — `api/Config.php` defines the Sovereign\Config constant with dev/production env blocks.
