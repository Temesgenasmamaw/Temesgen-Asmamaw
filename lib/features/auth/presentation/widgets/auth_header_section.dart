import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';

class AuthHeaderSection extends StatelessWidget {
  final String selectedLanguage;
  final List<String> languages;
  final ValueChanged<String> onLanguageChanged;
  final String userName;
  final String phoneNumber;

  const AuthHeaderSection({
    super.key,
    required this.selectedLanguage,
    required this.languages,
    required this.onLanguageChanged,
    this.userName = 'John Kamau',
    this.phoneNumber = '+254 7** *** 678',
  });

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    final headerHeight = 210.0 + topPadding;

    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(36),
        bottomRight: Radius.circular(36),
      ),
      child: Container(
        height: headerHeight,
        width: double.infinity,
        decoration: const BoxDecoration(color: AppColors.safaricomRed),
        child: Stack(
          children: [
            // ── 1. Pure Canvas Red Diagonal Stripes (Renders instantly without asset/network dependency) ──
            const Positioned.fill(
              child: CustomPaint(painter: RedDiagonalStripesPainter()),
            ),

            // ── 2. Asset Image Overlay (Blends seamlessly if asset bundle is loaded) ──
            Positioned.fill(
              child: Image.asset(
                'assets/images/red_header.png',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const SizedBox.shrink(),
              ),
            ),

            // ── 3. Top Bar: Language Selector (Left Side Only) ──
            Positioned(
              top: topPadding + 10,
              left: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.space12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha: 0.22),
                  borderRadius: BorderRadius.circular(AppSizes.radiusCircular),
                  border: Border.all(
                    color: AppColors.white.withValues(alpha: 0.4),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.language,
                      color: AppColors.white,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedLanguage,
                        icon: const Icon(
                          Icons.keyboard_arrow_down,
                          color: AppColors.white,
                          size: 18,
                        ),
                        dropdownColor: AppColors.darkRed,
                        style: AppTextStyles.labelMedium.copyWith(
                          color: AppColors.white,
                        ),
                        isDense: true,
                        items: languages.map((lang) {
                          return DropdownMenuItem(
                            value: lang,
                            child: Text(
                              lang,
                              style: AppTextStyles.labelMedium.copyWith(
                                color: AppColors.white,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) onLanguageChanged(value);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── 4. Profile Section: Pure Avatar & Text directly on top of Image (No borders/box) ──
            Positioned(
              bottom: 22,
              left: 20,
              right: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Profile Avatar Icon
                  Container(
                    width: 60,
                    height: 60,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.white,
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.person,
                        size: 34,
                        color: AppColors.safaricomRed,
                      ),
                    ),
                  ),

                  const SizedBox(width: AppSizes.space16),

                  // User details column directly on top of image
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Welcome back',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.white.withValues(alpha: 0.9),
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        userName,
                        style: AppTextStyles.heading3.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 21,
                          letterSpacing: -0.2,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        phoneNumber,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.white.withValues(alpha: 0.9),
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Custom painter that renders the authentic Safaricom Red diagonal stripes.
/// Renders 100% on the Flutter canvas without asset bundle or network dependency,
/// guaranteeing the red background appears immediately on hot reload.
class RedDiagonalStripesPainter extends CustomPainter {
  final Color primaryColor;
  final Color stripeColor;
  final double stripeWidth;
  final double stripeSpacing;

  const RedDiagonalStripesPainter({
    this.primaryColor = const Color(0xFFE31937),
    this.stripeColor = const Color(0xFFC7132B),
    this.stripeWidth = 22.0,
    this.stripeSpacing = 22.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Draw solid primary red base
    final bgPaint = Paint()..color = primaryColor;
    canvas.drawRect(Offset.zero & size, bgPaint);

    // 2. Draw diagonal stripes from top-left to bottom-right (45 degrees)
    final stripePaint = Paint()
      ..color = stripeColor
      ..strokeWidth = stripeWidth
      ..style = PaintingStyle.stroke;

    final totalStep = stripeWidth + stripeSpacing;
    canvas.save();
    canvas.clipRect(Offset.zero & size);

    final start = -size.height * 2;
    final end = size.width + size.height * 2;

    for (double x = start; x < end; x += totalStep) {
      canvas.drawLine(
        Offset(x, -20),
        Offset(x + size.height + 40, size.height + 20),
        stripePaint,
      );
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
