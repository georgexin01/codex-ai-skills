---
name: auth-login-gradient
description: "Auth Login Page — Dark Gradient + Glassmorphism"
triggers: ["auth login gradient", "auth-login-gradient", "auth login page"]
phase: reference
model_hint: gpt-5.3-codex
version: 42.0
_ohdy_wrapper: |-
  # OHDY COMPRESSED NODE (V42.0)
  <dna_node>
  v: 42.0
  n: auth-login-gradient
  graph:
    req: []
    rel: []
  l: |-
  </dna_node>
---

# Auth Login Page — Dark Gradient + Glassmorphism

Score: 95 (S-CORE) | Source: lee-ming-pork LoginView
Description: Full-screen dark gradient background with ambient circles, glassmorphism logo badge, white card form with rounded corners.
Reuse: Any app login/auth page. Change: brand colors, logo text, form fields.

## Customize These
- Gradient: `from-primary-600 via-primary-700 to-primary-900` → your brand
- Logo initials: `LM` → your app initials
- App name: `李明猪肉` → your app name
- Subtitle: `Pork Ordering System` → your description
- Form fields: phone → email/password/etc.
- Links: signup/forgot password URLs

## Full Code

```vue
<template>
  <div class="min-h-screen bg-gradient-to-br from-primary-600 via-primary-700 to-primary-900 flex flex-col relative overflow-hidden">
    
    <div class="absolute top-0 right-0 w-48 h-48 rounded-full bg-white/5 -mr-16 -mt-16"></div>
    <div class="absolute bottom-20 left-0 w-36 h-36 rounded-full bg-white/5 -ml-12"></div>

    <div class="flex-1 flex flex-col justify-center px-6 relative z-10">
      
      <div class="text-center mb-10">
        <div class="w-20 h-20 rounded-[24px] bg-white/10 backdrop-blur-xl mx-auto mb-5 flex items-center justify-center border border-white/20 shadow-2xl">
          <span class="text-3xl font-black text-white tracking-tighter">LM</span>
          
        </div>
        <h1 class="text-2xl font-black text-white tracking-tight uppercase">APP NAME</h1>
        <p class="text-primary-100 text-[10px] font-bold mt-2 uppercase tracking-[0.3em] opacity-80">SUBTITLE HERE</p>
      </div>

      
      <div class="bg-white rounded-[32px] p-8 shadow-float">
        <h2 class="text-2xl font-black text-gray-800 mb-1 tracking-tight">欢迎回来</h2>
        <p class="text-[10px] text-gray-400 font-bold mb-8 uppercase tracking-widest leading-relaxed">
          FORM DESCRIPTION HERE
        </p>

        <div class="space-y-4 mb-10">
          
          <div class="relative">
            <span class="absolute left-6 top-1/2 -translate-y-1/2 text-sm font-black text-primary-600">+60</span>
            <input
              type="tel"
              placeholder="手机号码"
              class="w-full h-18 bg-gray-50 border-2 border-gray-100 rounded-[24px] pl-16 pr-6 text-sm font-bold focus:border-primary-500 focus:bg-white outline-none transition-all shadow-sm"
            />
          </div>
        </div>

        
        <button class="w-full h-18 bg-primary-600 text-white rounded-xl text-sm font-black tracking-[0.2em] uppercase shadow-lg shadow-primary-600/20 active:scale-[0.97] transition-all flex items-center justify-center">
          登录
        </button>
      </div>

      
      <p class="text-center text-primary-200 text-[10px] font-black mt-8 uppercase tracking-[0.3em]">
        还没有账号?
        <a href="/signup" class="text-white hover:underline underline-offset-4 decoration-2">立即注册</a>
      </p>
    </div>
  </div>
</template>
```

## Required CSS

```css
.shadow-float {
  box-shadow: 0 8px 30px rgba(0, 0, 0, 0.12);
}
```

