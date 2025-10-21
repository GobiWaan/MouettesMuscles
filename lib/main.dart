import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'services/hive_service.dart';
import 'services/rest_timer_service.dart';
import 'services/interval_timer_service.dart';
import 'services/notification_sound_service.dart';
import 'providers/workout_provider.dart';
import 'providers/run_provider.dart';
import 'providers/weight_provider.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize date formatting for French Canadian locale
  await initializeDateFormatting('fr_CA', null);

  // Initialize Hive
  await HiveService.init();

  // Initialize notifications
  await NotificationSoundService().initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WorkoutProvider()),
        ChangeNotifierProvider(create: (_) => RunProvider()),
        ChangeNotifierProvider(create: (_) => WeightProvider()),
        ChangeNotifierProvider(create: (_) => RestTimerService()),
        ChangeNotifierProvider(create: (_) => IntervalTimerService()),
      ],
      child: MaterialApp(
        title: 'Mouette Musclé',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme(
            primary: const Color(0xFFBEA139), // A more sober gold
            secondary: const Color(0xFFBEA139), // Using the same for secondary
            surface: const Color(0xFF1E1E1E),
            background: const Color(0xFF121212),
            error: Colors.red,
            onPrimary: Colors.black,
            onSecondary: Colors.black,
            onSurface: Colors.white,
            onBackground: Colors.white,
            onError: Colors.white,
            brightness: Brightness.dark,
          ),
          textTheme: GoogleFonts.bebasNeueTextTheme(
            ThemeData.dark().textTheme,
          ).apply(
            bodyColor: Colors.white,
            displayColor: Colors.white,
          ),
          useMaterial3: true,
          cardTheme: CardThemeData(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
