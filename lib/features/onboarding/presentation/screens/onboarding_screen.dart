// lib/features/onboarding/presentation/screens/onboarding_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/router/app_router.dart';
import '../widgets/onboarding_slide.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _totalPages = 3;

  // Les 3 slides avec leurs contenus
  late final List<OnboardingSlide> _slides = [
    OnboardingSlide(
      illustration: _SlideIllustration1(),
      title: AppStrings.onboarding1Title,
      subtitle: AppStrings.onboarding1Subtitle,
    ),
    OnboardingSlide(
      illustration: _SlideIllustration2(),
      title: AppStrings.onboarding2Title,
      subtitle: AppStrings.onboarding2Subtitle,
    ),
    OnboardingSlide(
      illustration: _SlideIllustration3(),
      title: AppStrings.onboarding3Title,
      subtitle: AppStrings.onboarding3Subtitle,
    ),
  ];

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_done', true);
    if (mounted) context.go(AppRouter.home);
  }

  void _nextPage() {
    if (_currentPage < _totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Bouton "Passer" en haut à droite
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(
                  top: AppSpacing.lg,
                  right: AppSpacing.lg,
                ),
                child: _currentPage < _totalPages - 1
                    ? TextButton(
                        onPressed: _completeOnboarding,
                        child: Text(
                          AppStrings.skip,
                          style: AppTypography.labelLarge.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      )
                    : const SizedBox(height: 40),
              ),
            ),

            // Pages
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _totalPages,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                itemBuilder: (context, index) => _slides[index],
              ),
            ),

            // Indicateurs de progression (dots)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _totalPages,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xs,
                  ),
                  width: _currentPage == index ? 24.0 : 8.0,
                  height: 8.0,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? AppColors.primary
                        : AppColors.border,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.xl),

            // Bouton principal
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xl,
              ),
              child: ElevatedButton(
                onPressed: _nextPage,
                child: Text(
                  _currentPage < _totalPages - 1
                      ? AppStrings.next
                      : AppStrings.getStarted,
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }
}

// ===== ILLUSTRATIONS SVG SOBRES =====
// Dessinées en Flutter pur (CustomPaint) — zéro image externe requise

class _SlideIllustration1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Slide 1 : Livre ouvert + étoile (culture & connaissance)
    return CustomPaint(
      painter: _Slide1Painter(),
      size: const Size(260, 260),
    );
  }
}

class _Slide1Painter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paintGreen = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.fill;

    final paintGold = Paint()
      ..color = AppColors.secondary
      ..style = PaintingStyle.fill;

    final paintBorder = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    final paintBg = Paint()
      ..color = AppColors.surfaceVariant
      ..style = PaintingStyle.fill;

    final cx = size.width / 2;
    final cy = size.height / 2;

    // Cercle de fond doux
    canvas.drawCircle(
      Offset(cx, cy),
      110,
      paintBg,
    );

    // Livre — page gauche
    final bookLeft = Path()
      ..moveTo(cx - 8, cy - 50)
      ..lineTo(cx - 8, cy + 55)
      ..quadraticBezierTo(cx - 50, cy + 50, cx - 75, cy + 45)
      ..lineTo(cx - 75, cy - 55)
      ..quadraticBezierTo(cx - 50, cy - 52, cx - 8, cy - 50)
      ..close();
    canvas.drawPath(bookLeft, paintGreen..color = AppColors.primaryLight);
    canvas.drawPath(bookLeft, paintBorder);

    // Livre — page droite
    final bookRight = Path()
      ..moveTo(cx + 8, cy - 50)
      ..lineTo(cx + 8, cy + 55)
      ..quadraticBezierTo(cx + 50, cy + 50, cx + 75, cy + 45)
      ..lineTo(cx + 75, cy - 55)
      ..quadraticBezierTo(cx + 50, cy - 52, cx + 8, cy - 50)
      ..close();
    canvas.drawPath(
      bookRight,
      Paint()
        ..color = AppColors.surface
        ..style = PaintingStyle.fill,
    );
    canvas.drawPath(bookRight, paintBorder);

    // Lignes de texte sur page droite (sobres)
    final linePaint = Paint()
      ..color = AppColors.border
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < 5; i++) {
      final y = cy - 25.0 + (i * 16);
      final width = i == 4 ? 35.0 : 55.0;
      canvas.drawLine(
        Offset(cx + 18, y),
        Offset(cx + 18 + width, y),
        linePaint,
      );
    }

    // Étoile dorée en haut
    _drawStar(canvas, Offset(cx, cy - 75), 18, paintGold);

    // Spine du livre (milieu)
    canvas.drawLine(
      Offset(cx, cy - 50),
      Offset(cx, cy + 55),
      Paint()
        ..color = AppColors.primary
        ..strokeWidth = 3,
    );
  }

  void _drawStar(Canvas canvas, Offset center, double size, Paint paint) {
    final path = Path();
    for (int i = 0; i < 5; i++) {
      final angle = (i * 4 * 3.14159 / 5) - 3.14159 / 2;
      final innerAngle = ((i * 4 + 2) * 3.14159 / 5) - 3.14159 / 2;
      final x = center.dx + size * 0.95 * cos(angle);
      final y = center.dy + size * 0.95 * sin(angle);
      final ix = center.dx + size * 0.4 * cos(innerAngle);
      final iy = center.dy + size * 0.4 * sin(innerAngle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
      path.lineTo(ix, iy);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  double cos(double angle) => _cos(angle);
  double sin(double angle) => _sin(angle);

  double _cos(double x) {
    // Approximation Taylor suffisante pour les angles simples
    x = x % (2 * 3.14159265);
    return 1 - (x * x) / 2 + (x * x * x * x) / 24;
  }

  double _sin(double x) {
    x = x % (2 * 3.14159265);
    return x - (x * x * x) / 6 + (x * x * x * x * x) / 120;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _SlideIllustration2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _Slide2Painter(),
      size: const Size(260, 260),
    );
  }
}

class _Slide2Painter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    // Cercle de fond doux
    canvas.drawCircle(
      Offset(cx, cy),
      110,
      Paint()
        ..color = AppColors.surfaceVariant
        ..style = PaintingStyle.fill,
    );

    // Silhouette Afrique simplifiée (forme géométrique sobre)
    final africaPaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.fill;

    final africa = Path()
      ..moveTo(cx - 25, cy - 70)
      ..lineTo(cx + 30, cy - 65)
      ..lineTo(cx + 45, cy - 30)
      ..lineTo(cx + 40, cy + 10)
      ..lineTo(cx + 20, cy + 50)
      ..lineTo(cx - 5, cy + 75)
      ..lineTo(cx - 20, cy + 55)
      ..lineTo(cx - 40, cy + 20)
      ..lineTo(cx - 45, cy - 20)
      ..lineTo(cx - 35, cy - 50)
      ..close();
    canvas.drawPath(africa, africaPaint);

    // Point RCA (étoile dorée au centre de l'Afrique)
    canvas.drawCircle(
      Offset(cx + 5, cy - 5),
      10,
      Paint()
        ..color = AppColors.secondary
        ..style = PaintingStyle.fill,
    );
    canvas.drawCircle(
      Offset(cx + 5, cy - 5),
      10,
      Paint()
        ..color = AppColors.surface
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    // 3 personnes stylisées (cercles + lignes sobres)
    final positions = [
      Offset(cx - 60, cy + 30),
      Offset(cx, cy + 55),
      Offset(cx + 60, cy + 30),
    ];

    for (final pos in positions) {
      // Tête
      canvas.drawCircle(
        Offset(pos.dx, pos.dy - 18),
        10,
        Paint()
          ..color = AppColors.secondary
          ..style = PaintingStyle.fill,
      );
      // Corps
      canvas.drawLine(
        Offset(pos.dx, pos.dy - 8),
        Offset(pos.dx, pos.dy + 15),
        Paint()
          ..color = AppColors.textSecondary
          ..strokeWidth = 3,
      );
    }

    // Lignes de connexion entre les personnes
    final linePaint = Paint()
      ..color = AppColors.primaryLight.withOpacity(0.5)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    canvas.drawLine(
      Offset(positions[0].dx + 10, positions[0].dy - 18),
      Offset(positions[1].dx - 10, positions[1].dy - 18),
      linePaint,
    );
    canvas.drawLine(
      Offset(positions[1].dx + 10, positions[1].dy - 18),
      Offset(positions[2].dx - 10, positions[2].dy - 18),
      linePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _SlideIllustration3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _Slide3Painter(),
      size: const Size(260, 260),
    );
  }
}

