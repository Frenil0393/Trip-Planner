import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme.dart';
import 'data/local_db/db_helper.dart';
import 'providers/auth_provider.dart';
import 'providers/trip_provider.dart';
import 'providers/ui_provider.dart';
import 'presentation/screens/auth_gate.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final authProvider = AuthProvider();
  final tripProvider = TripProvider();

  // Initialize SQLite database and restore session in parallel without blocking UI rendering
  DatabaseHelper.instance.init().then((_) {
    authProvider.restoreSession().then((_) {
      tripProvider.loadTrips(userId: authProvider.currentUser?.id);
    });
  }).catchError((e) {
    debugPrint('[DatabaseHelper] Background init notice: $e');
  });

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: authProvider),
        ChangeNotifierProvider.value(value: tripProvider),
        ChangeNotifierProvider(create: (_) => UiProvider()),
      ],
      child: const AITripPlannerApp(),
    ),
  );
}


class AITripPlannerApp extends StatelessWidget {
  const AITripPlannerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UiProvider>(
      builder: (context, uiProvider, child) {
        return MaterialApp(
          title: 'AI Trip Planner',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: uiProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          home: const AuthGate(),
        );
      },
    );
  }
}
