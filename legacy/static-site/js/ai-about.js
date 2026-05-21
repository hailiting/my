/**
 * AI 生成式「关于我」— DeepSeek（经 /api/ai-about 代理）或本地模板回退
 */
(function () {
  const PROXY = window.AI_PROXY_URL || '/api/ai-about';

  const LOCAL = {
    区块链: '海立婷在区块链领域有 3+ 年实战经验，精通 Solidity 与多链生态，主导 OpenWallet 插件与 DeFi 产品从零上线；代表作 Faypay 多链钱包 App 一人开发，可将链上交互转化为稳定可维护的前端体验。',
    web3: '海立婷在区块链领域有 3+ 年实战经验，精通 Solidity 与多链生态，主导 OpenWallet 插件与 DeFi 产品从零上线；代表作 Faypay 多链钱包 App 一人开发，可将链上交互转化为稳定可维护的前端体验。',
    flutter: '海立婷拥有 4 年 React Native / Flutter 跨端经验，独立完成 Faypay 钱包 App；精通跨端工程化、状态管理与复杂交互，可将产品需求稳定落地为可维护的客户端体验。',
    ai: '海立婷将 Cursor、Trae 与大模型深度融入研发全流程。本站 AI 介绍模块即 DeepSeek 实时生成，展示 Prompt 约束、服务端代理与可回退的产品化集成思路。',
    性能: '海立婷注重前端工程化与性能：Webpack 打包提速 30%、首屏缓存与 Flutter Web 构建优化，能在业务迭代中持续验证加载体验。',
    架构: '海立婷注重前端架构与工程化：模块化分层、可预测状态、声明式路由与可测试边界，能在复杂业务中长期保持交付速度与代码质量。',
  };

  function localFallback(keyword) {
    const k = keyword.toLowerCase();
    for (const [key, text] of Object.entries(LOCAL)) {
      if (k.includes(key)) return text;
    }
    return `海立婷，11 年前端工程师，专注 Web3、跨端与 AI 辅助开发。针对「${keyword}」具备对应项目实践，欢迎通过本站联系获取完整履历。`;
  }

  async function generate(keyword) {
    const res = await fetch(PROXY, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ keyword }),
    });

    if (res.status === 503) {
      return { text: localFallback(keyword), meta: '未配置 API Key · 本地模板', source: 'fallback' };
    }

    if (!res.ok) {
      const err = await res.json().catch(() => ({}));
      throw new Error(err.error || `请求失败 ${res.status}`);
    }

    const data = await res.json();
    const tokens = data.usage?.total_tokens;
    const meta = [
      'DeepSeek 实时生成',
      data.model,
      tokens != null ? `约 ${tokens} tokens` : null,
    ]
      .filter(Boolean)
      .join(' · ');

    return { text: data.text, meta, source: 'deepseek' };
  }

  function initAiAbout() {
    const input = document.getElementById('aiAboutInput');
    const btn = document.getElementById('aiAboutSend');
    const out = document.getElementById('aiAboutOutput');
    const meta = document.getElementById('aiAboutMeta');
    const chips = document.querySelectorAll('[data-ai-keyword]');
    if (!input || !out) return;

    let loading = false;

    async function run() {
      const kw = input.value.trim();
      if (!kw || loading) return;
      loading = true;
      btn?.setAttribute('disabled', 'true');
      out.textContent = 'DeepSeek 正在基于预设背景生成…';
      if (meta) meta.textContent = '';

      try {
        const result = await generate(kw);
        out.textContent = result.text;
        if (meta) meta.textContent = result.meta || '';
      } catch (e) {
        out.textContent = localFallback(kw);
        if (meta) meta.textContent = `网络异常 · 本地模板 · ${e.message}`;
      } finally {
        loading = false;
        btn?.removeAttribute('disabled');
      }
    }

    btn?.addEventListener('click', run);
    input.addEventListener('keydown', (e) => {
      if (e.key === 'Enter') run();
    });
    chips.forEach((chip) => {
      chip.addEventListener('click', () => {
        input.value = chip.getAttribute('data-ai-keyword') || '';
        run();
      });
    });
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', initAiAbout);
  } else {
    initAiAbout();
  }
})();
