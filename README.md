# 海立婷 · 个人作品集网站

基于简历生成的静态个人主页，展示技能、经历与项目。

## 本地预览

```bash
# 在项目目录下任选一种方式
python3 -m http.server 8080
# 或
npx serve .
```

浏览器打开 http://localhost:8080

## 免费部署

### Vercel（推荐）

```bash
npx vercel --yes
```

按提示登录后即可获得 `*.vercel.app` 域名。

### Netlify

```bash
npx netlify deploy --prod --dir=.
```

### Cloudflare Pages

将本仓库推送到 GitHub 后，在 [Cloudflare Pages](https://pages.cloudflare.com) 连接仓库，构建命令留空，输出目录为 `/`。
