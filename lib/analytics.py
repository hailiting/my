import json
import os
import urllib.error
import urllib.request
from pathlib import Path
from typing import Any, Optional

PAGE_VIEWS_KEY = 'portfolio:page_views'
UNIQUE_SET_KEY = 'portfolio:unique_sessions'


def _redis_rest_url() -> str:
    """兼容 Upstash 直连变量与 Vercel Storage 注入的 KV_* 变量。"""
    return (
        os.environ.get('UPSTASH_REDIS_REST_URL', '').strip()
        or os.environ.get('KV_REST_API_URL', '').strip()
    )


def _redis_rest_token() -> str:
    return (
        os.environ.get('UPSTASH_REDIS_REST_TOKEN', '').strip()
        or os.environ.get('KV_REST_API_TOKEN', '').strip()
    )


def redis_configured() -> bool:
    return bool(_redis_rest_url() and _redis_rest_token())


def _local_store_path() -> Path:
    root = Path(__file__).resolve().parent.parent
    data_dir = root / '.data'
    data_dir.mkdir(parents=True, exist_ok=True)
    return data_dir / 'visits.json'


def _local_read() -> dict[str, Any]:
    path = _local_store_path()
    if not path.exists():
        return {'page_views': 0, 'unique_visitors': 0, 'sessions': []}
    with path.open(encoding='utf-8') as f:
        return json.load(f)


def _local_write(data: dict[str, Any]) -> None:
    path = _local_store_path()
    with path.open('w', encoding='utf-8') as f:
        json.dump(data, f, ensure_ascii=False)


def _upstash(command: list[str]) -> Any:
    base = _redis_rest_url().rstrip('/')
    token = _redis_rest_token()
    url = f'{base}/{"/".join(command)}'
    req = urllib.request.Request(
        url,
        method='POST',
        headers={'Authorization': f'Bearer {token}'},
    )
    with urllib.request.urlopen(req, timeout=10) as resp:
        payload = json.loads(resp.read().decode('utf-8'))
    return payload.get('result')


def record_visit(session_id: Optional[str], path: Optional[str] = None) -> dict[str, Any]:
    if redis_configured():
        page_views = int(_upstash(['incr', PAGE_VIEWS_KEY]) or 0)
        unique_visitors = 0
        if session_id:
            _upstash(['sadd', UNIQUE_SET_KEY, session_id])
            unique_visitors = int(_upstash(['scard', UNIQUE_SET_KEY]) or 0)
        else:
            unique_visitors = int(_upstash(['scard', UNIQUE_SET_KEY]) or 0)
        return {
            'ok': True,
            'storage': 'upstash',
            'page_views': page_views,
            'unique_visitors': unique_visitors,
            'path': path,
        }

    data = _local_read()
    data['page_views'] = int(data.get('page_views', 0)) + 1
    sessions: list[str] = list(data.get('sessions', []))
    if session_id and session_id not in sessions:
        sessions.append(session_id)
    data['sessions'] = sessions[-5000:]
    data['unique_visitors'] = len(sessions)
    _local_write(data)
    return {
        'ok': True,
        'storage': 'local',
        'page_views': data['page_views'],
        'unique_visitors': data['unique_visitors'],
        'path': path,
        'note': '本地 .data/visits.json；生产环境请配置 Upstash Redis',
    }


def get_stats() -> dict[str, Any]:
    if redis_configured():
        page_views = int(_upstash(['get', PAGE_VIEWS_KEY]) or 0)
        unique_visitors = int(_upstash(['scard', UNIQUE_SET_KEY]) or 0)
        return {
            'configured': True,
            'storage': 'upstash',
            'page_views': page_views,
            'unique_visitors': unique_visitors,
        }

    data = _local_read()
    return {
        'configured': False,
        'storage': 'local',
        'page_views': int(data.get('page_views', 0)),
        'unique_visitors': int(data.get('unique_visitors', len(data.get('sessions', [])))),
        'note': '生产环境请在 Vercel 绑定 Upstash Redis（UPSTASH_REDIS_REST_URL / TOKEN）',
    }
