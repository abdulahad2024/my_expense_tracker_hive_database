import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationServices {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
  FlutterLocalNotificationsPlugin();

  // 🎯 ১. নোটিফিকেশন ইনিশিয়ালাইজ করা (Fix: settings parameter added)
  static Future<void> initNotification() async {
    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings =
    DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    // 🔥 ফিক্স ১: এখানে 'settings:' নাম উল্লেখ করে দিতে হবে
    await _notificationsPlugin.initialize(
      settings: initSettings,
    );

    // অ্যান্ডরয়েড ১৩+ এর জন্য পারমিশন রিকোয়েস্ট
    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  // 🎯 ২. ইনস্ট্যান্ট নোটিফিকেশন পাঠানোর মেথড (Fix: show method named parameters)
  static Future<void> showInstantNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    const AndroidNotificationDetails androidDetails =
    AndroidNotificationDetails(
      'expense_tracker_channel',
      'Expense Reminders',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(),
    );

    // 🔥 ফিক্স ২: .show() মেথডের ভেতর সব ভ্যালুর আগে নাম (id:, title:, body:, notificationDetails:) দিতে হবে
    await _notificationsPlugin.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: notificationDetails,
    );
  }
}