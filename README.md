# 海立婷 · 求职作品集

静态 HTML 求职作品集 + **Vercel Python 后端**（DeepSeek AI 介绍、访问统计）。

## 仓库结构

```
my/
├── .cursor/skills/       ← Agent Skills（含 cursor-best-practices）
├── legacy/static-site/   ← 正式站点（部署到 Vercel / PageDrop）
├── api/                  ← Python Serverless（ai-about、visit）
├── lib/                  ← 共享业务逻辑
├── vercel.json           ← 输出目录 + Python 3.12
├── portfolio_app/        ← 旧 Flutter 实验版（不作为主站）
└── DEPLOY.md             ← 部署与环境变量
```

## Cursor Agent Skills

已安装 **[cursor-best-practices](https://github.com/HKTITAN/cursor-best-practices)**（`.cursor/skills/cursor-best-practices/`）：

- Rules、Commands、Subagents、MCP、`.cursorignore` 等最佳实践
- 内含 14 个命令模板、15 个子 Agent 模板，可复制到 `.cursor/commands/`、`.cursor/agents/`
- 在 Agent 聊天输入 **`/cursor-best-practices`**，或说「setup my .cursor folder」即可按技能指引初始化

详见 [.cursor/skills/README.md](./.cursor/skills/README.md)。

## 本地预览静态站

```bash
cd legacy/static-site
python3 -m http.server 8080
# 打开 http://localhost:8080（无 API，AI/统计需 vercel dev）
```

## 本地调试（含 API）

```bash
cp .env.example .env
npx vercel dev
```

## 部署

见 [DEPLOY.md](./DEPLOY.md)：Vercel 根目录部署，配置 `DEEPSEEK_API_KEY` 与 Upstash Redis。

## 功能

| 模块 | 说明 |
|------|------|
| 技术全景图 | 动态技能词云，点击进入技能证据页 |
| AI 交流 | `ai.html` — DeepSeek 智能介绍（`POST /api/ai-about`） |
| 架构专页 | AI Agent + Python Serverless + LangChain/LangGraph + Flutter |
| 访问统计 | `POST/GET /api/visit`，页脚展示浏览量与访客数 |
| 作品体验 | `experience.html?slug=faypay` 等 — 操作录屏 + 在线体验 |
| 主站 / 项目 | [PageDrop](https://pagedrop.dev/s/hailiting/) + 架构 / 联系页 |

## 正式地址

| 平台 | URL | 说明 |
|------|-----|------|
| **PageDrop**（大陆主站） | https://pagedrop.dev/s/hailiting/ | 静态 HTML；AI/统计 API 指向 Vercel |
| **Vercel**（API + 完整静态） | https://hailiting.vercel.app | Python 后端、录屏资源 |

一键部署：

```bash
bash scripts/deploy-all.sh   # 需 .env 中 PAGEDROP_DELETE_TOKEN
# 或仅 Vercel：npx vercel --prod --yes
# 或仅 PageDrop：bash scripts/deploy-pagedrop.sh
```