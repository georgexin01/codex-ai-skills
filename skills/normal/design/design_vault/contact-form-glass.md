---
name: contact-form-glass
description: "Design Snippet: Contact Form (Glassmorphism)"
triggers: ["contact form glass", "contact-form-glass", "design snippet contact"]
phase: reference
model_hint: gpt-5.3-codex
version: 42.0
_ohdy_wrapper: |-
  # OHDY COMPRESSED NODE (V42.0)
  <dna_node>
  v: 42.0
  n: contact-form-glass
  graph:
    req: []
    rel: []
  l: |-
  </dna_node>
---

# Design Snippet: Contact Form (Glassmorphism)

Type: CONTACT_SECTION
DNA: LUXURY_UTILITY
Context: Contact page conversion.

## 🎨 VISUAL STRUCTURE
A card-based form with high-density input fields.

```html
<div class="glass-panel contact-form">
  <form id="contact-form">
    <div class="form-group">
      <label>项目类型</label>
      <select class="form-control">
        <option value="app">移动 App 开发</option>
      </select>
    </div>
    <div class="form-group">
      <label>姓名</label>
      <input type="text" class="form-control" placeholder="您的姓名" />
    </div>
    
    <button type="submit" class="btn btn-primary">
      提交申请 <i data-lucide="send"></i>
    </button>
  </form>
</div>
```

## 🛠️ CSS TOKENS
- Input Border: `rgba(255, 255, 255, 0.1)`.
- Focus Glow: `border-color: var(--color-primary)`.
- Submit Button: Large padding (`18px`) and 100% width.

---
ZETA Design Vault — Contact Form Pattern

