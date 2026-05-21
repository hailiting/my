import json
from http.server import BaseHTTPRequestHandler
from typing import Any, Dict
from urllib.parse import urlparse

CORS_HEADERS = {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
    'Access-Control-Allow-Headers': 'Content-Type',
}


def read_json_body(handler: BaseHTTPRequestHandler) -> Dict[str, Any]:
    length = int(handler.headers.get('Content-Length', 0) or 0)
    if length <= 0:
        return {}
    raw = handler.rfile.read(length)
    try:
        data = json.loads(raw.decode('utf-8'))
        return data if isinstance(data, dict) else {}
    except json.JSONDecodeError:
        return {}


def send_json(handler: BaseHTTPRequestHandler, status: int, payload: Dict[str, Any]) -> None:
    body = json.dumps(payload, ensure_ascii=False).encode('utf-8')
    handler.send_response(status)
    for key, value in CORS_HEADERS.items():
        handler.send_header(key, value)
    handler.send_header('Content-Type', 'application/json; charset=utf-8')
    handler.send_header('Content-Length', str(len(body)))
    handler.end_headers()
    handler.wfile.write(body)


def send_options(handler: BaseHTTPRequestHandler) -> None:
    handler.send_response(204)
    for key, value in CORS_HEADERS.items():
        handler.send_header(key, value)
    handler.end_headers()


def request_path(handler: BaseHTTPRequestHandler) -> str:
    return urlparse(handler.path).path
