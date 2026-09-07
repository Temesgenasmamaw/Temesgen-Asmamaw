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
import '../widgets/dashboard_bottom_nav.dart';
import '../widgets/dashboard_top_bar.dart';
import '../widgets/recent_transactions_section.dart';
import '../widgets/services_grid.dart';

/// Clean Dashboard Page assembling feature presentation widgets.
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _currentNavIndex = 0;

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

          // ── Docked QR Scanner Button ──
          floatingActionButton: FloatingQrScannerButton(
            onTap: () {
              ToastUtils.showInfo(context, 'QR Scanner activated');
            },
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,

          // ── Curved Bottom Navigation Bar ──
          bottomNavigationBar: DashboardBottomNav(
            currentIndex: _currentNavIndex,
            onNavItemSelected: (index) {
              setState(() => _currentNavIndex = index);
            },
          ),

          // ── Dashboard Body ──
          body: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              AppSizes.space20,
              AppSizes.space12,
              AppSizes.space20,
              AppSizes.space40 + 60, // Extra bottom padding for docked FAB
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Balance Card
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

                const SizedBox(height: AppSizes.space24),

                // 2. Compact 3x3 Services Grid
                const ServicesGrid(),

                const SizedBox(height: AppSizes.space24),

                // 3. Recent Transactions Section
                const RecentTransactionsSection(),

                const SizedBox(height: AppSizes.space20),
              ],
            ),
          ),
        );
      },
    );
  }
}
