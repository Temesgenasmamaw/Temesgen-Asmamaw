import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/toast_utils.dart';

class AuthFooterLinks extends StatelessWidget {
  const AuthFooterLinks({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildLink(context, 'Forgot PIN', () {
          ToastUtils.showInfo(
            context,
            'Forgot PIN: Dial *777# or visit your nearest branch',
          );
        }, color: AppColors.safaricomRed),
        _buildDivider(),
        _buildLink(context, 'Contact Us', () {
          ToastUtils.showInfo(
            context,
            'Customer Care: Call 7333 or email info@safaricom.et',
          );
        }),
        _buildDivider(),
        _buildLink(context, 'Terms', () {
          ToastUtils.showInfo(context, 'Terms and Conditions');
        }),
      ],
    );
  }

  Widget _buildLink(
    BuildContext context,
    String title,
    VoidCallback onTap, {
    Color? color,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.space12,
          vertical: AppSizes.space8,
        ),
        child: Text(
          title,
          style: AppTextStyles.labelMedium.copyWith(
            color: color ?? AppColors.grey500,
            fontWeight: color != null ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(width: 1, height: 12, color: AppColors.grey300);
  }
}
