// lib/core/router/app_router.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Screens — Onboarding
import '../../features/onboarding/presentation/screens/splash_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';

// Screens — Main Shell
import '../../shared/widgets/main_shell.dart';

// Screens — Placeholders (seront remplacés sprint par sprint)
import '../../shared/widgets/coming_soon_screen.dart';

class AppRouter {
  AppRouter._();

  // Clé pour savoir si l'onboarding a déjà été vu
  static const String _onboardingKey = 'onboarding_done';

  // Noms des routes — on utilise des constantes pour éviter les typos
  static const String splash      = '/';
  static const String onboarding  = '/onboarding';
  static const String home        = '/home';
  static const String medias      = '/medias';
  static const String histoire    = '/histoire';
  static const String marche      = '/marche';
  static const String communaute  = '/communaute';
  static const String culture     = '/culture';
  static const String astuces     = '/astuces';
  static const String dictionnaire = '/dictionnaire';
  static const String devises     = '/devises';
  static const String meteo       = '/meteo';
  static const String chatbot     = '/chatbot';

  static final GoRouter router = GoRouter(
    initialLocation: splash,
    debugLogDiagnostics: false,

    // redirect : vérifie si l'onboarding a été vu
    // Si non → redirige vers /onboarding
    // Si oui → laisse passer
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
      GoRoute(
        path: splash,
        builder: (context, state) => const SplashScreen(),
      ),

      // Onboarding
      GoRoute(
        path: onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),

      // Shell principal avec BottomNavigationBar
      ShellRoute(
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          GoRoute(
            path: home,
            builder: (context, state) => const ComingSoonScreen(
              moduleName: 'Accueil',
              moduleDescription: 'Votre tableau de bord centrafricain.',
              icon: Icons.home_outlined,
            ),
          ),
          GoRoute(
            path: medias,
            builder: (context, state) => const ComingSoonScreen(
              moduleName: 'Médias & Actualités',
              moduleDescription: 'Les dernières nouvelles de RCA.',
              icon: Icons.newspaper_outlined,
            ),
          ),
          GoRoute(
            path: histoire,
            builder: (context, state) => const ComingSoonScreen(
              moduleName: 'Histoire & Patrimoine',
              moduleDescription: 'L\'encyclopédie culturelle de la RCA.',
              icon: Icons.account_balance_outlined,
            ),
          ),
          GoRoute(
            path: marche,
            builder: (context, state) => const ComingSoonScreen(
              moduleName: 'Marché',
              moduleDescription: 'Achetez et vendez des produits centrafricains.',
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

      // Routes secondaires (accessibles depuis menu/accueil)
      GoRoute(
        path: culture,
        builder: (context, state) => const ComingSoonScreen(
          moduleName: 'Culture & Artisanat',
          moduleDescription: 'La richesse culturelle vivante de la RCA.',
          icon: Icons.palette_outlined,
        ),
      ),
      GoRoute(
        path: astuces,
        builder: (context, state) => const ComingSoonScreen(
          moduleName: 'Astuces & Conseils',
          moduleDescription: 'Guides pratiques pour vivre en RCA.',
          icon: Icons.lightbulb_outlined,
        ),
      ),
      GoRoute(
        path: dictionnaire,
        builder: (context, state) => const ComingSoonScreen(
          moduleName: 'Dictionnaire Sango',
          moduleDescription: 'Apprenez le Sango, langue nationale de la RCA.',
          icon: Icons.menu_book_outlined,
        ),
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
        builder: (context, state) => const ComingSoonScreen(
          moduleName: 'Météo',
          moduleDescription: 'La météo des villes principales de RCA.',
          icon: Icons.wb_sunny_outlined,
        ),
      ),
      GoRoute(
        path: chatbot,
        builder: (context, state) => const ComingSoonScreen(
          moduleName: 'Kôdô — Assistant IA',
          moduleDescription: 'Votre guide intelligent sur la RCA.',
          icon: Icons.chat_outlined,
        ),
      ),
    ],
  );
}