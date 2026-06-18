import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_expense_tracker_hive_database/core/themes/color.dart';
import 'package:my_expense_tracker_hive_database/views/settings/widgets/action_tile.dart';
import 'package:my_expense_tracker_hive_database/views/settings/widgets/header.dart';
import 'package:my_expense_tracker_hive_database/views/settings/widgets/section_title.dart';
import 'package:my_expense_tracker_hive_database/views/settings/widgets/switch.dart';
import 'package:my_expense_tracker_hive_database/widgets/common/custom_button.dart';
import 'package:share_plus/share_plus.dart';
import '../../controllers/transaction_controller.dart';
import '../../controllers/theme_controller.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TransactionController transactionController =
        Get.find<TransactionController>();
    final ThemeController themeController = Get.find<ThemeController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Settings",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        scrolledUnderElevation: 0,
        backgroundColor: primaryColor,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Header(),

            const SizedBox(height: 24),
            SectionTitle(title: "General Settings"),
            const SizedBox(height: 10),

            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: GetBuilder<ThemeController>(
                builder: (controller) {
                  return SwitchTile(
                    icon: Icons.dark_mode_rounded,
                    iconColor: Colors.purple,
                    title: "Dark Mode",
                    value: Get.isDarkMode,
                    onChanged: (val) {
                      controller.toggleTheme(val);
                    },
                  );
                },
              ),
            ),

            const SizedBox(height: 24),
            SectionTitle(title: "App Preference & Interaction"),
            const SizedBox(height: 10),

            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  ActionTile(
                    icon: Icons.share_rounded,
                    iconColor: Colors.orange,
                    title: "Share App",
                    subtitle: "Spread the word to friends and family",
                    onTap: () {
                      _shareApp();
                    },
                  ),
                  const Divider(height: 1, indent: 55, endIndent: 20),

                  ActionTile(
                    icon: Icons.star_rate_rounded,
                    iconColor: Colors.amber,
                    title: "Rate Us",
                    subtitle: "Give us 5 stars on Play Store",
                    onTap: () {
                      _rateApp(context);
                    },
                  ),
                  const Divider(height: 1, indent: 55, endIndent: 20),

                  ActionTile(
                    icon: Icons.privacy_tip_rounded,
                    iconColor: Colors.teal,
                    title: "Privacy Policy",
                    subtitle: "How we protect your data",
                    onTap: () {
                      _showPrivacyPolicyBottomSheet(context);
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            SectionTitle(title: "Account Actions"),
            const SizedBox(height: 10),

            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  ActionTile(
                    icon: Icons.refresh_rounded,
                    iconColor: Colors.blue,
                    title: "Reset Database",
                    subtitle: "Clear all transaction history",
                    onTap: () {
                      _showResetDialog(context, transactionController);
                    },
                  ),
                  const Divider(height: 1, indent: 55, endIndent: 20),
                  ActionTile(
                    icon: Icons.info_outline_rounded,
                    iconColor: primaryColor,
                    title: "About Developer",
                    subtitle: "v1.0.0",
                    onTap: () {
                      _showAboutBottomSheet(context);
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  void _shareApp() {
    Share.share(
      'Hello! I am using this amazing "Personal Expense Tracker" app to manage my daily income and expenses easily. Download it now to track yours: https://play.google.com/store/apps/details?id=com.abdulahad.my_expense_tracker',
      subject: 'Download Expense Tracker App!',
    );
  }

  void _rateApp(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Enjoying the App?", textAlign: TextAlign.center),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Your positive review will motivate us to add more exciting features in the future!",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                5,
                (index) => const Icon(
                  Icons.star_rounded,
                  color: Colors.amber,
                  size: 32,
                ),
              ),
            ),
          ],
        ),
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Later", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
              Get.snackbar(
                "Thank You!",
                "We truly appreciate your support.",
                backgroundColor: Colors.white,
              );
            },
            child: const Text(
              "Rate Now",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showPrivacyPolicyBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Privacy Policy",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Expanded(
              child: SingleChildScrollView(
                child: Text(
                  "1. Data Security:\n"
                  "All your transaction data is completely encrypted and stored locally on your device using Hive database. We do not collect, store, or upload your personal or financial information to any third-party servers.\n\n"
                  "2. Offline Access:\n"
                  "This application works entirely offline. Therefore, there is zero risk of data leaks or online data theft.\n\n"
                  "3. Data Deletion:\n"
                  "You can permanently delete all your data from your device at any time by using the 'Reset Database' option found in the settings menu.",
                  style: TextStyle(fontSize: 14, height: 1.5),
                ),
              ),
            ),
            const SizedBox(height: 12),

            CustomButton(
              title: "I Understand",
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showResetDialog(
    BuildContext context,
    TransactionController controller,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Are you sure?"),
        content: const Text(
          "This will permanently erase all your transaction history from this device. This action cannot be undone!",
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              for (var tx in List.from(controller.transactions)) {
                controller.deleteTransaction(tx.id);
              }
              Navigator.pop(context);
              Get.snackbar(
                "Success",
                "Database has been cleared successfully!",
                backgroundColor: Colors.white,
              );
            },
            child: const Text(
              "Reset All",
              style: TextStyle(
                color: Colors.redAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAboutBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Expense Tracker App",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "Developed by Abdul Ahad",
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 20),
            const Text(
              "This is a secure offline personal expense tracker application designed to help you monitor and manage your daily income and expenses effortlessly.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: Color(0xFF616161),
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
