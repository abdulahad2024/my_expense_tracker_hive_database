import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:my_expense_tracker_hive_database/core/helper/custom_toast.dart';
import 'package:my_expense_tracker_hive_database/core/themes/color.dart';
import 'package:my_expense_tracker_hive_database/views/analytics/analytics_screen.dart';
import 'package:my_expense_tracker_hive_database/views/dashboard/dashboard_screen.dart';
import 'package:my_expense_tracker_hive_database/views/settings/setting_screen.dart';
import 'package:my_expense_tracker_hive_database/views/transaction/add_transaction_screen.dart';
import 'package:my_expense_tracker_hive_database/views/transaction/transaction_list_screen.dart';

class BottomScreen extends StatefulWidget {
  const BottomScreen({super.key});

  @override
  State<BottomScreen> createState() => _BottomScreenState();
}

class _BottomScreenState extends State<BottomScreen> {
  int _currentIndex = 0;

  Widget _getSelectedScreen(int index) {
    switch (index) {
      case 0:
        return const DashboardScreen(key: ValueKey(0));
      case 1:
        return const AnalyticsScreen(key: ValueKey(1));
      case 2:
        return const TransactionListScreen(key: ValueKey(2));
      case 3:
        return SettingScreen(key: const ValueKey(3));
      default:
        return const DashboardScreen(key: ValueKey(0));
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime? _lastPressedAt;

    final theme = Theme.of(context);
    final bool isDarkMode = theme.brightness == Brightness.dark;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;

        final now = DateTime.now();

        if (_lastPressedAt == null ||
            now.difference(_lastPressedAt!) > const Duration(seconds: 2)) {
          _lastPressedAt = now;

          CustomToast.showError("Press back again to exit");
        } else {
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        extendBody: true,
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          switchInCurve: Curves.easeInOut,
          switchOutCurve: Curves.easeInOut,
          child: _getSelectedScreen(_currentIndex),
        ),

        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

        floatingActionButton: FloatingActionButton(
          elevation: 4,
          backgroundColor: primaryColor,
          shape: const CircleBorder(),
          onPressed: () {
            Get.to(() => const AddTransactionScreen());
          },
          child: const Icon(Icons.add_rounded, color: Colors.white, size: 30),
        ),

        bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          notchMargin: 8,
          elevation: isDarkMode ? 2 : 12,
          color: theme.cardColor,
          child: SizedBox(
            height: 68,
            child: Row(
              children: [
                _buildNavItem(
                  index: 0,
                  icon: Icons.dashboard_rounded,
                  label: "Dashboard",
                ),
                _buildNavItem(
                  index: 1,
                  icon: Icons.pie_chart_rounded,
                  label: "Analytics",
                ),

                const SizedBox(width: 50),

                _buildNavItem(
                  index: 2,
                  icon: Icons.receipt_long_rounded,
                  label: "Transactions",
                ),
                _buildNavItem(
                  index: 3,
                  icon: Icons.settings_rounded,
                  label: "Settings",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required String label,
  }) {
    final theme = Theme.of(context);
    final bool isSelected = _currentIndex == index;
    final bool isDarkMode = theme.brightness == Brightness.dark;

    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        splashColor: primaryColor.withValues(alpha: 0.1),
        highlightColor: Colors.transparent,
        onTap: () {
          if (_currentIndex != index) {
            setState(() {
              _currentIndex = index;
            });
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedScale(
                duration: const Duration(milliseconds: 250),
                scale: isSelected ? 1.12 : 1.0,
                child: Icon(
                  icon,
                  size: 24,
                  color: isSelected
                      ? primaryColor
                      : (isDarkMode
                            ? Colors.grey.shade600
                            : Colors.grey.shade400),
                ),
              ),
              const SizedBox(height: 2),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected
                        ? primaryColor
                        : (isDarkMode
                              ? Colors.grey.shade500
                              : Colors.grey.shade600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
