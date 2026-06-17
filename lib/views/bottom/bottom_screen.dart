import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

  // 💡 সমাধান ১: রানটাইম JS/Web ক্র্যাশ এড়াতে অন-ডিমান্ড মেথডের মাধ্যমে স্ক্রিন বিল্ড করা
  // 💡 সমাধান ২: AnimatedSwitcher-এর পারফেক্ট ট্রানজিশনের জন্য প্রতিটিতে আলাদা 'ValueKey' যুক্ত করা হয়েছে
  Widget _getSelectedScreen(int index) {
    switch (index) {
      case 0:
        return const DashboardScreen(key: ValueKey(0));
      case 1:
        return const AnalyticsScreen(key: ValueKey(1));
      case 2:
        return const TransactionListScreen(key: ValueKey(2));
      case 3:
        return SettingScreen(key: const ValueKey(3)); // আপনার এই স্ক্রিনটি const না হলে সমস্যা নেই, key কাজ করবে
      default:
        return const DashboardScreen(key: ValueKey(0));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Scaffold(
      // বটম বারের নিচের অংশ সুন্দরভাবে দেখানোর জন্য extendBody ট্রু থাকবে
      extendBody: true,

      // নির্দিষ্ট স্ক্রিনটি মেথড থেকে কল করা হচ্ছে এবং স্মুথ অ্যানিমেশন হ্যান্ডেল করা হচ্ছে
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
        shape: const CircleBorder(), // নিখুঁত রাউন্ড শেপের জন্য
        onPressed: () {
          Get.to(() => const AddTransactionScreen());
        },
        child: const Icon(
          Icons.add_rounded,
          color: Colors.white,
          size: 30,
        ),
      ),

      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        elevation: 12,
        color: theme.cardColor,
        child: SizedBox(
          height: 68,
          child: Row(
            children: [
              _buildNavItem(
                index: 0,
                icon: Icons.dashboard,
                label: "Dashboard",
              ),
              _buildNavItem(
                index: 1,
                icon: Icons.pie_chart_rounded,
                label: "Analytics",
              ),

              // ফ্লোটিং অ্যাকশন বাটনের জন্য মাঝখানের গ্যাপ
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
    );
  }

  // কাস্টম ন্যাভিগেশন আইটেম বিল্ডার যা রিয়েল-টাইমে অ্যাক্টিভ স্টেট কালার চেঞ্জ করে
  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required String label,
  }) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final bool isSelected = _currentIndex == index;

    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          if (_currentIndex != index) {
            setState(() {
              _currentIndex = index;
            });
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          // প্যাডিং কিছুটা কমিয়ে সেফ জোনে আনা হয়েছে
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min, // 💡 সমাধান: কলামটি যেন অতিরিক্ত জায়গা না নেয়
            children: [
              AnimatedScale(
                duration: const Duration(milliseconds: 250),
                scale: isSelected ? 1.12 : 1.0,
                child: Icon(
                  icon,
                  size: 24, // সাইজ ২৫ থেকে ২৪ করা হয়েছে পারফেক্ট ফিটের জন্য
                  color: isSelected
                      ? primaryColor
                      : theme.iconTheme.color?.withOpacity(.5) ?? Colors.grey,
                ),
              ),
              const SizedBox(height: 2), // স্পেসিফিকেশন গ্যাপ কমানো হয়েছে
              Flexible( // 💡 সমাধান: কোনো কারণে টেক্সট বড় হলেও ক্র্যাশ করবে না
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected
                        ? primaryColor
                        : theme.textTheme.bodySmall?.color?.withOpacity(.7) ?? Colors.grey,
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