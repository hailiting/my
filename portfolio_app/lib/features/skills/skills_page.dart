import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolio_app/core/constants/profile_data.dart';
import 'package:portfolio_app/core/theme/site_style.dart';
import 'package:portfolio_app/widgets/section_header.dart';
import 'package:portfolio_app/widgets/skill_radar_chart.dart';
import 'package:portfolio_app/widgets/skill_word_cloud.dart';

final radarWeightsProvider = StateProvider<List<double>>((ref) {
  return List.filled(ProfileData.radarDimensions.length, 1.0);
});

class SkillsPage extends ConsumerWidget {
  const SkillsPage({super.key});

  static const _rolePresets = {
    'Web3 工程师': [1.0, 0.9, 1.0, 0.85, 0.8],
    'Flutter 跨端': [0.9, 1.0, 0.7, 0.8, 0.85],
    'AI 前端': [0.95, 0.85, 0.75, 1.0, 0.9],
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weights = ref.watch(radarWeightsProvider);
    final projects = ProfileData.projects;
    final scores = ProfileData.baseRadarScores;

    final matchScores = projects.map((p) {
      final dim = switch (p.highlight) {
        '区块链' => 2,
        '跨端' => 1,
        'AI' => 3,
        '产品思维' => 4,
        _ => 0,
      };
      return scores[dim] * weights[dim];
    }).toList();

    final bestIdx = matchScores.isEmpty
        ? 0
        : matchScores.indexOf(matchScores.reduce((a, b) => a > b ? a : b));

    return SitePageScroll(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
              const SectionHeader(
                number: '01',
                title: '我的技术全景图',
                subtitle: '点击标签查看对应项目证据；词越大代表该领域经验越深',
              ),
              const SkillWordCloud(),
              const SizedBox(height: 32),
              const SectionHeader(
                number: '02',
                title: '交互式技能雷达图',
                subtitle: '调整权重模拟不同岗位需求，高亮最匹配项目',
              ),
              Wrap(
                spacing: 8,
                children: _rolePresets.entries.map((e) {
                  return SiteChipButton(
                    label: e.key,
                    onPressed: () {
                      ref.read(radarWeightsProvider.notifier).state = e.value;
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              Center(
                child: SkillRadarChart(
                  labels: ProfileData.radarDimensions,
                  values: ProfileData.baseRadarScores,
                  weights: weights,
                ),
              ),
              const SizedBox(height: 16),
              ...List.generate(ProfileData.radarDimensions.length, (i) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 88,
                        child: Text(ProfileData.radarDimensions[i]),
                      ),
                      Expanded(
                        child: Slider(
                          value: weights[i],
                          onChanged: (v) {
                            final next = List<double>.from(weights);
                            next[i] = v;
                            ref.read(radarWeightsProvider.notifier).state = next;
                          },
                        ),
                      ),
                    ],
                  ),
                );
              }),
              Card(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const Icon(Icons.recommend),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          '与当前权重最匹配：${projects[bestIdx].name}',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
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
