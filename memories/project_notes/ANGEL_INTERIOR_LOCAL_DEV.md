---
name: angel-interior-local-dev
description: "Angel Interior localhost startup — exact working commands for PHP website and Vben admin panel. run-local.bat silently exits; use direct PHP command instead."
metadata:
  type: project
---

# Angel Interior — Local Dev Startup (Verified 2026-06-02)

## Project root
`C:\Users\user\Desktop\angel-interior`

---

## PHP Website (website-angel-interior)

**Working URL:** `http://127.0.0.1:8000/`

**Why `run-local.bat` fails:** When launched via `Start-Process cmd`, the bat file exits silently without keeping the PHP server alive. Use the direct PHP command below instead.

**Correct command — opens a dedicated PowerShell window that stays open:**
```powershell
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd 'c:\Users\user\Desktop\angel-interior\website-angel-interior'; php -S 127.0.0.1:8000 index.php"
```

**Verify it's up:**
```powershell
Invoke-WebRequest -Uri "http://127.0.0.1:8000/" -UseBasicParsing -TimeoutSec 5
# Expect: StatusCode = 200
```

**PHP binary:** `php 8.3.8` is on PATH — no path override needed.

**Keep window open** — closing the PowerShell window kills the server.

---

## Admin Panel (admin-panel-angel)

**Working URL:** `http://localhost:6006/`
**Login:** `admin@interiordesignangel.com` / `123456`

**Correct command — opens a dedicated PowerShell window:**
```powershell
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd 'c:\Users\user\Desktop\angel-interior\admin-panel-angel'; pnpm run dev:local"
```

---

## Both at once (one-liner)
```powershell
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd 'c:\Users\user\Desktop\angel-interior\admin-panel-angel'; pnpm run dev:local"
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd 'c:\Users\user\Desktop\angel-interior\website-angel-interior'; php -S 127.0.0.1:8000 index.php"
```

---

**Why:** `run-local.bat` silently exits when spawned non-interactively. Direct `php -S` keeps the server alive as long as the terminal window stays open.
