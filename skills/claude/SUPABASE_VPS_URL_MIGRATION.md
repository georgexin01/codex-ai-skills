---
name: supabase-vps-url-migration
description: "VPS Supabase URL change from supabase.interiordesign-angel.com subdomain to interiordesign-angel.com root domain. All env files, docs, and required Nginx/Supabase config changes documented."
triggers: ["supabase url", "supabase domain", "vps supabase", "change supabase url", "supabase subdomain", "interiordesign-angel supabase"]
version: 1.0
date_updated: "2026-06-03"
project: angel-interior
status: COMPLETED — migrated 2026-06-03
---

# Supabase VPS URL Migration

## Change Summary
| Before | After |
|---|---|
| `https://supabase.interiordesign-angel.com` | `https://interiordesign-angel.com` |

Root domain now serves both the PHP website AND reverse-proxies Supabase API — no subdomain needed.

---

## Files Updated (angel-interior project)

### website-angel-interior
| File | Change |
|---|---|
| `api/core/.env.production` | `SUPABASE_URL=https://interiordesign-angel.com` |
| `api/core/.env` | Updated commented-out production reference |
| `CLAUDE.md` | Updated Supabase default URL reference |

### admin-panel-angel
| File | Change |
|---|---|
| `apps/web-antd/.env.production` | `VITE_SUPABASE_URL` + `VITE_GLOB_API_URL` |
| `apps/web-antd/.env.development` | `VITE_SUPABASE_URL` + `VITE_GLOB_API_URL` |

### Local dev files — DO NOT change
These always point to `localhost:54321` (Docker Compose):
- `apps/web-antd/.env.development.localhost`
- `apps/web-antd/.env.development.supabase`
- `api/core/.env` (active local dev env)

---

## VPS / Nginx Config Required

For `https://interiordesign-angel.com` to proxy Supabase API, your Nginx config must route `/rest/v1/`, `/auth/v1/`, `/storage/v1/`, `/realtime/v1/`, and `/functions/v1/` to the Supabase Kong gateway (port 8000).

**Nginx example:**
```nginx
server {
    listen 443 ssl;
    server_name interiordesign-angel.com;

    # PHP website (cPanel/Apache handles this)
    # ... existing site config ...

    # Supabase API reverse proxy
    location ~ ^/(rest|auth|storage|realtime|functions)/v1/ {
        proxy_pass http://localhost:8000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

**If using cPanel + VPS combo:** the cPanel Apache/Nginx handles the root domain for PHP. Add the Supabase proxy location block in the VPS Nginx conf — NOT in .htaccess (Apache can't proxy to a local port in a shared-hosting-style .htaccess).

---

## Supabase Docker Config — What to Check

In your VPS's `docker-compose.yml` (or `supabase/docker-compose.yml`):

```yaml
# Supabase expects to know its public URL for storage object URLs, auth redirects, etc.
# Update SITE_URL and API_EXTERNAL_URL:
environment:
  SITE_URL: https://interiordesign-angel.com
  API_EXTERNAL_URL: https://interiordesign-angel.com
  # If using Kong:
  KONG_HTTP_PORT: 8000
```

Also check `supabase/config.toml` if self-hosted:
```toml
[api]
port = 54321
# external URL used for storage URLs and auth callbacks
[auth]
site_url = "https://interiordesign-angel.com"
```

**Storage bucket public URL:** Supabase storage public URLs are built from `SUPABASE_URL/storage/v1/object/public/...`. After the URL change, existing stored file URLs in the DB still use the old domain — they'll work as long as Nginx proxies correctly. No DB migration needed unless you want to rewrite the stored URLs.

---

## Anon Key — Same Key Works

The anon JWT is signed by your Supabase instance's JWT secret, not the domain. The same key works regardless of whether you access via subdomain or root domain.

```
eyJhbGciOiAiSFMyNTYiLCAidHlwIjogIkpXVCJ9.eyJyb2xlIjogImFub24iLCAiaXNzIjogInN1cGFiYXNlIiwgImlhdCI6IDE2NDE3NjkyMDAsICJleHAiOiAxNzk5NTM1NjAwfQ.1z3DU1Qbm4RTErVIRiiSwTg-NpNG4EAxShvJsVO2zG4
```

---

## Post-Migration Checklist

```
[ ] Nginx proxy config updated on VPS for /rest/v1/, /auth/v1/, /storage/v1/
[ ] SITE_URL in Supabase docker-compose.yml updated to https://interiordesign-angel.com
[ ] API_EXTERNAL_URL updated in docker-compose.yml
[ ] Admin panel rebuilt (pnpm run build) with new .env.production
[ ] Website .env.production deployed to cPanel/server
[ ] Test: curl https://interiordesign-angel.com/rest/v1/ → should return Supabase response
[ ] Test: admin panel login works at production URL
[ ] Test: website blog/resources load on production
[ ] Storage image URLs still resolve (or update DB if needed)
```
