import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/toast_utils.dart';

/// Ultra-compact 3x3 Services Grid for dashboard.
///
/// Uses direct Rows instead of GridView to strictly control row height,
/// eliminating all extra vertical gaps and maximizing screen space for transactions.
class ServicesGrid extends StatelessWidget {
  const ServicesGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final services = [
      const _ServiceConfig(
        title: 'Fund\nTransfer',
        icon: Icons.account_balance,
        bgColor: Color(0xFFE8F1FA),
        iconColor: Color(0xFF1E88E5),
      ),
      const _ServiceConfig(
        title: 'Buy\nAirtime',
        icon: Icons.phone_android,
        bgColor: Color(0xFFFEF3C7),
        iconColor: Color(0xFFF59E0B),
      ),
      const _ServiceConfig(
        title: 'Exchange\nRate',
        icon: Icons.account_balance_wallet,
        bgColor: Color(0xFFE0F2FE),
        iconColor: Color(0xFF0284C7),
      ),
      const _ServiceConfig(
        title: 'Utility\nPayment',
        icon: Icons.receipt_long,
        bgColor: Color(0xFFE6F4EA),
        iconColor: Color(0xFF0D9488),
      ),
      const _ServiceConfig(
        title: 'Cash\nOut',
        icon: Icons.local_atm,
        bgColor: Color(0xFFFEE2E2),
        iconColor: Color(0xFFEF4444),
      ),
      const _ServiceConfig(
        title: 'Pay\nMerchant',
        icon: Icons.shopping_bag_outlined,
        bgColor: Color(0xFFF3E8FF),
        iconColor: Color(0xFF9333EA),
      ),
      const _ServiceConfig(
        title: 'Bank\nTransfer',
        icon: Icons.swap_horiz,
        bgColor: Color(0xFFEEF2FF),
        iconColor: Color(0xFF6366F1),
      ),
      const _ServiceConfig(
        title: 'Micro\nLoans',
        icon: Icons.savings_outlined,
        bgColor: Color(0xFFDCFCE7),
        iconColor: Color(0xFF16A34A),
      ),
      const _ServiceConfig(
        title: 'More\nServices',
        icon: Icons.apps,
        bgColor: Color(0xFFF3F4F6),
        iconColor: Color(0xFF4B5563),
      ),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildRow(context, services.sublist(0, 3)),
          const SizedBox(height: 8), // Minimized gap between Row 1 and Row 2
          _buildRow(context, services.sublist(3, 6)),
          const SizedBox(height: 8), // Minimized gap between Row 2 and Row 3
          _buildRow(context, services.sublist(6, 9)),
        ],
      ),
    );
  }

  Widget _buildRow(BuildContext context, List<_ServiceConfig> rowServices) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: rowServices.map((item) {
        return Expanded(
          child: InkWell(
            onTap: () {
              ToastUtils.showInfo(
                context,
                '${item.title.replaceAll('\n', ' ')} selected',
              );
            },
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: item.bgColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: Icon(item.icon, color: item.iconColor, size: 22),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    item.title,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    style: const TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w500,
                      color: AppColors.grey800,
                      height: 1.1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _ServiceConfig {
  final String title;
  final IconData icon;
  final Color bgColor;
  final Color iconColor;

  const _ServiceConfig({
    required this.title,
    required this.icon,
    required this.bgColor,
    required this.iconColor,
  });
}
