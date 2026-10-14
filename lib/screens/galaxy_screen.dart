import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/habit.dart';
import '../providers/galaxy_provider.dart';
import '../painters/galaxy_painter.dart';
import '../widgets/sun_core_widget.dart';
import '../widgets/planet_node_widget.dart';
import '../widgets/hud_bar.dart';
import '../widgets/habit_detail_sheet.dart';
import '../widgets/mood_selector_sheet.dart';
import '../widgets/add_habit_sheet.dart';
import '../widgets/onboarding_sheet.dart';
import '../widgets/habit_timer_sheet.dart';

class GalaxyScreen extends StatefulWidget {
  const GalaxyScreen({super.key});

  @override
  State<GalaxyScreen> createState() => _GalaxyScreenState();
}

class _GalaxyScreenState extends State<GalaxyScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _tickerController;
  bool _hasPromptedOnboarding = false;

  @override
  void initState() {
    super.initState();
    _tickerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    _tickerController.addListener(() {
      final provider = Provider.of<GalaxyProvider>(context, listen: false);
      provider.updateOrbitAngles(0.016); // ~60fps delta
    });
  }

  @override
  void dispose() {
    _tickerController.dispose();
    super.dispose();
  }

  void _checkOnboarding(GalaxyProvider provider) {
    if (!provider.isLoading && !provider.userProfile.isRegistered && !_hasPromptedOnboarding) {
      _hasPromptedOnboarding = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showOnboarding(context);
      });
    }
  }

  void _showOnboarding(BuildContext context) {
    final provider = Provider.of<GalaxyProvider>(context, listen: false);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      builder: (_) => OnboardingSheet(
        onRegister: (name, email, focusArea) {
          provider.registerUser(name, email, focusArea);
        },
      ),
    );
  }

  void _showHabitDetail(BuildContext context, Habit habit) {
    final provider = Provider.of<GalaxyProvider>(context, listen: false);
    provider.selectHabit(habit);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => HabitDetailSheet(
        habit: habit,
        onToggleComplete: () {
          provider.toggleHabitCompletion(habit.id);
          setState(() {});
        },
        onStartTimer: () {
          _showHabitTimer(context, habit);
        },
        onClose: () {
          provider.selectHabit(null);
          Navigator.pop(context);
        },
      ),
    ).whenComplete(() {
      provider.selectHabit(null);
    });
  }

  void _showHabitTimer(BuildContext context, Habit habit) {
    final provider = Provider.of<GalaxyProvider>(context, listen: false);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => HabitTimerSheet(
        habit: habit,
        onCompleted: () {
          if (!habit.isCompletedToday) {
            provider.toggleHabitCompletion(habit.id);
          }
        },
      ),
    );
  }

  void _showMoodSelector(BuildContext context) {
    final provider = Provider.of<GalaxyProvider>(context, listen: false);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => MoodSelectorSheet(
        currentMood: provider.currentMood,
        onSelectMood: (moodType) {
          provider.setMood(moodType);
        },
        onClose: () => Navigator.pop(context),
      ),
    );
  }

  void _showAddHabit(BuildContext context) {
    final provider = Provider.of<GalaxyProvider>(context, listen: false);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => AddHabitSheet(
        onAddHabit: (title, description, icon) {
          provider.addHabit(title: title, description: description, icon: icon);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GalaxyProvider>(
      builder: (context, provider, child) {
        _checkOnboarding(provider);

        if (provider.isLoading) {
          return const Scaffold(
            backgroundColor: Color(0xFF070814),
            body: Center(
              child: CircularProgressIndicator(color: Color(0xFF00E5FF)),
            ),
          );
        }

        final totalStreak = provider.habits.fold<int>(
          0,
          (sum, h) => sum + h.streak,
        );

        return Scaffold(
          backgroundColor: const Color(0xFF070814),
          body: GestureDetector(
            onScaleUpdate: (details) {
              if (details.scale != 1.0) {
                provider.setZoom(provider.zoom * details.scale);
              }
              if (details.focalPointDelta != Offset.zero) {
                provider.setPan(details.focalPointDelta);
              }
            },
            child: Stack(
              children: [
                // 1. CustomPainter Space Background & Orbits
                Positioned.fill(
                  child: CustomPaint(
                    painter: GalaxyPainter(
                      mood: provider.currentMood,
                      habits: provider.habits,
                      animationValue: _tickerController.value * 2 * math.pi,
                      panOffset: provider.panOffset,
                      zoom: provider.zoom,
                    ),
                  ),
                ),

                // 2. Center Sun Core (Mood Star)
                Positioned.fill(
                  child: Center(
                    child: Transform.translate(
                      offset: provider.panOffset,
                      child: SunCoreWidget(
                        mood: provider.currentMood,
                        animation: _tickerController,
                        onTap: () => _showMoodSelector(context),
                      ),
                    ),
                  ),
                ),

                // 3. Orbiting Planet Nodes
                ...provider.habits.map((habit) {
                  final center = Offset(
                    MediaQuery.of(context).size.width / 2 +
                        provider.panOffset.dx,
                    MediaQuery.of(context).size.height / 2 +
                        provider.panOffset.dy,
                  );

                  final radius = habit.orbitRadius * provider.zoom;
                  final x = center.dx + math.cos(habit.currentAngle) * radius;
                  final y = center.dy + math.sin(habit.currentAngle) * radius;

                  return Positioned(
                    left: x - (habit.size / 2),
                    top: y - (habit.size / 2),
                    child: Transform.scale(
                      scale: provider.zoom.clamp(0.7, 1.3),
                      child: PlanetNodeWidget(
                        habit: habit,
                        onTap: () => _showHabitDetail(context, habit),
                        onDoubleTap: () {
                          provider.toggleHabitCompletion(habit.id);
                        },
                      ),
                    ),
                  );
                }),

                // 4. HUD Navigation Bar
                HudBar(
                  totalStreak: totalStreak,
                  onAddHabit: () => _showAddHabit(context),
                  onChangeMood: () => _showMoodSelector(context),
                  onResetView: () => provider.resetCamera(),
                ),

                // 5. User Profile / Welcome Badge (Bottom Left)
                Positioned(
                  bottom: 24,
                  left: 16,
                  child: GestureDetector(
                    onTap: () => _showOnboarding(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFF00E5FF).withValues(alpha: 0.4)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.person, color: Color(0xFF00E5FF), size: 14),
                          const SizedBox(width: 6),
                          Text(
                            provider.userProfile.isRegistered
                                ? provider.userProfile.name
                                : 'Tap to Register',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // 6. Bottom Instructions Overlay
                Positioned(
                  bottom: 24,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white12),
                      ),
                      child: const Text(
                        '✨ Drag to pan • Pinch to zoom • Tap planet for timer & habits',
                        style: TextStyle(
                          color: Colors.white60,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
