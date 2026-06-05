# Sovereign Media Orchestration Protocol

This document defines the authoritative, 5-level protocol for implementing image and file uploads within the **Sovereign Web Framework (SWF)**. 

> [!IMPORTANT]
> Any implementation of a new module or feature involving media (Agents, Reviews, Lessons, Clients) MUST follow this checklist to ensure 100% architectural integrity and UI visibility.

---

## 🏗️ Level 1: Infrastructure Deployment
Before any code is written, ensure the physical storage and indexing layers are active in the local Supabase environment.

| Component | Target | Requirement |
|---|---|---|
| **Storage Bucket** | `storage.buckets` | Must match `import.meta.env.VITE_SUPABASE_SCHEMA` (usually `quizLaa`). |
| **Indexing Table** | `schema.attachment` | Must exist in the primary schema to allow the **Attachments Album** to function. |
| **Permissions** | `SQL GRANTS` | The `authenticated` role MUST have `ALL` permissions on the `attachment` table and `USAGE` on the schema. |

---

## 🧠 Level 2: Logic & Indexing (The Database Sync)
All uploads MUST be mirrored in the global `attachment` table. NEVER use raw storage uploads without an accompanying database index.

### The Indexing Rule
Always call `insertAttachmentRecord` within the `uploadPhoto` utility. If a new upload method is used, it MUST verify that a row is created in the `attachment` table.

---

## 📡 Level 3: Event Signatures (The Signal)
The communication between the **Cropping Tool** and the **Form** must use a unified signature.

- **Standard Signature**: `const handleCropConfirm = async (file: File) => { ... }`
- **Error Flag**: If you see `TypeError: Cannot read properties of undefined (reading 'name')`, it means the handler is expecting 2 arguments (`blob`, `originalFile`) instead of the single processed `File`.

---

## 💧 Level 4: Hydration & Visibility (The "Broken Image" Fix)
Raw storage paths (e.g., `folder/xyz.jpg`) are not visible to browsers. They must be hydrated into full URLs.

### The Visibility Rule
Always wrap the `data.url` (internal path) with the `getStorageUrl()` utility before assigning it to a `fileList` or preview field.
```typescript
// ✅ CORRECT
uploadFile.url = getStorageUrl(data.url);

// ❌ INCORRECT (Results in broken image icon)
uploadFile.url = data.url;
```

---

## 🧹 Level 5: Sanitization & State (The "Ghost Image" Fix)
Admin panels often "Cache" component states. When switching between different items in Edit mode, you MUST explicitly clear the state.

### The Cleanup Rule
In the `watch` logic that loads entity data, you MUST provide an `else` or ternary that sets the `fileList` to `[]` if the newly loaded entity has no image.
```typescript
// ✅ CORRECT
fileList.value = entity.photo ? urlsToFileList([entity.photo]) : [];

// ❌ INCORRECT (Causes images to leak from one item to another)
if (entity.photo) { fileList.value = [...]; } 
```

---
**Status**: Authoritative Protocol | **Target Domain**: Vben Admin / SWF V8.0 | **Last Update**: 2026-04-21
