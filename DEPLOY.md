# 海立婷 · 求职作品集 — 部署指南（Legacy + Python）

正式站点为 **`legacy/static-site/`** 静态 HTML，由 **Vercel** 托管；**Python Serverless** 提供 AI 与访问统计 API。

## 1. Vercel 项目设置

| 项 | 值 |
|----|-----|
| **Root Directory** | 留空（仓库根目录） |
| **Framework Preset** | Other |
| **Build Command** | （留空） |
| **Output Directory** | `legacy/static-site`（已在根目录 `vercel.json` 配置） |

根目录 `vercel.json` 已指定静态输出目录与 Python 运行时。

## 2. 环境变量

| Name | 必填 | 说明 |
|------|------|------|
| `DEEPSEEK_API_KEY` | 推荐 | [DeepSeek](https://platform.deepseek.com/) — AI 智能介绍 |
| `KV_REST_API_URL` + `KV_REST_API_TOKEN` | 推荐 | Vercel 绑定 Upstash 后**自动注入**（访问统计） |
| `UPSTASH_REDIS_REST_URL` + `UPSTASH_REDIS_REST_TOKEN` | 可选 | 与上一组二选一，代码均支持 |

未配置 `DEEPSEEK_API_KEY` 时，前端自动使用本地模板文案（HTTP 503）。

未配置 Redis 时，统计仅写入本地 `.data/visits.json`（`vercel dev` 可用；**生产环境计数会在函数冷启动后丢失**），请务必绑定 Upstash。

**不必手动抄全部变量**：在 Vercel 项目里 **Storage → 连接 Upstash** 后，只要有 `KV_REST_API_URL` 和 `KV_REST_API_TOKEN` 即可。`KV_URL`、`REDIS_URL`、`KV_REST_API_READ_ONLY_TOKEN` 可不加（本站在线统计需要写入权限）。

### 绑定 Upstash Redis（推荐）

1. Vercel 项目 → **Storage** → **Create Database** → 选 **Upstash Redis**
2. 连接到当前项目，会自动注入 `UPSTASH_REDIS_REST_*`
3. 重新 Deploy

## 3. API 端点（Python）

| 路径 | 方法 | 作用 |
|------|------|------|
| `/api/ai-about` | POST | 代理 DeepSeek，body: `{ "keyword": "区块链" }` |
| `/api/visit` | POST | 记录访问，body: `{ "session_id": "uuid", "path": "/" }` |
| `/api/visit` | GET | 查询统计 `{ page_views, unique_visitors, ... }` |

实现代码：`api/ai-about.py`、`api/visit.py`，共享逻辑在 `lib/`。

## 4. 部署

```bash
# 仓库根目录
npx vercel --yes
```

或在 Vercel 控制台连接 GitHub 后点 **Deploy**。

## 5. 验证

1. 打开站点首页 → 页脚应出现「本站累计 N 次浏览 · M 位访客」
2. 「AI 智能介绍」输入「区块链」→ 应显示 DeepSeek 实时生成（已配置 Key 时）
3. 控制台执行 `fetch('/api/visit').then(r=>r.json()).then(console.log)` 查看统计

## 6. 本地调试

```bash
cp .env.example .env
# 编辑 .env 填入 DEEPSEEK_API_KEY（可选 Upstash）

npx vercel dev
# 浏览器打开 http://localhost:3000
```

另开终端可用 curl：

```bash
curl -X POST http://localhost:3000/api/ai-about \
  -H 'Content-Type: application/json' \
  -d '{"keyword":"区块链"}'

curl http://localhost:3000/api/visit
```

## 7. 目录说明

```
my/
├── legacy/static-site/   ← 正式前端（HTML/CSS/JS）
├── api/                  ← Vercel Python 函数
├── lib/                  ← DeepSeek / 统计逻辑
├── vercel.json
└── portfolio_app/        ← 旧 Flutter 版（不再作为主站部署）
```

## 控制台彩蛋

```js
hireMe()
```
