import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_expense_tracker_hive_database/views/analytics/widgets/chart.dart';
import 'package:my_expense_tracker_hive_database/views/analytics/widgets/legent_item.dart';
import 'package:my_expense_tracker_hive_database/views/analytics/widgets/state_row_card.dart';
import '../../controllers/transaction_controller.dart';
import '../../core/themes/color.dart' show primaryColor;

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TransactionController controller = Get.put(TransactionController());
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Analytics",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: primaryColor,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Obx(() {
        final totalIncome = controller.totalIncome;
        final totalExpense = controller.totalExpense;
        final totalTransactions = totalIncome + totalExpense;

        if (totalTransactions == 0 && totalIncome == 0 && totalExpense == 0) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.pie_chart_outline_rounded,
                  size: 70,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 16),
                Text(
                  "No data found!",
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        }

        if (totalTransactions == 0) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.pie_chart_outline_rounded,
                  size: 70,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 16),
                Text(
                  "বিশ্লেষণ করার মতো কোনো ডাটা পাওয়া যায়নি!",
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        }

        final double incomePercentage = (totalIncome / totalTransactions) * 100;
        final double expensePercentage =
            (totalExpense / totalTransactions) * 100;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      "Cash Flow Structure",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 30),

                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          height: 160,
                          width: 160,
                          child: CustomPaint(
                            painter: IncomeExpenseChartPainter(
                              incomePercentage: incomePercentage,
                              expensePercentage: expensePercentage,
                            ),
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Total Flow",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade500,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              "৳${totalTransactions.toStringAsFixed(0)}",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        LegendItem(
                          label: "Income",
                          percentage: incomePercentage,
                          color: primaryColor,
                        ),
                        LegendItem(
                          label: "Expense",
                          percentage: expensePercentage,
                          color: Colors.red.shade600,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),
              const Text(
                "Financial Summary",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),


        StatRowCard(
          title: "Total Income",
          amount: "৳ ${totalIncome.toStringAsFixed(2)}",
          percentage: "${incomePercentage.toStringAsFixed(1)}%",
          icon: Icons.south_west_rounded,
          color: isDarkMode ? const Color(0xFF81C784) : primaryColor,
          bgColor: isDarkMode ? const Color(0xFF1B3A24) : Colors.green.shade50,
        ),

        const SizedBox(height: 12),

        StatRowCard(
        title: "Total Expenses",
        amount: "৳ ${totalExpense.toStringAsFixed(2)}",
        percentage: "${expensePercentage.toStringAsFixed(1)}%",
        icon: Icons.north_east_rounded,
        color: isDarkMode ? const Color(0xFFE57373) : Colors.red.shade700,
        bgColor: isDarkMode ? const Color(0xFF421D1D) : Colors.red.shade50,
        ),

              const SizedBox(height: 85),
            ],
          ),
        );
      }),
    );
  }
}
