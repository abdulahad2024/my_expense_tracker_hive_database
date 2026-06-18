import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:my_expense_tracker_hive_database/core/themes/color.dart';
import '../../controllers/transaction_controller.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final amountController = TextEditingController();
  final dateController = TextEditingController();
  final categoryController = TextEditingController();

  String _selectedType = 'Expense';
  DateTime _selectedDateTime = DateTime.now();
  bool _isEditMode = false;
  dynamic _editTx;

  @override
  void initState() {
    super.initState();

    _editTx = Get.arguments;
    if (_editTx != null) {
      _isEditMode = true;

      if (_editTx is Map) {
        titleController.text = (_editTx['title'] ?? "").toString();
        amountController.text = (_editTx['amount'] ?? "").toString();
        _selectedType = _editTx['type'] ?? 'Expense';
        categoryController.text = (_editTx['category'] ?? _editTx['note'] ?? "").toString();
      } else {
        titleController.text = (_editTx.title ?? "").toString();
        amountController.text = (_editTx.amount ?? "").toString();
        _selectedType = _editTx.type ?? 'Expense';

        String tempCategory = "";
        try {
          tempCategory = _editTx.note ?? "";
        } catch (_) {}

        if (tempCategory.isEmpty) {
          try {
            final dynamicAsMap = _editTx.toMap();
            tempCategory = dynamicAsMap['category'] ?? dynamicAsMap['note'] ?? "";
          } catch (_) {}
        }
        categoryController.text = tempCategory;
      }

      try {
        final dynamic txDate = _editTx is Map ? _editTx['dateTime'] : _editTx.dateTime;
        if (txDate is DateTime) {
          _selectedDateTime = txDate;
        } else if (txDate is String) {
          _selectedDateTime = DateTime.tryParse(txDate) ?? DateTime.now();
        }
      } catch (e) {
        _selectedDateTime = DateTime.now();
      }
      // UI-তে সুন্দর করে দেখানোর জন্য ফরম্যাট
      dateController.text = DateFormat('yyyy-MM-dd • hh:mm a').format(_selectedDateTime);
    } else {
      // নিউ ট্রানজেকশনের ক্ষেত্রেও সময় সহ দেখাবে
      dateController.text = DateFormat('yyyy-MM-dd • hh:mm a').format(_selectedDateTime);
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    amountController.dispose();
    dateController.dispose();
    categoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TransactionController controller = Get.find<TransactionController>();
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          _isEditMode ? "Edit Transaction" : "Add Transaction",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _buildTypeSelectionCard(
                    context: context,
                    type: 'Expense',
                    label: 'Expense',
                    icon: Icons.south_west_rounded,
                    activeColor: isDarkMode ? const Color(0xFFE57373) : Colors.red.shade700,
                    backgroundColor: isDarkMode ? const Color(0xFF421D1D) : Colors.red.shade50,
                  ),
                  const SizedBox(width: 16),
                  _buildTypeSelectionCard(
                    context: context,
                    type: 'Income',
                    label: 'Income',
                    icon: Icons.north_east_rounded,
                    activeColor: isDarkMode ? const Color(0xFF81C784) : primaryColor,
                    backgroundColor: isDarkMode ? const Color(0xFF1B3A24) : Colors.green.shade50,
                  ),
                ],
              ),

              const SizedBox(height: 28),
              _buildSectionTitle(context, "Transaction Details"),
              const SizedBox(height: 12),

              CustomTextField(
                controller: titleController,
                hintText: "Title (e.g., Salary, Rent, Grocery)",
                prefixIcon: Icons.edit_note_rounded,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please enter a valid title";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              CustomTextField(
                controller: amountController,
                hintText: "Amount (৳)",
                prefixIcon: Icons.account_balance_wallet_outlined,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
                validator: (value) {
                  if (value == null || double.tryParse(value) == null || double.parse(value) <= 0) {
                    return "Please enter a valid amount";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              CustomTextField(
                controller: dateController,
                hintText: "Select Date",
                prefixIcon: Icons.calendar_today_rounded,
                readOnly: true,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: _selectedDateTime,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2035),
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: isDarkMode
                              ? const ColorScheme.dark(
                            primary: primaryColor,
                            onPrimary: Colors.white,
                            surface: Color(0xFF1E1E1E),
                            onSurface: Colors.white,
                          )
                              : const ColorScheme.light(
                            primary: primaryColor,
                            onPrimary: Colors.white,
                            onSurface: Colors.black,
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );

                  if (pickedDate != null) {
                    setState(() {
                      // 🎯 ফিক্স: সিলেক্টেড ডেটের সাথে নিখুঁত কারেন্ট টাইম মার্জ করা হলো
                      final now = DateTime.now();
                      _selectedDateTime = DateTime(
                        pickedDate.year,
                        pickedDate.month,
                        pickedDate.day,
                        now.hour,
                        now.minute,
                        now.second,
                      );
                      // UI টেক্সট আপডেট
                      dateController.text = DateFormat('yyyy-MM-dd • hh:mm a').format(_selectedDateTime);
                    });
                  }
                },
              ),
              const SizedBox(height: 16),

              CustomTextField(
                controller: categoryController,
                hintText: "Category or Short Note (Optional)",
                prefixIcon: Icons.category_outlined,
                maxLines: 2,
              ),

              const SizedBox(height: 40),

              Obx(() => CustomButton(
                title: _isEditMode ? "Update Transaction" : "Save Transaction",
                icon: Icons.check_circle_outline_rounded,
                backgroundColor: primaryColor,
                isLoading: controller.isLoading.value,
                onTap: () async {
                  if (_formKey.currentState!.validate()) {
                    final String isoDateStr = _selectedDateTime.toIso8601String();
                    bool success = false;

                    if (_isEditMode) {
                      success = await controller.updateTransaction(
                        id: _editTx is Map ? _editTx['id'] : _editTx.id,
                        title: titleController.text.trim(),
                        amount: double.parse(amountController.text),
                        type: _selectedType,
                        date: isoDateStr,
                        note: categoryController.text.trim().isEmpty ? null : categoryController.text.trim(),
                      );
                    } else {
                      success = await controller.addTransaction(
                        title: titleController.text.trim(),
                        amount: double.parse(amountController.text),
                        type: _selectedType,
                        date: isoDateStr,
                        note: categoryController.text.trim().isEmpty ? null : categoryController.text.trim(),
                      );
                    }

                    if (success) {
                      Get.back();
                    }
                  }
                },
              )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Text(
      title,
      style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.bold,
        color: isDarkMode ? Colors.grey.shade400 : const Color(0xFF616161),
        letterSpacing: 0.3,
      ),
    );
  }

  Widget _buildTypeSelectionCard({
    required BuildContext context,
    required String type,
    required String label,
    required IconData icon,
    required Color activeColor,
    required Color backgroundColor,
  }) {
    final bool isSelected = _selectedType == type;
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Expanded(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 56,
        child: Material(
          color: isSelected
              ? backgroundColor
              : (isDarkMode ? const Color(0xFF1E1E1E) : Colors.white),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: isSelected
                  ? activeColor
                  : (isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200),
              width: isSelected ? 2 : 1.5,
            ),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              setState(() {
                _selectedType = type;
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: isSelected ? activeColor : (isDarkMode ? Colors.grey.shade600 : Colors.grey.shade400),
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    color: isSelected ? activeColor : (isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}