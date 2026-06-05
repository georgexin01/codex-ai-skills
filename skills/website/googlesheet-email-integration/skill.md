---
name: googlesheet-email-integration
description: Send website form data to Google Sheets + email notification via Google Apps Script. Works for any PHP website (angel-interior pattern).
triggers: ["send email to googlesheet", "google sheet form", "appscript form", "contact form email", "form to googlesheet", "send to googlesheet"]
phase: integration
---

# Google Sheets + Email via Apps Script

When user asks to connect a website form to Google Sheets / send email notification, follow this skill.

## Required Keys (always ask user if not provided)

| Key | Description |
|-----|-------------|
| `APPS_SCRIPT_DEPLOYMENT_ID` | The `/exec` deployment ID from Apps Script |
| `SPREADSHEET_ID` | Google Sheet ID from URL |
| `DRIVE_FOLDER_ID` | Google Drive folder ID (only if forms have file uploads) |

## Flow Overview

```
User submits form
  → existing backend (Supabase, DB, etc.) — primary
  → window.angelSendEmail(type, data) — supplementary, fire-and-forget
      → Google Apps Script /exec endpoint
          → writes row to Google Sheet table
          → reads EmailAccount sheet for recipient emails
          → sends HTML email notification via MailApp
```

## File Structure

```
website-root/
├── sendEmail.php          ← exposes window.angelSendEmail(type, data)
└── template/
    └── contact.php        ← includes sendEmail.php, calls angelSendEmail on success
```

## Step 1 — Create sendEmail.php in website root

```php
<script>
/**
 * Exposes window.angelSendEmail(type, data)
 * Replace APPS_SCRIPT_ID with the deployment ID.
 * Each project gets its own sendEmail.php.
 */
(function () {
    const APPS_SCRIPT_ID = '{APPS_SCRIPT_DEPLOYMENT_ID}';

    window.angelSendEmail = async function (type, data) {
        try {
            await fetch(
                'https://script.google.com/macros/s/' + APPS_SCRIPT_ID + '/exec', {
                    method: 'POST',
                    cache: 'no-cache',
                    redirect: 'follow',
                    body: JSON.stringify({ type: type, data: data }),
                }
            );
        } catch (e) {
            console.warn('[sendEmail] AppScript error (non-critical):', e);
        }
    };
})();
</script>
```

## Step 2 — Include in template page + call on success

In any page template that has a form:

```php
// At top of the page's <script> block:
<?php include(dirname(__DIR__) . '/sendEmail.php'); ?>
```

In the existing form submit handler (after primary submission succeeds):

```javascript
// After successful Supabase/DB submit:
if (typeof window.angelSendEmail === 'function') {
    window.angelSendEmail('contact', {
        name: payload.name,
        email: payload.email,
        phone: payload.phone,
        subject: payload.subject,
        message: payload.message
    });
}
```

## Step 3 — Google Apps Script (full template)

> Copy to https://script.google.com → paste → deploy as Web App → Anyone access

```javascript
// ============================================================
// CONFIGURATION — edit here only
// ============================================================
const SPREADSHEET_ID = '{SPREADSHEET_ID}';

// Table definitions — change sheetName/headers here
// Table is auto-created in Sheet if it doesn't exist (header row frozen)
const TABLES = {
  contact: {
    sheetName: 'Contacts',
    headers: ['Timestamp', 'Name', 'Email', 'Phone', 'Subject', 'Message'],
    buildRow: (data) => [
      timestamp(), data.name, data.email, data.phone, data.subject, data.message
    ],
    emailSubject: (data) => `✉️ New Contact Message — ${data.name || 'Unknown'}`,
    buildEmail: buildContactEmail,
  },
  // Add more form types here following the same pattern
};

// ============================================================
// CORE
// ============================================================
function doPost(e) {
  try {
    const body = JSON.parse(e.postData.contents);
    const config = TABLES[body.type];
    if (!config) return jsonResponse({ success: false, message: 'Unknown type: ' + body.type });

    const sheet = getOrCreateSheet(config.sheetName, config.headers);
    sheet.appendRow(config.buildRow(body.data));

    const emails = getEmailAccounts();
    if (emails.length > 0) {
      emails.forEach(email => MailApp.sendEmail({
        to: email,
        subject: config.emailSubject(body.data),
        htmlBody: config.buildEmail(body.data),
      }));
    }

    return jsonResponse({ success: true });
  } catch (err) {
    return jsonResponse({ success: false, message: err.toString() });
  }
}

function getOrCreateSheet(name, headers) {
  const ss = SpreadsheetApp.openById(SPREADSHEET_ID);
  let sheet = ss.getSheetByName(name);
  if (!sheet) {
    sheet = ss.insertSheet(name);
    sheet.appendRow(headers);
    sheet.setFrozenRows(1);
    const r = sheet.getRange(1, 1, 1, headers.length);
    r.setBackground('#2c2c2c');
    r.setFontColor('#ffffff');
    r.setFontWeight('bold');
  }
  return sheet;
}

function getEmailAccounts() {
  const ss = SpreadsheetApp.openById(SPREADSHEET_ID);
  const sheet = ss.getSheetByName('EmailAccount');
  if (!sheet) return [];
  return sheet.getDataRange().getValues()
    .slice(1)
    .map(r => String(r[0]).trim())
    .filter(e => e.includes('@'));
}

function timestamp() {
  return new Date().toLocaleString('en-MY', { timeZone: 'Asia/Kuala_Lumpur' });
}

function jsonResponse(obj) {
  return ContentService.createTextOutput(JSON.stringify(obj))
    .setMimeType(ContentService.MimeType.JSON);
}
```

