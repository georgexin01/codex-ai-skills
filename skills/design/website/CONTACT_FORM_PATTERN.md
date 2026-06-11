---
name: contact-form-pattern
description: "Full recipe for a production-grade Contact page in PHP/HTML: glass-card form (gold top stripe + mint inputs + custom green chevron select), info-card stack with tinted icon tiles, neutral-white social card, rounded Google Maps iframe. Bootstrap col-12 / col-md-6 / col-lg-8 + col-lg-4 grid with optional order-lg-1/2 swap. Validated 2026-05-12 against the EcoWorld contact page after a website-LAA-website reference study."
type: skill
tier: 2
phase: 06-component-engineering
priority: HIGH
applies_to: ["claude", "claude-code", "codex", "gpt-5.4-mini"]
related:
  - "SKILL.md"
  - "06-component-engineering/skill.md"
  - "ECOWORLD_COLOR_SYSTEM.md"
  - "HEADER_FOOTER_BOOTSTRAP_PATTERN.md"
version: 1.0
date: 2026-05-12
status: authoritative
triggers:
  - "contact page"
  - "contact form"
  - "enquiry form"
  - "contact us section"
  - "sales gallery contact"
  - "form with map"
  - "contact card design"
---

# Contact Page — Glass Form + Info Stack + Map Pattern

> Drop-in recipe for a Contact page that feels like a real-estate sales gallery rather than a generic web form. Built around four panels: a soft-gradient hero, a glass form card, a vertical info-card stack, and a rounded map. Bootstrap grid + custom CSS. Reference impl: `c:/Users/user/Desktop/ecoworld/template/contact.php` + ".contact-*" CSS block.

## 1. Page composition (top → bottom)

1. **Hero** — `Contact us now` kicker + serif headline + lead paragraph (2–3 sentences). Soft `--grad-soft`-style backdrop.
2. **Form + info row** — Bootstrap `row.g-4.g-lg-5` containing two columns: form `col-lg-8`, info stack `col-lg-4`. Optional `order-lg-1` / `order-lg-2` to put info on the left at desktop while keeping form first in the mobile DOM order (form is the primary action on mobile).
3. **Map** — full-width rounded iframe inside its own section.

The previous "About company" facts grid we tried *between* (2) and (3) was overkill for a Contact page — users want to *act*, not read a corporate bio. Skip it.

## 2. Form card markup

```html
<article class="contact-form-card">
  <header class="contact-form-card__head">
    <span class="section-kicker">Enquiry form</span>
    <h2>Send us a message.</h2>
    <p>We'll reply within one business day.</p>
  </header>

  <form class="contact-form" method="post" action="#" novalidate>
    <div class="row g-3">
      <div class="col-12 col-md-6 form-row">
        <label for="cf-name">Full name <span class="req">*</span></label>
        <input id="cf-name" type="text" name="fullname" placeholder="" required>
      </div>
      <div class="col-12 col-md-6 form-row">
        <label for="cf-email">Email address <span class="req">*</span></label>
        <input id="cf-email" type="email" name="email" placeholder="" required>
      </div>
      <!-- phone, region (select), interest (select), budget (select), message -->
      <div class="col-12 form-row form-row--consent">
        <label class="form-consent">
          <input type="checkbox" name="consent" required>
          <span>I agree to be contacted about EcoWorld units.</span>
        </label>
      </div>
      <div class="col-12 form-row form-row--submit">
        <button type="submit" class="button button--lg">Send enquiry →</button>
        <a class="button button--ghost" href="https://wa.me/…" target="_blank" rel="noopener">Chat on WhatsApp instead</a>
      </div>
    </div>
  </form>
</article>
```

### Form copy rules

- **Heading**: short ("Send us a message.") — not "Tell us what you're looking for…"
- **Sub-copy**: one promise ("We'll reply within one business day.") — not a paragraph
- **Consent**: one line ("I agree to be contacted about X units.") — not a disclaimer
- **Placeholders**: prefer empty. Labels carry the meaning; placeholders that look like data ("e.g. Tan Wei Ming") create visual noise. Keep `<select>` placeholders ("Any region", "Open to suggestions", "Prefer not to say") because they double as the default value.

## 3. Form card CSS — the signature treatment

