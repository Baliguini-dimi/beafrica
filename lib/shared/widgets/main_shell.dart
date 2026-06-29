// lib/shared/widgets/main_shell.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_typography.dart';
import '../../core/router/app_router.dart';

class MainShell extends StatelessWidget {
  final Widget child;

  const MainShell({super.key, required this.child});

  static const List<String> _routes = [
    AppRouter.home,
    AppRouter.medias,
    AppRouter.histoire,
    AppRouter.marche,
    AppRouter.communaute,
  ];

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    final index = _routes.indexWhere((r) => location.startsWith(r));
    return index < 0 ? 0 : index;
  }

  @override
  Widget build(BuildContext context) {
    final index = _currentIndex(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        title: Row(
          children: [
            Image.asset(
              'assets/images/logo/beafrica_logo.png',
              height: 28,
              width: 28,
            ),
            const SizedBox(width: 8),
            Text('BéAfrica', style: AppTypography.headlineMedium),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push(AppRouter.settings),
            tooltip: 'Paramètres',
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppColors.divider),
        ),
      ),
      body: child,
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Divider(height: 1, thickness: 1, color: AppColors.divider),
          BottomNavigationBar(
            currentIndex: index,
            onTap: (i) => context.go(_routes[i]),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: AppStrings.navHome,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.newspaper_outlined),
                activeIcon: Icon(Icons.newspaper),
                label: AppStrings.navMedias,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.account_balance_outlined),
                activeIcon: Icon(Icons.account_balance),
                label: AppStrings.navHistoire,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.storefront_outlined),
                activeIcon: Icon(Icons.storefront),
                label: AppStrings.navMarche,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.people_outlined),
                activeIcon: Icon(Icons.people),
                label: AppStrings.navCommunaute,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
