import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/habit.dart';
import '../models/user_profile.dart';

class StorageService {
  static const String _keyProfile = 'morph_user_profile';
  static const String _keyHabits = 'morph_habits_list';

  static Future<UserProfile> loadUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_keyProfile);
    if (jsonStr == null) return UserProfile.guest;
    try {
      return UserProfile.fromJson(jsonDecode(jsonStr));
    } catch (_) {
      return UserProfile.guest;
    }
  }

  static Future<void> saveUserProfile(UserProfile profile) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyProfile, jsonEncode(profile.toJson()));
  }

  static Future<List<Habit>> loadHabits() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_keyHabits);
    if (jsonStr == null) {
      return _defaultHabits();
    }
    try {
      final List<dynamic> list = jsonDecode(jsonStr);
      return list.map((item) => Habit.fromJson(item)).toList();
    } catch (_) {
      return _defaultHabits();
    }
  }

  static Future<void> saveHabits(List<Habit> habits) async {
    final prefs = await SharedPreferences.getInstance();
    final list = habits.map((h) => h.toJson()).toList();
    await prefs.setString(_keyHabits, jsonEncode(list));
  }

  static List<Habit> _defaultHabits() {
    return [
      Habit(
        id: 'h1',
        title: 'Hydration Flow',
        description: 'Drink 8 glasses of pure spring water.',
        icon: Icons.water_drop,
        streak: 5,
        maxStreak: 12,
        isCompletedToday: true,
        biomeType: BiomeType.lush,
        baseColor: const Color(0xFF00B4D8),
        glowColor: const Color(0xFF90E0EF),
        orbitRadius: 130.0,
        orbitSpeed: 0.35,
        currentAngle: 0.0,
        size: 32.0,
      ),
      Habit(
        id: 'h2',
        title: 'Deep Meditation',
        description: '20 minutes of mindful breathing & silence.',
        icon: Icons.self_improvement,
        streak: 9,
        maxStreak: 15,
        isCompletedToday: false,
        biomeType: BiomeType.radiant,
        baseColor: const Color(0xFF76FF03),
        glowColor: const Color(0xFFB9F6CA),
        orbitRadius: 205.0,
        orbitSpeed: 0.25,
        currentAngle: 1.2,
        size: 38.0,
      ),
      Habit(
        id: 'h3',
        title: 'Quantum Coding',
        description: 'Build robust architectures and shaders.',
        icon: Icons.code,
        streak: 18,
        maxStreak: 21,
        isCompletedToday: true,
        biomeType: BiomeType.crystal,
        baseColor: const Color(0xFF00E5FF),
        glowColor: const Color(0xFF80D8FF),
        orbitRadius: 285.0,
        orbitSpeed: 0.18,
        currentAngle: 2.5,
        size: 44.0,
      ),
    ];
  }
}
