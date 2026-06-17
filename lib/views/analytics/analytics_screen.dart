import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/transaction_controller.dart'; // আপনার কন্ট্রোলারের সঠিক পাথ দিন

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TransactionController controller = Get.find<TransactionController>();
    final theme = Theme.of(context);
    final primaryColor = const Color(0xFF2E7D32); // অ্যাপের সিগনেচার গ্রিন থিম

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F6), // প্রিমিয়াম ব্যাকগ্রাউন্ড
      appBar: AppBar(
        title: const Text(
          "Analytics",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: primaryColor,
        elevation: 0,
        automaticallyImplyLeading: false, // বটম ন্যাভিগেশনের জন্য ব্যাক বাটন অফ
      ),
      body: Obx(() {
        final totalIncome = controller.totalIncome;
        final totalExpense = controller.totalExpense;
        final totalTransactions = totalIncome + totalExpense;

        // যদি কোনো ট্রানজেকশন না থাকে তবে নো-ডাটা স্টেট দেখাবে
        if (totalTransactions == 0) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.pie_chart_outline_rounded, size: 70, color: Colors.grey.shade400),
                const SizedBox(height: 16),
                Text(
                  "বিশ্লেষণ করার মতো কোনো ডাটা পাওয়া যায়নি!",
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 15, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          );
        }

        // পার্সেন্টেজ হিসাব
        final double incomePercentage = (totalIncome / totalTransactions) * 100;
        final double expensePercentage = (totalExpense / totalTransactions) * 100;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 📊 ১. প্রিমিয়াম কাস্টম পাই-চার্ট কার্ড
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    )
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      "Cash Flow Structure",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF212121)),
                    ),
                    const SizedBox(height: 30),

                    // কাস্টম চার্ট পেইন্টার উইজেট
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
                        // মাঝখানের হোয়াইট সার্কেল এবং টোটাল টেক্সট (Donut Style)
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Total Flow",
                              style: TextStyle(fontSize: 12, color: Colors.grey.shade500, fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              "৳${totalTransactions.toStringAsFixed(0)}",
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF212121)),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    // চার্ট লেজেন্ড (ইনডেক্স কালার ইন্ডিকেটর)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildLegendItem(label: "Income", percentage: incomePercentage, color: Colors.green.shade600),
                        _buildLegendItem(label: "Expense", percentage: expensePercentage, color: Colors.red.shade600),
                      ],
                    )
                  ],
                ),
              ),

              const SizedBox(height: 28),
              const Text(
                "Financial Summary",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF616161)),
              ),
              const SizedBox(height: 12),

              // 🟢 ২. ইনকাম রিপোর্ট কার্ড
              _buildStatRowCard(
                title: "Total Income",
                amount: "৳ ${totalIncome.toStringAsFixed(2)}",
                percentage: "${incomePercentage.toStringAsFixed(1)}%",
                icon: Icons.arrow_downward_rounded,
                color: Colors.green.shade700,
                bgColor: Colors.green.shade50,
              ),

              const SizedBox(height: 12),

              // 🔴 ৩. এক্সপেন্স রিপোর্ট কার্ড
              _buildStatRowCard(
                title: "Total Expenses",
                amount: "৳ ${totalExpense.toStringAsFixed(2)}",
                percentage: "${expensePercentage.toStringAsFixed(1)}%",
                icon: Icons.arrow_upward_rounded,
                color: Colors.red.shade700,
                bgColor: Colors.red.shade50,
              ),

              const SizedBox(height: 85), // বটম বারের সেফ মার্জিন গ্যাপ
            ],
          ),
        );
      }),
    );
  }

  // চার্টের নিচে ছোট লেবেল ইন্ডিকেটর মেথড
  Widget _buildLegendItem({required String label, required double percentage, required Color color}) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text(
          "$label (${percentage.toStringAsFixed(0)}%)",
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF616161)),
        ),
      ],
    );
  }

  // নিচে থাকা ইনকাম/এক্সপেন্স ডিটেইলস রো কার্ড বিল্ডার
  Widget _buildStatRowCard({
    required String title,
    required String amount,
    required String percentage,
    required IconData icon,
    required Color color,
    required Color bgColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.01),
            blurRadius: 5,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 13, color: Colors.grey.shade500, fontWeight: FontWeight.w500)),
                const SizedBox(height: 4),
                Text(amount, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF212121))),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(20)),
            child: Text(
              percentage,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color),
            ),
          )
        ],
      ),
    );
  }
}

// 🎯 কাস্টম পাই-চার্ট পেইন্টার লজিক (যা ডাটা অনুযায়ী ডাইনামিক বৃত্ত আঁকবে)
class IncomeExpenseChartPainter extends CustomPainter {
  final double incomePercentage;
  final double expensePercentage;

  IncomeExpenseChartPainter({required this.incomePercentage, required this.expensePercentage});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final paintIncome = Paint()
      ..color = Colors.green.shade600
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20; // চার্টের থিকনেস/উইথ

    final paintExpense = Paint()
      ..color = Colors.red.shade600
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20;

    // রেডিয়ানে কনভার্ট করা (টোটাল ৩৬০ ডিগ্রি = ২ * পাই)
    double startAngle = -1.5708; // ওপরে ১২টার দিক থেকে শুরু করার জন্য (-৯degree)

    // ১. ইনকামের অংশ আঁকা
    double sweepAngleIncome = (incomePercentage / 100) * 6.28319;
    canvas.drawArc(rect, startAngle, sweepAngleIncome, false, paintIncome);

    // ২. এক্সপেন্সের অংশ আঁকা
    startAngle += sweepAngleIncome;
    double sweepAngleExpense = (expensePercentage / 100) * 6.28319;
    canvas.drawArc(rect, startAngle, sweepAngleExpense, false, paintExpense);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}