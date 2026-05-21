/**
 * 作品体验页 — 录屏与在线体验映射（按技能 slug）
 */
window.EXPERIENCE_ALIAS = {
  flutter: 'faypay',
  dart: 'faypay',
  'ui-ux': 'faypay',
  'claude-code': 'ai-coding',
  'mcp-skills': 'ai-coding',
  langchain: 'ai-coding',
  'trae-cursor': 'ai-coding',
};

window.EXPERIENCE_MEDIA = {
  faypay: {
    headline: 'Faypay 多链钱包 · 操作录屏',
    intro: '以下为 App / 插件真实操作录屏，可切换标签观看不同能力点。',
    videos: [
      {
        id: 'swap',
        title: '多链 Swap',
        src: 'assets/video/faypay/20260512_swap.mp4',
        desc: '跨链资产兑换与 Swap 流程演示。',
      },
      {
        id: 'plugin',
        title: 'OpenWallet 插件',
        src: 'assets/video/faypay/20260512_插件.mp4',
        desc: '浏览器多链插件钱包交互录屏。',
      },
      {
        id: 'core',
        title: '钱包核心流程',
        src: 'assets/video/faypay/840015421b3e792183f8a823d14c3dd4.mp4',
        desc: 'Mint / Send / Receive 等核心能力操作演示。',
      },
    ],
    liveUrl: 'https://faypay.com/',
    liveLabel: '打开 faypay.com 亲自体验',
  },
  'chrome-extension': {
    headline: 'OpenWallet 浏览器插件',
    intro: '多链插件钱包（Solana / EVM / BTC）操作录屏。',
    videos: [
      {
        id: 'plugin',
        title: '插件操作演示',
        src: 'assets/video/faypay/20260512_插件.mp4',
        desc: '插件内签名、切换链与支付流程。',
      },
    ],
    liveUrl: 'https://faypay.com/',
    liveLabel: '配合 Faypay 生态体验',
  },
  'ai-coding': {
    headline: 'AI 智能介绍',
    intro: '在独立 AI 交流页输入关键词，由 DeepSeek（Vercel Python 代理）实时生成介绍。',
    liveUrl: 'ai.html',
    liveLabel: '进入 AI 交流页',
  },
  'python-api': {
    headline: 'Python API · 接口体验',
    intro: '本站后端为 Vercel Serverless；可在浏览器控制台或下方说明体验统计接口。',
    demo: 'api',
    liveUrl: 'architecture.html',
    liveLabel: '查看后端架构',
  },
};

window.getExperienceMedia = function (slug) {
  const key = window.EXPERIENCE_ALIAS[slug] || slug;
  return window.EXPERIENCE_MEDIA[key] || null;
};
