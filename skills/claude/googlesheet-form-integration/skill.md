---
name: googlesheet-form-integration
description: Wire HTML/PHP website forms to Google Sheets + Google Drive + email via a Google Apps Script web app. Full build playbook + troubleshooting for "Access denied: DriveApp", "Unknown form type", deploy/scope issues.
triggers: ["send form to google sheet", "appscript form", "apps script web app", "sendEmail.php", "form to googlesheet", "google sheet form integration", "store form in drive"]
phase: build
requires: []
unlocks: []
inputs: [project_folder, appscript_deploy_id, sheet_id, drive_folder_id]
output_format: code_blocks
model_hint: gpt-5.3-codex
version: 1.0
---

# Google Sheet Form Integration (Apps Script web app)

Connect any static/PHP website's forms to **Google Sheets** (data rows) + **Google Drive**
(file uploads) + **email notification**, using a Google Apps Script web app as the backend.
No server code — the browser `fetch()`s the Apps Script `/exec` URL directly.

Reference implementation lives at `quizLAA/idealbuild/sendEmail.php` and `quizLAA/website-LAA-website/lib/sendEmail.php`.

## Architecture

```
HTML form  --(fetch POST JSON)-->  Apps Script /exec  -->  Google Sheet (rows)
                                                       -->  Google Drive (uploaded files)
                                                       -->  MailApp email to recipients
```

