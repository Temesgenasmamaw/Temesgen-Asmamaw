import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class DashboardBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onNavItemSelected;

  const DashboardBottomNav({
    super.key,
    required this.currentIndex,
    required this.onNavItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8.0,
      color: const Color(0xFF0A4C84),
      elevation: 12,
      child: SizedBox(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(icon: Iconsax.home, label: 'Home', index: 0),
            _buildNavItem(icon: Iconsax.receipt_2, label: 'History', index: 1),
            const SizedBox(width: 48),
            _buildNavItem(icon: Iconsax.wallet_2, label: 'Cards', index: 2),
            _buildNavItem(icon: Iconsax.user, label: 'Profile', index: 3),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final isSelected = currentIndex == index;
    return InkWell(
      onTap: () => onNavItemSelected(index),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 22,
              color: isSelected
                  ? const Color(0xFF38BDF8)
                  : Colors.white.withValues(alpha: 0.7),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected
                    ? const Color(0xFF38BDF8)
                    : Colors.white.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FloatingQrScannerButton extends StatelessWidget {
  final VoidCallback onTap;

  const FloatingQrScannerButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 62,
      height: 62,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFF0A4C84),
        border: Border.all(color: Colors.white, width: 3.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0A4C84).withValues(alpha: 0.35),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: const Center(
            child: Icon(
              Iconsax.scan_barcode,
              size: 28,
              color: Color(0xFF38BDF8),
            ),
          ),
        ),
      ),
    );
  }
}
