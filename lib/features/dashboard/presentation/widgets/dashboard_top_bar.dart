import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/utils/toast_utils.dart';

/// Top AppBar for the Dashboard showing user avatar, greeting, name,
/// notification icon, and more-options menu.
class DashboardTopBar extends StatelessWidget implements PreferredSizeWidget {
  final String displayName;
  final VoidCallback onLogout;

  const DashboardTopBar({
    super.key,
    required this.displayName,
    required this.onLogout,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 8);

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
      titleSpacing: AppSizes.space20,
      toolbarHeight: kToolbarHeight + 8,
      title: Row(
        children: [
          // Initials Box Avatar (e.g. "AB")
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFE8F1FA),
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Text(
              _getInitials(displayName),
              style: const TextStyle(
                color: Color(0xFF0A4C84),
                fontWeight: FontWeight.bold,
                fontSize: 16,
                letterSpacing: 0.5,
              ),
            ),
          ),

          const SizedBox(width: AppSizes.space12),

          // Greeting & Name ("Selam," in yellow, Name in deep blue)
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
        // Notification Icon
        IconButton(
          icon: const Icon(
            Icons.notifications_outlined,
            color: Color(0xFF0A4C84),
            size: 26,
          ),
          tooltip: 'Notifications',
          onPressed: () {
            ToastUtils.showInfo(context, 'No new notifications');
          },
        ),

        // More Options Menu (3 vertical dots)
        PopupMenuButton<String>(
          icon: const Icon(
            Icons.more_vert,
            color: Color(0xFF0A4C84),
            size: 24,
          ),
          onSelected: (value) {
            if (value == 'logout') {
              onLogout();
            } else if (value == 'settings') {
              ToastUtils.showInfo(context, 'Settings');
            } else if (value == 'help') {
              ToastUtils.showInfo(context, 'Help & Support');
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'settings',
              child: Row(
                children: [
                  Icon(
                    Icons.settings_outlined,
                    size: 20,
                    color: AppColors.grey700,
                  ),
                  SizedBox(width: 12),
                  Text('Settings'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'help',
              child: Row(
                children: [
                  Icon(
                    Icons.help_outline,
                    size: 20,
                    color: AppColors.grey700,
                  ),
                  SizedBox(width: 12),
                  Text('Help & Support'),
                ],
              ),
            ),
            const PopupMenuDivider(),
            const PopupMenuItem(
              value: 'logout',
              child: Row(
                children: [
                  Icon(
                    Icons.logout,
                    size: 20,
                    color: AppColors.safaricomRed,
                  ),
                  SizedBox(width: 12),
                  Text(
                    'Log Out',
                    style: TextStyle(color: AppColors.safaricomRed),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}
