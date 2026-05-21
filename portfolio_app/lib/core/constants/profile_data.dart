class ProfileData {
  static const name = '海立婷';
  static const title = '前端开发工程师';
  static const experience = '11 年';
  static const city = '杭州';
  static const salary = '25–30K';
  static const phone = '17767266371';
  static const email = 'hailiting@yeah.net';
  static const github = 'https://github.com';
  /// 旧版 PageDrop 静态站（已归档，见仓库 legacy/static-site/）
  static const legacySite = 'https://pagedrop.dev/s/hailiting';

  static const heroTagline =
      '3 秒看懂我的技术广度：点击下方「技术标签墙」任意关键词，'
      '即可查看对应实战作品与深度说明。代表作 Faypay 多链钱包 App（一人开发）。';

  static const skillCloudIntro =
      '下面这些是我日常开发中高频使用的技术与领域。'
      '点击任意关键词，可快速查看相关实战作品与详细解读。';

  static const skillCloudHint =
      '小提示：词越大，代表我在该领域的经验越深入；颜色相同的词属于同一技术生态。';

  static const aiDevDeclaration = '''
【声明】本项目全程使用 AI 辅助开发构建，无传统「纯手工从零敲代码」模式。

主要工具链：
• Cursor — 主力 IDE，负责架构设计、多文件重构与 Agent 式迭代
• Trae · SOLO Coder 2 — 端到端任务驱动，适合独立模块从 0 到 1 的快速交付
• GitHub Copilot — 行级补全、样板代码与单元测试草稿

AI 参与环节：需求分析 → 技术选型 → 编码实现 → 测试用例 → 重构优化 → 文档撰写
''';

  static const aiPromptTips = '''
Prompt 工程与 AI 协作心得：

1. 先约束，再生成
   开场写清：角色（资深 Flutter 工程师）、技术栈（Riverpod + go_router）、
   验收标准（可运行、无 lint 报错、响应式布局），再让 AI 输出代码。

2. 三段式 Prompt 模板
   「背景 + 目标」→「约束与边界（不要改哪些文件）」→「期望输出格式（完整文件 / diff）」

3. 大任务切片
   按 feature 拆分（路由 / 雷达图 / 实验室），每步可独立 `flutter analyze` 通过后再合并。

4. 人机分工
   架构决策、安全边界、业务取舍 — 人；样板代码、样式微调、测试草稿 — AI。

5. Review 检查清单
   每次采纳 AI 代码前：依赖是否必要、是否有硬编码密钥、动画/布局在窄屏是否可用。

6. SOLO Coder 2 使用场景
   适合「给我一个 XX 页面」类完整交付；Cursor 适合「在现有项目上改 XX」类精准迭代。
''';

  /// 兼容旧引用
  static const aiDevStatement = '$aiDevDeclaration\n$aiPromptTips';

  /// DeepSeek 系统背景（控制单次请求总 token 在 1 万以内）
  static const aiSystemContext = '''
你是资深技术招聘顾问。仅根据下列事实为访客生成「第三方视角」中文介绍，勿编造未提及经历。

【候选人】海立婷 · 前端开发工程师 · 11 年经验 · 期望杭州 · 25–30K
【代表作】Faypay 多链加密钱包 App — 一人独立完成含 App 内全部核心功能（Mint/Send/Receive/多链资产/安全交易），非仅官网；faypay.com 可体验
【技术栈】Flutter/Dart 跨端 · React/RN/TS · Web3（Solidity、DeFi、Ethers.js、多链）· Chrome 钱包插件 OpenWallet · Node.js · AI 辅助开发（Cursor/Trae/全流程）· 性能优化（Webpack/首屏）
【代表项目】PPToken 多链钱包 · Kaco DeFi(BSC) · Bingo 全链游 · ZG 交易所 · Zytron · 本作品集站点（Flutter Web + AI 模块）
【工程体系】Riverpod · go_router · Feature-first 架构
【输出要求】针对用户关键词突出匹配能力；200–350 字；语气专业、可验证、可说服技术负责人；不要列表堆砌；结尾可一句邀请联系
''';

  static const aiAboutMaxOutputTokens = 1200;

  static const radarDimensions = [
    '前端工程',
    '跨端开发',
    '区块链',
    'AI 应用',
    '产品思维',
  ];

  static const baseRadarScores = [0.92, 0.88, 0.85, 0.90, 0.82];

  /// 可视化技能导航器词库：字号 = 熟练度权重，颜色 = 技术生态。
  static const skillWords = [
    SkillWord(
      slug: 'flutter',
      text: 'Flutter',
      size: 40,
      ecosystem: SkillEcosystem.flutter,
      positioning:
          '不仅将 Flutter 用于移动端，更致力于 Web / 桌面等跨端场景，'
          '追求一套代码、一致体验的高性能交付。',
      depthPoints: [
        '响应式布局与自适应组件体系',
        'CustomPaint / 动画流与复杂交互',
        'Riverpod / Bloc 状态管理与模块化路由',
        '与原生平台能力桥接（插件、通道）',
      ],
      projectIndices: [0, 1],
      projectsRoute: '/projects',
      aboutRoute: '/about',
      sheetTitle: '🎯 Flutter 跨端开发',
    ),
    SkillWord(
      slug: 'dart',
      text: 'Dart',
      size: 30,
      ecosystem: SkillEcosystem.flutter,
      positioning: 'Flutter 生态核心语言，用于钱包 App、跨端组件库与本站 Flutter Web 工程化实践。',
      depthPoints: ['空安全与异步模型', 'Isolate / 性能敏感模块拆分'],
      projectIndices: [0, 1],
      projectsRoute: '/projects',
      sheetTitle: 'Dart · 跨端语言',
    ),
    SkillWord(
      slug: 'ai-coding',
      text: 'AI 编程',
      size: 35,
      ecosystem: SkillEcosystem.ai,
      positioning:
          '将大模型与 IDE Agent 深度融入需求分析、编码、测试与重构，'
          '用可验收的 Prompt 约束驱动高质量交付。',
      depthPoints: [
        'Cursor Agent 多文件重构与架构迭代',
        'Trae / SOLO Coder 端到端模块交付',
        '人机分工：架构与安全边界由人把关',
      ],
      projectIndices: [],
      projectsRoute: '/lab',
      aboutRoute: '/about',
      sheetTitle: '🤖 AI 辅助研发',
    ),
    SkillWord(
      slug: 'trae-cursor',
      text: 'Trae / Cursor',
      size: 25,
      ecosystem: SkillEcosystem.ai,
      positioning: '主力 AI 工具链：Cursor 负责在既有项目上精准迭代；Trae 适合从 0 到 1 的完整页面交付。',
      depthPoints: ['三段式 Prompt：背景 → 约束 → 输出格式', '每步 flutter analyze 通过再合并'],
      projectIndices: [],
      projectsRoute: '/lab',
      aboutRoute: '/about',
      sheetTitle: 'Trae · Cursor 工具链',
    ),
    SkillWord(
      slug: 'react',
      text: 'React',
      size: 28,
      ecosystem: SkillEcosystem.web,
      positioning: '8 年 React 大型项目经验，擅长组件化、链游逻辑层与交易所级复杂业务前端。',
      depthPoints: ['Hooks / 状态分层', 'Ethers.js 链上交互封装', '多端同构（Web / H5 / TG）'],
      projectIndices: [4, 5, 6],
      projectsRoute: '/projects',
      sheetTitle: '⚛️ React 前端工程',
    ),
    SkillWord(
      slug: 'typescript',
      text: 'TypeScript',
      size: 26,
      ecosystem: SkillEcosystem.web,
      positioning: '类型安全驱动的大型 Web3 / 金融前端，降低链上交互与多模块协作的维护成本。',
      depthPoints: ['严格类型边界与 API 契约', '与构建工具链协同的类型检查'],
      projectIndices: [4, 6],
      projectsRoute: '/projects',
      sheetTitle: 'TypeScript',
    ),
    SkillWord(
      slug: 'solidity',
      text: 'Solidity',
      size: 32,
      ecosystem: SkillEcosystem.blockchain,
      positioning: '3+ 年智能合约与 DeFi 实战，能从合约设计理解前端 DApp 交互与安全边界。',
      depthPoints: ['Farm / Pool / NFT 碎片化', 'KYC 与隐私模块协作', 'BSC / EVM 生态部署经验'],
      projectIndices: [3],
      projectsRoute: '/projects',
      sheetTitle: '⛓️ Solidity · 智能合约',
    ),
    SkillWord(
      slug: 'ethers-js',
      text: 'Ethers.js',
      size: 22,
      ecosystem: SkillEcosystem.blockchain,
      positioning: '链游与钱包场景的标准交互层，保证链上状态与 UI 一致、可观测。',
      depthPoints: ['合约事件订阅与错误恢复', '多链 RPC 抽象'],
      projectIndices: [4, 2],
      projectsRoute: '/projects',
      sheetTitle: 'Ethers.js · Web3 交互',
    ),
    SkillWord(
      slug: 'chrome-extension',
      text: 'Chrome 插件',
      size: 24,
      ecosystem: SkillEcosystem.tooling,
      positioning: '主导多链浏览器钱包插件 OpenWallet，覆盖 Solana / EVM / BTC 生态。',
      depthPoints: ['插件沙箱与安全存储', '统一账户模型与签名流程'],
      projectIndices: [2],
      projectsRoute: '/projects',
      sheetTitle: '🔌 浏览器钱包插件',
    ),
    SkillWord(
      slug: 'nodejs',
      text: 'Node.js',
      size: 26,
      ecosystem: SkillEcosystem.tooling,
      positioning: 'Web3 项目自主后端与 BFF 层，支撑 DApp 快速迭代与接口缓存优化。',
      depthPoints: ['Express / Koa 服务搭建', '接口聚合与缓存策略'],
      projectIndices: [5],
      projectsRoute: '/projects',
      sheetTitle: 'Node.js 全栈支撑',
    ),
    SkillWord(
      slug: 'ui-ux',
      text: 'UI / UX',
      size: 20,
      ecosystem: SkillEcosystem.soft,
      positioning: '与设计协作落地 TVL 分析、钱包与 DeFi 产品的可读性与转化路径优化。',
      depthPoints: ['信息层级与加载态设计', 'C 端钱包动线打磨'],
      projectIndices: [6, 0],
      projectsRoute: '/projects',
      aboutRoute: '/about',
      sheetTitle: 'UI / UX 协作',
    ),
    SkillWord(
      slug: 'performance',
      text: '性能优化',
      size: 22,
      ecosystem: SkillEcosystem.soft,
      positioning: 'Webpack 打包提速、首屏缓存与 Flutter Web 构建优化，用数据验证加载体验。',
      depthPoints: ['打包体积 -20% / 构建提速 30% 实战经验', 'Lighthouse 导向的首屏策略'],
      projectIndices: [6, 5],
      projectsRoute: '/projects',
      sheetTitle: '⚡ 性能优化',
    ),
    SkillWord(
      slug: 'architecture',
      text: '架构设计',
      size: 28,
      ecosystem: SkillEcosystem.architecture,
      route: '/architecture',
      positioning:
          '以可预测状态流、声明式路由与 Feature-first 分层架构组织代码，'
          '让工程体系本身成为可审查的作品。',
      depthPoints: [
        'Riverpod：Provider 组合、派生状态与 UI 解耦',
        'go_router：ShellRoute、路径参数与深度链接',
        'core / features / widgets 清晰边界，数据与展示分离',
      ],
      projectIndices: [],
      projectsRoute: '/projects',
      aboutRoute: '/about',
      sheetTitle: '🏗️ 架构设计 · 现代化工程体系',
    ),
    SkillWord(
      slug: 'faypay',
      text: 'Faypay',
      size: 36,
      ecosystem: SkillEcosystem.flutter,
      positioning: '一人独立完成的多链加密钱包 App（含应用内全部核心功能），可直接下载体验。',
      depthPoints: ['Mint / Send / Receive / Request 全链路', 'Openverse / ETH / BNB / Polygon 多链资产'],
      projectIndices: [0],
      projectsRoute: '/projects',
      sheetTitle: '👛 Faypay · 代表作',
    ),
  ];

  static List<ProjectItem> projectsForSkill(SkillWord word) {
    return [
      for (final i in word.projectIndices)
        if (i >= 0 && i < projects.length) projects[i],
    ];
  }

  static SkillWord? skillBySlug(String slug) {
    for (final w in skillWords) {
      if (w.slug == slug) return w;
    }
    return null;
  }

  static const architectureTitle = '架构设计 · 现代化工程体系';
  static const architectureSubtitle =
      '状态可预测、路由可声明、边界可划分——本作品集站的 Flutter 工程即按此标准搭建，代码结构即能力证明。';

  static const architectureClosing =
      '招聘方可直接审查 portfolio_app 目录：从 router、Riverpod Provider 到 features 分包，'
      '每一层职责清晰，便于协作、测试与长期演进。';

  static const architectureSections = [
    ArchitectureSection(
      title: '状态管理 · Riverpod',
      subtitle: '可预测的单向数据流，UI 只订阅状态',
      body:
          '本站使用 flutter_riverpod 管理主题、路由与技能雷达权重等全局/局部状态。'
          '相比 setState 散落各处，Provider 让依赖关系显式、可测试、可组合。',
      bullets: [
        'StateProvider：轻量 UI 状态（如雷达权重 slider）',
        'Provider：GoRouter 等无状态依赖注入',
        'ref.watch / ref.read 区分重建与一次性读取',
        '与 Feature 模块解耦：状态定义靠近领域，消费在 Widget',
      ],
      codeSample: '''
// lib/features/skills/skills_page.dart
final radarWeightsProvider = StateProvider<List<double>>((ref) {
  return List.filled(ProfileData.radarDimensions.length, 1.0);
});

// 消费方
final weights = ref.watch(radarWeightsProvider);
ref.read(radarWeightsProvider.notifier).state = next;
''',
    ),
    ArchitectureSection(
      title: '路由 · go_router',
      subtitle: '声明式路由表 + 深度链接',
      body:
          'go_router 统一管理站内路径，支持 Shell 布局（侧栏/底栏常驻）、'
          '路径参数与浏览器地址栏同步，便于分享与 SEO。',
      bullets: [
        'ShellRoute：AppShell 包裹各业务页，导航栏不重复构建',
        'GoRoute(path: \'/skill/:slug\')：技能证据深度链接',
        'GoRoute(path: \'/architecture\')：本架构说明页',
        'initialLocation + navigatorKey：可编程导航与 Web 回退',
      ],
      codeSample: '''
// lib/router/app_router.dart
GoRoute(path: '/skill/:slug', builder: (_, state) {
  return SkillDetailPage(slug: state.pathParameters['slug']!);
}),
GoRoute(path: '/architecture', builder: (_, __) => const ArchitecturePage()),
''',
    ),
    ArchitectureSection(
      title: '代码架构 · Feature-first / Clean 思想',
      subtitle: '分层清晰，代码即作品',
      body:
          '采用 Feature-first + 轻量 Clean 边界：领域数据在 core，'
          '业务能力在 features，可复用 UI 在 widgets。避免「大杂烩 lib/」难以维护。',
      bullets: [
        'core/constants：ProfileData 等领域数据，单一数据源',
        'core/theme：主题与 ThemeMode Provider',
        'features/*：按业务垂直切分（home / skills / projects / architecture）',
        'widgets/*：跨 Feature 的展示组件（词云、雷达图、项目卡片）',
        'router/：路由与 Shell 解耦，新增页面只改一处',
      ],
      codeSample: '''
portfolio_app/lib/
├── core/           # 常量、主题、通用能力
├── features/       # 业务模块（垂直切片）
│   ├── home/
│   ├── skills/
│   ├── architecture/   ← 本页
│   └── projects/
├── widgets/        # 共享 UI
├── router/         # go_router 配置
└── app.dart        # MaterialApp.router + ProviderScope
''',
    ),
    ArchitectureSection(
      title: '工程化实践',
      subtitle: '可构建、可部署、可演进',
      body: '除架构分层外，配套主题自适应、Web 构建与 CI 部署流水线，保证交付闭环。',
      bullets: [
        'flutter analyze 作为合并前质量门禁',
        'GitHub Actions：portfolio_app 变更自动 build web',
        'Vercel / PageDrop：静态站 + Flutter Web 双轨部署',
        'AI 辅助开发在架构约束下迭代，人不放权安全与边界',
      ],
    ),
  ];

  static const faypayUrl = 'https://faypay.com/';

  static const projects = [
    ProjectItem(
      category: '多链钱包 App · 代表作',
      name: 'Faypay Crypto Wallet',
      stack: ['钱包 App', '移动端', '多链', 'Openverse', 'Ethereum', 'BNB', 'Polygon'],
      summary:
          '独立完成 Faypay 加密钱包全套产品——含 App 内核心功能（非仅官网展示页）。'
          '一人负责 Mint / Send / Receive / Request、多链资产管理、交易与安全体验；'
          '覆盖 Openverse、Ethereum、BNB Chain、Polygon 等；配套 faypay.com 下载与产品展示。',
      metric: '一人开发 · App + Web 已上线',
      highlight: '跨端',
      liveUrl: faypayUrl,
      soloDev: true,
    ),
    ProjectItem(
      category: 'Flutter 跨端',
      name: 'PPToken 多链钱包',
      stack: ['Flutter', '多链', 'NFT', 'DApp'],
      summary: '助记词体系、多链余额/NFT、Uniswap/Pancake 等 DApp 交互。',
      metric: '2020–2022 · 钱包全链路',
      highlight: '跨端',
    ),
    ProjectItem(
      category: '浏览器插件',
      name: 'OpenWallet 多链插件',
      stack: ['插件', 'Solana', 'EVM', 'BTC'],
      summary: '多链浏览器钱包插件，稳定支持 OpenWallet 生态。',
      metric: '学神科技 · 主导上线',
      highlight: '区块链',
    ),
    ProjectItem(
      category: '区块链 DApp',
      name: 'Kaco DeFi · BSC',
      stack: ['Solidity', 'DeFi', 'NFT', 'KYC'],
      summary: '智能合约、Farm/Pool、NFT 碎片化与隐私/KYC 模块。',
      metric: '2022–2025 · BSC 链',
      highlight: '区块链',
    ),
    ProjectItem(
      category: '区块链游戏',
      name: 'Bingo 全链游',
      stack: ['React', 'Ethers.js', 'Telegram'],
      summary: 'Web/H5/TG 机器人多端，Ethereum 合约与链上透明交互。',
      metric: '全平台接入',
      highlight: '跨端',
    ),
    ProjectItem(
      category: 'Web 全栈',
      name: 'ZG 交易所 & 官网',
      stack: ['React Native', '交易', '行情', '冷钱包'],
      summary: '现货/期货/期权/永续、资产管理与多维行情分析。',
      metric: '2016–2020 · RN',
      highlight: '前端工程',
    ),
    ProjectItem(
      category: 'Web 全栈',
      name: 'Zytron 平台',
      stack: ['React', 'TVL', '性能优化'],
      summary: 'TVL 分析、页面性能优化，与设计团队协作 UX。',
      metric: '加载速度显著提升',
      highlight: '产品思维',
    ),
  ];

  static const experiences = [
    Experience(
      company: '浙江学神科技有限公司',
      role: '前端开发工程师',
      period: '2025.03 — 至今',
      bullets: [
        '多链插件 OpenWallet：Solana / EVM / BTC',
        'Flutter 多链应用：TRON / TON 等生态',
        'DeFi 新产品 · IM 客户端维护',
      ],
    ),
    Experience(
      company: '杭州创璞科技有限公司',
      role: '大前端',
      period: '2024.01 — 2025.03',
      bullets: [
        'Bingo 全链游 · Cocos 游戏系列',
        'Zytron TVL 与性能优化',
      ],
    ),
    Experience(
      company: '杭州对位网络技术有限公司',
      role: '前端开发工程师',
      period: '2021.11 — 2023.12',
      bullets: [
        'Web3 架构从零到一 · Node.js 后端',
        'DApp 体验与视觉优化',
      ],
    ),
    Experience(
      company: '杭州云创想网络科技有限公司',
      role: '前端开发工程师',
      period: '2018.11 — 2021.10',
      bullets: [
        'Webpack 打包提速 30%、体积减 20%',
        'RN → Flutter 迁移 · Electron 桌面端',
      ],
    ),
  ];

  static String aiAboutForKeyword(String keyword) {
    final k = keyword.toLowerCase();
    if (k.contains('faypay') || k.contains('钱包')) {
      return '海立婷独立完成 Faypay 多链加密钱包 App（含应用内全部核心功能），'
          '从资产收发、多链管理到安全交易流程均由一人交付；'
          '可在 faypay.com 下载体验，是最能证明实战能力的线上代表作。';
    }
    if (k.contains('区块链') || k.contains('web3') || k.contains('defi')) {
      return '海立婷在区块链领域有 3+ 年实战经验，精通 Solidity 与 Solana 生态，'
          '主导多链钱包插件与 DeFi 产品从零上线；代表作 Faypay 已服务百万级用户场景。'
          '她能将链上交互转化为稳定、可维护的前端体验，是 Web3 团队即战力。';
    }
    if (k.contains('flutter') || k.contains('跨端') || k.contains('移动')) {
      return '海立婷拥有 4 年 React Native / Flutter 跨端经验，'
          '本网站即采用 Flutter Web 构建，证明其跨端工程化与产品交付能力。'
          '从 App 到 Web，一套技术栈覆盖多端场景。';
    }
    if (k.contains('ai') || k.contains('cursor') || k.contains('大模型')) {
      return '海立婷将 Cursor、Trae 与大模型深度融入研发全流程，'
          '在需求分析、编码、测试与重构中驱动效能提升。'
          '本站的 AI 介绍、项目解说与实验室模块，即是其实战能力的现场演示。';
    }
    if (k.contains('性能') || k.contains('工程')) {
      return '海立婷注重前端工程化与性能：Webpack 优化、首屏缓存、'
          'Lighthouse 导向的 Flutter Web 构建。她能在业务迭代中持续压榨加载速度与包体积。';
    }
    return '海立婷，11 年前端工程师，专注 Web3、跨端与 AI 辅助开发。'
        '期望杭州 · 25–30K。欢迎通过本站联系，获取完整履历与代码样例。';
  }

  static String aiNarrateProject(String projectName) {
    switch (projectName) {
      case 'Faypay Crypto Wallet':
        return '技术难点：钱包 App 内多链账户体系、签名与交易链路、资产页与收发流程的一体化 UX。\n'
            '交付范围：移动端钱包 App 核心功能 + faypay.com 产品站（下载、介绍、多链说明），一人全栈完成。\n'
            '设计思路：C 端钱包为主——快速、安全、易用的 Mint / Send / Receive / Request。\n'
            '业务价值：商业级多链钱包已上线，支持 Openverse / ETH / BNB / Polygon 等，可直接下载体验。\n'
            '🔗 https://faypay.com/';
      case 'OpenWallet 多链插件':
        return '技术难点：多链 RPC 抽象、签名流程与安全沙箱。'
            '设计思路：插件化架构 + 统一账户模型。'
            '业务价值：降低用户跨链操作门槛，提升转化。';
      case 'Bingo 全链游':
        return '技术难点：合约状态机 + 多端一致 UI。'
            '通过 Ethers.js 保证链上透明，Telegram 机器人扩展获客。';
      case 'Kaco DeFi · BSC':
        return '涵盖 Farm/Pool、NFT 碎片化与 KYC，体现全栈 DeFi 交付能力。';
      default:
        return '该项目展示了从需求到上线的完整前端交付能力，'
            '含性能优化、可维护架构与业务指标达成。';
    }
  }
}

