/**
 * 双轨部署：PageDrop 静态站 → Vercel Python API（跨域，已 CORS *）
 * 同域（localhost / *.vercel.app）仍用相对路径 /api/*
 */
(function () {
  var host = location.hostname;
  var meta = document.querySelector('meta[name="portfolio-api-base"]');
  var fromMeta = meta && meta.getAttribute('content');
  var fromQuery = new URLSearchParams(location.search).get('api_base');
  var explicit = (fromQuery || fromMeta || '').trim().replace(/\/$/, '');

  var base = explicit;
  if (!base && (host === 'pagedrop.dev' || host.endsWith('.pagedrop.dev'))) {
    base = 'https://hailiting.vercel.app';
  }

  window.PORTFOLIO_API_BASE = base;
  if (base) {
    window.AI_PROXY_URL = base + '/api/ai-about';
    window.VISIT_API_URL = base + '/api/visit';
  }
})();
