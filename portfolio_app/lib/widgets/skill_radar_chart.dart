import 'dart:math' as math;
import 'package:flutter/material.dart';

class SkillRadarChart extends StatelessWidget {
  const SkillRadarChart({
    super.key,
    required this.labels,
    required this.values,
    required this.weights,
    this.size = 280,
  });

  final List<String> labels;
  final List<double> values;
  final List<double> weights;
  final double size;

  @override
  Widget build(BuildContext context) {
    final effective = List<double>.generate(
      values.length,
      (i) => (values[i] * weights[i]).clamp(0.0, 1.0),
    );

    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _RadarPainter(
          labels: labels,
          values: effective,
          primary: Theme.of(context).colorScheme.primary,
          secondary: Theme.of(context).colorScheme.secondary,
        ),
      ),
    );
  }
}

class _RadarPainter extends CustomPainter {
  _RadarPainter({
    required this.labels,
    required this.values,
    required this.primary,
    required this.secondary,
  });

  final List<String> labels;
  final List<double> values;
  final Color primary;
  final Color secondary;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.32;
    final n = labels.length;
    final angleStep = 2 * math.pi / n;

    for (var level = 1; level <= 4; level++) {
      final r = radius * level / 4;
      final path = Path();
      for (var i = 0; i < n; i++) {
        final a = -math.pi / 2 + i * angleStep;
        final p = center + Offset(math.cos(a) * r, math.sin(a) * r);
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
          ..color = Colors.white.withOpacity(0.06)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1,
      );
    }

    final dataPath = Path();
    for (var i = 0; i < n; i++) {
      final a = -math.pi / 2 + i * angleStep;
      final r = radius * values[i];
      final p = center + Offset(math.cos(a) * r, math.sin(a) * r);
      if (i == 0) {
        dataPath.moveTo(p.dx, p.dy);
      } else {
        dataPath.lineTo(p.dx, p.dy);
      }
    }
    dataPath.close();

    canvas.drawPath(
      dataPath,
      Paint()
        ..shader = LinearGradient(
          colors: [primary.withOpacity(0.45), secondary.withOpacity(0.35)],
        ).createShader(Rect.fromCircle(center: center, radius: radius))
        ..style = PaintingStyle.fill,
    );
    canvas.drawPath(
      dataPath,
      Paint()
        ..color = primary
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    final tp = TextPainter(textDirection: TextDirection.ltr);
    for (var i = 0; i < n; i++) {
      final a = -math.pi / 2 + i * angleStep;
      final labelR = radius + 28;
      final p = center + Offset(math.cos(a) * labelR, math.sin(a) * labelR);
      tp.text = TextSpan(
        text: labels[i],
        style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11),
      );
      tp.layout();
      tp.paint(canvas, p - Offset(tp.width / 2, tp.height / 2));
    }
  }

  @override
  bool shouldRepaint(covariant _RadarPainter old) => old.values != values;
}
