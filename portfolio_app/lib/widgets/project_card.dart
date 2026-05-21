import 'package:flutter/material.dart';
import 'package:portfolio_app/core/constants/profile_data.dart';
import 'package:url_launcher/url_launcher.dart';

class ProjectCard extends StatefulWidget {
  const ProjectCard({super.key, required this.project});

  final ProjectItem project;

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  String? _aiText;

  @override
  Widget build(BuildContext context) {
    final p = widget.project;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Chip(
                  label: Text(p.category, style: const TextStyle(fontSize: 11)),
                  visualDensity: VisualDensity.compact,
                ),
                if (p.soloDev) ...[
                  const SizedBox(width: 6),
                  Chip(
                    label: const Text('独立开发', style: TextStyle(fontSize: 10)),
                    backgroundColor: Theme.of(context).colorScheme.secondary.withOpacity(0.25),
                    visualDensity: VisualDensity.compact,
                  ),
                ],
                const Spacer(),
                Text(
                  p.metric,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              p.name,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: p.stack
                  .map((s) => Chip(label: Text(s), visualDensity: VisualDensity.compact))
                  .toList(),
            ),
            const SizedBox(height: 10),
            Text(
              p.summary,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.75),
                  ),
            ),
            if (_aiText != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(8),
                  border: Border(
                    left: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                      width: 3,
                    ),
                  ),
                ),
                child: Text(_aiText!, style: const TextStyle(height: 1.6, fontSize: 13)),
              ),
            ],
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: [
                if (p.liveUrl != null)
                  FilledButton.tonalIcon(
                    onPressed: () => launchUrl(Uri.parse(p.liveUrl!)),
                    icon: const Icon(Icons.open_in_new, size: 16),
                    label: const Text('在线预览'),
                  ),
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      _aiText = ProfileData.aiNarrateProject(p.name);
                    });
                  },
                  icon: const Icon(Icons.smart_toy_outlined, size: 18),
                  label: const Text('AI 解读'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
