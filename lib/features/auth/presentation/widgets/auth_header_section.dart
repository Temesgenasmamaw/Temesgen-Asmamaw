import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';

/// Top header section for authentication/login page with background network image,
/// language dropdown on left, brand logo on right, and curved white transition.
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

  static const String _headerImageUrl =
      'https://raw.githubusercontent.com/Temesgenasmamaw/mobile_wallet/main/assets/images/red_header.png';

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    final headerHeight = 185.0 + topPadding;

    return SizedBox(
      height: headerHeight,
      child: Stack(
        children: [
          // ── Background Red Striped Picture (Using Network Image with Asset Fallback) ──
          Positioned.fill(
            child: Image.network(
              _headerImageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Image.asset(
                'assets/images/red_header.png',
                fit: BoxFit.cover,
              ),
            ),
          ),

          // ── Top Bar: Language Selector (Left Side Only) ──
          Positioned(
            top: topPadding + 12,
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
                  const Icon(Icons.language, color: AppColors.white, size: 16),
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

          // ── Bottom Curved Edge Transition to White Body ──
          // Reverted design matching image: flat top with curved top-right corner
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 28,
              decoration: const BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.only(topRight: Radius.circular(56)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
