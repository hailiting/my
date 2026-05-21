import 'package:flutter/material.dart';
import 'package:portfolio_app/core/constants/profile_data.dart';
import 'package:portfolio_app/core/theme/site_style.dart';
import 'package:portfolio_app/widgets/section_header.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  Future<void> _launch(Uri uri) async {
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SitePageScroll(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SectionHeader(
            number: '01',
            title: '联系方式与价值主张',
          ),
          Text(
            '正在寻找 ${ProfileData.city} 地区的前端 / Web3 / Flutter 机会。',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 24),
          SitePrimaryButton(
            label: '为我提供一份工作',
            onPressed: () => _launch(Uri.parse('mailto:${ProfileData.email}')),
          ),
          const SizedBox(height: 12),
          SiteOutlineButton(
            label: '邀请我参与您的项目',
            onPressed: () => _launch(Uri.parse('tel:${ProfileData.phone}')),
          ),
              const SizedBox(height: 28),
              _contactTile(
                context,
                Icons.phone,
                '电话',
                ProfileData.phone,
                () => _launch(Uri.parse('tel:${ProfileData.phone}')),
              ),
              _contactTile(
                context,
                Icons.email,
                '邮箱',
                ProfileData.email,
                () => _launch(Uri.parse('mailto:${ProfileData.email}')),
              ),
              _contactTile(
                context,
                Icons.code,
                'GitHub',
                '查看代码仓库',
                () => _launch(Uri.parse(ProfileData.github)),
              ),
              const SizedBox(height: 24),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    '💡 技术彩蛋：打开浏览器控制台，输入 hireMe() 查看隐藏面试题思路。',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: SiteColors.accent,
                        ),
                  ),
                ),
              ),
        ],
      ),
    );
  }

  Widget _contactTile(
    BuildContext context,
    IconData icon,
    String label,
    String value,
    VoidCallback onTap,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon),
        title: Text(label),
        subtitle: Text(value),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
