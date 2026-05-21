import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:portfolio_app/core/constants/profile_data.dart';

class ChallengeLab extends StatefulWidget {
  const ChallengeLab({super.key});

  @override
  State<ChallengeLab> createState() => _ChallengeLabState();
}

class _ChallengeLabState extends State<ChallengeLab>
    with TickerProviderStateMixin {
  LabChallenge? _challenge;
  final _codeLines = <String>[];
  bool _running = false;
  late AnimationController _waveCtrl;

  @override
  void initState() {
    super.initState();
    _waveCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();
  }

  @override
  void dispose() {
    _waveCtrl.dispose();
    super.dispose();
  }

  void _pickChallenge() {
    final list = LabChallenges.list;
    final c = list[math.Random().nextInt(list.length)];
    setState(() {
      _challenge = c;
      _codeLines.clear();
      _running = false;
    });
  }

  Future<void> _runDemo() async {
    if (_challenge == null || _running) return;
    setState(() => _running = true);

    final lines = [
      '// Cursor + Trae · AI 协作流',
      '// Prompt: ${_challenge!.prompt}',
      'Widget build(BuildContext context) {',
      '  return ${_challenge!.type}Demo();',
      '}',
      '// ✓ 生成完成 · 渲染预览 →',
    ];

    for (final line in lines) {
      await Future<void>.delayed(const Duration(milliseconds: 420));
      if (!mounted) return;
      setState(() => _codeLines.add(line));
    }
    setState(() => _running = false);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FilledButton.icon(
          onPressed: _pickChallenge,
          icon: const Icon(Icons.casino_outlined),
          label: const Text('随机微型挑战'),
        ),
        const SizedBox(height: 16),
        if (_challenge != null)
          LayoutBuilder(
            builder: (context, c) {
              final wide = c.maxWidth > 720;
              final panels = [
                _promptPanel(context),
                const SizedBox(width: 16, height: 16),
                _codePanel(context),
                const SizedBox(width: 16, height: 16),
                _previewPanel(context),
              ];
              if (wide) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: panels[0]),
                    Expanded(child: panels[2]),
                    Expanded(child: panels[4]),
                  ],
                );
              }
              return Column(children: [panels[0], panels[2], panels[4]]);
            },
          ),
      ],
    );
  }

  Widget _promptPanel(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('需求', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            Text(
              _challenge?.title ?? '',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(_challenge?.prompt ?? ''),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: _runDemo,
              child: Text(_running ? 'AI 生成中…' : '启动 AI 编程演示'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _codePanel(BuildContext context) {
    return Card(
      color: const Color(0xFF0D1117),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'terminal · ai-session',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    fontFamily: 'monospace',
                    color: const Color(0xFF7EE787),
                  ),
            ),
            const SizedBox(height: 10),
            ..._codeLines.map(
              (l) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  l,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 12,
                    color: Color(0xFFC9D1D9),
                  ),
                ),
              ),
            ),
            if (_codeLines.isEmpty)
              const Text(
                '等待挑战…',
                style: TextStyle(
                  fontFamily: 'monospace',
                  color: Color(0xFF484F58),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _previewPanel(BuildContext context) {
    return Card(
      child: SizedBox(
        height: 200,
        child: Center(
          child: _codeLines.length >= 5
              ? _buildPreview()
              : Text(
                  '预览区',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildPreview() {
    return switch (_challenge?.type) {
      'wave' => AnimatedBuilder(
          animation: _waveCtrl,
          builder: (_, __) => CustomPaint(
            size: const Size(200, 48),
            painter: _WaveBarPainter(_waveCtrl.value),
          ),
        ),
      'skeleton' => const _PulseSkeleton(),
      'hex' => CustomPaint(
          size: const Size(80, 80),
          painter: _HexBadgePainter(),
        ),
      _ => const Icon(Icons.check_circle, size: 48, color: Color(0xFF38BDF8)),
    };
  }
}

class _WaveBarPainter extends CustomPainter {
  _WaveBarPainter(this.phase);
  final double phase;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0xFF38BDF8);
    final path = Path();
    path.moveTo(0, size.height / 2);
    for (var x = 0.0; x <= size.width; x += 2) {
      final y = size.height / 2 +
          math.sin((x / size.width * 4 * math.pi) + phase * 2 * math.pi) * 12;
      path.lineTo(x, y);
    }
    canvas.drawPath(path, paint..strokeWidth = 3..style = PaintingStyle.stroke);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, size.height * 0.65, size.width * 0.7, 8),
        const Radius.circular(4),
      ),
      Paint()..color = const Color(0xFF1E293B),
    );
  }

  @override
  bool shouldRepaint(covariant _WaveBarPainter o) => o.phase != phase;
}

class _HexBadgePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final r = size.width * 0.4;
    final path = Path();
    for (var i = 0; i < 6; i++) {
      final a = -math.pi / 2 + i * math.pi / 3;
      final p = c + Offset(math.cos(a) * r, math.sin(a) * r);
      if (i == 0) {
        path.moveTo(p.dx, p.dy);
      } else {
        path.lineTo(p.dx, p.dy);
      }
    }
    path.close();
    canvas.drawPath(
      path,
      Paint()
        ..color = const Color(0xFF38BDF8).withOpacity(0.3)
        ..style = PaintingStyle.fill,
    );
    canvas.drawPath(
      path,
      Paint()
        ..color = const Color(0xFF38BDF8)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _PulseSkeleton extends StatefulWidget {
  const _PulseSkeleton();

  @override
  State<_PulseSkeleton> createState() => _PulseSkeletonState();
}

class _PulseSkeletonState extends State<_PulseSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (_, __) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 160,
            height: 12,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: Color.lerp(
                const Color(0xFF1E293B),
                const Color(0xFF38BDF8),
                _c.value * 0.5,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: 120,
            height: 12,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: Color.lerp(
                const Color(0xFF1E293B),
                const Color(0xFFA78BFA),
                _c.value * 0.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
