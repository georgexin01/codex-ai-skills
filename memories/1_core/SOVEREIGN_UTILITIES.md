---
name: sovereign-utilities
description: "Sovereign Utility Functions (V1.0)"
triggers: ["utils", "helpers", "reset", "pinia", "mock", "upload"]
version: 1.0
status: authoritative
---

# 第一部分 通用工具 (Sovereign Utility Functions)

本文件定义了系统中使用的通用工具函数，旨在通过统一的逻辑提升开发效率和系统稳定性。

## 1. Pinia 全局重置 (Pinia Universal Reset)
*   **说明**: 在用户注销（Logout）或重置系统状态时，通过此函数一键重置所有 Pinia Store 的状态。
*   **代码示例**:

```typescript
import { getActivePinia } from 'pinia';

export function resetAllStores() {
  const pinia: any = getActivePinia();
  // 遍历所有已激活的 Store 并调用 $reset 函数
  pinia?._s?.forEach((store: any) => store.$reset?.());
}
```

## 2. Mock 优先上传助手 (Mock-First Upload Helper)
*   **说明**: 在开发阶段优先使用 Mock 图片路径，避免频繁调用 Supabase Storage 产生额度消耗。
*   **代码示例**:

```typescript
export async function uploadToBucket(
  bucket: string,
  file: File | Blob,
  path: string
): Promise<string> {
  // 如果处于 Mock 模式，返回预设图片
  if (import.meta.env.VITE_IS_MOCK === 'true') {
    return 'https://images.unsplash.com/photo-1532996122724-e3c354a0b15b?w=400&q=80';
  }
  // 否则执行正式的上传逻辑...
}
```

---
## 3. 相关链接 (Related Links)
*   **参考**: [MASTER_BLUEPRINT.md](../0_apex/templates/MASTER_BLUEPRINT.md)

---
*Created by Antigravity Tier-1 Core Engineering Node*
