---
name: 09-seo-hardening
description: "V2.0 SEO Hardening: Metadata saturation, JSON-LD Schema, and Keyword-Star optimization (e.g., SketchUp, RBZ, Interior Design)."
step: 9
version: 2.0
---

# 🛡️ [09] SEO Hardening — Structural Visibility

## 🎯 Objective
To "harden" the portal's visibility to search engines by saturating the code with semantic markers, structured data, and high-value keyword clusters without sacrificing the "Industrial" aesthetic.

## ⚠️ DEFAULT ROBOTS RULE — PERMANENT MANDATORY RULE

**ALL pages on ALL websites (dev, staging, AND production) MUST default to `noindex, nofollow`.**

```html
<meta name="robots" content="noindex, nofollow">
```

### Rules
- This applies to **every environment** — development, staging, and production builds.
- **NEVER change this default** unless the user explicitly instructs: *"set this site to index, follow"* or *"enable SEO indexing"*.
- Only override per-page or globally when the user gives a direct instruction to do so.
- In PHP shared head partial: `if (!isset($metaRobot)) { $metaRobot = 'noindex, nofollow'; }`
- In Vue/React `index.html`: `<meta name="robots" content="noindex, nofollow">`
- AI must NEVER auto-switch to `index, follow` as part of a "production build" or "SEO" task without explicit user approval.

---

## 📖 The Protocol
1.  **Metadata Saturation**:
    - Ensure every page has a unique `<title>` and `<meta description>`.
    - Apply Open Graph (`og:`) and Twitter Card tags for social scannability.
2.  **JSON-LD Schema**:
    - Inject `ld+json` scripts for core entities (e.g., `SoftwareApplication` for RBZ downloads, `LocalBusiness` for Interior Design services).
3.  **Keyword-Star Integration**:
    - Identify the "Star Keywords" (e.g., **SketchUp**, **RBZ**, **Interior Design**, **3D Material**).
    - Strategically place these in `<h1>`, `<h2>`, and `alt` tags.
4.  **Semantic Hierarchy Check**:
    - Verify the logical flow of headings (H1 -> H2 -> H3).
    - Ensure all links have descriptive `title` attributes.

## 📦 Code Vault: Schema Hardening Snippet

```html
<!-- 🤖 JSON-LD: Software Download (RBZ) -->
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "SoftwareApplication",
  "name": "Angel Interior SketchUp Pack",
  "operatingSystem": "Windows, MacOS",
  "applicationCategory": "DesignApplication",
  "downloadUrl": "https://angel-interior.com/rbz-download",
  "offers": {
    "@type": "Offer",
    "price": "0.00",
    "priceCurrency": "USD"
  }
}
</script>
```

## 🛠️ Validation Checklist
- [ ] Is there exactly one `<h1>` containing a star keyword?
- [ ] Does the JSON-LD schema pass the Google Rich Results test?
- [ ] Are all OG tags reflecting the premium "Sovereign" brand?
- [ ] Is the **Hidden Content Policy** preserved (No sensitive goals in meta)?

---
*Premium Design Node 09 — SEO Hardening (V2.0)*