class _Slide3Painter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    // Cercle de fond
    canvas.drawCircle(
      Offset(cx, cy),
      110,
      Paint()
        ..color = AppColors.surfaceVariant
        ..style = PaintingStyle.fill,
    );

    // Panier/sac de marché (artisanat)
    final basketPaint = Paint()
      ..color = AppColors.secondary
      ..style = PaintingStyle.fill;

    final basket = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(cx, cy + 10),
        width: 90,
        height: 70,
      ),
      const Radius.circular(8),
    );
    canvas.drawRRect(basket, basketPaint);

    // Lignes du panier (motif tressé sobre)
    final weavePaint = Paint()
      ..color = AppColors.primaryDark.withOpacity(0.3)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    for (int i = 1; i < 4; i++) {
      canvas.drawLine(
        Offset(cx - 45, cy - 25 + (i * 16)),
        Offset(cx + 45, cy - 25 + (i * 16)),
        weavePaint,
      );
    }
    for (int i = 1; i < 5; i++) {
      canvas.drawLine(
        Offset(cx - 45 + (i * 18), cy - 25),
        Offset(cx - 45 + (i * 18), cy + 45),
        weavePaint,
      );
    }

    // Anse du panier
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(cx, cy - 25),
        width: 60,
        height: 40,
      ),
      3.14159,
      3.14159,
      false,
      Paint()
        ..color = AppColors.primary
        ..strokeWidth = 4
        ..style = PaintingStyle.stroke,
    );

    // Motif géométrique centrafricain au-dessus (diamant)
    final diamondPaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.fill;

    final diamond = Path()
      ..moveTo(cx, cy - 65)
      ..lineTo(cx + 18, cy - 48)
      ..lineTo(cx, cy - 31)
      ..lineTo(cx - 18, cy - 48)
      ..close();
    canvas.drawPath(diamond, diamondPaint);

    // Petit carré au centre du diamant
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(cx, cy - 48),
        width: 10,
        height: 10,
      ),
      Paint()
        ..color = AppColors.secondary
        ..style = PaintingStyle.fill,
    );

    // Tag prix (étiquette sobre)
    final tagRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(cx + 55, cy - 10),
        width: 38,
        height: 22,
      ),
      const Radius.circular(4),
    );
    canvas.drawRRect(
      tagRect,
      Paint()
        ..color = AppColors.surface
        ..style = PaintingStyle.fill,
    );
    canvas.drawRRect(
      tagRect,
      Paint()
        ..color = AppColors.border
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
