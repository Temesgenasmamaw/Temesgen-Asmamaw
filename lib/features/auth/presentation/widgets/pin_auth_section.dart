import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/pin_input_field.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import 'auth_footer_links.dart';

class PinAuthSection extends StatefulWidget {
  const PinAuthSection({super.key});

  @override
  State<PinAuthSection> createState() => _PinAuthSectionState();
}

class _PinAuthSectionState extends State<PinAuthSection> {
  final GlobalKey<FourDigitPinInputState> _pinKey =
      GlobalKey<FourDigitPinInputState>();
  String _pin = '';

  void _onContinue() {
    if (_pin.length == 4) {
      context.read<AuthBloc>().add(AuthLoginRequested.withPin(_pin));
    }
  }

  void _resetErrorIfPresent() {
    if (context.read<AuthBloc>().state.status == AuthStatus.failure) {
      context.read<AuthBloc>().add(const AuthResetRequested());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listenWhen: (previous, current) =>
          previous.status != current.status &&
          current.status == AuthStatus.failure,
      listener: (context, state) {
        _pinKey.currentState?.clear();
        setState(() => _pin = '');
      },
      builder: (context, state) {
        final isLoading = state.status == AuthStatus.loading;
        final hasError = state.status == AuthStatus.failure;

        return Column(
          children: [
            const SizedBox(height: AppSizes.space20),

            Text(
              'Enter your PIN',
              style: AppTextStyles.heading4.copyWith(
                color: AppColors.grey800,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: AppSizes.space20),

            FourDigitPinInput(
              key: _pinKey,
              enabled: !isLoading,
              hasError: hasError,
              onPinChanged: (pin) {
                _resetErrorIfPresent();
                setState(() => _pin = pin);
              },
              onCompleted: (pin) {
                setState(() => _pin = pin);
              },
            ),

            if (hasError) ...[
              const SizedBox(height: AppSizes.space12),
              Text(
                'Incorrect PIN. Please try again.',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.error,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: AppSizes.space12),
            ] else ...[
              const SizedBox(height: AppSizes.space20),
            ],

            InternationalNumericKeypad(
              enabled: !isLoading,
              onNumberTap: (digit) {
                _resetErrorIfPresent();
                _pinKey.currentState?.appendDigit(digit);
              },
              onDeleteTap: () {
                _resetErrorIfPresent();
                _pinKey.currentState?.deleteDigit();
              },
            ),

            const SizedBox(height: AppSizes.space20),

            CustomButton(
              text: 'Continue',
              isLoading: isLoading,
              onPressed: (_pin.length == 4 && !isLoading) ? _onContinue : null,
            ),

            const SizedBox(height: AppSizes.space32),

            const AuthFooterLinks(),

            const SizedBox(height: AppSizes.space24),
          ],
        );
      },
    );
  }
}
