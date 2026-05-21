import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio_app/core/constants/profile_data.dart';
import 'package:portfolio_app/core/theme/site_style.dart';
import 'package:portfolio_app/widgets/section_header.dart';

class ArchitecturePage extends StatelessWidget {
  const ArchitecturePage({super.key});

  @override
  Widget build(BuildContext context) {
    final mono = Theme.of(context).textTheme.bodySmall?.copyWith(
          fontFamily: 'monospace',
          height: 1.5,
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.85),
        );

    return SitePageScroll(
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
                      ProfileData.architectureTitle,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                ProfileData.architectureSubtitle,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      height: 1.6,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.75),
                    ),
              ),
              const SizedBox(height: 28),
              for (var i = 0; i < ProfileData.architectureSections.length; i++)
                _SectionCard(
                  number: '${i + 1}'.padLeft(2, '0'),
                  section: ProfileData.architectureSections[i],
                  monoStyle: mono,
                ),
              const SizedBox(height: 24),
              Card(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.08),
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '代码即作品',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        ProfileData.architectureClosing,
                        style: const TextStyle(height: 1.6),
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          const Chip(label: Text('Claude Code')),
                          const Chip(label: Text('Skills / MCP')),
                          const Chip(label: Text('Python API')),
                          const Chip(label: Text('LangChain')),
                          const Chip(label: Text('Riverpod')),
                          const Chip(label: Text('go_router')),
                          ActionChip(
                            label: const Text('查看项目作品'),
                            onPressed: () => context.go('/projects'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.number,
    required this.section,
    required this.monoStyle,
  });

  final String number;
  final ArchitectureSection section;
  final TextStyle? monoStyle;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHeader(
              number: number,
              title: section.title,
              subtitle: section.subtitle,
            ),
            const SizedBox(height: 12),
            Text(section.body, style: const TextStyle(height: 1.65)),
            if (section.bullets.isNotEmpty) ...[
              const SizedBox(height: 12),
              ...section.bullets.map(
                (b) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        size: 18,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Expanded(child: Text(b, style: const TextStyle(height: 1.5))),
                    ],
                  ),
                ),
              ),
            ],
            if (section.codeSample != null) ...[
              const SizedBox(height: 14),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                  ),
                ),
                child: Text(section.codeSample!, style: monoStyle),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
