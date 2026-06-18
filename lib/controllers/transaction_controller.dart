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

  void loadTransactions() {
    try {
      isLoading.value = true;
      final data = TransactionServices.getAllTransactions();
      transactions.assignAll(data);
    } catch (e) {
      CustomToast.showError('Failed to load transactions: $e');
      print('Error loading transactions: $e');
    } finally {
      isLoading.value = false;
    }
  }

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
      CustomToast.showSuccess('Transaction added successfully.');
      return true;
    } catch (e) {
      CustomToast.showError('Failed to add transaction: $e');
      return false;
    }
  }

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
      CustomToast.showSuccess('Updated successfully.');
      return true;
    } catch (e) {
      CustomToast.showError('Update failed: $e');
      return false;
    }
  }

  Future<void> deleteTransaction(String id) async {
    try {
      await TransactionServices.deleteTransaction(id);
      loadTransactions();
      CustomToast.showSuccess('Transaction deleted successfully.');
    } catch (e) {
      CustomToast.showError('Delete failed: $e');
    }
  }

  double get totalIncome => transactions
      .where((t) => t.type == 'Income')
      .fold(0.0, (sum, item) => sum + item.amount);

  double get totalExpense => transactions
      .where((t) => t.type == 'Expense')
      .fold(0.0, (sum, item) => sum + item.amount);

  double get totalBalance => totalIncome - totalExpense;

  List<TransactionModel> get recentTransactions => transactions.take(5).toList();
}