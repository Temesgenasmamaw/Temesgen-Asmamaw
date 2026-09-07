import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/routes/app_router.dart';
import '../../../../core/utils/toast_utils.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_state.dart';
import '../widgets/auth_header_section.dart';
import '../widgets/pin_auth_section.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _selectedLanguage = 'English';
  final List<String> _languages = ['English', 'Amharic'];

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.success) {
          context.go(AppRouter.dashboard);
        } else if (state.status == AuthStatus.failure) {
          if (state.message != null && state.message!.isNotEmpty) {
            ToastUtils.showError(context, state.message!);
          }
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: Column(
          children: [
            AuthHeaderSection(
              selectedLanguage: _selectedLanguage,
              languages: _languages,
              onLanguageChanged: (lang) {
                setState(() => _selectedLanguage = lang);
              },
            ),

            const Expanded(
              child: SingleChildScrollView(
                physics: ClampingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: AppSizes.space24),
                child: PinAuthSection(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
