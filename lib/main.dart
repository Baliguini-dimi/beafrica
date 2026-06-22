import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Note : Firebase sera initialisé au Sprint 2 quand google-services.json sera prêt.
// Pour l'instant, on prépare la structure sans Firebase pour pouvoir tester.

Future<void> main() async {
  // WidgetsFlutterBinding.ensureInitialized() est obligatoire avant tout
  // appel asynchrone dans main(). Il initialise le binding Flutter/Dart.
  WidgetsFlutterBinding.ensureInitialized();

  // Charger les variables d'environnement depuis .env
  await dotenv.load(fileName: '.env');

  // ProviderScope est le widget racine de Riverpod.
  // Il permet à tous les widgets enfants d'accéder aux providers.
  runApp(
    const ProviderScope(
      child: BeAfricaApp(),
    ),
  );
}

class BeAfricaApp extends StatelessWidget {
  const BeAfricaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BéAfrica',
      debugShowCheckedModeBanner: false,
      // Le thème complet sera défini au Sprint 1
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1A6B3C), // AppColors.primary
        ),
        useMaterial3: true,
      ),
      home: const _PlaceholderHome(),
    );
  }
}

// Écran temporaire — sera remplacé au Sprint 1 par le vrai SplashScreen
class _PlaceholderHome extends StatelessWidget {
  const _PlaceholderHome();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F6F2),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.public,
              size: 64,
              color: Color(0xFF1A6B3C),
            ),
            const SizedBox(height: 16),
            Text(
              'BéAfrica',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    color: const Color(0xFF1A6B3C),
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Découvrez le cœur de l\'Afrique.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF5C5C5C),
                  ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Sprint 0 — Setup ✓',
              style: TextStyle(
                color: Color(0xFF2E7D32),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}