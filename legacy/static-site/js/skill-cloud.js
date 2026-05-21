/**
 * 居中圆形技能词云 — 移动端兼容（不依赖 fonts.ready / CSS 变量 transform）
 */
function initSkillCloud() {
  const mount = document.getElementById('skillCloudMount');
  if (!mount || !window.SKILL_WORDS || mount.dataset.ready === '1') return;

  const wrap = mount.closest('.skill-cloud-wrap');
  if (wrap) {
    wrap.style.opacity = '1';
    wrap.style.transform = 'none';
  }

  const words = window.SKILL_WORDS;
  const n = words.length;
  const reducedMotion = window.matchMedia('(prefers-reduced-motion: reduce)').matches;
  const links = [];
  const fallback = mount.querySelector('.skill-cloud-fallback');
  if (fallback) fallback.remove();

  words.forEach((word, index) => {
    const el = document.createElement('a');
    el.className = 'skill-cloud-word';
    el.href = word.page || `skill.html?slug=${encodeURIComponent(word.slug)}`;
    el.textContent = word.text;
    el.style.color = window.ECO_COLORS[word.eco] || '#38bdf8';
    el.dataset.index = String(index);
    el.setAttribute('aria-label', `查看 ${word.text} 技能详情`);
    mount.appendChild(el);
    links.push(el);
  });

  let driftStart = 0;
  let rafId = 0;

  function boxSize() {
    const rect = mount.getBoundingClientRect();
    if (rect.width > 0) return rect.width;
    const parent = mount.parentElement;
    if (parent) {
      const pw = parent.getBoundingClientRect().width;
      if (pw > 0) return Math.min(pw, 520);
    }
    return Math.min(window.innerWidth * 0.88, 340);
  }

  function fontScale(box) {
    if (box < 320) return 0.36;
    if (box < 400) return 0.42;
    return 0.5;
  }

  function layoutAll(t) {
    const box = boxSize();
    mount.style.width = `${box}px`;
    mount.style.height = `${box}px`;

    const radius = box * (box < 360 ? 0.3 : 0.34);
    const scale = fontScale(box);
    const wobble = reducedMotion ? 0 : box < 360 ? 3 : 5;

    links.forEach((el, i) => {
      const word = words[i];
      const angle = -Math.PI / 2 + (2 * Math.PI * i) / n;
      let dx = radius * Math.cos(angle);
      let dy = radius * Math.sin(angle);
      if (t != null && !reducedMotion) {
        dx += Math.sin(t * 0.9 + i) * wobble;
        dy += Math.cos(t * 0.7 + i * 0.5) * wobble * 0.7;
      }
      el.style.fontSize = `${word.size * scale}px`;
      el.style.left = `${box / 2 + dx}px`;
      el.style.top = `${box / 2 + dy}px`;
      el.style.transform = 'translate(-50%, -50%)';
    });
  }

  function markReady() {
    mount.dataset.ready = '1';
    mount.classList.add('is-ready');
    if (wrap) {
      wrap.style.opacity = '1';
      wrap.style.transform = 'none';
    }
  }

  let animStarted = false;

  function startLayout() {
    layoutAll(0);
    markReady();
    if (animStarted || reducedMotion) return;
    animStarted = true;
    driftStart = performance.now();
    cancelAnimationFrame(rafId);
    function frame(now) {
      layoutAll((now - driftStart) / 1000);
      rafId = requestAnimationFrame(frame);
    }
    rafId = requestAnimationFrame(frame);
  }

  if (typeof ResizeObserver !== 'undefined') {
    const ro = new ResizeObserver(() => {
      if (mount.dataset.ready === '1') layoutAll(0);
    });
    ro.observe(mount);
  }

  let resizeTimer;
  window.addEventListener('resize', () => {
    clearTimeout(resizeTimer);
    resizeTimer = setTimeout(() => layoutAll(0), 150);
  });
  window.addEventListener('orientationchange', () => {
    setTimeout(startLayout, 250);
  });

  /* 立即布局 + 延迟重试（字体/布局未就绪时） */
  startLayout();
  requestAnimationFrame(startLayout);
  setTimeout(startLayout, 100);
  setTimeout(startLayout, 400);
  window.addEventListener('load', startLayout);

  if (document.fonts && document.fonts.ready) {
    document.fonts.ready.then(startLayout).catch(startLayout);
  }
}

function bootSkillCloud() {
  try {
    initSkillCloud();
  } catch (err) {
    console.error('skill-cloud init failed', err);
    const mount = document.getElementById('skillCloudMount');
    const wrap = mount?.closest('.skill-cloud-wrap');
    if (wrap) wrap.classList.add('is-fallback');
    else if (mount) mount.classList.add('is-fallback');
  }
}

if (document.readyState === 'loading') {
  document.addEventListener('DOMContentLoaded', bootSkillCloud);
} else {
  bootSkillCloud();
}
