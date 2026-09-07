import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/toast_utils.dart';
import '../../../../core/widgets/custom_service_tile.dart';

/// Services Grid with comfortable, generous spacing and a cohesive
/// soft red palette ("red but not real red": rose-crimson #D63B48 on soft blush #FFF1F2).
class ServicesGrid extends StatefulWidget {
  const ServicesGrid({super.key});

  @override
  State<ServicesGrid> createState() => _ServicesGridState();
}

class _ServicesGridState extends State<ServicesGrid> {
  bool _isExpanded = false;

  // Refined soft red ("not real red") color constants
  static const Color _softRed = AppColors.softRed;
  static const Color _softRedBg = AppColors.softRedSurface;

  final List<_ServiceConfig> _row1 = const [
    _ServiceConfig(
      title: 'Merchant\nPayment',
      icon: Iconsax.shop,
    ),
    _ServiceConfig(
      title: 'Bill\nPayment',
      icon: Iconsax.receipt_2,
    ),
    _ServiceConfig(
      title: 'Credit &\nSaving',
      icon: Iconsax.empty_wallet,
    ),
  ];

  final List<_ServiceConfig> _row2 = const [
    _ServiceConfig(
      title: 'Transfer\nMoney',
      icon: Iconsax.money_send,
    ),
    _ServiceConfig(
      title: 'Airtime /\nPackage',
      icon: Iconsax.mobile,
    ),
    _ServiceConfig(
      title: 'More\nServices',
      icon: Iconsax.category,
      isMoreAction: true,
    ),
  ];

  final List<_ServiceConfig> _row3 = const [
    _ServiceConfig(
      title: 'Bank\nTransfer',
      icon: Iconsax.bank,
    ),
    _ServiceConfig(
      title: 'Cash\nOut',
      icon: Iconsax.money_change,
    ),
    _ServiceConfig(
      title: 'Exchange\nRate',
      icon: Iconsax.convert,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: AnimatedSize(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Row 1: Merchant Payment, Bill Payment, Credit & Saving
            _buildRow(context, _row1),
            const SizedBox(height: 14), // Generous space between rows

            // Row 2: Transfer Money, Airtime/Package, More Services
            _buildRow(context, _row2),

            // Optional Row 3: Bank Transfer, Cash Out, Exchange Rate (when expanded)
            if (_isExpanded) ...[
              const SizedBox(height: 14),
              _buildRow(context, _row3),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildRow(BuildContext context, List<_ServiceConfig> rowServices) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: rowServices.map((item) {
        return Expanded(
          child: CustomServiceTile(
            title: item.title,
            icon: item.icon,
            iconColor: _softRed,
            bgColor: _softRedBg,
            tileSize: 46,
            iconSize: 22,
            onTap: () {
              if (item.isMoreAction) {
                setState(() => _isExpanded = !_isExpanded);
                ToastUtils.showInfo(
                  context,
                  _isExpanded ? 'All services expanded' : 'Services collapsed',
                );
              } else {
                ToastUtils.showInfo(
                  context,
                  '${item.title.replaceAll('\n', ' ')} selected',
                );
              }
            },
          ),
        );
      }).toList(),
    );
  }
}

class _ServiceConfig {
  final String title;
  final IconData icon;
  final bool isMoreAction;

  const _ServiceConfig({
    required this.title,
    required this.icon,
    this.isMoreAction = false,
  });
}
