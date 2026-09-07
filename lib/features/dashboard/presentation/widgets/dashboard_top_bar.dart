import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/utils/toast_utils.dart';

class DashboardTopBar extends StatelessWidget implements PreferredSizeWidget {
  final String displayName;
  final VoidCallback? onLogout;

  const DashboardTopBar({super.key, required this.displayName, this.onLogout});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  String _getInitials(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return 'AB';
    final parts = trimmed.split(RegExp(r'\s+'));
    if (parts.length == 1) {
      return parts[0].substring(0, parts[0].length >= 2 ? 2 : 1).toUpperCase();
    }
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.scaffoldBackground,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      automaticallyImplyLeading: false,
      titleSpacing: AppSizes.space16,
      toolbarHeight: kToolbarHeight,
      title: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: const Color(0xFFE8F1FA),
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: Text(
              _getInitials(displayName),
              style: const TextStyle(
                color: Color(0xFF0A4C84),
                fontWeight: FontWeight.bold,
                fontSize: 14,
                letterSpacing: 0.5,
              ),
            ),
          ),

          const SizedBox(width: AppSizes.space12),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Selam,',
                style: TextStyle(
                  color: Color(0xFFF59E0B),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                displayName,
                style: const TextStyle(
                  color: Color(0xFF0A4C84),
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  height: 1.1,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(
            Iconsax.notification,
            color: Color(0xFF0A4C84),
            size: 24,
          ),
          tooltip: 'Notifications',
          onPressed: () {
            ToastUtils.showInfo(context, 'No new notifications');
          },
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}
