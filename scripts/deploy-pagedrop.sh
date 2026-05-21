#!/usr/bin/env bash
# 更新 PageDrop 站点 https://pagedrop.dev/s/hailiting/
# 需要创建站点时保存的 deleteToken，写入 .env：PAGEDROP_DELETE_TOKEN=dlt_...
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
STATIC="$ROOT/legacy/static-site"
SITE_ID="${PAGEDROP_SITE_ID:-hailiting}"
TOKEN="${PAGEDROP_DELETE_TOKEN:-}"

if [[ -z "$TOKEN" ]]; then
  if [[ -f "$ROOT/.env" ]]; then
    # shellcheck disable=SC1090
    set -a && source "$ROOT/.env" && set +a
    TOKEN="${PAGEDROP_DELETE_TOKEN:-}"
  fi
fi

if [[ -z "$TOKEN" ]]; then
  echo "缺少 PAGEDROP_DELETE_TOKEN（创建 /s/hailiting 时 API 返回的 deleteToken）"
  echo "在 .env 添加：PAGEDROP_DELETE_TOKEN=dlt_xxxxxxxx"
  echo "文档：https://pagedrop.dev/docs （PUT /api/v1/sites/:siteId）"
  exit 1
fi

# macOS mktemp *.zip 会先建空文件导致 zip -r 失败；用临时目录生成 zip
WORK="$(mktemp -d /tmp/pagedrop-XXXXXX)"
ZIP="$WORK/site.zip"
trap 'rm -rf "$WORK"' EXIT

# PageDrop ZIP 上限 10MB；录屏单独放 Vercel（约 37MB）
cd "$STATIC"
zip -r -q "$ZIP" . -x "assets/video/*" "*.DS_Store" "README.md" "*.md"

SIZE=$(stat -f%z "$ZIP" 2>/dev/null || stat -c%s "$ZIP")
if [[ "$SIZE" -gt 10485760 ]]; then
  echo "ZIP 超过 10MB，请减少资源或只部署到 Vercel"
  exit 1
fi

echo "上传 PageDrop /s/$SITE_ID（不含 assets/video，录屏请用 Vercel）…"
RESP=$(curl -sS -w "\n%{http_code}" -X PUT "https://pagedrop.dev/api/v1/sites/$SITE_ID" \
  -H "X-Delete-Token: $TOKEN" \
  -F "file=@$ZIP")

HTTP=$(echo "$RESP" | tail -1)
BODY=$(echo "$RESP" | sed '$d')

echo "$BODY" | python3 -m json.tool 2>/dev/null || echo "$BODY"

if [[ "$HTTP" != "200" ]]; then
  echo "PageDrop 更新失败 HTTP $HTTP"
  exit 1
fi

echo "完成：https://pagedrop.dev/s/$SITE_ID/"
