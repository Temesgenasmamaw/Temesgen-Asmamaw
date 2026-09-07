import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';
import '../constants/app_text_styles.dart';

/// Transaction list item displaying icon, title, subtitle, amount, and time.
class TransactionItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final double amount;
  final DateTime date;
  final bool isCredit;
  final IconData? icon;
  final VoidCallback? onTap;

  const TransactionItem({
    super.key,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.date,
    required this.isCredit,
    this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final amountColor = isCredit ? AppColors.primaryGreen : AppColors.onSurface;
    final amountPrefix = isCredit ? '+' : '-';
    final dateFormatter = DateFormat('dd MMM, HH:mm');

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.space16,
          vertical: AppSizes.space12,
        ),
        child: Row(
          children: [
            // Transaction icon
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isCredit
                    ? AppColors.primaryGreen.withValues(alpha: 0.1)
                    : AppColors.grey100,
                borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
              ),
              child: Icon(
                icon ?? (isCredit ? Icons.arrow_downward : Icons.arrow_upward),
                color: isCredit ? AppColors.primaryGreen : AppColors.grey600,
                size: 20,
              ),
            ),
            const SizedBox(width: AppSizes.space12),
            // Title & subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.labelLarge,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: AppTextStyles.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSizes.space8),
            // Amount & date
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '$amountPrefix KSh ${amount.toStringAsFixed(0)}',
                  style: AppTextStyles.labelLarge.copyWith(
                    color: amountColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  dateFormatter.format(date),
                  style: AppTextStyles.labelSmall,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
