/**
 * Vercel Serverless：代理 DeepSeek，API Key 仅存服务端。
 * 环境变量：DEEPSEEK_API_KEY
 */
const SYSTEM_CONTEXT = `你是资深技术招聘顾问。仅根据下列事实为访客生成「第三方视角」中文介绍，勿编造未提及经历。

【候选人】海立婷 · 前端开发工程师 · 11 年经验 · 期望杭州 · 25–30K
【代表作】Faypay 多链加密钱包 App — 一人独立完成含 App 内全部核心功能，faypay.com 可体验
【技术栈】Flutter/Dart 跨端 · React/RN/TS · Web3（Solidity、DeFi、多链）· Chrome 插件 OpenWallet · Node.js · AI 辅助开发（Cursor/Trae）· 性能优化
【代表项目】PPToken · Kaco DeFi · Bingo 链游 · ZG 交易所 · Zytron · 本作品集（Flutter Web + AI 模块）
【工程体系】Riverpod · go_router · Feature-first
【输出】针对关键词；200–350 字；专业可验证；勿列表堆砌`;

const MAX_OUTPUT_TOKENS = 1200;

module.exports = async function handler(req, res) {
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'POST, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type');

  if (req.method === 'OPTIONS') {
    return res.status(204).end();
  }

  if (req.method !== 'POST') {
    return res.status(405).json({ error: 'Method not allowed' });
  }

  const apiKey = process.env.DEEPSEEK_API_KEY;
  if (!apiKey) {
    return res.status(503).json({
      error: 'DEEPSEEK_API_KEY not configured',
      hint: 'Set DEEPSEEK_API_KEY in Vercel project settings',
    });
  }

  let body = req.body;
  if (typeof body === 'string') {
    try {
      body = JSON.parse(body);
    } catch {
      return res.status(400).json({ error: 'Invalid JSON body' });
    }
  }

  const keyword = (body?.keyword || '').trim();
  if (!keyword) {
    return res.status(400).json({ error: 'keyword is required' });
  }
  if (keyword.length > 48) {
    return res.status(400).json({ error: 'keyword too long (max 48)' });
  }

  try {
    const upstream = await fetch('https://api.deepseek.com/chat/completions', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        Authorization: `Bearer ${apiKey}`,
      },
      body: JSON.stringify({
        model: 'deepseek-chat',
        messages: [
          { role: 'system', content: SYSTEM_CONTEXT },
          {
            role: 'user',
            content: `访客输入关键词：「${keyword}」。请生成针对性个人介绍。`,
          },
        ],
        max_tokens: MAX_OUTPUT_TOKENS,
        temperature: 0.65,
        stream: false,
      }),
    });

    const data = await upstream.json();

    if (!upstream.ok) {
      const msg = data?.error?.message || data?.message || 'DeepSeek API error';
      return res.status(upstream.status).json({ error: msg });
    }

    const text = data?.choices?.[0]?.message?.content?.trim() || '';
    if (!text) {
      return res.status(502).json({ error: 'Empty response from DeepSeek' });
    }

    return res.status(200).json({
      text,
      model: data.model,
      usage: data.usage,
      source: 'deepseek',
    });
  } catch (e) {
    console.error('ai-about', e);
    return res.status(500).json({ error: e.message || 'Internal error' });
  }
};
