import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';

/// Top header section for authentication/login page with background gradient,
/// language dropdown on left, brand logo on right, and centered user profile information.
class AuthHeaderSection extends StatelessWidget {
  final String selectedLanguage;
  final List<String> languages;
  final ValueChanged<String> onLanguageChanged;

  const AuthHeaderSection({
    super.key,
    required this.selectedLanguage,
    required this.languages,
    required this.onLanguageChanged,
  });

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    final headerHeight = 250.0 + topPadding;

    return SizedBox(
      height: headerHeight,
      child: Stack(
        children: [
          // Background Gradient Image
          Container(
            width: double.infinity,
            height: headerHeight,
            decoration: const BoxDecoration(gradient: AppColors.headerGradient),
          ),

          // Diagonal stripe pattern overlay
          Positioned.fill(
            child: CustomPaint(painter: _DiagonalStripesPainter()),
          ),

          // Bottom smooth curved edge transitioning to white section
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 24,
              decoration: const BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
            ),
          ),

          // Top Bar: Language Selector (Left) & Logo (Right)
          Positioned(
            top: topPadding + 10,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Language Selector (Left Side with Internationalization Icon)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.space12,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(
                      AppSizes.radiusCircular,
                    ),
                    border: Border.all(
                      color: AppColors.white.withValues(alpha: 0.35),
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

                // Brand Logo (Right Side)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.account_balance_wallet,
                        color: AppColors.safaricomRed,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'M-PESA',
                      style: AppTextStyles.heading4.copyWith(
                        color: AppColors.white,
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // User Profile Information: Positioned around center of the image
          Positioned(
            left: 24,
            right: 24,
            top: topPadding + 64,
            bottom: 24,
            child: const Center(child: _ProfileSection()),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// USER PROFILE SECTION – icon & details in same row, different columns
// ─────────────────────────────────────────────────────────────────────────────

class _ProfileSection extends StatelessWidget {
  const _ProfileSection();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Column 1: Circular User/Profile Icon
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.white.withValues(alpha: 0.18),
            border: Border.all(color: AppColors.white, width: 2.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: const Icon(Icons.person, size: 38, color: AppColors.white),
        ),

        const SizedBox(width: AppSizes.space16),

        // Column 2: User details with high contrast against the background
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // User's name
            // Welcome message
            Text(
              'Welcome back!',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.white.withValues(alpha: 0.85),
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'Abebe Bekele',
              style: AppTextStyles.heading3.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 2),

            // Registered phone number
            Text(
              '+251 9XX XXX XXX',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.white.withValues(alpha: 0.9),
                letterSpacing: 0.8,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
          ],
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// DIAGONAL STRIPES PAINTER
// ─────────────────────────────────────────────────────────────────────────────

class _DiagonalStripesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8.0;

    const spacing = 28.0;
    final count = (size.width + size.height) ~/ spacing + 4;

    for (int i = 0; i < count; i++) {
      final offset = i * spacing - size.height;
      canvas.drawLine(
        Offset(offset, size.height),
        Offset(offset + size.height, 0),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
