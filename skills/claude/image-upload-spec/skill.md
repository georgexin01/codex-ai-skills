---
name: image-upload-spec
description: Configure image uploads with dimension specs, file-type validation, auto-resize, and crop modal.
triggers: ["image upload", "image spec", "avatar upload", "crop modal", "upload field"]
phase: 2-scaffold
requires: []
unlocks: []
inputs: [field_name, dimensions, accept_types]
output_format: integration_snippet
model_hint: gpt-5.3-codex
version: 2.0
---

# Image Upload Spec (image-upload-spec)

Configure image uploads with dimension specs, file type validation, auto-resize, and crop modal.

## Description

When a form has image upload fields, define an `ImageSpec` to enforce:
- **File type validation** — only allowed formats (e.g., jpg, jpeg), error popup if wrong
- **Auto-resize** — images with matching ratio are resized to exact spec dimensions
- **Crop modal** — images with mismatched ratio open a crop UI (vue-advanced-cropper), then resize
- **Only processed images are kept** — originals are never uploaded
- **Module-scoped storage paths** — group uploads by module before the `YYMM` folder (e.g. `driver_tasks/2605/...jpg`, `drivers/2605/...jpg`)

## Core Files

| File | Purpose |
| --- | --- |
| `src/utils/image-processor.ts` | `ImageSpec` type, `validateImageType()`, `loadImage()`, `checkImageNeedsCrop()`, `processImage()`, `formatAcceptList()`, `specToAcceptAttr()` |
| `src/components/image-crop-modal.vue` | Crop modal using `vue-advanced-cropper` — fixed crop area, dark overlay, drag to reposition, scroll to zoom |

## Storage Path and Attachment Rules

- `uploadPhoto()` supports an optional `folder` parameter. For module uploads, pass a stable snake_case module folder:
  - Driver task proof photos: `folder: 'driver_tasks'`
  - Driver profile photos: `folder: 'drivers'`
  - Generic module pattern: `folder: '{table_name}'`
- Storage bucket remains the project schema bucket (e.g. `trash`). Database values store the relative path only, without the bucket name.
- New paths should look like `{module_folder}/{YYMM}/{YYMMDD-HHMMSS-random-originalname.ext}`.
  - Full storage object: `trash/driver_tasks/2605/260514-154711-abcd-photo.jpg`
  - DB value in module arrays/fields and `attachments.storagePath`: `driver_tasks/2605/260514-154711-abcd-photo.jpg`
- If an uploaded file is removed from a module form array/field, soft-delete the matching `attachments` record by `storagePath` (`isDelete = true`) instead of deleting the storage object immediately.
- The global Album page is an attachment manager:
  - Both active (`isDelete = false`) and deleted (`isDelete = true`) attachments may be hard-deleted from the Album page.
  - Hard delete must remove the Supabase Storage object and then delete the `attachments` row.
  - Reference-guarding is done **server-side**, not in the frontend:
    - Deleted attachments (`isDelete = true`) hard-delete directly via `deleteStorageFiles()` + row delete.
    - Active attachments (`isDelete = false`) hard-delete through the `safe_delete_active_attachment` RPC, which validates admin role + checks active references before allowing deletion.
  - Do NOT re-implement reference checks in the frontend store — call `safeDeleteActiveAttachment(storagePath)` from `src/utils/upload.ts` instead.
- `Purge Deleted` should only purge `attachments` rows where `isDelete = true`; it must remove storage objects as part of the purge.
- Delete/purge failures must surface the **actual server error message** to the user (e.g. "still referenced by N active record(s)"), not a generic fallback. Use a `resolveErrorMessage(error, fallback)` helper that reads `error.message`.

### `safe_delete_active_attachment` RPC

SQL migration: `src/sql/migrations/024_trash_safe_delete_active_attachment_rpc.sql`

- `SECURITY DEFINER`, requires `get_current_role_level() <= 10` (admin).
- Derives the module from the storage path prefix (`split_part(p_storage_path, '/', 1)`).
- Checks active references per module:
  - `drivers` prefix → `drivers.photos` (where `isDelete = false`)
  - `driver_tasks` prefix → `driver_tasks.startPhotos` / `completePhotos` (where `isDelete = false`)
  - Unknown prefix → raises `Unsupported attachment module prefix`.
- Raises an exception if still referenced; otherwise returns `{ success, storagePath, references: 0 }`.
- **When adding a new module with image arrays, add its prefix branch to this RPC** — otherwise active-attachment hard delete will fail with "Unsupported module prefix".

### Frontend helper: `safeDeleteActiveAttachment()`

In `src/utils/upload.ts`:

```typescript
export async function safeDeleteActiveAttachment(storagePath: string): Promise<void> {
  if (!storagePath) return;
  const { error } = await supabase.rpc('safe_delete_active_attachment', {
    p_storage_path: storagePath,
  });
  if (error) throw error;          // server-side reference guard rejected it
  await deleteStorageFiles([storagePath]);
  await supabase.from('attachments').delete().eq('storagePath', storagePath);
}
```

The attachments store's `hardDelete(id)` branches on `isDelete`: `false` → `safeDeleteActiveAttachment()`, `true` → direct storage + row delete.

## ImageSpec Type

```typescript
interface ImageSpec {
  width: number;        // Target width in pixels (e.g., 800)
  height: number;       // Target height in pixels (e.g., 800)
  accept: string[];     // Allowed extensions without dot (e.g., ['jpg', 'jpeg'])
  outputType?: string;  // 'image/jpeg' | 'image/png' (default: 'image/jpeg')
  outputQuality?: number; // 0-1 for jpeg (default: 0.9)
}
```

## Multi-Image Module Upload Pattern

Use the same crop/processing pipeline for multi-image module fields such as `driver_tasks.startPhotos` and `driver_tasks.completePhotos`; do not direct-upload raw images with `accept="image/*"` only.

- Define an `ImageSpec` for the module field (current driver task proof photo pattern: `800x800`, `jpg/jpeg/png`, output `image/jpeg`).
- Set `<Upload :accept="specToAcceptAttr(spec)" :before-upload="(file) => handleBeforeUpload(file, target)" :custom-request="uploadViaCustomRequest" list-type="picture-card">`.
- In `beforeUpload`, call `validateImageType()`, `loadImage()`, `checkImageNeedsCrop()`, and `processImage()` just like the Labour agent avatar pattern.
- If crop is needed, set the active target (`start`/`complete` etc.), open `ImageCropModal`, return `Upload.LIST_IGNORE`, then upload the cropped processed file in the modal confirm handler.
- `customRequest` should upload the already processed file with `uploadPhoto({ file, folder: '{module_folder}' })`.
- DEV workflow upload targets should process the generated test image through `processImage()` before calling `uploadPhoto()` so workflow behavior matches the UI.
- Existing paths still load with `urlsToFileList()`, and submit values still use `fileListToUrls()`.
- **Always set `:max-count` on multi-image `<Upload>`** and hide the "+" tile when the limit is reached (`v-if="fileList.length < maxCount"`). Reference: `driver-form.vue` uses `maxDriverPhotos = 2`. Note: `driver-task-form.vue` `startPhotos`/`completePhotos` currently have no `max-count` — treat as a known gap to fix when touched.

## Integration Pattern (Reference: lesson-form.vue)

### Step 1: Define the spec

```typescript
const imageSpec: ImageSpec = {
  width: 800,
  height: 800,
  accept: ['jpg', 'jpeg'],
  outputType: 'image/jpeg',
  outputQuality: 0.9,
};
```

### Step 2: Import utilities and crop modal

```typescript
import ImageCropModal from '#/components/image-crop-modal.vue';
import {
  checkImageNeedsCrop,
  formatAcceptList,
  loadImage,
  processImage,
  specToAcceptAttr,
  validateImageType,
} from '#/utils/image-processor';

const cropModalRef = ref<InstanceType<typeof ImageCropModal>>();
```

### Step 3: beforeUpload handler

Validates file type, checks ratio, either auto-resizes or opens crop modal.

```typescript
const handleBeforeUpload = async (file: File): Promise<File | boolean> => {
  // 1. Validate file type
  const typeError = validateImageType(file, imageSpec);
  if (typeError) {
    message.error(
      $t('page.imageProcessor.invalidType', {
        formats: formatAcceptList(imageSpec.accept),
      }),
    );
    return Upload.LIST_IGNORE as any;
  }

  try {
    // 2. Load image to check dimensions
    const img = await loadImage(file);

    // 3. Check aspect ratio
    if (checkImageNeedsCrop(img, imageSpec)) {
      // Ratio mismatch — open crop modal, reject this upload
      cropModalRef.value?.open(file);
      return Upload.LIST_IGNORE as any;
    }

    // 4. Ratio matches — just resize to exact spec dimensions
    const processed = await processImage(img, imageSpec, file.name);
    return processed;
  } catch {
    message.error($t('page.imageProcessor.processFailed'));
    return Upload.LIST_IGNORE as any;
  }
};
```

### Step 4: Handle crop confirm (manual upload after crop)

