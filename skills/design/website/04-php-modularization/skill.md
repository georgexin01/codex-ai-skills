---
name: 04-php-modularization
description: "Sovereign Modular PHP: Extracting shared components into the lib/ directory. Ensuring structural consistency and easy site-wide updates."
step: 4
version: 1.0
---

# 🧩 [04] PHP Modularization — The Component Engine

## 🎯 Objective
To eliminate code duplication by centralizing shared UI components into modular PHP files. This allows for site-wide changes (like updating a logo or a link) in a single location.

## 📖 The Protocol
1.  **Identity the "Core 4"**:
    - `lib/htmlHead.php`: Meta tags, CSS links, Favicons.
    - `lib/header.php`: Navigation, Search Bar, User Profile.
    - `lib/footer.php`: Contact Info, Social Links, Legal.
    - `lib/htmlFoot.php`: JavaScript imports, tracking scripts.
2.  **Logic Extraction**:
    - Pull repetitive HTML blocks into separate files in the `lib/` directory.
    - Use `include()` or `require_once()` to inject them into page templates.
3.  **Variable Injection**:
    - Use PHP variables to pass page-specific data to modular components (e.g., `$page_title`).
4.  **Route Protection**:
    - Ensure all paths in the `lib/` files are **root-relative** (starting with `/`) to prevent broken links across different routes.

## 📦 Code Vault: Modular Integration Snippets

### 🛠️ In the Page Template (`template/*.php`)
```php
<?php 
    $page_title = "About Us"; 
    include('lib/htmlHead.php'); 
?>
<body class="body">
    <?php include('lib/header.php'); ?>
    <!-- Unique Content -->
    <?php include('lib/footer.php'); ?>
</body>
```

### 🌍 In the Component (`lib/header.php`)
```php
<header class="main-header">
    <div class="logo"><a href="/"><img src="/images/logo/logo.png"></a></div>
    <nav>
        <!-- Use root-relative links -->
        <li><a href="/about">About</a></li>
        <li><a href="/contact">Contact</a></li>
    </nav>
</header>
```

## 🛠️ Validation Checklist
- [ ] Are all common elements extracted to `lib/`?
- [ ] Are all links in `header/footer` root-relative?
- [ ] Is the PHP scope managed correctly (e.g., globals vs locals)?
- [ ] Are there any hardcoded paths that could break?

---
*Premium Design Node 04 — Modular PHP*
