---
name: localhost-php-test-protocol
description: "Reliable method to run and verify a local PHP website (php -S) for testing. Fixes the repeated 'ERR_CONNECTION_REFUSED' / dead-server failure."
tier: 2_governance
version: 1.0
status: authoritative
date_updated: "2026-05-21"
triggers: ["localhost", "php -S", "run php website", "test website locally", "ERR_CONNECTION_REFUSED", "local server", "8000", "8001", "8002", "8003", "run-local", "serve php"]
applies_to: ["codex-gpt", "claude-code"]
---

# Localhost PHP Website — Test Protocol (Tier-2)

How to start, keep alive, and verify a local PHP site. Written after repeated `ERR_CONNECTION_REFUSED` failures: the server was started in the **foreground**, so it died the moment the agent turn/command ended.

## 1. Root cause of ERR_CONNECTION_REFUSED

`ERR_CONNECTION_REFUSED` = nothing is listening on that port. Almost always one of:

- **Server died** — `php -S` ran in the foreground; when the agent turn or command finished, the process was killed. THE most common cause. A site that "started successfully" but is unreachable a minute later was never kept alive.
- **IPv4/IPv6 mismatch** — `php -S localhost:8000` may bind IPv6 `::1` while the browser hits IPv4 `127.0.0.1` (or vice versa). Always bind and browse `127.0.0.1`.
- **Port already in use** — another server holds the port.

## 2. The reliable command

From the website root (the folder containing the front controller):

```
php -S 127.0.0.1:8000 index.php
```

- Bind `127.0.0.1`, never `localhost` — avoids the IPv4/IPv6 trap.
- The last argument is the **front controller / router**, not a plain page. For the angel / LAA PHP sites it is `index.php` — it detects `php_sapi_name()==='cli-server'`, serves real static files via `return false`, then includes `router.php` + the route table. Passing a page file (or the wrong file) breaks pretty routes like `/blogs`.
- Port range for this user: **8000-8003** — pick the first free one so multiple PHP sites can run at once.

## 3. Keeping it alive — the actual fix

A foreground `php -S` dies when the turn ends. Two correct options:

- **Agent self-test** — start the server as a BACKGROUND / detached process, verify it, then report. A background process survives across turns within the session.
- **Hand to the user** — give a launcher (`run-local.bat`) the user double-clicks; it holds the port open in its own window, independent of the agent. This is the right deliverable when the user says "I will check myself."

NEVER run `php -S` foreground in a blocking command and then tell the user to open the browser — by then the process is already gone.

## 4. Verify before claiming success

Never report "it works" just because the command was issued. Confirm with HTTP:

```
curl -s -o NUL -w "%{http_code}\n" http://127.0.0.1:8000/blogs
```

Expect `200`. Also curl one API route (e.g. `/api/v1/blog-posts`).
- `000` / refused → server is not up (see §1/§3).
- `500` → server IS up but the page fatals — that is a code bug, NOT a connection problem; read the server log.

## 5. Port selection (8000-8003)

```
netstat -ano | findstr ":8000 "
```

A returned line = port taken; try 8001, 8002, 8003. First free wins. All four free → use 8000.

## 6. Launcher template (give to the user)

A `run-local.bat` in the website root that: locates PHP (PATH first, then known installs), picks the first free port of 8000-8003 (or accepts one as an argument), binds `127.0.0.1`, and `pause`s on exit so a startup crash stays visible instead of the window vanishing. Reference implementation: `website-angel-interior/run-local.bat`.

## 7. PHP location (this machine)

`php` is on PATH (8.3.8). Explicit fallbacks: `C:\Program Files\PHP\php-8.3.8\php.exe`, `C:\Program Files\PHP\php-8.1.18-Win32-vs16-x64\php.exe`. Prefer PATH; pin an explicit path only if PATH php is missing or the wrong version.

---
**Localhost PHP Test Protocol V1.0 — 2026-05-21**
