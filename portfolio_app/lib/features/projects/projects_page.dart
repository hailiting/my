import 'package:flutter/material.dart';
import 'package:portfolio_app/core/constants/profile_data.dart';
import 'package:portfolio_app/core/theme/site_style.dart';
import 'package:portfolio_app/widgets/project_card.dart';
import 'package:portfolio_app/widgets/section_header.dart';

class ProjectsPage extends StatefulWidget {
  const ProjectsPage({super.key});

  @override
  State<ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {
  String _filter = '全部';

  @override
  Widget build(BuildContext context) {
    final categories = {
      '全部',
      ...ProfileData.projects.map((p) => p.category).toSet(),
    };
    final list = _filter == '全部'
        ? ProfileData.projects
        : ProfileData.projects.where((p) => p.category == _filter);

    return SitePageScroll(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
              const SectionHeader(
                number: '01',
                title: '项目作品廊（智能版）',
                subtitle:
                    '代表作 Faypay：一人开发完整钱包 App（含应用内功能）· 可在线体验',
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: categories.map((c) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(c),
                        selected: _filter == c,
                        onSelected: (_) => setState(() => _filter = c),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 20),
              LayoutBuilder(
                builder: (context, c) {
                  final cross = c.maxWidth > 700 ? 2 : 1;
                  return GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: cross,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: cross == 2 ? 1.05 : 0.95,
                    children: [
                      for (final p in list) ProjectCard(project: p),
                    ],
                  );
                },
              ),
        ],
      ),
    );
  }
}
