import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';
import '../constants/app_text_styles.dart';

/// Redesigned M-Pesa Dashboard Balance Card.
///
/// Layout:
/// - Top-left: "Main Balance" label, with balance masked (****) by default.
/// - Top-right: "Add Money" action with plus (+) icon and text.
/// - Divider: Horizontal line separating top and bottom sections.
/// - Bottom section: 3 horizontally aligned columns:
///   1. "Main Balance" label + masked value (****)
///   2. "Entire Balance" label + masked value (****)
///   3. "View Balance" eye/view icon vertically aligned with the columns.
///
/// Tapping the eye icon toggles masking/revealing of the balance values.
class BalanceCard extends StatefulWidget {
  final double balance;
  final double? entireBalance;
  final String currency;
  final bool? isBalanceVisible;
  final VoidCallback? onToggleVisibility;
  final VoidCallback? onAddMoney;

  const BalanceCard({
    super.key,
    required this.balance,
    this.entireBalance,
    this.currency = 'ETB',
    this.isBalanceVisible,
    this.onToggleVisibility,
    this.onAddMoney,
  });

  @override
  State<BalanceCard> createState() => _BalanceCardState();
}

class _BalanceCardState extends State<BalanceCard> {
  // Starts hidden/masked by default as specified in requirements.
  bool _internalIsVisible = false;

  bool get _isVisible => widget.isBalanceVisible ?? _internalIsVisible;

  void _handleToggle() {
    if (widget.onToggleVisibility != null) {
      widget.onToggleVisibility!();
    } else {
      setState(() {
        _internalIsVisible = !_internalIsVisible;
      });
    }
  }

  String _formatAmount(double amount) {
    final parts = amount.toStringAsFixed(2).split('.');
    final intPart = parts[0].replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
    return '$intPart.${parts[1]}';
  }

  @override
  Widget build(BuildContext context) {
    final effectiveEntireBalance = widget.entireBalance ?? widget.balance;
    final formattedMain = '${widget.currency} ${_formatAmount(widget.balance)}';
    final formattedEntire =
        '${widget.currency} ${_formatAmount(effectiveEntireBalance)}';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
        boxShadow: [
          BoxShadow(
            color: AppColors.safaricomRed.withValues(alpha: 0.35),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── TOP SECTION: Main Balance (left) & Add Money (right) ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top-left: Main Balance Label + Masked Amount
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Main Balance',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.white.withValues(alpha: 0.88),
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 4),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      transitionBuilder: (child, animation) =>
                          FadeTransition(opacity: animation, child: child),
                      child: Text(
                        _isVisible ? formattedMain : '****',
                        key: ValueKey('top_$_isVisible'),
                        style: _isVisible
                            ? AppTextStyles.heading1.copyWith(
                                color: AppColors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                              )
                            : AppTextStyles.heading1.copyWith(
                                color: AppColors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 26,
                                letterSpacing: 4.0,
                              ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: AppSizes.space12),

              // Top-right: Add Money Action (+ Add Money)
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: widget.onAddMoney,
                  borderRadius: BorderRadius.circular(AppSizes.radiusCircular),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.black,
                      borderRadius: BorderRadius.circular(
                        AppSizes.radiusCircular,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.25),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Iconsax.add_circle,
                          size: 15,
                          color: AppColors.white,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          'Add Money',
                          style: AppTextStyles.labelMedium.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // ── DIVIDER LINE ──
          Divider(
            color: AppColors.white.withValues(alpha: 0.25),
            height: 1,
            thickness: 1,
          ),

          const SizedBox(height: 12),

          // ── BOTTOM SECTION: 3 Horizontally Aligned Columns ──
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Column 1: Main Balance
              Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Main Balance',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.white.withValues(alpha: 0.85),
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 3),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      transitionBuilder: (child, animation) =>
                          FadeTransition(opacity: animation, child: child),
                      child: Text(
                        _isVisible ? formattedMain : '****',
                        key: ValueKey('main_$_isVisible'),
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          letterSpacing: _isVisible ? 0.2 : 2.5,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: AppSizes.space8),

              // Column 2: Entire Balance
              Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Entire Balance',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.white.withValues(alpha: 0.85),
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 3),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      transitionBuilder: (child, animation) =>
                          FadeTransition(opacity: animation, child: child),
                      child: Text(
                        _isVisible ? formattedEntire : '****',
                        key: ValueKey('entire_$_isVisible'),
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          letterSpacing: _isVisible ? 0.2 : 2.5,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: AppSizes.space8),

              // Column 3: View Balance (Eye Icon)
              // Vertically aligned with Main Balance and Entire Balance columns
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _handleToggle,
                  borderRadius: BorderRadius.circular(AppSizes.radiusCircular),
                  child: Tooltip(
                    message: _isVisible ? 'Hide Balance' : 'View Balance',
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.white.withValues(alpha: 0.18),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _isVisible ? Iconsax.eye_slash : Iconsax.eye,
                        color: AppColors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
