import os
import sys

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from http.server import BaseHTTPRequestHandler

from lib.analytics import get_stats, record_visit
from lib.http_util import read_json_body, send_json, send_options


class handler(BaseHTTPRequestHandler):
    def do_OPTIONS(self) -> None:
        send_options(self)

    def do_POST(self) -> None:
        body = read_json_body(self)
        session_id = (body.get('session_id') or '').strip() or None
        if session_id and len(session_id) > 128:
            send_json(self, 400, {'error': 'session_id too long'})
            return
        path = (body.get('path') or '').strip()[:256] or None
        result = record_visit(session_id, path)
        send_json(self, 200, result)

    def do_GET(self) -> None:
        send_json(self, 200, get_stats())
