---
name: admin-image-crop-tool
description: "Vben admin panel image crop modal using vue-advanced-cropper + Pica. Covers ImageSpec, freeHeight mode (fixed width / draggable height), display sizing, and processImage output scaling."
triggers: ["crop image", "image crop", "crop modal", "freeHeight", "image spec", "pica resize", "upload image crop", "sketchup image", "material image"]
phase: feature
status: authoritative
last_updated: "2026-05-28"
---

# Admin Panel — Image Crop Tool

## Files

| File | Role |
|------|------|
| `src/utils/image-processor.ts` | `ImageSpec` interface, `processImage`, `validateImageType`, `checkImageNeedsCrop` |
| `src/components/image-crop-modal.vue` | Crop UI modal (vue-advanced-cropper) |
| `src/composables/use-single-image-attachment.ts` | Composable wiring upload → crop → Supabase storage |

---

## ImageSpec Interface

```ts
export interface ImageSpec {
  width: number;       // Target output width in px
  height: number;      // Target output height in px (also max height when freeHeight: true)
  accept: string[];    // Allowed extensions e.g. ['jpg', 'jpeg']
  outputType?: string; // 'image/jpeg' | 'image/png'  (default: 'image/jpeg')
  outputQuality?: number; // 0–1 (default: 0.9)
  freeHeight?: boolean;   // true = fixed width, user drags height up to spec.height max
}
```

---

## Spec Defaults (Angel Interior)

| Module | Spec | Ratio (W:H) | Mode |
|--------|------|-------------|------|
| SketchUp Resources | `{ width: 800, height: 1422, freeHeight: true }` | **800:1422** (portrait) | Fixed 800px width, drag height up to 1422px |
| Material Resources | `{ width: 600, height: 600 }` | 600:600 (square) | Fixed 1:1 ratio |
| Blog Posts (cover) | `{ width: 1200, height: 630 }` | 1200:630 (landscape) | Fixed OG ratio |

> **Convention:** ratio is always written **width : height** (left = width, right = height).
> SketchUp 800:1422 = portrait (taller than wide, ~9:16 mobile card).

---

## Pica Resize Config (Angel Interior)

| Setting | Value |
|---------|-------|
| Target width | **800px** |
| Max height | **1422px** |
| Ratio | **800:1422** (W:H — portrait) |
| Min width | 360px (never produce narrower than this) |
| Quality | 0.9 |
| Output format | image/jpeg |
| Engine | Pica (canvas-based, browser-side) |

```ts
// SketchUp resource image spec — use this exact object
const imageSpec: ImageSpec = {
  width: 800,       // ← width (left)
  height: 1422,     // ← height (right)
  accept: ['jpg', 'jpeg'],
  outputType: 'image/jpeg',
  outputQuality: 0.9,
  freeHeight: true, // fixed 800px width, user drags height up to 1422px max
};
```

---

## freeHeight Mode Rules

1. **Output width is always `spec.width` (800px)** — processImage scales the crop region to that width regardless of how large/small the user drew the crop box.
2. **Output height = `Math.round((cropRegion.sh / cropRegion.sw) * spec.width)`** — proportional to what the user selected, never forced to spec.height.
3. **Display height is fixed at `FREEHEIGHT_DISPLAY_H = 520px`** — NOT derived from spec.height. This prevents the 1422px max from shrinking the display canvas to a tiny size.
4. **stencil-size is NOT used** for freeHeight — using it locks/prevents resize. Use `default-size` instead.
5. **default-size MUST be a function** — plain pixel values are in IMAGE space, not display space. Use the portrait-ratio function form so the stencil opens at the correct 800:1422 portrait orientation:
   ```ts
   'default-size': ({ imageSize }: any) => {
     const ar = spec.width / spec.height; // 800/1422 ≈ 0.563 (portrait)
     const byH = imageSize.height * ar;   // width if using full image height
     if (byH <= imageSize.width) {
       return { width: byH, height: imageSize.height };
     }
     return { width: imageSize.width, height: imageSize.width / ar };
   }
   ```
   This starts the stencil at the exact 800:1422 ratio (portrait), scaled to fit the image. User drags north/south to adjust height.
