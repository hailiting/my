#!/usr/bin/env bash
# 对 vercel dev 或已部署站点做 HTTP 测试
# 用法: ./scripts/test_http.sh http://localhost:3000
set -euo pipefail
BASE="${1:-http://localhost:3000}"

echo "== GET $BASE/ =="
code=$(curl -s -o /dev/null -w "%{http_code}" "$BASE/")
echo "status: $code"
test "$code" = "200"

echo "== GET $BASE/api/visit =="
curl -s "$BASE/api/visit" | python3 -m json.tool

echo "== POST $BASE/api/visit =="
curl -s -X POST "$BASE/api/visit" \
  -H 'Content-Type: application/json' \
  -d '{"session_id":"http-test","path":"/"}' | python3 -m json.tool

echo "== POST $BASE/api/ai-about =="
curl -s -X POST "$BASE/api/ai-about" \
  -H 'Content-Type: application/json' \
  -d '{"keyword":"区块链"}' | python3 -c "
import sys, json
d=json.load(sys.stdin)
if 'text' in d:
    print('OK DeepSeek:', d.get('source'), (d.get('text') or '')[:60], '...')
elif d.get('error'):
    print('fallback/error:', d.get('error'), d.get('hint',''))
else:
    print(d)
"

echo "== 全部 HTTP 测试完成 =="
