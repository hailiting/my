/** 技能详情页 — 路由：skill.html?slug=flutter */
function initSkillPage() {
  const root = document.getElementById('skillDetailRoot');
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
        <p>未找到该技能页面。</p>
        <a class="btn btn-primary" href="index.html#skill-map">返回技术全景图</a>
      </div>`;
    document.title = '技能未找到 | 海立婷';
    return;
  }

  document.title = `${word.text} | 海立婷`;
  const eco = window.ECO_COLORS[word.eco] || '#38bdf8';

  const projectsHtml =
    word.projects.length === 0
      ? '<p class="skill-evidence-empty">更多说明见首页「个人优势」与 AI 协作章节。</p>'
      : word.projects
          .map(
            (p) => `
        <article class="skill-evidence-project">
          <h4>${p.name}</h4>
          <p>${p.summary}</p>
          <p class="skill-evidence-metric" style="color:${eco}">${p.metric}</p>
          ${p.url ? `<a href="${p.url}" target="_blank" rel="noopener">在线体验 →</a>` : ''}
        </article>`
          )
          .join('');

  const portfolioExtra =
    word.showPortfolio && !word.projects.some((p) => p.name.includes('作品集'))
      ? `<article class="skill-evidence-project">
          <h4>本作品集站点</h4>
          <p>可交互技术标签墙 + 技能证据路由页，Flutter 终极版见 portfolio_app。</p>
          <p class="skill-evidence-metric" style="color:${eco}">Flutter Web · 现场演示</p>
        </article>`
      : '';

  root.innerHTML = `
    <header class="skill-detail-header">
      <a href="index.html#skill-map" class="skill-detail-back">← 返回技术全景图</a>
      <h1>${word.title}</h1>
      <span class="skill-detail-badge" style="border-color:${eco};color:${eco}">${ecoLabel(word.eco)}</span>
    </header>
    <p class="skill-evidence-label">我的定位</p>
    <p class="skill-detail-text">${word.positioning}</p>
    ${word.projects.length || portfolioExtra ? '<p class="skill-evidence-label">核心项目</p>' : ''}
    ${projectsHtml}${portfolioExtra}
    <p class="skill-evidence-label">技术深度</p>
    <ul class="skill-detail-list">${word.depth.map((d) => `<li>${d}</li>`).join('')}</ul>
    <div class="skill-detail-actions">
      <a class="btn btn-primary" href="experience.html?slug=${encodeURIComponent(slug)}">进入体验 · 观看演示</a>
      <a class="btn btn-outline" href="${word.cta}">查看作品列表</a>
      ${word.eco === 'ai' ? '<a class="btn btn-outline" href="ai.html">进入 AI 交流</a><a class="btn btn-outline" href="architecture.html">架构说明</a>' : ''}
    </div>`;
}

function ecoLabel(eco) {
  const map = {
    flutter: '跨端 · Flutter', ai: 'AI 研发', web: 'Web 前端',
    chain: '区块链', tool: '工程 / 工具', soft: '综合素养',
  };
  return map[eco] || eco;
}

document.addEventListener('DOMContentLoaded', initSkillPage);
