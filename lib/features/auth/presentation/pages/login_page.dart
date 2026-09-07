import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/routes/app_router.dart';
import '../../../../core/utils/toast_utils.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/pin_input_field.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/auth_footer_links.dart';
import '../widgets/auth_header_section.dart';

/// Clean Login / Authentication Page assembling feature presentation widgets.
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FourDigitPinInputState> _pinKey =
      GlobalKey<FourDigitPinInputState>();
  String _pin = '';
  String _selectedLanguage = 'English';

  final List<String> _languages = ['English', 'Amharic'];

  void _onContinue() {
    if (_pin.length == 4) {
      context.read<AuthBloc>().add(
        AuthLoginRequested(phoneNumber: '+251912345678', pin: _pin),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.success) {
          context.go(AppRouter.dashboard);
        } else if (state.status == AuthStatus.failure) {
          _pinKey.currentState?.clear();
          setState(() => _pin = '');
          if (state.message != null && state.message!.isNotEmpty) {
            ToastUtils.showError(context, state.message!);
          }
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: Column(
          children: [
            // ── Section A: Header Section (Background Image + Language + Profile) ──
            AuthHeaderSection(
              selectedLanguage: _selectedLanguage,
              languages: _languages,
              onLanguageChanged: (lang) {
                setState(() => _selectedLanguage = lang);
              },
            ),

            // ── Section B: PIN Authentication Section (Clean White Area) ──
            Expanded(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.space24,
                ),
                child: BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    final isLoading = state.status == AuthStatus.loading;
                    final hasError = state.status == AuthStatus.failure;

                    return Column(
                      children: [
                        const SizedBox(height: AppSizes.space24),

                        // Title
                        Text(
                          'Enter your PIN',
                          style: AppTextStyles.heading4.copyWith(
                            color: AppColors.grey800,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const SizedBox(height: AppSizes.space24),

                        // 4-digit PIN input
                        FourDigitPinInput(
                          key: _pinKey,
                          enabled: !isLoading,
                          hasError: hasError,
                          onPinChanged: (pin) {
                            if (context.read<AuthBloc>().state.status ==
                                AuthStatus.failure) {
                              context.read<AuthBloc>().add(
                                const AuthResetRequested(),
                              );
                            }
                            setState(() => _pin = pin);
                          },
                          onCompleted: (pin) {
                            setState(() => _pin = pin);
                          },
                        ),

                        // Error message on incorrect PIN
                        if (hasError) ...[
                          const SizedBox(height: AppSizes.space12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.error_outline,
                                size: 16,
                                color: AppColors.error,
                              ),
                              const SizedBox(width: 6),
                              Flexible(
                                child: Text(
                                  state.message ?? '',
                                  textAlign: TextAlign.center,
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: AppColors.error,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],

                        const SizedBox(height: AppSizes.space16),

                        // International Numeric Keypad (123 / 456 / 789 / 0 + back)
                        InternationalNumericKeypad(
                          enabled: !isLoading,
                          onNumberTap: (digit) {
                            if (hasError) {
                              context.read<AuthBloc>().add(
                                const AuthResetRequested(),
                              );
                            }
                            _pinKey.currentState?.appendDigit(digit);
                          },
                          onDeleteTap: () {
                            if (hasError) {
                              context.read<AuthBloc>().add(
                                const AuthResetRequested(),
                              );
                            }
                            _pinKey.currentState?.deleteDigit();
                          },
                        ),

                        const SizedBox(height: AppSizes.space20),

                        // Primary Continue Button
                        CustomButton(
                          text: 'Continue',
                          isLoading: isLoading,
                          onPressed: (_pin.length == 4 && !isLoading)
                              ? _onContinue
                              : null,
                        ),

                        const SizedBox(height: AppSizes.space32),

                        // Footer Links: Forgot PIN (red) | Contact Us | Terms
                        const AuthFooterLinks(),

                        const SizedBox(height: AppSizes.space24),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
