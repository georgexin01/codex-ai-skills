# Sovereign Pre-Flight Checklist (V1.0)

This is a mandatory "Pre-Inference" audit list. Before implementing ANY module logic, I must verify these 4 levels.

| Check | Action | Failure Result |
| :--- | :--- | :--- |
| **Infrastructure** | Check `attachment` table and `quizLaa` bucket. | 404 / 401 Storage Error |
| **Schema Mapping** | Verify `created_at` (DB) -> `createdAt` (Vue). | Undefined Date |
| **Logic Casing** | DB uses `snake_case`, Store uses `camelCase`. | Data won't save/load |
| **Media Sync** | Wrap all relative paths with `getStorageUrl()`. | Broken image icon |
| **Schema Evolution** | Update `VOCABULARY.md` after any DB change. | Intelligence Drift / Binding Failure |

---

# Sovereign Code Foundry (Battle-Tested Patterns)

These patterns are "Golden" — they have been tested multiple times in the Agents, Reviews, and Clients modules.

### P1: The Sanitized Image Watcher (Prevents State Leak)
```typescript
watch(
  () => props.entity,
  (entity) => {
    if (entity && props.mode === 'edit') {
      fileList.value = entity.photo ? urlsToFileList([entity.photo]) : [];
    } else if (props.mode === 'create') {
      fileList.value = [];
    }
  },
  { immediate: true }
);
```

### P2: The Unified Crop Confirm (Signatory Sync)
```typescript
const handleCropConfirm = async (file: File) => {
  const uploadFile: UploadFile = {
    uid: `upload-${Date.now()}`,
    name: file.name,
    status: 'uploading',
    originFileObj: file as any,
  };
  fileList.value = [uploadFile];
  // ... proceed to uploadPhoto
};
```

---
**Status**: Authoritative | **Last Update**: 2026-04-21 | **Tier**: Battle-Tested