enum SkillEcosystem {
  flutter('跨端 · Flutter'),
  ai('AI 研发'),
  web('Web 前端'),
  blockchain('区块链'),
  architecture('工程架构'),
  tooling('工程 / 工具'),
  soft('综合素养');

  const SkillEcosystem(this.label);
  final String label;
}

class SkillWord {
  const SkillWord({
    required this.slug,
    required this.text,
    required this.size,
    required this.ecosystem,
    required this.positioning,
    required this.depthPoints,
    required this.projectIndices,
    this.projectsRoute = '/projects',
    this.aboutRoute,
    this.sheetTitle,
    this.route,
  });

  final String slug;
  final String text;
  final double size;
  final SkillEcosystem ecosystem;
  final String positioning;
  final List<String> depthPoints;
  final List<int> projectIndices;
  final String projectsRoute;
  final String? aboutRoute;
  final String? sheetTitle;
  /// 非空时词云/导航直达该路径（如架构设计页 `/architecture`）。
  final String? route;

  String get displayTitle => sheetTitle ?? text;
  String get navigateRoute => route ?? '/skill/$slug';
}

class ArchitectureSection {
  const ArchitectureSection({
    required this.title,
    required this.subtitle,
    required this.body,
    this.bullets = const [],
    this.codeSample,
  });

