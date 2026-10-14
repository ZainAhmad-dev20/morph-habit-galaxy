import 'package:flutter/material.dart';
import '../models/mood.dart';

class MoodSelectorSheet extends StatelessWidget {
  final Mood currentMood;
  final Function(MoodType) onSelectMood;
  final VoidCallback onClose;

  const MoodSelectorSheet({
    super.key,
    required this.currentMood,
    required this.onSelectMood,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF101223).withValues(alpha: 0.95),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        border: Border.all(color: const Color(0xFFFF85A1).withValues(alpha: 0.4), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF85A1).withValues(alpha: 0.25),
            blurRadius: 30,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Shape Your Core Mood',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: onClose,
                icon: const Icon(Icons.close, color: Colors.white60),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Select the stellar resonance that matches your emotional frequency.',
            style: TextStyle(color: Colors.white70, fontSize: 13),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 240,
            child: ListView.builder(
              itemCount: Mood.presets.length,
              itemBuilder: (context, index) {
                final moodType = Mood.presets.keys.elementAt(index);
                final mood = Mood.presets[moodType]!;
                final isSelected = currentMood.type == moodType;

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? mood.coreColor.withValues(alpha: 0.25) : Colors.white.withValues(alpha: 0.04),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected ? mood.outerGlowColor : Colors.white12,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: ListTile(
                    leading: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [mood.outerGlowColor, mood.coreColor],
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          isSelected ? Icons.star : Icons.star_border,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                    title: Text(
                      mood.name,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      ),
                    ),
                    subtitle: Text(
                      mood.description,
                      style: const TextStyle(color: Colors.white60, fontSize: 12),
                    ),
                    trailing: isSelected
                        ? Icon(Icons.check_circle, color: mood.outerGlowColor)
                        : null,
                    onTap: () {
                      onSelectMood(moodType);
                      onClose();
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
