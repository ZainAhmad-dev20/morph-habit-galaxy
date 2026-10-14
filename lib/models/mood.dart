import 'package:flutter/material.dart';

enum MoodType { calm, energetic, focused, melancholic, radiant, serene }

class Mood {
  final MoodType type;
  final String name;
  final String description;
  final Color coreColor;
  final Color outerGlowColor;
  final double intensity; // 0.0 to 1.0
  final double pulseSpeed;

  const Mood({
    required this.type,
    required this.name,
    required this.description,
    required this.coreColor,
    required this.outerGlowColor,
    required this.intensity,
    required this.pulseSpeed,
  });

  static const Map<MoodType, Mood> presets = {
    MoodType.serene: Mood(
      type: MoodType.serene,
      name: 'Serene',
      description: 'Peaceful, floating in quiet equilibrium.',
      coreColor: Color(0xFF00B4D8),
      outerGlowColor: Color(0xFF90E0EF),
      intensity: 0.7,
      pulseSpeed: 1.0,
    ),
    MoodType.energetic: Mood(
      type: MoodType.energetic,
      name: 'Supernova',
      description: 'Pulsing with radiant drive and vibrant energy.',
      coreColor: Color(0xFFFF4D6D),
      outerGlowColor: Color(0xFFFF85A1),
      intensity: 0.95,
      pulseSpeed: 2.2,
    ),
    MoodType.focused: Mood(
      type: MoodType.focused,
      name: 'Laser Focus',
      description: 'Deep orbital alignment and crystal clarity.',
      coreColor: Color(0xFF7209B7),
      outerGlowColor: Color(0xFFB5179E),
      intensity: 0.85,
      pulseSpeed: 1.5,
    ),
    MoodType.calm: Mood(
      type: MoodType.calm,
      name: 'Deep Calm',
      description: 'Starlit stillness, breathing with the cosmos.',
      coreColor: Color(0xFF4361EE),
      outerGlowColor: Color(0xFF4895EF),
      intensity: 0.6,
      pulseSpeed: 0.8,
    ),
    MoodType.melancholic: Mood(
      type: MoodType.melancholic,
      name: 'Nebula Veil',
      description: 'Quiet reflection amid stardust and shadows.',
      coreColor: Color(0xFF3A0CA3),
      outerGlowColor: Color(0xFF560BAD),
      intensity: 0.5,
      pulseSpeed: 0.6,
    ),
    MoodType.radiant: Mood(
      type: MoodType.radiant,
      name: 'Radiant Joy',
      description: 'Golden stellar warmth illuminating all orbits.',
      coreColor: Color(0xFFFFB703),
      outerGlowColor: Color(0xFFFFD166),
      intensity: 0.9,
      pulseSpeed: 1.8,
    ),
  };
}
