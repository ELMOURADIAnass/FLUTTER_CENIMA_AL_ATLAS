import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/booking_provider.dart';
import 'providers/language_provider.dart';
import 'providers/movie_provider.dart';
import 'providers/reservation_provider.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'services/database_service.dart';
import 'services/auth_repository.dart';
import 'utils/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive database
  await DatabaseService.initialize();

  // Initialize authentication
  await AuthRepository.initialize();

  runApp(const CinemaAtlasApp());
}

// Root widget with MultiProvider setup
class CinemaAtlasApp extends StatefulWidget {
  const CinemaAtlasApp({super.key});

  @override
  State<CinemaAtlasApp> createState() => _CinemaAtlasAppState();
}

class _CinemaAtlasAppState extends State<CinemaAtlasApp> {
  late ReservationProvider _reservationProvider;
  late AuthProvider _authProvider;

  @override
  void initState() {
    super.initState();
    _reservationProvider = ReservationProvider();
    _reservationProvider.initialize();

    _authProvider = AuthProvider();
    _authProvider.initialize();
  }

  @override
  void dispose() {
    _reservationProvider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ChangeNotifierProvider(create: (_) => MovieProvider()),
        ChangeNotifierProvider(create: (_) => BookingProvider()),
        ChangeNotifierProvider(create: (_) => _reservationProvider),
        ChangeNotifierProvider(create: (_) => _authProvider),
      ],
      child: Consumer<LanguageProvider>(
        builder: (context, languageProvider, child) {
          return MaterialApp(
            title: 'Cinéma Al-ATLAS',
            debugShowCheckedModeBanner: false,
            // Theme configuration
            theme: AppTheme.darkTheme,
            // Localization support
            locale: languageProvider.locale,
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('fr'),
              Locale('en'),
              Locale('ar'),
            ],
            // Route definitions
            routes: {
              '/home': (context) => const HomeScreen(),
              '/login': (context) => const LoginScreen(),
            },
            // Main entry point - determine based on auth state
            home: Consumer<AuthProvider>(
              builder: (context, authProvider, _) {
                if (authProvider.isLoggedIn) {
                  return const HomeScreen();
                } else {
                  return const LoginScreen();
                }
              },
            ),
          );
        },
      ),
    );
  }
}
