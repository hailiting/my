import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio_app/core/constants/profile_data.dart';
import 'package:portfolio_app/core/theme/site_style.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:portfolio_app/widgets/ai_about_generator.dart';
import 'package:portfolio_app/widgets/section_header.dart';
import 'package:portfolio_app/widgets/skill_word_cloud.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _heroSection(context),
          SiteContainer(
            alt: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionHeader(
                  number: '01',
                  title: '我的技术全景图',
                  lead:
                      '可点击、会动的技术标签墙（不是普通图表）。下面这些是我日常开发中高频使用的技术与领域——点击任意词，立刻查看相关实战作品与解读。',
                  subtitle: '小提示：词越大，代表经验越深；颜色相同的词属于同一技术生态。',
                ),
                const SkillWordCloud(),
              ],
            ),
          ),
          SiteContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                SectionHeader(
                  number: '✨',
                  title: 'AI 智能介绍 · DeepSeek',
                  lead:
                      '访客输入技术关键词（如「区块链」「前端性能」），大模型基于我的真实履历实时生成针对性介绍。单次对话 token 控制在 1 万以内。',
                ),
                Center(child: AiAboutGenerator()),
              ],
            ),
          ),
          SiteContainer(
            alt: true,
            child: _experiencePreview(context),
          ),
        ],
      ),
    );
  }

  Widget _heroSection(BuildContext context) {
    return HeroBackdrop(
      child: SiteContainer(
        padding: const EdgeInsets.fromLTRB(24, 32, 24, 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: SiteColors.border),
              ),
              child: Text(
                '${ProfileData.title} · ${ProfileData.experience} · AI 辅助开发',
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ),
            const SizedBox(height: 24),
            GradientText(
              ProfileData.name,
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const SizedBox(height: 16),
            Text(
              ProfileData.heroTagline,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: SiteColors.textMuted,
                    height: 1.75,
                  ),
            ),
            const SizedBox(height: 16),
            Text(
              '📍 期望城市：${ProfileData.city}  ·  💼 期望薪资：${ProfileData.salary}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 24),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                SitePrimaryButton(
                  label: '联系我',
                  onPressed: () => context.go('/contact'),
                ),
                SiteOutlineButton(
                  label: '查看经历',
                  onPressed: () => context.go('/contact'),
                ),
                SiteOutlineButton(
                  label: '体验 Faypay 钱包',
                  onPressed: () => launchUrl(Uri.parse(ProfileData.faypayUrl)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                _contactLink(context, ProfileData.phone, 'tel:${ProfileData.phone}'),
                Text('·', style: TextStyle(color: SiteColors.textMuted.withOpacity(0.4))),
                _contactLink(context, ProfileData.email, 'mailto:${ProfileData.email}'),
              ],
            ),
            const SizedBox(height: 40),
            const Divider(),
            const SizedBox(height: 24),
            LayoutBuilder(
              builder: (context, c) {
                final cols = c.maxWidth > 600 ? 4 : 2;
                return GridView.count(
                  crossAxisCount: cols,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: cols == 4 ? 1.35 : 1.5,
                  children: const [
                    SiteStatTile(value: '11+', label: '年经验'),
                    SiteStatTile(value: '8+', label: '年前端'),
                    SiteStatTile(value: '5+', label: '年链游'),
                    SiteStatTile(value: '3+', label: '年区块链'),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _contactLink(BuildContext context, String text, String uri) {
    return InkWell(
      onTap: () => launchUrl(Uri.parse(uri)),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: SiteColors.accent),
      ),
    );
  }

  Widget _experiencePreview(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          number: '03',
          title: '工作经历预览',
          lead: '完整时间线见「联系」页或简历 PDF。',
        ),
        ...ProfileData.experiences.take(2).map(
          (e) => Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              title: Text(e.company),
              subtitle: Text('${e.role} · ${e.period}'),
              trailing: const Icon(Icons.chevron_right, color: SiteColors.textMuted),
              onTap: () => context.go('/contact'),
            ),
          ),
        ),
      ],
    );
  }
}
