/**
 * 作品体验页 — experience.html?slug=faypay
 */
(function () {
  function ecoLabel(eco) {
    const map = {
      flutter: '跨端 · Flutter',
      ai: 'AI 研发',
      web: 'Web 前端',
      chain: '区块链',
      arch: '工程架构',
      tool: '工程 / 工具',
      soft: '综合素养',
    };
    return map[eco] || eco;
  }

  function escapeHtml(s) {
    return String(s)
      .replace(/&/g, '&amp;')
      .replace(/</g, '&lt;')
      .replace(/>/g, '&gt;')
      .replace(/"/g, '&quot;');
  }

  function renderVideoBlock(media, eco) {
    if (!media.videos || media.videos.length === 0) return '';

    const tabs = media.videos
      .map(
        (v, i) =>
          `<button type="button" class="exp-video-tab${i === 0 ? ' is-active' : ''}" data-exp-index="${i}" aria-selected="${i === 0}">${escapeHtml(v.title)}</button>`
      )
      .join('');

    const first = media.videos[0];
    return `
      <section class="exp-video-section" aria-label="操作录屏">
        <p class="skill-evidence-label">操作录屏</p>
        <p class="exp-intro">${escapeHtml(media.intro || '')}</p>
        <div class="exp-video-tabs" role="tablist">${tabs}</div>
        <div class="exp-video-player-wrap">
          <video
            id="expMainVideo"
            class="exp-video-player"
            controls
            playsinline
            preload="metadata"
            poster=""
            data-active-index="0"
          >
            <source src="${escapeHtml(first.src)}" type="video/mp4" />
            您的浏览器不支持视频播放，请<a href="${escapeHtml(first.src)}">下载录屏</a>观看。
          </video>
        </div>
        <p id="expVideoDesc" class="exp-video-desc" style="color:${window.ECO_COLORS[eco] || 'var(--accent)'}">${escapeHtml(first.desc || '')}</p>
        <ul class="exp-video-hints">
          <li>支持全屏与倍速播放</li>
          <li>移动端建议 Wi‑Fi 下观看（单段约 8–20 MB）</li>
        </ul>
      </section>`;
  }

  function renderAiDemo() {
    return `
      <section class="exp-demo-section" id="expAiDemo">
        <p class="skill-evidence-label">现场体验 · AI 介绍</p>
        <div class="ai-about-panel exp-ai-panel">
          <div class="ai-about-chips">
            <button type="button" class="ai-about-chip" data-ai-keyword="区块链">区块链</button>
            <button type="button" class="ai-about-chip" data-ai-keyword="Flutter 跨端">Flutter 跨端</button>
            <button type="button" class="ai-about-chip" data-ai-keyword="Claude Code">Claude Code</button>
          </div>
          <div class="ai-about-input-row">
            <input id="aiAboutInput" type="text" placeholder="输入关键词体验生成…" maxlength="48" autocomplete="off" />
            <button type="button" id="aiAboutSend" class="btn btn-primary">生成</button>
          </div>
          <p id="aiAboutOutput" class="ai-about-output">输入关键词，由 DeepSeek 实时生成介绍…</p>
          <p id="aiAboutMeta" class="ai-about-meta"></p>
        </div>
      </section>`;
  }

  function renderApiDemo() {
    return `
      <section class="exp-demo-section">
        <p class="skill-evidence-label">接口说明</p>
        <pre class="arch-code exp-api-code"># 访问统计（GET）
fetch('/api/visit').then(r =&gt; r.json()).then(console.log)

# AI 介绍（POST）
fetch('/api/ai-about', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({ keyword: '区块链' })
}).then(r =&gt; r.json()).then(console.log)</pre>
        <p class="exp-intro">PageDrop 主站会自动将 API 指向 Vercel；本地请使用 <code>npx vercel dev</code>。</p>
      </section>`;
  }

  function renderProjects(word, eco) {
    const items = (word.projects || [])
      .map(
        (p) => `
        <article class="skill-evidence-project">
          <h4>${escapeHtml(p.name)}</h4>
          <p>${escapeHtml(p.summary)}</p>
          <p class="skill-evidence-metric" style="color:${window.ECO_COLORS[eco] || 'var(--accent)'}">${escapeHtml(p.metric)}</p>
          ${p.url ? `<a href="${escapeHtml(p.url)}" target="_blank" rel="noopener">在线打开 →</a>` : ''}
        </article>`
      )
      .join('');

    if (!items) return '';
    return `
      <section class="exp-projects-section">
        <p class="skill-evidence-label">相关作品</p>
        ${items}
      </section>`;
  }

  function bindVideoTabs(media) {
    const video = document.getElementById('expMainVideo');
    const desc = document.getElementById('expVideoDesc');
    const tabs = document.querySelectorAll('.exp-video-tab');
    if (!video || !tabs.length) return;

    tabs.forEach((tab) => {
      tab.addEventListener('click', () => {
        const i = Number(tab.getAttribute('data-exp-index'));
        const clip = media.videos[i];
        if (!clip) return;

        tabs.forEach((t) => {
          t.classList.remove('is-active');
          t.setAttribute('aria-selected', 'false');
        });
        tab.classList.add('is-active');
        tab.setAttribute('aria-selected', 'true');

        video.pause();
        video.src = clip.src;
        video.load();
        if (desc) desc.textContent = clip.desc || '';
        video.setAttribute('data-active-index', String(i));
      });
    });
  }

  function initExperiencePage() {
    const root = document.getElementById('experienceRoot');
    if (!root) return;

    const slug = new URLSearchParams(window.location.search).get('slug');
    if (slug === 'architecture') {
      window.location.replace('architecture.html');
      return;
    }

    const word = slug && window.getSkillBySlug ? window.getSkillBySlug(slug) : null;
    if (!word) {
      root.innerHTML = `
        <div class="skill-detail-empty">
          <p>未找到该技能的体验页。</p>
          <a class="btn btn-primary" href="index.html#skill-map">返回技术全景图</a>
        </div>`;
      document.title = '体验未找到 | 海立婷';
      return;
    }

    const media = window.getExperienceMedia ? window.getExperienceMedia(slug) : null;
    const eco = word.eco || 'soft';
    const ecoColor = window.ECO_COLORS[eco] || '#38bdf8';
    const headline = (media && media.headline) || `${word.text} · 作品体验`;
    const hasVideo = media && media.videos && media.videos.length > 0;
    const hasAiDemo = media && media.demo === 'ai';
    const hasApiDemo = media && media.demo === 'api';
    const liveUrl = (media && media.liveUrl) || word.cta || 'index.html#projects';
    const liveLabel =
      (media && media.liveLabel) ||
      (liveUrl.startsWith('http') ? '在线体验' : '查看架构说明');

    document.title = `体验 · ${word.text} | 海立婷`;

    root.innerHTML = `
      <header class="skill-detail-header">
        <a href="skill.html?slug=${encodeURIComponent(slug)}" class="skill-detail-back">← 返回技能说明</a>
        <h1>${escapeHtml(headline)}</h1>
        <span class="skill-detail-badge" style="border-color:${ecoColor};color:${ecoColor}">${ecoLabel(eco)}</span>
      </header>
      <p class="skill-detail-text">${escapeHtml(word.positioning)}</p>
      ${hasVideo ? renderVideoBlock(media, eco) : ''}
      ${hasAiDemo ? renderAiDemo() : ''}
      ${hasApiDemo ? renderApiDemo() : ''}
      ${!hasVideo && !hasAiDemo && !hasApiDemo ? `
        <section class="exp-fallback-section">
          <p class="skill-evidence-label">体验说明</p>
          <p class="exp-intro">该技能暂无录屏，请通过下方「相关作品」链接在线体验，或查看首页项目列表。</p>
        </section>` : ''}
      ${renderProjects(word, eco)}
      <div class="skill-detail-actions exp-actions">
        <a class="btn btn-primary" href="${escapeHtml(liveUrl)}" ${liveUrl.startsWith('http') ? 'target="_blank" rel="noopener"' : ''}>${escapeHtml(liveLabel)}</a>
        <a class="btn btn-outline" href="index.html#projects">全部代表项目</a>
        <a class="btn btn-outline" href="skill.html?slug=${encodeURIComponent(slug)}">技能详情</a>
      </div>`;

    if (hasVideo) bindVideoTabs(media);
    if (hasAiDemo && typeof window.initAiAbout === 'function') {
      window.initAiAbout();
    }
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', initExperiencePage);
  } else {
    initExperiencePage();
  }
})();
