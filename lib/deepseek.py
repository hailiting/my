import json
import os
import urllib.error
import urllib.request
from typing import Any, Dict, Tuple

SYSTEM_CONTEXT = """你是资深技术招聘顾问。仅根据下列事实为访客生成「第三方视角」中文介绍，勿编造未提及经历。

【候选人】海立婷 · 前端开发工程师 · 11 年经验 · 期望杭州 · 25–30K
【代表作】Faypay 多链加密钱包 App — 一人独立完成含 App 内全部核心功能，faypay.com 可体验
【技术栈】Flutter/Dart 跨端 · React/RN/TS · Web3（Solidity、DeFi、多链）· Chrome 插件 OpenWallet · Node.js · AI 辅助开发（Cursor/Trae）· 性能优化
【代表项目】PPToken · Kaco DeFi · Bingo 链游 · ZG 交易所 · Zytron · 本求职作品集站点
【输出】针对关键词；200–350 字；专业可验证；勿列表堆砌"""

MAX_OUTPUT_TOKENS = 1200


def api_key_configured() -> bool:
    return bool(os.environ.get('DEEPSEEK_API_KEY', '').strip())


def generate_about(keyword: str) -> Tuple[int, Dict[str, Any]]:
    api_key = os.environ.get('DEEPSEEK_API_KEY', '').strip()
    if not api_key:
        return 503, {
            'error': 'DEEPSEEK_API_KEY not configured',
            'hint': 'Set DEEPSEEK_API_KEY in Vercel project settings',
        }

    payload = {
        'model': 'deepseek-chat',
        'messages': [
            {'role': 'system', 'content': SYSTEM_CONTEXT},
            {
                'role': 'user',
                'content': f'访客输入关键词：「{keyword}」。请生成针对性个人介绍。',
            },
        ],
        'max_tokens': MAX_OUTPUT_TOKENS,
        'temperature': 0.65,
        'stream': False,
    }

    req = urllib.request.Request(
        'https://api.deepseek.com/chat/completions',
        data=json.dumps(payload).encode('utf-8'),
        headers={
            'Content-Type': 'application/json',
            'Authorization': f'Bearer {api_key}',
        },
        method='POST',
    )

    try:
        with urllib.request.urlopen(req, timeout=55) as resp:
            data = json.loads(resp.read().decode('utf-8'))
    except urllib.error.HTTPError as e:
        err_body = e.read().decode('utf-8', errors='replace')
        try:
            err_json = json.loads(err_body)
            msg = err_json.get('error', {}).get('message') or err_json.get('message') or err_body
        except json.JSONDecodeError:
            msg = err_body or str(e)
        return e.code, {'error': msg}
    except Exception as e:
        return 500, {'error': str(e)}

    text = (data.get('choices') or [{}])[0].get('message', {}).get('content', '').strip()
    if not text:
        return 502, {'error': 'Empty response from DeepSeek'}

    return 200, {
        'text': text,
        'model': data.get('model'),
        'usage': data.get('usage'),
        'source': 'deepseek',
    }