```typescript
const handleCropConfirm = async (croppedFile: File) => {
  const uid = `upload-${Date.now()}`;
  const uploadFile: UploadFile = {
    uid,
    name: croppedFile.name,
    status: 'uploading',
    percent: 0,
  };
  fileList.value = [...fileList.value, uploadFile];

  await uploadPhoto({
    file: croppedFile,
    folder: 'module_name',
    onProgress: (progress) => {
      const idx = fileList.value.findIndex((f) => f.uid === uid);
      if (idx !== -1) {
        fileList.value[idx] = { ...fileList.value[idx]!, percent: progress.percent };
        fileList.value = [...fileList.value];
      }
    },
    onSuccess: (data) => {
      const idx = fileList.value.findIndex((f) => f.uid === uid);
      if (idx !== -1) {
        fileList.value[idx] = {
          ...fileList.value[idx]!,
          status: 'done',
          percent: 100,
          response: data,
          url: getStorageUrl(data.url),
          thumbUrl: getStorageUrl(data.url),
        };
        fileList.value = [...fileList.value];
      }
    },
    onError: (error) => {
      const idx = fileList.value.findIndex((f) => f.uid === uid);
      if (idx !== -1) {
        fileList.value[idx] = { ...fileList.value[idx]!, status: 'error', percent: 0 };
        fileList.value = [...fileList.value];
      }
      message.error(error.message || $t('page.imageProcessor.uploadFailed'));
    },
  });
};
```

### Step 5: Template

```vue
<Upload
  v-model:file-list="fileList"
  :accept="specToAcceptAttr(imageSpec)"
  :before-upload="handleBeforeUpload"
  :custom-request="handleUpload"
  list-type="picture-card"
  :max-count="5"
  :multiple="true"
  @change="handleChange"
>
  <div class="flex flex-col items-center">
    <IconifyIcon icon="lucide:plus" class="text-lg" />
    <div class="mt-1 text-xs">{{ $t('page.lessons.form.uploadImage') }}</div>
  </div>
</Upload>

<!-- Spec hint -->
<div class="mt-1 text-xs text-gray-400">
  {{ $t('page.imageProcessor.specHint', {
    width: imageSpec.width,
    height: imageSpec.height,
    formats: formatAcceptList(imageSpec.accept),
  }) }}
</div>

<!-- Crop Modal -->
<ImageCropModal
  ref="cropModalRef"
  :spec="imageSpec"
  @confirm="handleCropConfirm"
/>
```

## Crop Modal Details

The crop modal (`image-crop-modal.vue`) uses `vue-advanced-cropper`:

- **Fixed crop area** — matches spec dimensions (e.g., 800×800), not resizable, not movable
- **Dark overlay** — areas outside crop are dimmed
- **Drag to reposition** — user moves the image behind the fixed crop frame
- **Scroll to zoom** — zoom in/out
- **Responsive** — frame scales down if viewport can't fit the full spec size
- **Frame size calculation**: `scale = min(1, viewportW / specW, viewportH / specH)`

## Processing Flow

```
User selects image
  → validateImageType() — wrong format? → error popup, reject
  → loadImage() — load into HTMLImageElement
  → checkImageNeedsCrop() — ratio mismatch?
    YES → open crop modal → user adjusts → processImage(cropRegion) → upload
    NO  → processImage(fullImage) → auto-resize to spec → upload
  → Only processed file is uploaded (original discarded)
```

## i18n Keys

All under `page.imageProcessor`:

| Key | EN | ZH |
| --- | --- | --- |
| `specHint` | Required: {width}×{height}px, {formats} only | 要求：{width}×{height}px，仅限 {formats} |
| `invalidType` | Only {formats} images are allowed | 仅允许 {formats} 格式的图片 |
| `processFailed` | Failed to process image | 图片处理失败 |
| `uploadFailed` | Failed to upload image | 图片上传失败 |
| `cropTitle` | Crop Image | 裁剪图片 |
| `cropHint` | Crop to {width}×{height}px ratio | 裁剪为 {width}×{height}px 比例 |
| `cropConfirm` | Crop & Upload | 裁剪并上传 |
| `dragHint` | Drag to reposition, scroll to zoom | 拖动调整位置，滚轮缩放 |

## Common Spec Examples

| Use Case | Width | Height | Accept | Ratio |
| --- | --- | --- | --- | --- |
| Square avatar/thumbnail | 800 | 800 | jpg, jpeg | 1:1 |
| Banner/cover | 1200 | 400 | jpg, jpeg, png | 3:1 |
| Product photo | 1000 | 1000 | jpg, jpeg | 1:1 |
| Document scan | 800 | 1200 | jpg, jpeg, png | 2:3 |

## Free Visual Sourcing Extension

When image upload/spec work needs prototype images but the agent cannot generate images directly, use:

`C:\Users\user\.codex\skills\normal\design\FREE_VISUAL_ASSET_SOURCING.md`

Use stock/photo URLs, downloaded local prototype assets, Material Symbols, SVG, or CSS placeholders. Keep the upload spec separate from sourcing: free assets can seed mock data, but production user uploads still follow the validated `ImageSpec` pipeline.

