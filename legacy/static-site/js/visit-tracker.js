/**
 * 访问统计 — POST /api/visit（同会话仅上报一次）
 */
(function () {
  const API = window.VISIT_API_URL || '/api/visit';
  const SID_KEY = 'ht_portfolio_sid';
  const SENT_KEY = 'ht_visit_sent';

  function sessionId() {
    try {
      let sid = localStorage.getItem(SID_KEY);
      if (!sid) {
        sid =
          typeof crypto !== 'undefined' && crypto.randomUUID
            ? crypto.randomUUID()
            : 's-' + Date.now() + '-' + Math.random().toString(36).slice(2);
        localStorage.setItem(SID_KEY, sid);
      }
      return sid;
    } catch {
      return null;
    }
  }

  function recordVisit() {
    try {
      if (sessionStorage.getItem(SENT_KEY)) return;
    } catch {
      /* ignore */
    }

    const body = JSON.stringify({
      session_id: sessionId(),
      path: location.pathname || '/',
    });

    fetch(API, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body,
      keepalive: true,
    })
      .then(function () {
        try {
          sessionStorage.setItem(SENT_KEY, '1');
        } catch {
          /* ignore */
        }
      })
      .catch(function () {
        /* 统计失败不影响浏览 */
      });
  }

  function showStats() {
    var el = document.getElementById('visitStats');
    if (!el) return;

    fetch(API)
      .then(function (r) {
        return r.json();
      })
      .then(function (data) {
        if (!data || data.page_views == null) return;
        var unique = data.unique_visitors != null ? data.unique_visitors : '—';
        el.textContent =
          '本站累计 ' +
          data.page_views +
          ' 次浏览 · ' +
          unique +
          ' 位访客（统计由 Python 后端记录）';
        el.hidden = false;
      })
      .catch(function () {});
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', function () {
      recordVisit();
      showStats();
    });
  } else {
    recordVisit();
    showStats();
  }
})();
