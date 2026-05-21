import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio_app/core/constants/profile_data.dart';
import 'package:url_launcher/url_launcher.dart';

class SkillDetailPage extends StatelessWidget {
  const SkillDetailPage({super.key, required this.slug});

  final String slug;

  @override
  Widget build(BuildContext context) {
    final word = ProfileData.skillBySlug(slug);
    if (word == null) {
      return _NotFound(slug: slug);
    }

    final projects = ProfileData.projectsForSkill(word);
    final ecoColor = _ecosystemColor(word.ecosystem);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => context.canPop()
                        ? context.pop()
                        : context.go('/'),
                    icon: const Icon(Icons.arrow_back),
                    tooltip: '返回',
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      word.displayTitle,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  Chip(
                    label: Text(word.ecosystem.label),
                    backgroundColor: ecoColor.withOpacity(0.15),
                    side: BorderSide(color: ecoColor.withOpacity(0.4)),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _sectionLabel(context, '我的定位'),
              Text(
                word.positioning,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.65),
              ),
              if (projects.isNotEmpty ||
                  word.ecosystem == SkillEcosystem.flutter) ...[
                const SizedBox(height: 28),
                _sectionLabel(context, '核心项目'),
                ...projects.map(
                  (p) => _ProjectCard(project: p, accent: ecoColor),
                ),
                if (word.ecosystem == SkillEcosystem.flutter)
                  _PortfolioSiteCard(accent: ecoColor),
              ],
              if (word.depthPoints.isNotEmpty) ...[
                const SizedBox(height: 28),
                _sectionLabel(context, '技术深度'),
                ...word.depthPoints.map(
                  (d) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('· ', style: TextStyle(color: ecoColor, height: 1.5)),
                        Expanded(child: Text(d, style: const TextStyle(height: 1.5))),
                      ],
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 32),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  FilledButton(
                    onPressed: () => context.go(word.projectsRoute),
                    child: const Text('查看全部相关作品'),
                  ),
                  if (word.aboutRoute != null)
                    OutlinedButton(
                      onPressed: () => context.go(word.aboutRoute!),
                      child: const Text('了解方法论'),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Color _ecosystemColor(SkillEcosystem e) => switch (e) {
        SkillEcosystem.flutter => const Color(0xFF38BDF8),
        SkillEcosystem.ai => const Color(0xFFA78BFA),
        SkillEcosystem.web => const Color(0xFF22D3EE),
        SkillEcosystem.blockchain => const Color(0xFFFB923C),
        SkillEcosystem.architecture => const Color(0xFF818CF8),
        SkillEcosystem.tooling => const Color(0xFF4ADE80),
        SkillEcosystem.soft => const Color(0xFF94A3B8),
      };

  static Widget _sectionLabel(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}

class _NotFound extends StatelessWidget {
  const _NotFound({required this.slug});

  final String slug;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.search_off, size: 48),
            const SizedBox(height: 16),
            Text('未找到技能：$slug'),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => context.go('/'),
              child: const Text('返回首页'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProjectCard extends StatelessWidget {
  const _ProjectCard({required this.project, required this.accent});

  final ProjectItem project;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              project.name,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 8),
            Text(project.summary, style: const TextStyle(height: 1.55)),
            const SizedBox(height: 10),
            Text(
              project.metric,
              style: TextStyle(color: accent, fontWeight: FontWeight.w500),
            ),
            if (project.liveUrl != null) ...[
              const SizedBox(height: 8),
              TextButton.icon(
                onPressed: () => launchUrl(Uri.parse(project.liveUrl!)),
                icon: const Icon(Icons.open_in_new, size: 18),
                label: const Text('在线体验'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _PortfolioSiteCard extends StatelessWidget {
  const _PortfolioSiteCard({required this.accent});

  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '本作品集站点',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 8),
            const Text(
              '你现在访问的站点采用 Flutter Web 构建，含技术标签墙、雷达图与 AI 实验室，'
              '是跨端工程化的现场演示。',
              style: TextStyle(height: 1.55),
            ),
            const SizedBox(height: 10),
            Text(
              'Flutter Web · 可交互技能导航',
              style: TextStyle(color: accent, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
