---
name: angel-interior-local-dev
description: Start the Angel Interior website and admin panel locally with the verified commands when `run-local.bat` exits or the user asks to run/check localhost.
argument-hint: "[website|admin|both]"
user-invocable: false
allowed-tools:
  - Read
  - Bash
---

# Angel Interior Local Dev

## When to use

Use this when work is in `C:\Users\user\Desktop\angel-interior` and the user wants the local website, the admin panel, or both running.

Do not use this for production deploy/debug work, or when the task is about changing app code without needing local servers.

## Inputs / context to gather

1. Confirm the project note `project_notes/ANGEL_INTERIOR_LOCAL_DEV.md` still exists.
2. Confirm whether the user needs `website`, `admin`, or `both`.
3. Confirm the checkout root is `C:\Users\user\Desktop\angel-interior`.

## Procedure

1. Read `project_notes/ANGEL_INTERIOR_LOCAL_DEV.md` for the last verified commands.
2. For `website`, start a dedicated PowerShell window with:
   ```powershell
   Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd 'c:\Users\user\Desktop\angel-interior\website-angel-interior'; php -S 127.0.0.1:8000 index.php"
   ```
3. For `admin`, start a dedicated PowerShell window with:
   ```powershell
   Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd 'c:\Users\user\Desktop\angel-interior\admin-panel-angel'; pnpm run dev:local"
   ```
4. For `both`, run both startup commands in separate windows.
5. Verify the website with:
   ```powershell
   Invoke-WebRequest -Uri "http://127.0.0.1:8000/" -UseBasicParsing -TimeoutSec 5
   ```
6. Report the expected local URLs and note that closing the spawned PowerShell window stops that server.

## Efficiency plan

1. Read only the project note unless it looks stale.
2. Do not explore unrelated code before trying the verified startup commands.
3. Use the direct commands first because `run-local.bat` is known to exit silently when spawned non-interactively.
4. Stop after startup plus one verification request unless the user asks for deeper debugging.

## Pitfalls and fixes

- Symptom: `run-local.bat` opens and exits immediately.
  Fix: use direct `php -S 127.0.0.1:8000 index.php` in a `Start-Process powershell -NoExit` window.

- Symptom: localhost check fails after startup.
  Fix: confirm the spawned PowerShell window is still open and the command was started from the correct subfolder.

- Symptom: the agent is tempted to expose demo/admin credentials.
  Fix: do not copy credentials from notes into memory or chat unless the user explicitly asks for them.

## Verification checklist

1. `project_notes/ANGEL_INTERIOR_LOCAL_DEV.md` matches the commands being used.
2. `Invoke-WebRequest http://127.0.0.1:8000/` returns HTTP 200 for the website path.
3. The user gets the correct localhost URL for the service they asked for.
4. The response notes that server lifetime is tied to the spawned PowerShell window.
