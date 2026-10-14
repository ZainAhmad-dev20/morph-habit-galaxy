import 'package:flutter/material.dart';

enum BiomeType { barren, recovering, lush, radiant, crystal }

class Habit {
  final String id;
  String title;
  String description;
  IconData icon;
  int streak;
  int maxStreak;
  bool isCompletedToday;
  BiomeType biomeType;
  Color baseColor;
  Color glowColor;
  double orbitRadius;
  double orbitSpeed; // radians per second
  double currentAngle; // current angle in orbit
  double size;

  Habit({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.streak,
    required this.maxStreak,
    required this.isCompletedToday,
    required this.biomeType,
    required this.baseColor,
    required this.glowColor,
    required this.orbitRadius,
    required this.orbitSpeed,
    required this.currentAngle,
    required this.size,
  });

  void toggleComplete() {
    isCompletedToday = !isCompletedToday;
    if (isCompletedToday) {
      streak += 1;
      if (streak > maxStreak) maxStreak = streak;
      if (streak >= 14) {
        biomeType = BiomeType.crystal;
        baseColor = const Color(0xFF00E5FF);
        glowColor = const Color(0xFF80D8FF);
      } else if (streak >= 7) {
        biomeType = BiomeType.radiant;
        baseColor = const Color(0xFF76FF03);
        glowColor = const Color(0xFFB9F6CA);
      } else if (streak >= 3) {
        biomeType = BiomeType.lush;
        baseColor = const Color(0xFF69F0AE);
        glowColor = const Color(0xFFCCFF90);
      } else {
        biomeType = BiomeType.recovering;
        baseColor = const Color(0xFFFFAB40);
        glowColor = const Color(0xFFFFD180);
      }
    } else {
      streak = streak > 0 ? streak - 1 : 0;
      if (streak < 3) {
        biomeType = BiomeType.barren;
        baseColor = const Color(0xFF90A4AE);
        glowColor = const Color(0xFFCFD8DC);
      }
    }
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'iconCode': icon.codePoint,
        'streak': streak,
        'maxStreak': maxStreak,
        'isCompletedToday': isCompletedToday,
        'biomeType': biomeType.index,
        'baseColor': baseColor.toARGB32(),
        'glowColor': glowColor.toARGB32(),
        'orbitRadius': orbitRadius,
        'orbitSpeed': orbitSpeed,
        'currentAngle': currentAngle,
        'size': size,
      };

  factory Habit.fromJson(Map<String, dynamic> json) {
    final code = json['iconCode'] ?? Icons.bolt.codePoint;
    IconData iconData = Icons.bolt;
    if (code == Icons.water_drop.codePoint) {
      iconData = Icons.water_drop;
    } else if (code == Icons.self_improvement.codePoint) {
      iconData = Icons.self_improvement;
    } else if (code == Icons.code.codePoint) {
      iconData = Icons.code;
    } else if (code == Icons.fitness_center.codePoint) {
      iconData = Icons.fitness_center;
    } else if (code == Icons.auto_stories.codePoint) {
      iconData = Icons.auto_stories;
    } else if (code == Icons.favorite.codePoint) {
      iconData = Icons.favorite;
    } else if (code == Icons.spa.codePoint) {
      iconData = Icons.spa;
    } else if (code == Icons.psychology.codePoint) {
      iconData = Icons.psychology;
    } else if (code == Icons.menu_book.codePoint) {
      iconData = Icons.menu_book;
    } else if (code == Icons.directions_run.codePoint) {
      iconData = Icons.directions_run;
    } else if (code == Icons.nightlight_round.codePoint) {
      iconData = Icons.nightlight_round;
    } else if (code == Icons.brush.codePoint) {
      iconData = Icons.brush;
    } else if (code == Icons.music_note.codePoint) {
      iconData = Icons.music_note;
    }

    return Habit(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      icon: iconData,
      streak: json['streak'] ?? 0,
      maxStreak: json['maxStreak'] ?? 0,
      isCompletedToday: json['isCompletedToday'] ?? false,
      biomeType: BiomeType.values[json['biomeType'] ?? 0],
      baseColor: Color(json['baseColor'] ?? 0xFF00B4D8),
      glowColor: Color(json['glowColor'] ?? 0xFF90E0EF),
      orbitRadius: (json['orbitRadius'] ?? 150.0).toDouble(),
      orbitSpeed: (json['orbitSpeed'] ?? 0.3).toDouble(),
      currentAngle: (json['currentAngle'] ?? 0.0).toDouble(),
      size: (json['size'] ?? 35.0).toDouble(),
    );
  }
}
