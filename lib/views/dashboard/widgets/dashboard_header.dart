import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:my_expense_tracker_hive_database/controllers/transaction_controller.dart';
import 'package:my_expense_tracker_hive_database/services/notification_services.dart';
import '../../../core/themes/color.dart';
import 'modren_state.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key, required this.controller});

  final TransactionController controller;

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      height: 370,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: 220,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [primaryColor, primaryColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            padding: const EdgeInsets.fromLTRB(24, 55, 24, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.waving_hand_rounded,
                          color: Colors.amber.shade400,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          "Welcome back,",
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.8),
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      "Expense Tracker",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.notifications_active_outlined,
                      color: Colors.white,
                      size: 22,
                    ),
                    onPressed: () async {
                      await NotificationServices.showInstantNotification(
                        id: 1,
                        title: "আজকের হিসাব লিখেছেন কি? 📝",
                        body:
                            "আপনার খরচগুলো ট্র্যাক করতে এখনই আজকের ট্রানজেকশনগুলো যুক্ত করুন।",
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          Positioned(
            top: 140,
            left: 20,
            right: 20,
            child: Obx(
              () => Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: isDarkMode
                          ? Colors.black.withValues(alpha: 0.3)
                          : Colors.black.withValues(alpha: 0.04),
                      blurRadius: 24,
                      offset: const Offset(0, 16),
                    ),
                    BoxShadow(
                      color: primaryColor.withValues(
                        alpha: isDarkMode ? 0.02 : 0.06,
                      ),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  border: Border.all(
                    color: isDarkMode
                        ? Colors.grey.shade800
                        : Colors.grey.shade100,
                    width: 1.5,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: primaryColor.withValues(
                              alpha: isDarkMode ? 0.15 : 0.08,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.account_balance_wallet_rounded,
                                size: 16,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                "Total Balance",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.trending_up_rounded,
                          color: isDarkMode
                              ? Colors.grey.shade600
                              : Colors.grey.shade400,
                          size: 20,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    Text(
                      "৳ ${controller.totalBalance.toStringAsFixed(2)}",
                      style: TextStyle(
                        color: isDarkMode
                            ? const Color(0xFFF5F5F7)
                            : const Color(0xFF1A1D1E),
                        fontSize: 34,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'Roboto',
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 20),

                    Container(
                      height: 1,
                      color: isDarkMode
                          ? Colors.grey.shade800
                          : Colors.grey.shade100,
                    ),
                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: ModrenStat(
                            icon: Icons.arrow_downward_rounded,
                            iconColor: isDarkMode
                                ? const Color(0xFF81C784)
                                : const Color(0xFF2E7D32),
                            bgColor: isDarkMode
                                ? const Color(0xFF1B3A24)
                                : const Color(0xFFE8F5E9),
                            label: "Income",
                            amount:
                                "৳ ${controller.totalIncome.toStringAsFixed(0)}",
                          ),
                        ),

                        Container(
                          width: 1,
                          height: 40,
                          color: isDarkMode
                              ? Colors.grey.shade800
                              : Colors.grey.shade200,
                          margin: const EdgeInsets.symmetric(horizontal: 12),
                        ),

                        Expanded(
                          child: ModrenStat(
                            icon: Icons.arrow_upward_rounded,
                            iconColor: isDarkMode
                                ? const Color(0xFFE57373)
                                : const Color(0xFFC62828),
                            bgColor: isDarkMode
                                ? const Color(0xFF421D1D)
                                : const Color(0xFFFFEBEE),
                            label: "Expenses",
                            amount:
                                "৳ ${controller.totalExpense.toStringAsFixed(0)}",
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
