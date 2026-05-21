# 海立婷 · AI 时代个人能力门户

> **本网站即作品本身** — 使用 Flutter Web 构建。

## AI 辅助开发声明

**本项目全程使用 AI 辅助开发**，从需求到部署文档均由人与 AI 协作完成，而非传统纯手工从零编写。

| 工具 | 用途 |
|------|------|
| **Cursor** | 主力 IDE：架构设计、多文件重构、Agent 式迭代 |
| **Trae · SOLO Coder 2** | 端到端任务驱动，独立模块 0→1 快速交付 |
| **GitHub Copilot** | 行级补全、样板代码、测试草稿 |

AI 参与环节：需求分析 → 技术选型 → 编码 → 测试 → 重构 → 文档

### Prompt 工程与协作心得

1. **先约束，再生成** — 写清角色、技术栈、验收标准（可运行、无 lint、响应式），再让 AI 出代码  
2. **三段式 Prompt** — 「背景+目标」→「约束与边界」→「期望输出格式（完整文件 / diff）」  
3. **大任务切片** — 按 feature 拆分，每步 `flutter analyze` 通过后再合并  
4. **人机分工** — 架构 / 安全 / 业务取舍由人决策；样板代码、样式、测试草稿交给 AI  
5. **Review 清单** — 采纳前检查：多余依赖、硬编码密钥、窄屏布局  
6. **SOLO Coder 2 vs Cursor** — 前者适合「完整页面交付」；后者适合「在现有项目上精准修改」

## 技术栈宣言

| 层级 | 选型 |
|------|------|
| 框架 | Flutter for Web |
| 状态 | flutter_riverpod |
| 路由 | go_router |
| 架构 | feature-first 分层 |
| 字体 | google_fonts (Noto Sans SC) |

## 功能模块

- **首页**：动态技能词云、AI 生成式「关于我」
- **技能**：交互式雷达图 + 岗位权重预设
- **作品**：分类项目廊 + AI 项目解说员
- **实验室**：微型挑战 + AI 编程流模拟 + 实时预览
- **关于本站**：技术选型与 AI 协作范式说明
- **联系**：CTA + 控制台彩蛋 `hireMe()`

## 本地运行

```bash
cd portfolio_app
flutter pub get
flutter config --enable-web   # 首次需开启 Web 支持
flutter run -d web-server     # 未安装 Chrome：用 Safari/任意浏览器打开 http://localhost:8080
# 已安装 Chrome：flutter run -d chrome
```

若 `flutter doctor` 提示找不到 Chrome，可安装 [Google Chrome](https://www.google.com/chrome/)，或指定其它 Chromium 内核浏览器：

```bash
export CHROME_EXECUTABLE="/Applications/你的浏览器.app/Contents/MacOS/浏览器可执行文件名"
flutter run -d chrome
```

## 构建与部署

```bash
flutter build web --release
```

### Vercel

```bash
cd portfolio_app
npx vercel --yes
```

## DeepSeek · AI 生成式「关于我」

访客输入关键词，基于预设背景由 **DeepSeek** 实时生成介绍；单次 token ≤ 1 万。

Vercel 配置 `DEEPSEEK_API_KEY` 后部署（`api/ai-about.js` 服务端代理）。未配置时回退本地模板。
