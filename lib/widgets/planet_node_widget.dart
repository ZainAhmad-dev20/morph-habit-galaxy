import 'package:flutter/material.dart';
import '../models/habit.dart';

class PlanetNodeWidget extends StatelessWidget {
  final Habit habit;
  final VoidCallback onTap;
  final VoidCallback onDoubleTap;

  const PlanetNodeWidget({
    super.key,
    required this.habit,
    required this.onTap,
    required this.onDoubleTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onDoubleTap: onDoubleTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: habit.size,
            height: habit.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  habit.glowColor,
                  habit.baseColor,
                  habit.baseColor.withValues(alpha: 0.6),
                ],
                stops: const [0.0, 0.6, 1.0],
              ),
              boxShadow: [
                BoxShadow(
                  color: habit.glowColor.withValues(alpha: habit.isCompletedToday ? 0.9 : 0.3),
                  blurRadius: habit.isCompletedToday ? 16.0 : 6.0,
                  spreadRadius: habit.isCompletedToday ? 3.0 : 1.0,
                ),
              ],
              border: Border.all(
                color: habit.isCompletedToday ? Colors.white : Colors.white24,
                width: habit.isCompletedToday ? 2.0 : 1.0,
              ),
            ),
            child: Center(
              child: Icon(
                habit.icon,
                color: Colors.white,
                size: habit.size * 0.5,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.55),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: habit.isCompletedToday
                    ? habit.baseColor.withValues(alpha: 0.6)
                    : Colors.white12,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  habit.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  '🔥${habit.streak}',
                  style: TextStyle(
                    color: habit.isCompletedToday ? const Color(0xFFFFD166) : Colors.white60,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
