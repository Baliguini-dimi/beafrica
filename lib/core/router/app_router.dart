// lib/core/router/app_router.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Screens — Onboarding
import '../../features/onboarding/presentation/screens/splash_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';

// Screens — Main Shell
import '../../shared/widgets/main_shell.dart';

// Screens — Placeholders
import '../../shared/widgets/coming_soon_screen.dart';

// Screens — Settings
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/settings/presentation/screens/about_screen.dart';
import '../../features/settings/presentation/screens/privacy_screen.dart';

// Screens — Auth
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';

// Screens — Home
import '../../features/home/presentation/screens/home_screen.dart';

// Screens — Meteo
import '../../features/meteo/presentation/screens/meteo_screen.dart';

// Screens — Medias
import '../../features/medias/presentation/screens/medias_screen.dart';
import '../../features/medias/presentation/screens/article_detail_screen.dart';
import '../../models/article_model.dart';
import '../../features/astuces/presentation/screens/astuces_screen.dart';
import '../../features/astuces/presentation/screens/astuce_detail_screen.dart';
import '../../models/astuce_model.dart';
import '../../features/dictionnaire/presentation/screens/dictionnaire_screen.dart';

// Screens — Radio
import '../../features/radio/presentation/screens/radio_screen.dart';

// Screens — Histoire
import '../../features/histoire/presentation/screens/histoire_screen.dart';
import '../../features/histoire/presentation/screens/chronologie_screen.dart';
import '../../features/histoire/presentation/screens/personnages_screen.dart';
import '../../features/histoire/presentation/screens/royaumes_screen.dart';
import '../../features/histoire/presentation/screens/contes_screen.dart';
import '../../features/histoire/presentation/screens/proverbes_screen.dart';

// Screens — Culture
import '../../features/culture/presentation/screens/culture_screen.dart';
import '../../features/culture/presentation/screens/gastronomie_screen.dart';
import '../../features/culture/presentation/screens/musique_screen.dart';
import '../../features/culture/presentation/screens/artisanat_screen.dart';
import '../../features/culture/presentation/screens/tenues_screen.dart';

class AppRouter {
  AppRouter._();

  static const String _onboardingKey = 'onboarding_done';

  // === ROUTES ===
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String home = '/home';
  static const String medias = '/medias';
  static const String histoire = '/histoire';
  static const String marche = '/marche';
  static const String communaute = '/communaute';
  static const String culture = '/culture';
  static const String astuces = '/astuces';
  static const String astuceDetail = '/astuce-detail';
  static const String dictionnaire = '/dictionnaire';
  static const String devises = '/devises';
  static const String meteo = '/meteo';
  static const String chatbot = '/chatbot';
  static const String radio = '/radio';
  static const String chronologie = '/chronologie';
  static const String personnages = '/personnages';
  static const String royaumes = '/royaumes';
  static const String contes = '/contes';
  static const String proverbes = '/proverbes';
  static const String gastronomie = '/gastronomie';
  static const String musique = '/musique';
  static const String artisanat = '/artisanat';
  static const String tenues = '/tenues';
  static const String settings = '/settings';
  static const String about = '/about';
  static const String privacy = '/privacy';

  static final GoRouter router = GoRouter(
    initialLocation: splash,
    debugLogDiagnostics: false,
    redirect: (BuildContext context, GoRouterState state) async {
      if (state.matchedLocation == splash) return null;

      final prefs = await SharedPreferences.getInstance();
      final onboardingDone = prefs.getBool(_onboardingKey) ?? false;

      if (!onboardingDone && state.matchedLocation != onboarding) {
        return onboarding;
      }
      return null;
    },
    routes: [
      // Splash
      GoRoute(path: splash, builder: (context, state) => const SplashScreen()),

      // Onboarding
      GoRoute(
        path: onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),

      // Auth
      GoRoute(path: login, builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: register,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: forgotPassword,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),

      // Shell principal
      ShellRoute(
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          // Home — vrai écran maintenant
          GoRoute(path: home, builder: (context, state) => const HomeScreen()),
          GoRoute(
            path: medias,
            builder: (context, state) => const MediasScreen(),
          ),
          GoRoute(
            path: histoire,
            builder: (context, state) => const HistoireScreen(),
          ),
          GoRoute(
            path: marche,
            builder: (context, state) => const ComingSoonScreen(
              moduleName: 'Marché',
              moduleDescription:
                  'Achetez et vendez des produits centrafricains.',
              icon: Icons.storefront_outlined,
            ),
          ),
          GoRoute(
            path: communaute,
            builder: (context, state) => const ComingSoonScreen(
              moduleName: 'Communauté',
              moduleDescription: 'Le forum de la diaspora centrafricaine.',
              icon: Icons.people_outlined,
            ),
          ),
        ],
      ),

      // Routes Histoire
      GoRoute(
        path: chronologie,
        builder: (context, state) => const ChronologieScreen(),
      ),
      GoRoute(
        path: personnages,
        builder: (context, state) => const PersonnagesScreen(),
      ),
      GoRoute(
        path: royaumes,
        builder: (context, state) => const RoyaumesScreen(),
      ),
      GoRoute(
        path: contes,
        builder: (context, state) => const ContesScreen(),
      ),
      GoRoute(
        path: proverbes,
        builder: (context, state) => const ProverbesScreen(),
      ),

      // Routes secondaires
      GoRoute(
        path: culture,
        builder: (context, state) => const CultureScreen(),
      ),
      GoRoute(
        path: gastronomie,
        builder: (context, state) => const GastronomieScreen(),
      ),
      GoRoute(
        path: musique,
        builder: (context, state) => const MusiqueScreen(),
      ),
      GoRoute(
        path: artisanat,
        builder: (context, state) => const ArtisanatScreen(),
      ),
      GoRoute(
        path: tenues,
        builder: (context, state) => const TenuesScreen(),
      ),
      GoRoute(
        path: astuces,
        builder: (context, state) => const AstucesScreen(),
      ),
      GoRoute(
        path: AppRouter.astuceDetail,
        builder: (context, state) {
          final astuce = state.extra as AstuceModel;
          return AstuceDetailScreen(astuce: astuce);
        },
      ),
      GoRoute(
        path: dictionnaire,
        builder: (context, state) => const DictionnaireScreen(),
      ),
      GoRoute(
        path: devises,
        builder: (context, state) => const ComingSoonScreen(
          moduleName: 'Convertisseur Devises',
          moduleDescription: 'Convertissez entre les monnaies africaines.',
          icon: Icons.currency_exchange,
        ),
      ),
      GoRoute(
        path: meteo,
        builder: (context, state) => const MeteoScreen(),
      ),
      GoRoute(
        path: chatbot,
        builder: (context, state) => const ComingSoonScreen(
          moduleName: 'Kôdô — Assistant IA',
          moduleDescription: 'Votre guide intelligent sur la RCA.',
          icon: Icons.chat_outlined,
        ),
      ),
      GoRoute(
        path: radio,
        builder: (context, state) => const RadioScreen(),
      ),
      GoRoute(
        path: '/article',
        builder: (context, state) {
          final article = state.extra as ArticleModel;
          return ArticleDetailScreen(article: article);
        },
      ),

      // Settings
      GoRoute(
        path: settings,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(path: about, builder: (context, state) => const AboutScreen()),
      GoRoute(
        path: privacy,
        builder: (context, state) => const PrivacyScreen(),
      ),
    ],
  );
}
