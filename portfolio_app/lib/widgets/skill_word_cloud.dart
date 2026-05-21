import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio_app/core/constants/profile_data.dart';
import 'package:portfolio_app/core/theme/site_style.dart';

/// Canvas 动态技能词云 — 正圆飘动 + 点击路由。
class SkillWordCloud extends StatefulWidget {
  const SkillWordCloud({super.key});

  @override
  State<SkillWordCloud> createState() => _SkillWordCloudState();
}

class _SkillWordCloudState extends State<SkillWordCloud>
    with SingleTickerProviderStateMixin {
  late final AnimationController _drift;
  int? _hoveredIndex;

  static const _ecosystemColors = {
    SkillEcosystem.flutter: Color(0xFF38BDF8),
    SkillEcosystem.ai: Color(0xFFA78BFA),
    SkillEcosystem.web: Color(0xFF22D3EE),
    SkillEcosystem.blockchain: Color(0xFFFB923C),
    SkillEcosystem.architecture: Color(0xFF818CF8),
    SkillEcosystem.tooling: Color(0xFF4ADE80),
    SkillEcosystem.soft: Color(0xFF94A3B8),
  };

  @override
  void initState() {
    super.initState();
    _drift = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 28),
    )..repeat();
  }

  @override
  void dispose() {
    _drift.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final words = ProfileData.skillWords;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final maxW = constraints.maxWidth;
              final box = maxW < 400
                  ? maxW.clamp(280.0, 360.0)
                  : math.min(maxW, 560.0).clamp(380.0, 560.0);

              return SizedBox(
                width: box,
                height: box,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: SiteColors.border),
                    gradient: RadialGradient(
                      colors: [
                        SiteColors.accent.withOpacity(0.05),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  child: ClipOval(
                    child: GestureDetector(
                      onTapUp: (d) => _onTap(context, d.localPosition, words, box),
                      child: MouseRegion(
                        onHover: (e) => _onHover(e.localPosition, words, box),
                        onExit: (_) => setState(() => _hoveredIndex = null),
                        child: AnimatedBuilder(
                          animation: _drift,
                          builder: (context, _) {
                            return CustomPaint(
                              size: Size(box, box),
                              painter: _SkillCloudPainter(
                                words: words,
                                colors: _ecosystemColors,
                                phase: _drift.value * 2 * math.pi,
                                hoveredIndex: _hoveredIndex,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 12,
          runSpacing: 6,
          children: SkillEcosystem.values.map((e) {
            final c = _ecosystemColors[e]!;
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(color: c, shape: BoxShape.circle),
                ),
                const SizedBox(width: 6),
                Text(
                  e.label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 13,
                        color: SiteColors.textMuted,
                      ),
                ),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }

  void _onHover(Offset p, List<SkillWord> words, double box) {
    final hit = _hitTest(p, words, box, _drift.value * 2 * math.pi);
    if (hit != _hoveredIndex) setState(() => _hoveredIndex = hit);
  }

  void _onTap(BuildContext context, Offset p, List<SkillWord> words, double box) {
    final hit = _hitTest(p, words, box, _drift.value * 2 * math.pi);
    if (hit != null) context.go(words[hit].navigateRoute);
  }

  int? _hitTest(Offset p, List<SkillWord> words, double box, double phase) {
    final layouts = _layoutWords(words, box, phase);
    for (var i = layouts.length - 1; i >= 0; i--) {
      final l = layouts[i];
      if ((p - l.offset).distance < l.hitRadius) return i;
    }
    return null;
  }

  List<_WordLayout> _layoutWords(List<SkillWord> words, double box, double phase) {
    final n = words.length;
    final radius = box * (box < 360 ? 0.32 : 0.36);
    final scale = box < 360 ? 0.42 : 0.48;
    final center = Offset(box / 2, box / 2);
    final wobble = box < 360 ? 5.0 : 6.0;

    return List.generate(n, (i) {
      final w = words[i];
      final angle = -math.pi / 2 + (2 * math.pi * i) / n;
      var dx = radius * math.cos(angle);
      var dy = radius * math.sin(angle);
      dx += math.sin(phase + i * 0.65) * wobble;
      dy += math.cos(phase * 0.85 + i * 0.5) * wobble * 0.7;
      final fs = w.size * scale;
      return _WordLayout(
        offset: center + Offset(dx, dy),
        hitRadius: fs * 0.55 + 14,
      );
    });
  }
}

class _WordLayout {
  const _WordLayout({required this.offset, required this.hitRadius});
  final Offset offset;
  final double hitRadius;
}

class _SkillCloudPainter extends CustomPainter {
  _SkillCloudPainter({
    required this.words,
    required this.colors,
    required this.phase,
    required this.hoveredIndex,
  });

  final List<SkillWord> words;
  final Map<SkillEcosystem, Color> colors;
  final double phase;
  final int? hoveredIndex;

  @override
  void paint(Canvas canvas, Size size) {
    final box = size.width;
    final center = Offset(box / 2, box / 2);
    final radius = box * (box < 360 ? 0.32 : 0.36);
    final scale = box < 360 ? 0.42 : 0.48;
    final wobble = box < 360 ? 5.0 : 6.0;
    final n = words.length;

    final bg = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFF38BDF8).withOpacity(0.06),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius * 1.1));
    canvas.drawRect(Offset.zero & size, bg);

    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..style = PaintingStyle.stroke
        ..color = const Color(0xFF38BDF8).withOpacity(0.12)
        ..strokeWidth = 1,
    );

    for (var i = 0; i < n; i++) {
      final w = words[i];
      final angle = -math.pi / 2 + (2 * math.pi * i) / n;
      var dx = radius * math.cos(angle);
      var dy = radius * math.sin(angle);
      dx += math.sin(phase + i * 0.65) * wobble;
      dy += math.cos(phase * 0.85 + i * 0.5) * wobble * 0.7;

      final hovered = hoveredIndex == i;
      final fs = w.size * scale * (hovered ? 1.1 : 1);
      final color = colors[w.ecosystem] ?? const Color(0xFF38BDF8);

      final tp = TextPainter(
        text: TextSpan(
          text: w.text,
          style: TextStyle(
            fontSize: fs,
            fontWeight: w.size >= 32 ? FontWeight.w700 : FontWeight.w600,
            color: hovered ? color : color.withOpacity(0.9),
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      if (hovered) {
        canvas.drawCircle(
          center + Offset(dx, dy),
          tp.width / 2 + 8,
          Paint()
            ..color = color.withOpacity(0.15)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
        );
      }

      tp.paint(
        canvas,
        center + Offset(dx, dy) - Offset(tp.width / 2, tp.height / 2),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _SkillCloudPainter old) =>
      old.phase != phase || old.hoveredIndex != hoveredIndex;
}
