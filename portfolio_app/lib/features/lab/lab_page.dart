import 'package:flutter/material.dart';
import 'package:portfolio_app/core/theme/site_style.dart';
import 'package:portfolio_app/widgets/challenge_lab.dart';
import 'package:portfolio_app/widgets/section_header.dart';

class LabPage extends StatelessWidget {
  const LabPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SitePageScroll(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            number: '01',
            title: '「一键验证」实验室',
            subtitle:
                '随机微型挑战 → AI 协作流模拟 → 实时代码预览。让面试官亲手感受你的产出节奏。',
          ),
          ChallengeLab(),
        ],
      ),
    );
  }
}
