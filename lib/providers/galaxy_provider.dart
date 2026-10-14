import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/habit.dart';
import '../models/mood.dart';
import '../models/user_profile.dart';
import '../services/storage_service.dart';

class GalaxyProvider extends ChangeNotifier {
  UserProfile _userProfile = UserProfile.guest;
  UserProfile get userProfile => _userProfile;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  Mood _currentMood = Mood.presets[MoodType.serene]!;
  Mood get currentMood => _currentMood;

  List<Habit> _habits = [];
  List<Habit> get habits => _habits;

  // Camera state for zoom / pan
  double _zoom = 1.0;
  double get zoom => _zoom;
  Offset _panOffset = Offset.zero;
  Offset get panOffset => _panOffset;

  Habit? _selectedHabit;
  Habit? get selectedHabit => _selectedHabit;

  bool _isDetailZoomed = false;
  bool get isDetailZoomed => _isDetailZoomed;

  GalaxyProvider() {
    _initStorage();
  }

  Future<void> _initStorage() async {
    _isLoading = true;
    notifyListeners();

    _userProfile = await StorageService.loadUserProfile();
    _habits = await StorageService.loadHabits();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> registerUser(String name, String email, String focusArea) async {
    _userProfile = UserProfile(
      name: name,
      email: email,
      focusArea: focusArea,
      isRegistered: true,
    );
    await StorageService.saveUserProfile(_userProfile);
    notifyListeners();
  }

  void setMood(MoodType type) {
    if (Mood.presets.containsKey(type)) {
      _currentMood = Mood.presets[type]!;
      notifyListeners();
    }
  }

  Future<void> toggleHabitCompletion(String id) async {
    final habit = _habits.firstWhere((h) => h.id == id);
    habit.toggleComplete();
    await StorageService.saveHabits(_habits);
    notifyListeners();
  }

  Future<void> addHabit({
    required String title,
    required String description,
    required IconData icon,
  }) async {
    final newRadius = 130.0 + (_habits.length * 75.0);
    final newHabit = Habit(
      id: 'h_${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      description: description,
      icon: icon,
      streak: 1,
      maxStreak: 1,
      isCompletedToday: true,
      biomeType: BiomeType.lush,
      baseColor: const Color(0xFF69F0AE),
      glowColor: const Color(0xFFCCFF90),
      orbitRadius: newRadius,
      orbitSpeed: math.max(0.05, 0.4 - (_habits.length * 0.06)),
      currentAngle: math.Random().nextDouble() * 2 * math.pi,
      size: 35.0,
    );
    _habits.add(newHabit);
    await StorageService.saveHabits(_habits);
    notifyListeners();
  }

  void updateOrbitAngles(double deltaTime) {
    for (var habit in _habits) {
      habit.currentAngle += habit.orbitSpeed * deltaTime;
      if (habit.currentAngle > 2 * math.pi) {
        habit.currentAngle -= 2 * math.pi;
      }
    }
    notifyListeners();
  }

  void setZoom(double newZoom) {
    _zoom = newZoom.clamp(0.5, 3.0);
    notifyListeners();
  }

  void setPan(Offset delta) {
    _panOffset += delta;
    notifyListeners();
  }

  void selectHabit(Habit? habit) {
    _selectedHabit = habit;
    _isDetailZoomed = habit != null;
    notifyListeners();
  }

  void resetCamera() {
    _zoom = 1.0;
    _panOffset = Offset.zero;
    _selectedHabit = null;
    _isDetailZoomed = false;
    notifyListeners();
  }
}
