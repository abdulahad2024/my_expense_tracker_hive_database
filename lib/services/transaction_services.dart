import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_expense_tracker_hive_database/models/transaction/transaction_model.dart';

class TransactionServices {
  static const String transactionBox = 'transaction_box';

  static Future<void> initHive() async {
    await Hive.initFlutter();
    if (!Hive.isBoxOpen(transactionBox)) {
      await Hive.openBox(transactionBox);
    }
  }

  // --- CREATE ---
  static Future<void> addTransaction({
    required String title,
    required double amount,
    required String type,
    required String date,
    String? note,
  }) async {
    final box = Hive.box(transactionBox);
    String id = DateTime.now().millisecondsSinceEpoch.toString();

    // 🎯 ফিক্স: মডেলের fromMap-এর সাথে মিলিয়ে key নাম 'dateTime' এবং 'category' দেওয়া হলো
    Map<String, dynamic> transactionData = {
      'id': id,
      'title': title,
      'amount': amount,
      'type': type,
      'dateTime': date, // মডেল 'dateTime' রিড করে
      'category': note ?? '', // মডেল 'category' রিড করে
    };

    await box.put(id, transactionData);
  }

  // --- READ ---
  static List<TransactionModel> getAllTransactions() {
    final box = Hive.box(transactionBox);
    List<TransactionModel> transactions = [];

    for (var key in box.keys) {
      final data = box.get(key);
      if (data is Map) {
        transactions.add(TransactionModel.fromMap(data));
      }
    }
    return transactions.reversed.toList();
  }

  // --- UPDATE ---
  static Future<void> updateTransaction({
    required String id,
    required String title,
    required double amount,
    required String type,
    required String date,
    String? note,
  }) async {
    final box = Hive.box(transactionBox);

    // 🎯 ফিক্স: আপডেট করার সময়ও যেন একই key নামে ডাটাবেজে ডাটা মডিফাই হয়
    Map<String, dynamic> updatedData = {
      'id': id,
      'title': title,
      'amount': amount,
      'type': type,
      'dateTime': date,
      'category': note ?? '',
    };

    await box.put(id, updatedData);
  }

  // --- DELETE ---
  static Future<void> deleteTransaction(String id) async {
    final box = Hive.box(transactionBox);
    await box.delete(id);
  }
}