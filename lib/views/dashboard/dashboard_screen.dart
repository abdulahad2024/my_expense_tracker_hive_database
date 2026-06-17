import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../color.dart';
import '../../controllers/transaction_controller.dart';
import '../../services/notification_services.dart';
import '../transaction/add_transaction_screen.dart'; // আপনার সঠিক পাথ দিন

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get.put-এর বদলে Get.find ব্যবহার করা নিরাপদ যদি অলরেডি ইনিশিয়ালাইজড থাকে,
    // তবে ব্যাকআপ হিসেবে Get.put-ই রাখা হলো।
    final TransactionController controller = Get.put(TransactionController());

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          SizedBox(
            height: 350,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 220,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [primaryColor, Color(0xFF165A46)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(36),
                      bottomRight: Radius.circular(36),
                    ),
                  ),
                  padding: const EdgeInsets.fromLTRB(24, 60, 24, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Welcome back,",
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.65),
                              fontSize: 14,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            "Expense Tracker",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.12),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.notifications_none_rounded, color: Colors.white, size: 24),
                          onPressed: () async {
                            // 🎯 বাটনে ক্লিক করলেই নোটিফিকেশন আসবে!
                            await NotificationServices.showInstantNotification(
                              id: 1,
                              title: "আজকের হিসাব লিখেছেন কি? 📝",
                              body: "আপনার খরচগুলো ট্র্যাক করতে এখনই আজকের ট্রানজেকশনগুলো যুক্ত করুন।",
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                // 💳 ব্যালেন্স কার্ড (🎯 ফিক্স: এটি এখন Positioned উইজেটে রাখা হলো যেন নিখুঁতভাবে ভাসমান থাকে)
                Positioned(
                  top: 130,
                  left: 20,
                  right: 20,
                  child: Obx(() => Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF1E2A22), Color(0xFF121D17)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF121D17).withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        )
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.account_balance_wallet_outlined, color: Colors.white.withOpacity(0.5), size: 18),
                                const SizedBox(width: 8),
                                Text(
                                  "Total Balance",
                                  style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0.5),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          "৳ ${controller.totalBalance.toStringAsFixed(2)}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                            fontFamily: 'Roboto',
                          ),
                        ),
                        const SizedBox(height: 28),
                        Container(height: 1, color: Colors.white.withOpacity(0.08)),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildBalanceStat(
                              icon: Icons.arrow_downward_rounded,
                              iconColor: accentColor,
                              label: "Income",
                              amount: "৳ ${controller.totalIncome.toStringAsFixed(0)}",
                            ),
                            Container(width: 1, height: 35, color: Colors.white.withOpacity(0.1)),
                            _buildBalanceStat(
                              icon: Icons.arrow_upward_rounded,
                              iconColor: expenseColor,
                              label: "Expenses",
                              amount: "৳ ${controller.totalExpense.toStringAsFixed(0)}",
                            ),
                          ],
                        )
                      ],
                    ),
                  )),
                ),
              ],
            ),
          ),

          // 🎯 ফিক্স: ব্যালেন্স কার্ডের ঠিক নিচ থেকে হেডার শুরু করার জন্য ছোট একটি সেফ গ্যাপ
          const SizedBox(height: 10),

          // 🕒 ট্রানজেকশন হেডার
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Recent Transactions",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF1A1D1E), letterSpacing: 0.3),
                ),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    foregroundColor: primaryColor.withOpacity(0.1),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text(
                    "See all",
                    style: TextStyle(color: primaryColor, fontWeight: FontWeight.w700, fontSize: 14),
                  ),
                ),
              ],
            ),
          ),

          // 📜 ৪. রিসেন্ট ট্রানজেকশনের লাক্সারি লিস্ট ভিউ (সম্পূর্ণ ফিক্সড উইথ এডিট/ডিলিট)
          Expanded(
            child: Obx(() {
              if (controller.recentTransactions.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)
                        ]),
                        child: Icon(Icons.receipt_long_rounded, size: 45, color: Colors.grey.shade400),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "কোনো ট্রানজেকশন পাওয়া যায়নি!",
                        style: TextStyle(color: Colors.grey.shade500, fontSize: 15, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                itemCount: controller.recentTransactions.length,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  final tx = controller.recentTransactions[index];
                  final isIncome = tx.type == 'Income';

                  // আপনার মডেলের ডেট ভ্যারিয়েবলটি ফিল্টার করা হচ্ছে
                  DateTime parsedDate = DateTime.now();
                  if (tx.dateTime is DateTime) {
                    parsedDate = tx.dateTime as DateTime;
                  } else if (tx.dateTime is String) {
                    parsedDate = DateTime.tryParse(tx.dateTime as String) ?? DateTime.now();
                  }

                  return Container(
                    margin: const EdgeInsets.only(bottom: 14),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF000000).withOpacity(0.02),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        )
                      ],
                    ),
                    child: Row(
                      children: [
                        // আইকন কন্টেইনার
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isIncome ? const Color(0xFFE8F5E9) : const Color(0xFFFFEBEE),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(
                            isIncome ? Icons.south_west_rounded : Icons.north_east_rounded,
                            color: isIncome ? const Color(0xFF2E7D32) : const Color(0xFFC62828),
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),

                        // টাইটেল ও সাবটাইটেল
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                tx.title,
                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF1A1D1E)),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                DateFormat('MMM dd, yyyy • hh:mm a').format(parsedDate),
                                style: TextStyle(fontSize: 11, color: Colors.grey.shade500, fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                        ),

                        // অ্যামাউন্ট
                        Text(
                          "${isIncome ? '+ ' : '- '}৳${tx.amount.toStringAsFixed(1)}",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: isIncome ? const Color(0xFF2E7D32) : const Color(0xFFC62828),
                          ),
                        ),

                        // 🎯 অ্যাকশন পপআপ মেনু (Edit / Delete)
                        PopupMenuButton<String>(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          icon: Icon(Icons.more_vert_rounded, color: Colors.grey.shade400, size: 20),
                          padding: EdgeInsets.zero,
                          onSelected: (value) {
                            if (value == 'edit') {
                              // এডিট করার জন্য AddTransactionScreen-এ ডাটা পাঠানো হচ্ছে
                              Get.to(() => const AddTransactionScreen(), arguments: tx);
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
                                  Text('Edit', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                                ],
                              ),
                            ),
                            PopupMenuItem<String>(
                              value: 'delete',
                              child: Row(
                                children: [
                                  Icon(Icons.delete_outline_rounded, color: Colors.red.shade700, size: 18),
                                  SizedBox(width: 8),
                                  Text('Delete', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.red)),
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
          const SizedBox(height: 75), // বটম বারের জন্য সেফ স্পেস
        ],
      ),
    );
  }

  // 🗑️ ডিলিট কনফার্মেশন ডায়ালগ বক্স
  void _showDeleteConfirmation(BuildContext context, TransactionController controller, String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Transaction?"),
        content: const Text("আপনি কি নিশ্চিতভাবে এই ট্রানজেকশনটি ডিলিট করতে চান?"),
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
            child: const Text("Delete", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceStat({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String amount,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor, size: 16),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 0.3),
            ),
            const SizedBox(height: 4),
            Text(
              amount,
              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700, fontFamily: 'Roboto'),
            ),
          ],
        )
      ],
    );
  }
}