```css
.contact-form-card {
  position: relative;
  background: rgba(255, 255, 255, 0.96);
  border-radius: 28px;
  padding: clamp(28px, 4vw, 48px);
  box-shadow:
    0 24px 60px rgba(6, 63, 36, 0.08),
    0 4px 12px rgba(21, 21, 21, 0.04);
  border: 1px solid rgba(21, 21, 21, 0.05);
  overflow: hidden;
  backdrop-filter: blur(6px);
}
.contact-form-card::before {
  content: "";
  position: absolute; inset: 0 0 auto 0;
  height: 6px;
  background: var(--grad-gold);                /* 6 px gold gradient stripe */
  border-top-left-radius: 28px;
  border-top-right-radius: 28px;
}

.form-row { display: flex; flex-direction: column; gap: 8px; }
.form-row label {
  font-size: 12px; font-weight: 800;
  letter-spacing: 0.06em; text-transform: uppercase;
  color: var(--eco-green-800);
}
.form-row .req { color: var(--cat-food); margin-left: 4px; }

.contact-form input, .contact-form select, .contact-form textarea {
  width: 100%; min-height: 48px;
  padding: 12px 16px;
  border: 1px solid rgba(21, 21, 21, 0.1);
  border-radius: 14px;
  background: var(--eco-white);
  color: var(--text-main);
  font-size: 15px;
  transition: border-color 160ms, box-shadow 160ms, background 160ms;
}
.contact-form input:focus, .contact-form select:focus, .contact-form textarea:focus {
  outline: none;
  border-color: var(--eco-green-600);
  box-shadow: 0 0 0 4px rgba(28, 154, 80, 0.16);            /* mint focus halo */
}
.contact-form select {
  appearance: none; -webkit-appearance: none;
  padding-right: 44px;
  background-image: url("data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='%23117a3d' stroke-width='2.4' stroke-linecap='round' stroke-linejoin='round'><path d='m6 9 6 6 6-6'/></svg>");
  background-repeat: no-repeat;
  background-position: right 16px center;
  background-size: 16px 16px;
  cursor: pointer;
}

.form-row--consent .form-consent {
  display: flex; align-items: flex-start; gap: 12px;
  padding: 14px 16px;
  background: var(--eco-mist);            /* soft mint plate */
  border-radius: 14px;
  font-size: 13.5px;
  color: var(--eco-green-900);
  cursor: pointer;
}
.form-row--consent input[type="checkbox"] {
  width: 18px; height: 18px;
  accent-color: var(--eco-green-700);
}

.button--lg {
  min-height: 54px;
  padding: 14px 28px;
  font-size: 15px;
  box-shadow: 0 12px 28px rgba(11, 90, 50, 0.22);
}
```

**Signature elements** — the 4 details that make this form feel premium:
1. 6 px gold gradient stripe pinned to the card's top edge
2. 28 px card radius + layered shadow + 1 px subtle border + 6 px backdrop blur
3. Custom green chevron `<select>` — never use OS-native dropdown chrome
4. Mint focus halo (`box-shadow: 0 0 0 4px rgba(28,154,80,0.16)`)

## 4. Info card stack

Each info item is its own white card with a tinted icon tile and a kicker → value → optional sub-line:

```html
<aside class="col-12 col-lg-4 order-lg-1 contact-info-col">
  <article class="contact-info-card">
    <span class="contact-info-card__icon">📞</span>
    <div>
      <span class="contact-info-card__label">Sales hotline</span>
      <a class="contact-info-card__value" href="tel:…">+60 12-345 6789</a>
    </div>
  </article>
  <!-- email, address+map link, opening hours, social pills -->
</aside>
```

```css
.contact-info-col { display: flex; flex-direction: column; gap: 16px; }
.contact-info-card {
  display: flex; align-items: flex-start; gap: 16px;
  padding: 20px 22px;
  background: var(--eco-white);
  border: 1px solid rgba(21, 21, 21, 0.06);
  border-radius: 20px;
  box-shadow: 0 8px 22px rgba(6, 63, 36, 0.05);
  transition: transform 180ms ease, box-shadow 180ms ease, border-color 180ms ease;
}
.contact-info-card:hover {
  transform: translateY(-2px);
  border-color: var(--eco-green-100);
  box-shadow: 0 14px 32px rgba(6, 63, 36, 0.1);
}
.contact-info-card__icon {
  display: inline-flex; align-items: center; justify-content: center;
  width: 48px; height: 48px;
  border-radius: 14px;
  background: var(--eco-green-100);           /* tinted icon tile */
  font-size: 22px;
}
.contact-info-card__value {
  font-family: Georgia, "Times New Roman", serif;
  font-size: 19px;
  font-weight: 700;
  color: var(--eco-green-900);
  word-break: break-word;
}
```

### Card-list order

