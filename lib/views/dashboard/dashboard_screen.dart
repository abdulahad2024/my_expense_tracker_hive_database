import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:my_expense_tracker_hive_database/core/themes/color.dart';
import 'package:my_expense_tracker_hive_database/views/dashboard/widgets/dashboard_header.dart';
import 'package:my_expense_tracker_hive_database/views/dashboard/widgets/transaction_header.dart';
import '../../controllers/transaction_controller.dart';
import '../transaction/add_transaction_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TransactionController controller = Get.put(TransactionController());

    return Scaffold(
      body: Column(
        children: [
          DashboardHeader(controller: controller),

          const SizedBox(height: 10),

          TransactionHeader(),

          Expanded(
            child: Obx(() {
              if (controller.recentTransactions.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.03),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.receipt_long_rounded,
                          size: 45,
                          color: Colors.grey.shade400,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "No transactions found!",
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
              return ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                itemCount: controller.recentTransactions.length,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  final tx = controller.recentTransactions[index];
                  final isIncome = tx.type == 'Income';

                  DateTime parsedDate = DateTime.now();
                  parsedDate = tx.dateTime;

// 🎯 থিম এবং ব্রাইটনেস চেক (উইজেটের শুরুতে বা বিল্ড মেথডের ভেতর এটি নিশ্চিত করুন)
                  final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 14),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      // 🎯 ফিক্স ১: মূল কার্ডের ব্যাকগ্রাউন্ড থিম অনুযায়ী ডাইনামিক করা হলো
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          // 🎯 ডার্ক মোডে শ্যাডো যেন অতিরিক্ত গ্লো না করে সেজন্য আলফা অ্যাডজাস্টমেন্ট
                          color: isDarkMode
                              ? Colors.black.withValues(alpha: 0.2)
                              : const Color(0xFF000000).withValues(alpha: 0.02),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // 📦 আইকন কন্টেইনার (ইনকাম/এক্সপেন্স অনুযায়ী শেড)
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isIncome
                                ? (isDarkMode ? const Color(0xFF1B3A24) : const Color(0xFFE8F5E9))
                                : (isDarkMode ? const Color(0xFF421D1D) : const Color(0xFFFFEBEE)),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            isIncome ? Icons.south_west_rounded : Icons.north_east_rounded,
                            color: isIncome
                                ? (isDarkMode ? const Color(0xFF81C784) : primaryColor)
                                : (isDarkMode ? const Color(0xFFE57373) : const Color(0xFFC62828)),
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),

                        // 📝 টেক্সট ডিটেইলস সেকশন (টাইটেল ও ডেট)
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                tx.title,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  // 🎯 ফিক্স ২: টাইটেলের কালার থিম ফ্রেন্ডলি করা হলো
                                  color: isDarkMode ? const Color(0xFFF5F5F7) : const Color(0xFF1A1D1E),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                DateFormat('MMM dd, yyyy • hh:mm a').format(parsedDate),
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w400,
                                  // 🎯 ফিক্স ৩: ডার্ক মোডে সাবটাইটেল রিড্যাবিলিটি বুস্ট
                                  color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade500,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // 💰 অ্যামাউন্ট টেক্সট
                        Text(
                          "${isIncome ? '+ ' : '- '}৳${tx.amount.toStringAsFixed(1)}",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: isIncome
                                ? (isDarkMode ? primaryColor : primaryColor)
                                : (isDarkMode ? Colors.red : Colors.red),
                          ),
                        ),

                        PopupMenuButton<String>(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          color:  Theme.of(context).cardColor,
                          icon: Icon(
                            Icons.more_vert_rounded,
                            color: isDarkMode ? Colors.grey.shade500 : Colors.grey.shade400,
                            size: 20,
                          ),
                          padding: EdgeInsets.zero,
                          onSelected: (value) {
                            if (value == 'edit') {
                              Get.to(
                                    () => const AddTransactionScreen(),
                                arguments: tx,
                              );
                            } else if (value == 'delete') {
                              _showDeleteConfirmation(context, controller, tx.id);
                            }
                          },
                          itemBuilder: (BuildContext context) => [
                            const PopupMenuItem<String>(
                              value: 'edit',
                              child: Row(
                                children: [
                                  Icon(Icons.edit_rounded, color: Colors.blue, size: 18),
                                  SizedBox(width: 8),
                                  Text(
                                    'Edit',
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                            PopupMenuItem<String>(
                              value: 'delete',
                              child: Row(
                                children: [
                                  Icon(Icons.delete_outline_rounded, color: Colors.red, size: 18),
                                  SizedBox(width: 8),
                                  Text(
                                    'Delete',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );

                },
              );
            }),
          ),
          const SizedBox(height: 75),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(
    BuildContext context,
    TransactionController controller,
    String id,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Transaction?"),
        content: const Text(
          "Are you sure you want to delete this transaction?",
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              controller.deleteTransaction(id);
              Get.back();
            },
            child: const Text(
              "Delete",
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
