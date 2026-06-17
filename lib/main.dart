import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_expense_tracker_hive_database/services/notification_services.dart';
import 'package:my_expense_tracker_hive_database/services/transaction_services.dart';
import 'package:my_expense_tracker_hive_database/views/bottom/bottom_screen.dart';

void main() async {
  // 💡 ফ্লাটার বাইন্ডিং নিশ্চিত করুন (অ্যাসিঙ্ক কোড থাকলে এটি বাধ্যতামূলক)
  WidgetsFlutterBinding.ensureInitialized();

  // 💡 অ্যাপ চালু হওয়ার আগেই ডাটাবেজ বক্স ওপেন করা নিশ্চিত করা হলো
  await TransactionServices.initHive();

  await NotificationServices.initNotification(); // 🎯 নোটিফিকেশন চালু হলো

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Personal Expense Tracker',
      debugShowCheckedModeBanner: false, // ডিবাগ ব্যানার হাইড করার জন্য
      builder: BotToastInit(),
      navigatorObservers: [BotToastNavigatorObserver()],
      home: const BottomScreen(),
    );
  }
}