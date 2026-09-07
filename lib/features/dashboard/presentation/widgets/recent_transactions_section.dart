import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/utils/toast_utils.dart';

class RecentTransactionsSection extends StatelessWidget {
  const RecentTransactionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              ' Transactions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0A4C84),
              ),
            ),
            InkWell(
              onTap: () {
                ToastUtils.showInfo(context, 'Showing all transactions');
              },
              borderRadius: BorderRadius.circular(4),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'See all',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFF59E0B),
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(
                      Iconsax.arrow_right_3,
                      size: 15,
                      color: Color(0xFFF59E0B),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        _buildTransactionRow(
          context,
          title: 'ATM Cash Withdrawal',
          date: 'March 28, 2023 9:40 AM',
          amount: '- 574 Birr',
          isDebit: true,
          icon: Iconsax.card_send,
          iconBg: const Color(0xFFFEE2E2),
          iconColor: const Color(0xFFEF4444),
        ),
        _buildTransactionRow(
          context,
          title: 'Bank Transfer',
          date: 'March 27, 2023 4:15 PM',
          amount: '+ 1,200 Birr',
          isDebit: false,
          icon: Iconsax.money_recive,
          iconBg: const Color(0xFFE0F2FE),
          iconColor: const Color(0xFF0284C7),
        ),
        _buildTransactionRow(
          context,
          title: 'Buy Airtime',
          date: 'March 26, 2023 11:30 AM',
          amount: '- 100 Birr',
          isDebit: true,
          icon: Iconsax.mobile,
          iconBg: const Color(0xFFFEF3C7),
          iconColor: const Color(0xFFF59E0B),
        ),
        _buildTransactionRow(
          context,
          title: 'Utility Payment',
          date: 'March 25, 2023 2:00 PM',
          amount: '- 350 Birr',
          isDebit: true,
          icon: Iconsax.receipt_2,
          iconBg: const Color(0xFFE6F4EA),
          iconColor: const Color(0xFF0D9488),
        ),
      ],
    );
  }

  Widget _buildTransactionRow(
    BuildContext context, {
    required String title,
    required String date,
    required String amount,
    required bool isDebit,
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => ToastUtils.showInfo(context, '$title: $amount'),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: AppSizes.space12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0A4C84),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      date,
                      style: const TextStyle(
                        fontSize: 11.5,
                        color: AppColors.grey500,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                amount,
                style: TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.bold,
                  color: isDebit
                      ? const Color(0xFF0A4C84)
                      : AppColors.primaryGreen,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