- **Front end**: one JS file (`sendEmail.php` — it's just a `<script>` block, the `.php` ext lets it be `include()`d). Attaches `submit` listeners to each form by `id`, builds a JSON payload `{ type, data }`, POSTs to `https://script.google.com/macros/s/<DEPLOY_ID>/exec`.
- **Back end**: a single Apps Script project. `doPost(e)` parses JSON, routes on `type`, writes a row, optionally uploads a file, sends email.
- **IDs needed**: Apps Script **deployment ID** (the `AKfycb...` string), Google **Sheet ID**, Google **Drive folder ID**.

## Build Steps (in order)

### 1. Audit every form in the project
- `grep -rn "<form" --include="*.php"` (ignore any `downloaded-template/` / vendor copies).
- For each form record: file, `id="..."`, every `name="..."` input, whether it has `<input type="file">`.
- Forms with **identical field shape and similar purpose** (e.g. two "apply" forms) can share ONE table/type. Forms that differ (contact vs survey vs newsletter) each get their own table/type. **If the user later says "contact should be its own table", split the `type` even if fields are identical** — table separation is a product decision, not a schema one.

### 2. Define table schemas
One sheet/tab per form type. Decide headers up front. Example grouping from LAA:

| Form id | Page | `type` | Sheet tab |
|---|---|---|---|
| `resumeForm` | home.php | `application` | Applications |
| `contact-form` | contact.php | `contact` | Contacts |
| `survey-form` | survey.php | `survey` | Surveys |
| `newsletterForm` | footer.php | `subscriber` | Subscribers |
| (pre-existing) | — | — | EmailAccount (read-only, holds recipient emails in col A) |

### 3. Front end — `sendEmail.php`
- Single `const fetchCode = '<DEPLOY_ID>'`.
- `fetchPostByType(type, data)` — `fetch` with `method:"POST"`, `body: JSON.stringify({type,data})`.
  **Do NOT set `Content-Type: application/json`** — that triggers a CORS preflight Apps Script can't answer. Plain body = "simple request" = no preflight.
- `readFileAsBase64(file)` — `FileReader.readAsDataURL` → base64 data URL string.
- For file forms: read `input[type="file"]`, attach `fileData` (base64), `fileName`, `fileType` to payload.
- A `makeFormHandler(type)` factory keeps multiple same-shape forms DRY.
- Include it once globally (LAA does `include(__DIR__.'/sendEmail.php')` inside `lib/htmlBody.php` so every page gets it).
- Verify EVERY form `name="..."` is read by the JS. Mismatch = silent empty cell.

### 4. Back end — Apps Script (template below)
- `const SHEET_ID`, `const DRIVE_ID`, `const EMAIL_TAB = 'EmailAccount'`.
- `HEADERS` object: `{ TableName: [...headers] }` — single source of truth.
- `doPost(e)` → parse, route on `type`, return `ContentService` JSON.
- `ensureSheet(name)` — create tab if missing, **always re-write row 1 from `HEADERS`** (so editing a header label in code updates the sheet on next submit), bold + grey header, `setFrozenRows(1)`.
- `uploadToDrive()` — decode base64, `folder.createFile(blob)`. **Wrap `setSharing()` in its own try/catch** (see Pitfall 4).
- `getRecipients()` — read `EmailAccount` col A, regex-filter valid emails.
- `notify()` — `MailApp.sendEmail` to recipients.
- Each `handle<Type>()` — wrap `uploadToDrive` in try/catch so a Drive failure still saves the row (writes `UPLOAD FAILED: <reason>` into the URL cell instead of dropping the whole submission).
- Remove all test/auth scaffolding from the final version — keep only `doPost`, `doGet`, and the helpers.

### 5. Deploy & authorize (the step everyone forgets)
1. Paste code, **Save**.
2. Run any function once from the editor (e.g. `doGet` or a temp `authorize()`) → approve the OAuth consent covering **Sheets + Drive + Gmail/Mail**. Scope consent is per-script and is a SEPARATE step from deploying.
3. **Deploy → Manage deployments → ✏️ Edit → Version: New version → Deploy.** Same `/exec` URL, new code. **Just saving does NOT update the live endpoint.**
4. Deployment settings MUST be **Execute as: Me** + **Who has access: Anyone**.
5. Put deploy ID into `fetchCode` in `sendEmail.php`.

## Apps Script Template (canonical)

```javascript
const SHEET_ID  = '<SHEET_ID>';
const DRIVE_ID  = '<DRIVE_FOLDER_ID>';
const EMAIL_TAB = 'EmailAccount';

const HEADERS = {
  // TableName: [ ...header labels ]  — edit a label here, sheet updates next submit
};

function doPost(e) {
  try {
    const payload = JSON.parse(e.postData.contents);
    const type = payload.type, data = payload.data || {};
    let result;
    if (type === 'application')     result = handleApplication(data);
    else if (type === 'contact')    result = handleContact(data);
    else if (type === 'survey')     result = handleSurvey(data);
    else if (type === 'subscriber') result = handleSubscriber(data);
    else throw new Error('Unknown form type: ' + type);
    return jsonOut({ success: true, message: 'Saved', data: result });
  } catch (err) {
    return jsonOut({ success: false, message: String(err && err.message || err) });
  }
}

function doGet() { return jsonOut({ success: true, message: 'endpoint live' }); }

function ensureSheet(name) {
  const ss = SpreadsheetApp.openById(SHEET_ID);          // openById — getActive() is null in web app
  const headers = HEADERS[name];
  if (!headers) throw new Error('No header config for table: ' + name);
  let sheet = ss.getSheetByName(name);
  const isNew = !sheet;
  if (isNew) sheet = ss.insertSheet(name);
  const range = sheet.getRange(1, 1, 1, headers.length);
  range.setValues([headers]);
  range.setFontWeight('bold').setBackground('#f1f3f4');
  sheet.setFrozenRows(1);
  if (isNew) sheet.autoResizeColumns(1, headers.length);
  return sheet;
}

function uploadToDrive(base64DataUrl, fileName, mimeType, ownerLabel) {
  const folder = DriveApp.getFolderById(DRIVE_ID);
  const comma  = base64DataUrl.indexOf(',');
  const raw    = comma >= 0 ? base64DataUrl.substring(comma + 1) : base64DataUrl;
  const bytes  = Utilities.base64Decode(raw);
  const stamp  = Utilities.formatDate(new Date(), Session.getScriptTimeZone() || 'UTC', 'yyyyMMdd-HHmmss');
  const safe   = String(ownerLabel || 'file').replace(/[^A-Za-z0-9._-]+/g, '_');
  const named  = stamp + '_' + safe + '_' + fileName;
  const blob   = Utilities.newBlob(bytes, mimeType || 'application/octet-stream', named);
  const file   = folder.createFile(blob);
  // setSharing can throw "Access denied" even after createFile works (account/Workspace
  // sharing policy). Folder shared "Anyone with link" => children inherit access anyway.
  try { file.setSharing(DriveApp.Access.ANYONE_WITH_LINK, DriveApp.Permission.VIEW); }
  catch (_e) { /* file still reachable via inherited folder sharing */ }
  return { url: file.getUrl(), name: named };
}

function getRecipients() {
  const sheet = SpreadsheetApp.openById(SHEET_ID).getSheetByName(EMAIL_TAB);
  if (!sheet || sheet.getLastRow() < 1) return [];
  const re = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  return sheet.getRange(1, 1, sheet.getLastRow(), 1).getValues()
    .map(r => String(r[0] || '').trim()).filter(v => re.test(v));
}

function notify(subject, body) {
  const to = getRecipients();
  if (to.length) MailApp.sendEmail({ to: to.join(','), subject: '[PREFIX] ' + subject, body: body });
}

function jsonOut(obj) {
  return ContentService.createTextOutput(JSON.stringify(obj))
    .setMimeType(ContentService.MimeType.JSON);
}

// handle<Type>(d): ensureSheet -> (optional) try{uploadToDrive}catch{write 'UPLOAD FAILED'} -> appendRow -> notify
```

## Troubleshooting Playbook (real incidents from LAA project)

### Pitfall 1 — `Error: Unknown form type: <x>`
The Apps Script doesn't have a route for that `type`. **Cause is almost always: code edited in editor but NOT redeployed as a new version.** The `/exec` URL serves the last *deployed* version, not the editor buffer. Fix: add the `else if` route + `handle<Type>()` + `HEADERS` entry, Save, then **Manage deployments → Edit → New version → Deploy**.

### Pitfall 2 — `Error: Access denied: DriveApp.` (whole submission fails)
Sheet/Mail work but Drive throws. Three possible causes — diagnose with a `pingFolder()` that does `getFolderById` + `createFile` + logs `Session.getEffectiveUser()`:
1. **Folder not owned by / shared with the script's Google account** — most common. Share the folder as Editor with the script-owner email, or make a new folder in the script-owner's own Drive and swap `DRIVE_ID`.
2. **Drive scope never consented** — DriveApp code added after first deploy; run a function from the editor once and approve.
3. **Deployment is "Execute as: User accessing"** — anonymous callers have no Drive identity. Set "Execute as: Me".

### Pitfall 3 — Drive failure drops the entire row
If `uploadToDrive` throws unguarded, `handle<Type>` throws, `doPost` returns `success:false`, and NOTHING is saved. Always wrap the upload in try/catch inside the handler so the row + email still go through, with `UPLOAD FAILED: <msg>` written into the URL cell as an in-sheet diagnostic.

### Pitfall 4 — File appears in Drive but URL cell shows "UPLOAD FAILED"
`folder.createFile()` succeeded but `file.setSharing(ANYONE_WITH_LINK, VIEW)` threw "Access denied" — some personal/Workspace accounts block per-file public sharing even when folder-level sharing works. Fix: wrap **only `setSharing`** in its own try/catch and still `return file.getUrl()`. The file inherits the parent folder's "Anyone with link" access, so the URL works regardless.

### Pitfall 5 — CORS preflight failure / opaque response
Don't set `Content-Type: application/json` on the `fetch`. Send the JSON string as a plain body so it stays a CORS "simple request". The front end already handles opaque/non-JSON responses by treating `response.ok` as success.

### Pitfall 6 — `getActiveSpreadsheet()` returns null
A web app has no "active" spreadsheet. Always use `SpreadsheetApp.openById(SHEET_ID)`.

## Golden Rules
- **Save ≠ Deploy.** Every backend change needs a *New version* deployment or the `/exec` URL serves stale code.
- **Scope consent is its own step**, separate from deploy — trigger it by running a function in the editor once.
- **Execute as: Me + Anyone** for anonymous public forms.
- **`EmailAccount` tab is read-only** and pre-existing — never recreate it; only create data tabs.
- `ensureSheet` re-writes row 1 every call so `HEADERS` stays the single source of truth.
- One `type` ↔ one sheet tab ↔ one `handle<Type>()`. Splitting/merging types is a product call.