## Step 4 — File Upload (only if form has file input)

When a form has `<input type="file">`, add to sendEmail.php:

```javascript
// Read file as base64 before sending
async function readFileAsBase64(file) {
    return new Promise((resolve, reject) => {
        const reader = new FileReader();
        reader.onload = () => resolve(reader.result);
        reader.onerror = reject;
        reader.readAsDataURL(file);
    });
}

// In form submit handler, before angelSendEmail:
const fileInput = form.querySelector('input[type="file"]');
if (fileInput && fileInput.files[0]) {
    const file = fileInput.files[0];
    data.fileData = await readFileAsBase64(file);
    data.fileName = file.name;
    data.fileType = file.type;
}
```

AppScript — add Drive upload function:

```javascript
const DRIVE_FOLDER_ID = '{DRIVE_FOLDER_ID}';

function uploadFileToDrive(base64Data, fileName, mimeType) {
  const folder = DriveApp.getFolderById(DRIVE_FOLDER_ID);
  const base64 = base64Data.replace(/^data:[^;]+;base64,/, '');
  const bytes = Utilities.base64Decode(base64);
  const blob = Utilities.newBlob(bytes, mimeType, fileName);
  const file = folder.createFile(blob);
  file.setSharing(DriveApp.Access.ANYONE_WITH_LINK, DriveApp.Permission.VIEW);
  return file.getUrl();
}
// Call: const driveUrl = uploadFileToDrive(data.fileData, data.fileName, data.fileType);
// Save driveUrl in the sheet row
```

## Step 5 — Email HTML Template (Professional v2)

Use `buildContactEmail(data)` function — dark brown brand color `#796d65`, emoji section labels, reply CTA button. See angel-interior AppScript for full HTML template.

## ⚠️ CRITICAL: AppScript OAuth Scope (MailApp Authorization)

**Symptom:** Sheet writes work but email is NOT sent. Error in Apps Script logs:
```
Exception: Specified permissions are not sufficient to call MailApp.sendEmail.
Required permissions: https://www.googleapis.com/auth/script.send_mail
```

**Fix — must declare scopes in `appsscript.json` manifest:**

1. In Apps Script editor → ⚙️ **Project Settings** → tick **"Show appsscript.json manifest file in editor"**
2. Click `appsscript.json` → replace entire content with:

```json
{
  "timeZone": "Asia/Kuala_Lumpur",
  "dependencies": {},
  "exceptionLogging": "STACKDRIVER",
  "runtimeVersion": "V8",
  "oauthScopes": [
    "https://www.googleapis.com/auth/spreadsheets",
    "https://www.googleapis.com/auth/script.send_mail",
    "https://www.googleapis.com/auth/gmail.send"
  ]
}
```

3. Save → run `authorizeMailApp()` manually → Allow permissions popup
4. Deploy as **new version** after authorization

**Also fix: `EmailAccount` has NO header row** — emails start from row 1.
Use `.getValues()` directly, **no `.slice(1)`**:

```javascript
function getEmailAccounts() {
  const ss = SpreadsheetApp.openById(SPREADSHEET_ID);
  const sheet = ss.getSheetByName('EmailAccount');
  if (!sheet) return [];
  // NO .slice(1) — EmailAccount has no header, emails start from row 1
  return sheet.getDataRange().getValues()
    .map(function(r) { return String(r[0]).trim(); })
    .filter(function(e) { return e.indexOf('@') > -1; });
}
```

**One-time authorization helper** (add to script, run once, keep for future use):
```javascript
function authorizeMailApp() {
  MailApp.sendEmail({
    to: 'your@email.com',
    subject: '✅ AppScript Authorization OK',
    body: 'MailApp is now authorized.'
  });
}
```

## Rules

- `sendEmail.php` is always **supplementary** — never replace the primary backend (Supabase)
- Call `angelSendEmail` only **after** primary submission succeeds (not in catch)
- `EmailAccount` sheet: **never recreate** — it already exists with user emails in row 1+, **no header row**
- Auto-create other tables (freeze row 1, dark header style `#2c2c2c`)
- All tables use `const TABLES` config — changing `sheetName` or `headers` there auto-updates created table
- **Always declare `oauthScopes` in `appsscript.json`** — required for MailApp to work via web app exec
- Keep `authorizeMailApp()` in script — needed after every new deployment or scope change

## Google Sheets Tables Created

| Sheet Name | Headers | Notes |
|---|---|---|
| `EmailAccount` | Email | Pre-existing, never recreate |
| `Contacts` | Timestamp, Name, Email, Phone, Subject, Message | Auto-created |

## Reference Implementation

**Angel Interior** (`website-angel-interior/`):
- `sendEmail.php` — root level, exposes `window.angelSendEmail`
- `template/contact.php` — includes sendEmail.php, fires after Supabase success
- AppScript type: `"contact"` → Sheet: `Contacts`
- No file uploads (no upload forms on this site)

**Idealbuild** (reference pattern, script saved separately):
- Form types: `contact`, `speakWithUs`, `jobApplication` (with file upload to Drive)
- See `idealbuild-sendEmail-reference.md` for full script
