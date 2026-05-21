import 'package:flutter/material.dart';
import 'package:portfolio_app/core/ai/deepseek_service.dart';
import 'package:portfolio_app/core/theme/site_style.dart';

class AiAboutGenerator extends StatefulWidget {
  const AiAboutGenerator({super.key});

  @override
  State<AiAboutGenerator> createState() => _AiAboutGeneratorState();
}

class _AiAboutGeneratorState extends State<AiAboutGenerator> {
  final _controller = TextEditingController();
  final _service = DeepSeekService();
  String _output = '输入关键词，由 DeepSeek 生成第三方视角个人介绍…';
  String? _meta;
  bool _loading = false;

  final _suggestions = ['区块链', 'Flutter 跨端', 'AI 编程', '前端性能', '架构设计'];

  @override
  void dispose() {
    _controller.dispose();
    _service.dispose();
    super.dispose();
  }

  Future<void> _generate() async {
    final kw = _controller.text.trim();
    if (kw.isEmpty || _loading) return;

    setState(() {
      _loading = true;
      _output = 'DeepSeek 正在基于预设背景生成…';
      _meta = null;
    });

    try {
      final result = await _service.generateAbout(kw);
      if (!mounted) return;
      setState(() {
        _output = result.text;
        _meta = _buildMeta(result);
        _loading = false;
      });
    } on AiAboutException catch (e) {
      if (!mounted) return;
      setState(() {
        _output = e.message;
        _meta = null;
        _loading = false;
      });
    }
  }

  String? _buildMeta(AiAboutResult result) {
    final parts = <String>[];
    if (result.source == AiAboutSource.deepseek) {
      parts.add('DeepSeek 实时生成');
      if (result.model != null) parts.add(result.model!);
      final tokens = result.totalTokens;
      if (tokens != null) parts.add('本次约 $tokens tokens（单次上限 1 万）');
    } else {
      parts.add('本地模板');
      if (result.note != null) parts.add(result.note!);
    }
    return parts.join(' · ');
  }

  @override
  Widget build(BuildContext context) {
    return SitePanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _suggestions.map((s) {
              return SiteChipButton(
                label: s,
                enabled: !_loading,
                onPressed: () {
                  _controller.text = s;
                  _generate();
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  enabled: !_loading,
                  decoration: const InputDecoration(
                    hintText: '输入关键词…',
                  ),
                  onSubmitted: _loading ? null : (_) => _generate(),
                ),
              ),
              const SizedBox(width: 10),
              SitePrimaryButton(
                label: _loading ? '…' : '生成',
                onPressed: _loading ? () {} : _generate,
              ),
            ],
          ),
          const SizedBox(height: 14),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Text(
              _output,
              key: ValueKey(_output),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          if (_meta != null) ...[
            const SizedBox(height: 10),
            Text(
              _meta!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: SiteColors.accent,
                    fontSize: 13,
                  ),
            ),
          ],
        ],
      ),
    );
  }
}
