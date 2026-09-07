import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/routes/app_router.dart';
import '../../../../core/utils/toast_utils.dart';
import '../../../../core/widgets/balance_card.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../widgets/dashboard_top_bar.dart';
import '../widgets/qr_scanner_fab.dart';
import '../widgets/recent_transactions_section.dart';
import '../widgets/services_grid.dart';

/// Clean Dashboard Page assembling feature presentation widgets.
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.initial) {
          context.go(AppRouter.login);
        }
      },
      builder: (context, state) {
        final user = state.user;
        final currency = user?.currency ?? 'ETB';
        final balance = user?.accountBalance ?? 1250.50;
        final displayName = user?.fullName.isNotEmpty == true
            ? user!.fullName
            : 'Abebe Bekele';

        return Scaffold(
          backgroundColor: AppColors.scaffoldBackground,
          // ── Top Bar Widget ──
          appBar: DashboardTopBar(
            displayName: displayName,
            onLogout: () {
              context.read<AuthBloc>().add(const AuthLogoutRequested());
            },
          ),

          // ── Floating QR Scanner Button (Red Icon, No Bottom Nav) ──
          floatingActionButton: QrScannerFab(
            onTap: () {
              ToastUtils.showInfo(context, 'QR Scanner activated');
            },
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

          // ── Dashboard Body ──
          body: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              AppSizes.space16,
              AppSizes.space8,
              AppSizes.space16,
              AppSizes.space24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Balance Card (with Black Add Money Button)
                BalanceCard(
                  balance: balance,
                  entireBalance: balance,
                  currency: currency,
                  onAddMoney: () {
                    ToastUtils.showInfo(
                      context,
                      'Add Money feature coming soon',
                    );
                  },
                ),

                const SizedBox(height: 14),

                // 2. Services Grid (Spacious, Soft Red Icons)
                const ServicesGrid(),

                const SizedBox(height: 16),

                // 3. Recent Transactions Section
                const RecentTransactionsSection(),

                const SizedBox(height: AppSizes.space16),
              ],
            ),
          ),
        );
      },
    );
  }
}
