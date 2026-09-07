import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

/// Reusable service action tile for dashboard grids and menus.
///
/// Designed with generous spacing, soft touch feedback, and clear typography.
class CustomServiceTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final Color bgColor;
  final VoidCallback? onTap;
  final double tileSize;
  final double iconSize;

  const CustomServiceTile({
    super.key,
    required this.title,
    required this.icon,
    this.iconColor = AppColors.softRed,
    this.bgColor = AppColors.softRedSurface,
    this.onTap,
    this.tileSize = 48,
    this.iconSize = 24,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: tileSize,
              height: tileSize,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: iconColor.withValues(alpha: 0.08),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: Icon(icon, color: iconColor, size: iconSize),
            ),
            const SizedBox(height: 6),
            Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1F2937),
                height: 1.15,
                letterSpacing: 0.1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
