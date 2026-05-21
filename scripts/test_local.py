#!/usr/bin/env python3
"""本地 API 冒烟测试（不依赖 vercel dev）。"""
import json
import os
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, ROOT)

from lib.analytics import get_stats, record_visit, redis_configured
from lib.deepseek import api_key_configured, generate_about


def main() -> int:
    ok = True
    print('1) 访问统计')
    r = record_visit('smoke-test', '/')
    print('   record:', json.dumps(r, ensure_ascii=False))
    s = get_stats()
    print('   stats:', json.dumps(s, ensure_ascii=False))
    if not r.get('ok'):
        ok = False

    print('2) DeepSeek')
    if api_key_configured():
        code, body = generate_about('区块链')
        print('   status:', code)
        if code != 200:
            print('   error:', body)
            ok = False
        else:
            print('   preview:', (body.get('text') or '')[:80], '...')
    else:
        print('   跳过：未设置 DEEPSEEK_API_KEY')

    print('3) 存储')
    print('   Upstash:', 'OK' if redis_configured() else '未配置（生产需绑定）')

    print('\n' + ('全部通过' if ok else '存在失败项'))
    return 0 if ok else 1


if __name__ == '__main__':
    raise SystemExit(main())
