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

          appBar: DashboardTopBar(
            displayName: displayName,
            onLogout: () {
              context.read<AuthBloc>().add(const AuthLogoutRequested());
            },
          ),

          floatingActionButton: QrScannerFab(
            onTap: () {
              ToastUtils.showInfo(context, 'QR Scanner activated');
            },
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

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

                const ServicesGrid(),

                const SizedBox(height: 16),

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
