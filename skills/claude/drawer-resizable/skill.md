---
name: drawer-resizable
description: Enforce resizable drawers — drag-to-resize edge handle with per-drawer localStorage size persistence on desktop VbenDrawer components.
triggers: ["drawer resizable", "resize drawer", "drag drawer", "drawer handle", "resizable drawer"]
phase: reference
requires: []
unlocks: []
inputs: []
output_format: integration_snippet
model_hint: gpt-5.3-codex
version: 2.0
---

# Resizable Drawer UI (drawer-resizable)

Enforces resizable functionality on all horizontal and vertical drawers on desktop devices, allowing users to drag the edges to adjust width/height.

## Description

This skill ensures that every Drawer component (VbenDrawer) provides a visual handle (blue line) on its edge that users can click and drag to resize. The size is persisted in `localStorage` per drawer title.

## Implementation Details

The core logic resides in `packages/@core/ui-kit/popup-ui/src/drawer/drawer.vue`.

### 1. Resizing Logic (Script)

```typescript
// --- Resizable drawers (width for left/right, height for top/bottom) ---
const RESIZE_KEY = 'drawer-sz:';
const MIN_W = 320;
const MIN_H = 200;

const resizeSize = ref(0); // 0 = use CSS default

const isHorizontal = computed(
  () => placement.value === 'left' || placement.value === 'right',
);
const isVertical = computed(
  () => placement.value === 'top' || placement.value === 'bottom',
);
const canResize = computed(() => !isMobile.value);

function getStorageKey() {
  return `${RESIZE_KEY}${unref(title) || 'default'}`;
}

// Load saved size on open
watch(
  () => state?.value?.isOpen,
  (isOpen) => {
    if (isOpen) {
      const saved = localStorage.getItem(getStorageKey());
      const min = isHorizontal.value ? MIN_W : MIN_H;
      resizeSize.value = saved ? Math.max(Number(saved) || 0, min) : 0;
    }
  },
);

const resizeStyle = computed(() => {
  if (!resizeSize.value || isMobile.value) return {};
  if (isHorizontal.value) return { width: `${resizeSize.value}px` };
  if (isVertical.value) return { height: `${resizeSize.value}px` };
  return {};
});

let _dragging = false;
let _startPos = 0;
let _startSize = 0;

function onResizeMouseMove(e: MouseEvent) {
  if (!_dragging) return;
  if (isHorizontal.value) {
    const maxW = window.innerWidth * 0.92;
    const delta =
      placement.value === 'left' ? e.clientX - _startPos : _startPos - e.clientX;
    resizeSize.value = Math.round(
      Math.min(Math.max(_startSize + delta, MIN_W), maxW),
    );
  } else {
    const maxH = window.innerHeight * 0.92;
    const delta =
      placement.value === 'top' ? e.clientY - _startPos : _startPos - e.clientY;
    resizeSize.value = Math.round(
      Math.min(Math.max(_startSize + delta, MIN_H), maxH),
    );
  }
}

function onResizeMouseUp() {
  if (!_dragging) return;
  _dragging = false;
  document.body.style.cursor = '';
  document.body.style.userSelect = '';
  document.removeEventListener('mousemove', onResizeMouseMove);
  document.removeEventListener('mouseup', onResizeMouseUp);
  if (resizeSize.value > 0) {
    localStorage.setItem(getStorageKey(), String(resizeSize.value));
  }
}

function onResizeMouseDown(e: MouseEvent) {
  e.preventDefault();
  _dragging = true;
  _startPos = isHorizontal.value ? e.clientX : e.clientY;
  const el = (e.target as HTMLElement).closest('[data-state]') as HTMLElement;
  _startSize = el
    ? isHorizontal.value
      ? el.offsetWidth
      : el.offsetHeight
    : resizeSize.value || (isHorizontal.value ? 520 : 400);
  if (!resizeSize.value) resizeSize.value = _startSize;
  document.body.style.cursor = isHorizontal.value
    ? 'col-resize'
    : 'row-resize';
  document.body.style.userSelect = 'none';
  document.addEventListener('mousemove', onResizeMouseMove);
  document.addEventListener('mouseup', onResizeMouseUp);
}
```

### 2. UI Handles (Template)

```html
<SheetContent
  ...
  :style="resizeStyle"
>
  <!-- Resize handle: horizontal drawers (left/right edge) -->
  <div
    v-if="canResize && isHorizontal"
    :class="
      cn(
        'absolute top-0 z-50 h-full w-1.5 cursor-col-resize transition-colors hover:bg-primary/20',
        placement === 'left' ? 'right-0' : 'left-0',
      )
    "
    @mousedown="onResizeMouseDown"
  />
  <!-- Resize handle: vertical drawers (top/bottom edge) -->
  <div
    v-if="canResize && isVertical"
    :class="
      cn(
        'absolute z-50 h-1.5 w-full cursor-row-resize transition-colors hover:bg-primary/20',
        placement === 'top' ? 'bottom-0 left-0' : 'left-0 top-0',
      )
    "
    @mousedown="onResizeMouseDown"
  />
  ...
</SheetContent>
```

## Rules for Claude

1.  **Verification**: When entering a new project, check `packages/@core/ui-kit/popup-ui/src/drawer/drawer.vue`.
2.  **Implementation**: If the resizing logic is missing (e.g., file ends around line 330 and lacks `onResizeMouseDown`), apply the code above to match the project's premium UI standard.
3.  **Persistence**: Ensure `localStorage` keys use `${RESIZE_KEY}${unref(title) || 'default'}` to maintain independent sizes for different drawers.
4.  **Desktop Only**: Always check `!isMobile.value` before enabling resizing.
