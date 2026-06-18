import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_expense_tracker_hive_database/services/notification_services.dart';
import 'package:my_expense_tracker_hive_database/services/transaction_services.dart';
import 'package:my_expense_tracker_hive_database/views/bottom/bottom_screen.dart';

import 'controllers/theme_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await TransactionServices.initHive();
  await Hive.openBox('settings');
  await NotificationServices.initNotification();
  final themeController = Get.put(ThemeController());
  runApp(MyApp(themeController: themeController));
}

class MyApp extends StatelessWidget {
  final ThemeController themeController;
  const MyApp({super.key, required this.themeController});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Expense Tracker',
      debugShowCheckedModeBanner: false,

      theme: ThemeData.light(useMaterial3: true).copyWith(
      ),
      darkTheme: ThemeData.dark(useMaterial3: true).copyWith(
      ),
      themeMode: themeController.themeMode,
      builder: (context, child) {
        child = BotToastInit()(context, child);
        return child;
      },
      navigatorObservers: [BotToastNavigatorObserver()],
      home: const BottomScreen(),
    );
  }
}