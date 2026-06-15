import 'package:bot_toast/bot_toast.dart'; // ইম্পোর্ট করুন
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_expense_tracker_hive_database/services/transaction_services.dart';
import 'package:my_expense_tracker_hive_database/views/bottom/bottom_screen.dart';

void main() async {
  runApp(const MyApp());
  await TransactionServices.initHive();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Personal Expense Tracker',
      builder: BotToastInit(),
      navigatorObservers: [BotToastNavigatorObserver()],
      home: const BottomScreen(),
    );
  }
}