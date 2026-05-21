# 海立婷 · 求职作品集

静态 HTML 求职作品集 + **Vercel Python 后端**（DeepSeek AI 介绍、访问统计）。

## 仓库结构

```
my/
├── legacy/static-site/   ← 正式站点（部署到 Vercel）
├── api/                  ← Python Serverless（ai-about、visit）
├── lib/                  ← 共享业务逻辑
├── vercel.json           ← 输出目录 + Python 3.12
├── portfolio_app/        ← 旧 Flutter 实验版（不作为主站）
└── DEPLOY.md             ← 部署与环境变量
```

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
| AI 智能介绍 | `POST /api/ai-about` → DeepSeek |
| 访问统计 | `POST/GET /api/visit`，页脚展示浏览量与访客数 |
| 项目 / 架构 / 联系 | 多页静态站 |
