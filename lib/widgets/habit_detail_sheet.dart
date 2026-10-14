import 'package:flutter/material.dart';
import '../models/habit.dart';

class HabitDetailSheet extends StatelessWidget {
  final Habit habit;
  final VoidCallback onToggleComplete;
  final VoidCallback onStartTimer;
  final VoidCallback onClose;

  const HabitDetailSheet({
    super.key,
    required this.habit,
    required this.onToggleComplete,
    required this.onStartTimer,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF101223).withValues(alpha: 0.92),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        border: Border.all(color: habit.baseColor.withValues(alpha: 0.4), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: habit.glowColor.withValues(alpha: 0.3),
            blurRadius: 30,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [habit.glowColor, habit.baseColor],
                  ),
                ),
                child: Icon(habit.icon, color: Colors.white, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      habit.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Biome: ${habit.biomeType.name.toUpperCase()}',
                      style: TextStyle(
                        color: habit.glowColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: onClose,
                icon: const Icon(Icons.close, color: Colors.white60),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            habit.description,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 24),
          // Streak Stats Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem('Current Streak', '🔥 ${habit.streak} days'),
                _buildStatItem('Max Streak', '⭐ ${habit.maxStreak} days'),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Start Timer Session Button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton.icon(
              onPressed: () {
                onClose();
                onStartTimer();
              },
              icon: Icon(Icons.timer, color: habit.glowColor),
              label: Text(
                'Start Focus Timer Session',
                style: TextStyle(
                  color: habit.glowColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: habit.baseColor),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Complete / Incomplete Button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: onToggleComplete,
              icon: Icon(
                habit.isCompletedToday ? Icons.check_circle : Icons.radio_button_unchecked,
                color: Colors.black87,
              ),
              label: Text(
                habit.isCompletedToday ? 'Completed Today! (Tap to Undo)' : 'Mark as Completed',
                style: const TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: habit.baseColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 6,
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white54, fontSize: 12),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
