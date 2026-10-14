import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/galaxy_provider.dart';
import 'screens/galaxy_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MorphApp());
}

class MorphApp extends StatelessWidget {
  const MorphApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GalaxyProvider(),
      child: MaterialApp(
        title: 'Morph - Habit Galaxy',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: const Color(0xFF070814),
          colorScheme: ColorScheme.dark(
            primary: const Color(0xFF00E5FF),
            secondary: const Color(0xFFFF85A1),
            surface: const Color(0xFF101223),
          ),
          fontFamily: 'sans-serif',
        ),
        home: const GalaxyScreen(),
      ),
    );
  }
}
