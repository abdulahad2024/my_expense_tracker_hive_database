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

  static Future<void> addTransaction({
    required String title,
    required double amount,
    required String type,
    required String date,
    String? note,
  }) async {
    final box = Hive.box(transactionBox);
    String id = DateTime.now().millisecondsSinceEpoch.toString();

    Map<String, dynamic> transactionData = {
      'id': id,
      'title': title,
      'amount': amount,
      'type': type,
      'dateTime': date,
      'category': note ?? '',
    };

    await box.put(id, transactionData);
  }

  static List<TransactionModel> getAllTransactions() {
    final box = Hive.box(transactionBox);
    List<TransactionModel> transactions = [];

    for (var key in box.keys) {
      final data = box.get(key);
      if (data is Map) {
        try {
          transactions.add(
            TransactionModel.fromMap(Map<dynamic, dynamic>.from(data)),
          );
        } catch (e) {
          print("Error parsing transaction key $key: $e");
        }
      }
    }

    transactions.sort((a, b) {
      int dateCompare = b.dateTime.compareTo(a.dateTime);
      if (dateCompare != 0) {
        return dateCompare;
      }
      return b.id.compareTo(a.id);
    });

    return transactions;
  }

  static Future<void> updateTransaction({
    required String id,
    required String title,
    required double amount,
    required String type,
    required String date,
    String? note,
  }) async {
    final box = Hive.box(transactionBox);

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

  static Future<void> deleteTransaction(String id) async {
    final box = Hive.box(transactionBox);
    await box.delete(id);
  }
}
