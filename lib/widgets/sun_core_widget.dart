import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/mood.dart';

class SunCoreWidget extends StatelessWidget {
  final Mood mood;
  final Animation<double> animation;
  final VoidCallback onTap;

  const SunCoreWidget({
    super.key,
    required this.mood,
    required this.animation,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final pulse = math.sin(animation.value * math.pi * mood.pulseSpeed) * 0.1 + 1.0;
        final glowSize = 90.0 * pulse * mood.intensity;

        return GestureDetector(
          onTap: onTap,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Outer Corona Glow
              Container(
                width: 140.0 * glowSize / 90.0,
                height: 140.0 * glowSize / 90.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      mood.outerGlowColor.withValues(alpha: 0.5),
                      mood.coreColor.withValues(alpha: 0.2),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.6, 1.0],
                  ),
                ),
              ),
              // Inner Sun Core Body
              Container(
                width: 76.0,
                height: 76.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Colors.white,
                      mood.coreColor,
                      mood.outerGlowColor,
                    ],
                    stops: const [0.0, 0.4, 1.0],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: mood.coreColor.withValues(alpha: 0.8),
                      blurRadius: 25.0,
                      spreadRadius: 5.0,
                    ),
                    BoxShadow(
                      color: mood.outerGlowColor.withValues(alpha: 0.5),
                      blurRadius: 45.0,
                      spreadRadius: 10.0,
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    Icons.star,
                    color: Colors.white.withValues(alpha: 0.9),
                    size: 32.0,
                  ),
                ),
              ),
              // Mood Title Badge floating just above
              Positioned(
                top: -30,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: mood.coreColor.withValues(alpha: 0.5), width: 1),
                  ),
                  child: Text(
                    mood.name,
                    style: TextStyle(
                      color: mood.outerGlowColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
