import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/themes/app_theme.dart';
import 'core/config/firebase_config.dart';
import 'features/auth/data/repositories/firebase_auth_repository.dart';
import 'features/auth/data/repositories/mock_auth_repository.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/exercises/data/repositories/mock_exercise_repository.dart';
import 'features/exercises/domain/repositories/exercise_repository.dart';
import 'features/home/presentation/pages/home_page.dart';
import 'features/workouts/data/repositories/mock_workout_repository.dart';
import 'features/workouts/domain/repositories/workout_repository.dart';
import 'features/calendar/data/repositories/mock_calendar_repository.dart';
import 'features/calendar/domain/repositories/calendar_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'features/onboarding/presentation/pages/onboarding_page.dart';
import 'core/di/injection.dart';
import 'features/gamification/presentation/bloc/gamification_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    // Initialisation de la DB pour le Web
    databaseFactory = databaseFactoryFfiWeb;
  }

  // Initialiser Firebase
  AuthRepository authRepository;

  // TEMPORAIRE: Forcer le mode Mock pour tester l'application
  // Pour activer Firebase, changez cette ligne en: if (FirebaseConfig.isConfigured) {
  if (false) {
    // Mode Mock forcé
    try {
      await Firebase.initializeApp(
        options: FirebaseOptions(
          apiKey: FirebaseConfig.apiKey,
          authDomain: FirebaseConfig.authDomain,
          projectId: FirebaseConfig.projectId,
          storageBucket: FirebaseConfig.storageBucket,
          messagingSenderId: FirebaseConfig.messagingSenderId,
          appId: FirebaseConfig.appId,
          measurementId: FirebaseConfig.measurementId,
          databaseURL: FirebaseConfig.databaseURL, // Realtime Database URL
        ),
      );

      // Utiliser Firebase Auth
      authRepository = FirebaseAuthRepository();
      print('✅ Firebase initialisé avec succès!');
    } catch (e) {
      print('⚠️ Erreur Firebase: $e - Utilisation du mode Mock');
      authRepository = MockAuthRepository();
    }
  } else {
    print('⚠️ Firebase non configuré - Utilisation du mode Mock');
    print('📖 Consultez FIREBASE_SETUP.md pour configurer Firebase');
    authRepository = MockAuthRepository();
  }

  configureDependencies();

  runApp(FitTrackApp(authRepository: authRepository));
}

class FitTrackApp extends StatelessWidget {
  final AuthRepository _authRepository;

  const FitTrackApp({
    super.key,
    required AuthRepository authRepository,
  }) : _authRepository = authRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: _authRepository),
        RepositoryProvider<ExerciseRepository>(
          create: (_) => MockExerciseRepository(),
        ),
        RepositoryProvider<WorkoutRepository>(
          create: (_) => MockWorkoutRepository(), // Mock pour le web
        ),
        RepositoryProvider<CalendarRepository>(
          create: (_) => MockCalendarRepository(), // Mock pour le web
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => AuthBloc(authRepository: _authRepository)),
          BlocProvider(create: (_) => GamificationCubit()),
        ],
        child: const AppView(),
      ),
    );
  }
}

class AppView extends StatefulWidget {
  const AppView({super.key});

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  bool? _hasSeenOnboarding;

  @override
  void initState() {
    super.initState();
    _checkOnboarding();
  }

  Future<void> _checkOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _hasSeenOnboarding = prefs.getBool('has_seen_onboarding') ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_hasSeenOnboarding == null) {
      return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }

    return MaterialApp(
      title: 'FitTrack',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: _hasSeenOnboarding!
          ? BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                switch (state.status) {
                  case AuthStatus.authenticated:
                    return const HomePage();
                  case AuthStatus.unauthenticated:
                    return const LoginPage();
                  case AuthStatus.unknown:
                  default:
                    return const Scaffold(
                      body: Center(child: CircularProgressIndicator()),
                    );
                }
              },
            )
          : const OnboardingPage(),
    );
  }
}
