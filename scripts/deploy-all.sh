#!/usr/bin/env bash
# 双轨部署：Git push → Vercel 生产 → PageDrop（需 PAGEDROP_DELETE_TOKEN）
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

echo "==> 1/3 Git push（触发 Vercel Git 集成时可选）"
git push origin main

echo "==> 2/3 Vercel 生产部署（含 Python API + 静态站 + 录屏）"
npx vercel --prod --yes

echo "==> 3/3 PageDrop 更新 /s/hailiting"
if bash "$ROOT/scripts/deploy-pagedrop.sh"; then
  echo "双轨部署完成。"
else
  echo "Vercel 已部署；PageDrop 需配置 PAGEDROP_DELETE_TOKEN 后执行："
  echo "  bash scripts/deploy-pagedrop.sh"
  exit 1
fi
