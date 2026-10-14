import 'package:flutter/material.dart';

class HudBar extends StatelessWidget {
  final VoidCallback onAddHabit;
  final VoidCallback onChangeMood;
  final VoidCallback onResetView;
  final int totalStreak;

  const HudBar({
    super.key,
    required this.onAddHabit,
    required this.onChangeMood,
    required this.onResetView,
    required this.totalStreak,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 12,
      left: 12,
      right: 12,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // App Branding & Total Streak
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white24, width: 1),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.public, color: Color(0xFF00E5FF), size: 18),
                  const SizedBox(width: 6),
                  const Text(
                    'MORPH',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.2,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFD166).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '🔥 $totalStreak',
                      style: const TextStyle(
                        color: Color(0xFFFFD166),
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Action Buttons
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHudButton(
                onPressed: onResetView,
                icon: Icons.center_focus_strong,
                color: Colors.white70,
                tooltip: 'Recenter',
              ),
              const SizedBox(width: 6),
              _buildHudButton(
                onPressed: onChangeMood,
                icon: Icons.auto_awesome,
                color: const Color(0xFFFF85A1),
                tooltip: 'Mood',
              ),
              const SizedBox(width: 6),
              _buildHudButton(
                onPressed: onAddHabit,
                icon: Icons.add,
                color: const Color(0xFF00E5FF),
                tooltip: 'Add',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHudButton({
    required VoidCallback onPressed,
    required IconData icon,
    required Color color,
    required String tooltip,
  }) {
    return SizedBox(
      width: 38,
      height: 38,
      child: IconButton(
        onPressed: onPressed,
        padding: EdgeInsets.zero,
        icon: Icon(icon, color: color, size: 18),
        style: IconButton.styleFrom(
          backgroundColor: Colors.black.withValues(alpha: 0.5),
          shape: const CircleBorder(),
          side: const BorderSide(color: Colors.white24),
        ),
        tooltip: tooltip,
      ),
    );
  }
}
