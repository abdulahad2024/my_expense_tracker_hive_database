import 'package:get/get.dart';
import 'package:my_expense_tracker_hive_database/core/helper/custom_toast.dart';
import '../../models/transaction/transaction_model.dart';
import '../../services/transaction_services.dart';

class TransactionController extends GetxController {
  var transactions = <TransactionModel>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadTransactions();
  }

  // --- READ ---
  void loadTransactions() {
    try {
      isLoading.value = true;
      final data = TransactionServices.getAllTransactions();
      transactions.assignAll(data);
    } catch (e) {
      CustomToast.showError('ডাটা লোড করতে সমস্যা হয়েছে: $e');
      print('Error loading transactions: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // --- CREATE ---
  Future<bool> addTransaction({
    required String title,
    required double amount,
    required String type,
    required String date,
    String? note,
  }) async {
    try {
      await TransactionServices.addTransaction(
        title: title,
        amount: amount,
        type: type,
        date: date,
        note: note,
      );
      loadTransactions();
      CustomToast.showSuccess('ট্রানজেকশনটি সফলভাবে যোগ করা হয়েছে।');
      return true;
    } catch (e) {
      CustomToast.showError('যোগ করা সম্ভব হয়নি: $e');
      return false;
    }
  }

  // --- UPDATE ---
  Future<bool> updateTransaction({
    required String id,
    required String title,
    required double amount,
    required String type,
    required String date,
    String? note,
  }) async {
    try {
      await TransactionServices.updateTransaction(
        id: id,
        title: title,
        amount: amount,
        type: type,
        date: date,
        note: note,
      );
      loadTransactions();
      CustomToast.showSuccess('সফলভাবে আপডেট করা হয়েছে।');
      return true;
    } catch (e) {
      CustomToast.showError('আপডেট করা সম্ভব হয়নি: $e');
      return false;
    }
  }

  // --- DELETE ---
  Future<void> deleteTransaction(String id) async {
    try {
      await TransactionServices.deleteTransaction(id);
      loadTransactions();
      CustomToast.showSuccess('ট্রানজেকশনটি সফলভাবে মুছে ফেলা হয়েছে।');
    } catch (e) {
      CustomToast.showError('মুছে ফেলা সম্ভব হয়নি: $e');
    }
  }

  // --- CALCULATIONS ---
  double get totalIncome => transactions
      .where((t) => t.type == 'Income')
      .fold(0.0, (sum, item) => sum + item.amount);

  double get totalExpense => transactions
      .where((t) => t.type == 'Expense')
      .fold(0.0, (sum, item) => sum + item.amount);

  double get totalBalance => totalIncome - totalExpense;

  List<TransactionModel> get recentTransactions =>
      transactions.take(5).toList();
}