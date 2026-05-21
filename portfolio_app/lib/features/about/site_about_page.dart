import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio_app/core/constants/profile_data.dart';
import 'package:portfolio_app/core/theme/site_style.dart';
import 'package:portfolio_app/widgets/section_header.dart';

class SiteAboutPage extends StatelessWidget {
  const SiteAboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SitePageScroll(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
              const SectionHeader(
                number: '01',
                title: '关于本网站 · 技术宣言',
              ),
              _block(
                context,
                '技术栈选型',
                '本网站使用 Flutter for Web 构建，证明跨端工程能力。\n'
                '状态管理：flutter_riverpod\n'
                '路由：go_router 声明式路由\n'
                '架构：feature-first 分层，数据与 UI 分离',
              ),
              _block(context, 'AI 辅助开发声明', ProfileData.aiDevDeclaration),
              _block(context, 'Prompt 工程与协作心得', ProfileData.aiPromptTips),
              _block(
                context,
                '现代化工程体系',
                '• 状态管理：Riverpod 可预测状态流\n'
                '• 路由：go_router 声明式路由与深度链接\n'
                '• 架构：Feature-first 分层，代码即作品\n'
                '• 详见「架构设计」专页（词云可点击）',
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: OutlinedButton.icon(
                  onPressed: () => context.push('/architecture'),
                  icon: const Icon(Icons.architecture, size: 18),
                  label: const Text('打开架构设计页'),
                ),
              ),
              _block(
                context,
                '部署',
                '目标平台：Vercel / Firebase Hosting / PageDrop\n'
                '构建：flutter build web --release',
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Chip(
                    avatar: const Icon(Icons.check_circle, size: 16),
                    label: const Text('Build: passing'),
                  ),
                  const SizedBox(width: 8),
                  Chip(
                    avatar: const Icon(Icons.smart_toy, size: 16),
                    label: const Text('AI-Native UI'),
                  ),
                ],
              ),
        ],
      ),
    );
  }

  Widget _block(BuildContext context, String title, String body) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 10),
            Text(body, style: const TextStyle(height: 1.75)),
          ],
        ),
      ),
    );
  }
}
