import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../models/habit.dart';
import '../models/mood.dart';

class GalaxyPainter extends CustomPainter {
  final Mood mood;
  final List<Habit> habits;
  final double animationValue;
  final Offset panOffset;
  final double zoom;

  GalaxyPainter({
    required this.mood,
    required this.habits,
    required this.animationValue,
    required this.panOffset,
    required this.zoom,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2 + panOffset.dx, size.height / 2 + panOffset.dy);

    // 1. Paint Deep Space Background Gradient & Nebula
    final bgRect = Offset.zero & size;
    final bgPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFF0F1026),
          const Color(0xFF070814),
          const Color(0xFF020205),
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(bgRect);
    canvas.drawRect(bgRect, bgPaint);

    // Paint Nebula Clouds
    final nebulaPaint = Paint()
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 60.0);

    final random = math.Random(42);
    for (int i = 0; i < 5; i++) {
      final angle = (i * math.pi / 2.5) + (animationValue * 0.05);
      final dist = 100.0 + (i * 50.0);
      final x = center.dx + math.cos(angle) * dist * zoom;
      final y = center.dy + math.sin(angle) * dist * zoom;
      
      nebulaPaint.color = mood.outerGlowColor.withValues(alpha: 0.08 + (i * 0.02));
      canvas.drawCircle(Offset(x, y), (120.0 + i * 30.0) * zoom, nebulaPaint);
    }

    // 2. Paint Starfield Particles
    final starPaint = Paint()..strokeCap = StrokeCap.round;
    for (int i = 0; i < 100; i++) {
      final sx = (random.nextDouble() * size.width);
      final sy = (random.nextDouble() * size.height);
      final twinkle = math.sin((animationValue * 3.0) + i) * 0.5 + 0.5;
      
      starPaint.color = Colors.white.withValues(alpha: 0.2 + (twinkle * 0.6));
      starPaint.strokeWidth = (i % 3 == 0) ? 2.0 : 1.0;
      canvas.drawPoints(ui.PointMode.points, [Offset(sx, sy)], starPaint);
    }

    // 3. Paint Orbit Paths & Energy Connections to Sun
    for (var habit in habits) {
      final radius = habit.orbitRadius * zoom;
      
      // Orbit Path Ring
      final orbitPaint = Paint()
        ..color = habit.baseColor.withValues(alpha: habit.isCompletedToday ? 0.25 : 0.08)
        ..style = PaintingStyle.stroke
        ..strokeWidth = habit.isCompletedToday ? 1.5 : 1.0;
      
      canvas.drawCircle(center, radius, orbitPaint);

      // Energy Stream connection to Sun if completed
      if (habit.isCompletedToday) {
        final currentX = center.dx + math.cos(habit.currentAngle) * radius;
        final currentY = center.dy + math.sin(habit.currentAngle) * radius;
        
        final linePaint = Paint()
          ..shader = LinearGradient(
            colors: [
              mood.coreColor.withValues(alpha: 0.4),
              habit.baseColor.withValues(alpha: 0.6),
            ],
          ).createShader(Rect.fromPoints(center, Offset(currentX, currentY)))
          ..strokeWidth = 1.5
          ..style = PaintingStyle.stroke;

        canvas.drawLine(center, Offset(currentX, currentY), linePaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant GalaxyPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.mood != mood ||
        oldDelegate.habits != habits ||
        oldDelegate.panOffset != panOffset ||
        oldDelegate.zoom != zoom;
  }
}