  final String title;
  final String subtitle;
  final String body;
  final List<String> bullets;
  final String? codeSample;
}

class ProjectItem {
  const ProjectItem({
    required this.category,
    required this.name,
    required this.stack,
    required this.summary,
    required this.metric,
    required this.highlight,
    this.liveUrl,
    this.soloDev = false,
  });
  final String category;
  final String name;
  final List<String> stack;
  final String summary;
  final String metric;
  final String highlight;
  final String? liveUrl;
  final bool soloDev;
}

class Experience {
  const Experience({
    required this.company,
    required this.role,
    required this.period,
    required this.bullets,
  });
  final String company;
  final String role;
  final String period;
  final List<String> bullets;
}

class LabChallenge {
  const LabChallenge(this.title, this.prompt, this.type);
  final String title;
  final String prompt;
  final String type;
}

extension LabChallenges on ProfileData {
  static final list = [
    LabChallenge(
      '波浪进度条',
      '生成一个带波浪动画的 Material 进度指示器',
      'wave',
    ),
    LabChallenge(
      '链上加载骨架',
      '实现 Web3 风格的脉冲加载占位组件',
      'skeleton',
    ),
    LabChallenge(
      '技能徽章',
      '用 CustomPaint 绘制六边形技能徽章',
      'hex',
    ),
  ];
}
