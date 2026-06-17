import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/transaction_controller.dart'; // আপনার কন্ট্রোলারের সঠিক পাথ দিন

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool _isDarkMode = false;
  bool _isNotificationEnabled = true;

  @override
  Widget build(BuildContext context) {
    final TransactionController controller = Get.find<TransactionController>();
    final theme = Theme.of(context);
    final primaryColor = const Color(0xFF2E7D32); // অ্যাপের সিগনেচার গ্রিন থিম

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F6), // প্রিমিয়াম অফ-হোয়াইট ব্যাকগ্রাউন্ড
      appBar: AppBar(
        title: const Text(
          "Settings",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: primaryColor,
        elevation: 0,
        automaticallyImplyLeading: false, // বটম ন্যাভিগেশনের জন্য ব্যাক বাটন অফ
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 👤 ১. প্রোফাইল কার্ড সেকশন
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: primaryColor.withOpacity(0.1),
                    child: Icon(Icons.person_rounded, color: primaryColor, size: 35),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Abdul Ahad",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF212121)),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Premium Account",
                          style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            _buildSectionTitle("General Settings"),
            const SizedBox(height: 10),

            // 🛠️ ২. জেনারেল সেটিংস অপশনস
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  _buildSwitchTile(
                    icon: Icons.dark_mode_rounded,
                    iconColor: Colors.purple,
                    title: "Dark Mode",
                    value: _isDarkMode,
                    onChanged: (val) {
                      setState(() {
                        _isDarkMode = val;
                        // এখানে আপনার থিম চেঞ্জ করার লজিক দিতে পারেন (যেমন: Get.changeTheme)
                      });
                    },
                  ),
                  const Divider(height: 1, indent: 55, endIndent: 20, color: Color(0xFFF1F1F1)),
                  _buildSwitchTile(
                    icon: Icons.notifications_active_rounded,
                    iconColor: Colors.orange,
                    title: "Notifications",
                    value: _isNotificationEnabled,
                    onChanged: (val) {
                      setState(() {
                        _isNotificationEnabled = val;
                      });
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            _buildSectionTitle("Account Actions"),
            const SizedBox(height: 10),

            // ⚠️ ৩. অ্যাকাউন্ট অ্যাকশন অপশনস (ডাটা ক্লিয়ার লজিক)
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  _buildActionTile(
                    icon: Icons.refresh_rounded,
                    iconColor: Colors.blue,
                    title: "Reset Database",
                    subtitle: "Clear all transaction history",
                    onTap: () {
                      _showResetDialog(context, controller);
                    },
                  ),
                  const Divider(height: 1, indent: 55, endIndent: 20, color: Color(0xFFF1F1F1)),
                  _buildActionTile(
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

            const SizedBox(height: 85), // বটম বারের সেফ মার্জিন গ্যাপ
          ],
        ),
      ),
    );
  }

  // সেকশন হেডার টাইটেল বিল্ডার
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Color(0xFF757575),
        letterSpacing: 0.3,
      ),
    );
  }

  // সুইচ (Toggle) সম্বলিত লিস্ট টাইল বিল্ডার
  Widget _buildSwitchTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: iconColor.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
        child: Icon(icon, color: iconColor, size: 22),
      ),
      title: Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF212121))),
      trailing: Switch.adaptive(
        value: value,
        activeColor: const Color(0xFF2E7D32),
        onChanged: onChanged,
      ),
    );
  }

  // ক্লিকঅ্যাবল অ্যাকশন লিস্ট টাইল বিল্ডার
  Widget _buildActionTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: iconColor.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
        child: Icon(icon, color: iconColor, size: 22),
      ),
      title: Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF212121))),
      subtitle: Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
      trailing: Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.grey.shade400),
    );
  }

  // ডাটাবেজ রিসেট করার কনফার্মেশন অ্যালার্ট ডায়ালগ
  void _showResetDialog(BuildContext context, TransactionController controller) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Are you sure?"),
        content: const Text("এটি আপনার সমস্ত ট্রানজেকশন ডাটা স্থায়ীভাবে মুছে ফেলবে। এই অ্যাকশনটি রিভার্ট করা যাবে না!"),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              // আপনার কন্ট্রোলারের লুপ বা ডাটা ডিলিট লজিক কল করা
              for (var tx in List.from(controller.transactions)) {
                controller.deleteTransaction(tx.id);
              }
              Navigator.pop(context);
            },
            child: const Text("Reset All", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  // ডেভেলপার ইনফো দেখার সুন্দর বটম শিট
  void _showAboutBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10))),
            const SizedBox(height: 20),
            const Text("Expense Tracker App", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text("Developed by Abdul Ahad", style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
            const SizedBox(height: 20),
            const Text(
              "এটি একটি নিরাপদ লোকাল ডাটাবেজ সম্বলিত এক্সপেন্স ট্র্যাকার অ্যাপ্লিকেশন, যা আপনার দৈনিক আয় এবং ব্যয়ের হিসাব রাখতে সাহায্য করে।",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Color(0xFF616161), height: 1.4),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}