1. **Sales hotline** — primary action
2. **Email**
3. **Address** with Google Maps deep link
4. **Opening hours** — weekday / weekend / holiday lines
5. **Social** — neutral white card (NOT a green-gradient block — that competes with the form's gold stripe). Pills go neutral paper background + green-900 text, mint hover.

## 5. Data contract — `$contact` extension

Bare-minimum contact array isn't enough for a real page. Use this extended shape:

```php
$contact = [
  'phone'           => '+60 12-345 6789',
  'phone_alt'       => '+60 7-555 1234',
  'email'           => 'sales@example.test',
  'email_support'   => 'support@example.test',
  'whatsapp'        => 'https://wa.me/60123456789',
  'whatsapp_label'  => '+60 12-345 6789',
  'address_short'   => 'Eco Galleria Sales Gallery',
  'address'         => 'No. 1, Persiaran Eco Galleria, …',
  'maps_url'        => 'https://maps.google.com/?q=…',
  'maps_embed'      => 'https://www.google.com/maps/embed?pb=…',
  'hours_weekday'   => 'Mon – Fri · 9:00 AM – 6:00 PM',
  'hours_weekend'   => 'Sat – Sun · 10:00 AM – 5:00 PM',
  'hours_holiday'   => 'Public Holiday · By appointment',
  'instagram'       => 'https://instagram.com/…',
  'facebook'        => 'https://facebook.com/…',
  'tiktok'          => 'https://tiktok.com/@…',
];
```

## 6. Bootstrap grid + order swap

Mobile DOM keeps form first (primary action). On desktop, info-on-left/form-on-right reads more like a brochure:

```html
<div class="col-12 col-lg-8 order-lg-2">  <!-- form -->
<aside class="col-12 col-lg-4 order-lg-1">  <!-- info -->
```

If you want form-left/info-right instead (sales-page reading order), drop both `order-lg-*` classes.

## 7. Map block

```html
<section class="contact-map">
  <div class="contact-map__frame">
    <iframe src="<?= h($contact['maps_embed']) ?>"
      width="100%" height="420" style="border:0;"
      allowfullscreen loading="lazy"
      referrerpolicy="no-referrer-when-downgrade"
      title="Sales gallery location"></iframe>
  </div>
</section>
```

```css
.contact-map { padding: 0 clamp(16px, 4vw, 56px) clamp(40px, 6vw, 80px); }
.contact-map__frame {
  border-radius: 24px;
  overflow: hidden;
  box-shadow: 0 24px 60px rgba(6, 63, 36, 0.12);
  border: 1px solid rgba(21, 21, 21, 0.06);
}
.contact-map iframe {
  display: block;
  width: 100%;
  filter: saturate(1.05);
}
```

## 8. Anti-patterns

- ❌ Inline icon SVGs in info cards. Use emoji or Material Symbols — they ship with the OS and stay crisp at any size. Custom SVG requires fill-color tuning per icon.
- ❌ Green-gradient social card on the same page as a gold-striped form card. Both blocks become "feature blocks" and compete for attention. Pick one tinted, the other neutral.
- ❌ Putting the map in the same row as the form. Map deserves its own section so the iframe can be full-width on mobile.
- ❌ Long disclaimer text in the consent checkbox. Move legal copy to a footer link.
- ❌ Verbose form labels ("PLEASE ENTER YOUR FULL LEGAL NAME"). One word in uppercase 12 px is enough.
- ❌ Adding a "Reset" button. Modern form UX is "fill, submit, refresh if needed".
- ❌ Forgetting `novalidate` on the `<form>` — browser-native validation bubbles look out of place against the brand inputs. Style your own validation feedback if needed.

## 9. Reference points

- Original LAA contact reference: `c:/Users/user/Desktop/ecoworld/website-LAA-website/template/contact.php` — 2-column form/info + map iframe.
- EcoWorld implementation: `c:/Users/user/Desktop/ecoworld/template/contact.php`.
- Sister-pattern hooks:
  - Form-card gold stripe ↔ Sovereign Punctuation kicker pattern from [ECOWORLD_COLOR_SYSTEM.md §6](ECOWORLD_COLOR_SYSTEM.md).
  - Custom green chevron select ↔ [ECOWORLD_COLOR_SYSTEM.md §9](ECOWORLD_COLOR_SYSTEM.md#9-modern-polish-layer-2026-05-11-update).
  - Unified mint hover/focus ↔ [ECOWORLD_COLOR_SYSTEM.md §10](ECOWORLD_COLOR_SYSTEM.md).

---

*Authored 2026-05-12 by Claude during EcoWorld contact-page build. Iterated three times based on user feedback: removed "About the company" facts grid; swapped form/info column order with Bootstrap `order-lg-*`; trimmed copy; emptied placeholders; reset social card from green gradient to neutral white.*

