---
name: dna-specialty
description: "DNA 专项规范 (DNA SPECIALTY) — PWA, i18n, and native-bridge deployment patterns for Vue 3 + Capacitor sovereign stack."
triggers: ["pwa", "offline", "service worker", "manifest", "i18n", "lang", "translate", "locale", "capacitor", "native bridge"]
phase: constitutional
version: 2.0
status: authoritative
date_updated: "2026-04-24"
---

# 1. DNA 专项规范 (DNA SPECIALTY V2.0) — PWA / i18n / Native Deploy

本文件定义了现代 Web 构建中必须处理的三个相邻领域。每个领域都经过精确定位，不绑定框架，不包含推测性功能。

---

## 一、 PWA (Progressive Web App)

### 1.1 Manifest 核心要素
- **Display**: `standalone` (无浏览器边框) — 强制要求。
- **Status bar (iOS)**: `black-translucent` 通过 `<meta name="apple-mobile-web-app-status-bar-style">` 实现。
- **Icons**: 提供 192px 和 512px 的 `maskable` PNG 格式图标。可选 180px 的 `apple-touch-icon`。
- **Start URL**: `/?source=pwa` — 保留分析归属。
- **Theme color**: 必须与首屏渲染时的头部背景色匹配（防止闪烁）。
- **Orientation**: 除非应用是游戏或媒体专用的，否则设为 `any`。

### 1.2 Service Worker 策略
- **默认**: HTML 使用 `NetworkFirst`，指纹化的 `/assets/*` 资源使用 `CacheFirst`。
- **禁止**: 禁止在 API 路由上使用 `StaleWhileRevalidate` — 会导致陈旧数据 Bug。
- **更新流**: 使用 skipWaiting + clients.claim + 重新加载提示，不要静默重新加载。
- **版本**: 每次部署都必须提升 Service Worker 版本。

### 1.3 视口强制标准 (Viewport Mandate)
- **`width=device-width`** — 响应式标准，适配所有手机尺寸（320–430px CSS宽度）。`width=412` 已废弃，禁止使用（会在窄屏设备如 iPhone SE 上裁切右边缘）。
- `initial-scale=1.0`, `viewport-fit=cover`。禁止使用 `maximum-scale=1.0` 或 `user-scalable=no`（影响无障碍访问）。

### 1.4 安装提示 UX
- 延迟 `beforeinstallprompt` — 捕获事件，仅在用户交互后显示 CTA（例如：2 次页面浏览或在网站上停留 30 秒）。
- 安装后：切换到 `window.matchMedia('(display-mode: standalone)')` 以进行应用内 UX 分支。

---

## 二、 i18n (Internationalization)

### 2.1 Vue i18n 设置 (仅限 Composition API)
- **`legacy: false`** — 始终设置。Composition API 通过 `useI18n()` 解锁响应式的 `t()`。
- **全局作用域**: 共享键使用 `useI18n({ useScope: 'global' })`；页面特定包默认为 `'local'`。
- **存储**: 在 `localStorage` 的 `__locale` 键中持久化用户语言，并在应用挂载时同步到 Pinia。
- **回退链**: `zh-CN + en` (或根据项目反转)。切勿在缺失键时硬崩溃。

### 2.2 ID 与文本分离
- **IDs, 数字, 枚举, 键**：存储在 JS/TS 中。
- **可见字符串**：仅存储在 `/locales/{lang}.json` 中。
- **规则 #1 违规**: 在 `.vue` 模板中直接编写中/英文 = 代码审查自动失败。

### 2.3 响应式绑定
- 模板中的每个可见字符串必须使用 `{{ t('path.to.key') }}` 或 `:placeholder="t(...)"`。
- 动态标签: 封装在 `computed(() => t(...))` 中，以便语言切换时立即重绘。
- 当可以使用 Composition API 时，切勿在 setup 脚本中使用 `$t` — 使用从 `useI18n()` 解构出来的 `t`。

### 2.4 双语搜索意图
- 搜索输入接受两种语言 — 通过每条记录的 `searchTerms` 数组进行规范化（例如：`["手机", "driver", "sije"]`）。
- 在中文项目中尽可能提供拼音回退。

---

## 三、 原生桥接 (Native Bridge - Capacitor 6+)

### 3.1 何时使用原生
- 需要 Google Maps 原生 SDK, GPS, 高帧率相机, 或蓝牙时使用 **Capacitor**。
- 纯浏览器功能（通知、文件上传、简单地理定位）使用 **PWA** 即可，不要发布原生应用。

### 3.2 插件规范
- 将每个原生插件调用封装在 try/catch 中，并回退到 Web API。
- **示例**: 相机使用 `Camera.getPhoto()`；在 Web 上回退到 `<input type="file" accept="image/*" capture>`。
- 仅在 `Capacitor.isNativePlatform()` 为真时在 `onMounted` 中初始化插件 — 绝不要在模块作用域初始化。

### 3.3 深度链接 (Deep Linking)
- 使用 `@capacitor/app` 的 `appUrlOpen` 监听器。
- 路由表: 映射 `myapp://driver/task/:id` 到 `router.push("/driver/task/${id}")`。

### 3.4 构建流水线
- `npm run build` + `dist/` + `npx cap sync` + 在 Android Studio / Xcode 中打开。
- 绝不要将 `android/` 或 `ios/` 原生文件夹提交到项目 Git — 从 Web 构建生成。
- 在 `package.json` 中锁定 Capacitor 版本。

---

## 四、 跨领域治理

| 领域 | 规则 | 执行方式 |
|---|---|---|
| 包体积 | PWA 预缓存 < 3 MB gzipped | Vite 构建分析器 |
| 首屏时间 | TTI < 2.5 s 在 4G 环境 | Lighthouse CI |
| 语言缺失键 | 记录到 console.warn，不抛出异常 | i18n 回退链 |
| 原生专用代码 | 使用 `isNativePlatform()` 保护 | try/catch 包装器 |
| Service Worker 作用域 | 绝不注册在 `/admin/*` 路由上 | 注册守卫 |

---

## 五、 参考资料 (REFERENCES)

- [claude-app/12-i18n-composables/skill.md](../../skills/claude-app/12-i18n-composables/skill.md) — 逐步实现指南
- [claude-app/13-native-pwa-deploy/skill.md](../../skills/claude-app/13-native-pwa-deploy/skill.md) — 部署流水线
- [lib/htmlHead.php](../../../../alexis/lib/htmlHead.php) — 视口 412 参考实现

---
**DNA Specialty V2.0 — 2026-04-24**