6. **Handlers**: `{ eastNorth: true, north: true, westNorth: true, east: false, west: false, eastSouth: true, south: true, westSouth: true }` — corners + top/bottom enabled; left/right disabled to lock width.
7. **image-restriction**: `'visibleArea'` — image moves freely behind the stencil.
8. **movable**: `false` on stencil-props — stencil stays, image moves.

---

## Frame Size Calculation

```ts
const MODAL_PADDING = 160;       // modal left/right + body padding
const MODAL_CHROME_H = 350;      // title + footer + hints + viewport margin
const FREEHEIGHT_DISPLAY_H = 520; // fixed display height for freeHeight mode

const calcFrameSize = () => {
  const maxW = window.innerWidth - MODAL_PADDING;
  const maxH = window.innerHeight - MODAL_CHROME_H;

  if (props.spec.freeHeight) {
    // Width fills modal (scaled for narrow viewports), height is fixed display size
    const widthScale = Math.min(1, maxW / props.spec.width);
    frameSize.value = {
      width: Math.round(props.spec.width * widthScale),
      height: Math.min(FREEHEIGHT_DISPLAY_H, maxH),
    };
  } else {
    // Fixed ratio: scale down to fit both width and height
    const scale = Math.min(1, maxW / props.spec.width, maxH / props.spec.height);
    frameSize.value = {
      width: Math.round(props.spec.width * scale),
      height: Math.round(props.spec.height * scale),
    };
  }
};
```

---

## Cropper Component Binding (freeHeight vs fixed)

```vue
<Cropper
  v-bind="spec.freeHeight
    ? { 'default-size': { width: frameSize.width, height: Math.round(frameSize.height * 0.7) } }
    : { 'stencil-size': { width: frameSize.width, height: frameSize.height } }"
  :stencil-props="spec.freeHeight
    ? {
        handlers: {
          eastNorth: true, north: true, westNorth: true,
          east: false, west: false,
          eastSouth: true, south: true, westSouth: true,
        },
        movable: false,
        resizable: true,
        lines: true,
      }
    : {
        handlers: {},
        movable: false,
        resizable: false,
        aspectRatio: spec.width / spec.height,
        lines: true,
      }"
  :image-restriction="spec.freeHeight ? 'visibleArea' : 'stencil'"
/>
```

---

## processImage — Output Sizing

```ts
const outputHeight = spec.freeHeight && cropRegion
  ? Math.round((cropRegion.sh / cropRegion.sw) * spec.width)
  : spec.height;

canvas.width = spec.width;
canvas.height = outputHeight;

ctx.drawImage(img, sx, sy, sw, sh, 0, 0, spec.width, outputHeight);
```

---

## Pica Resize (html-content-editor.vue)

Pica is used for embedded images in the HTML editor (not for the crop tool — crop uses canvas directly).

```ts
const MIN_WIDTH = 360; // never produce an image narrower than 360px
const effectiveWidth = Math.max(MIN_WIDTH, Math.min(targetWidth, img.width));
const scale = effectiveWidth / img.width;
canvas.width = Math.round(img.width * scale);
canvas.height = Math.round(img.height * scale);
await pica.resize(img, canvas);
const blob = await pica.toBlob(canvas, file.type || 'image/jpeg', 0.9);
```

Rule: **never upscale** (capped at `img.width`), **never below 360px** (minimum width enforced).

---

## Key Rules

- **stencil-size locks resize** — never use it for freeHeight mode; use `default-size` instead
- **FREEHEIGHT_DISPLAY_H = 520px** — do not derive display height from spec.height (1422px) or the canvas will be microscopic
- **Output width always = spec.width** — processImage always scales to spec.width regardless of crop box size
- **Minimum upload width = 360px** — Pica enforces this for HTML editor embedded images
