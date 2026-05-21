import os
import sys

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from http.server import BaseHTTPRequestHandler

from lib.deepseek import generate_about
from lib.http_util import read_json_body, send_json, send_options


class handler(BaseHTTPRequestHandler):
    def do_OPTIONS(self) -> None:
        send_options(self)

    def do_POST(self) -> None:
        body = read_json_body(self)
        keyword = (body.get('keyword') or '').strip()
        if not keyword:
            send_json(self, 400, {'error': 'keyword is required'})
            return
        if len(keyword) > 48:
            send_json(self, 400, {'error': 'keyword too long (max 48)'})
            return

        status, payload = generate_about(keyword)
        send_json(self, status, payload)

    def do_GET(self) -> None:
        send_json(self, 405, {'error': 'Method not allowed'})
