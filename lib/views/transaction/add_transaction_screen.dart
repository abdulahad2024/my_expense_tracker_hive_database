import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
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

      print("====== TX EDIT DATA DEBUG ======");
      if (_editTx is Map) {
        print("TX_DATA_TYPE: Map");
        print("TX_DATA_CONTENT: $_editTx");
      } else {
        print("TX_DATA_TYPE: Object (${_editTx.runtimeType})");
        try {
          print("TX_DATA_CONTENT (toMap): ${_editTx.toMap()}");
        } catch (e) {
          print("TX_DATA_CONTENT (toString): ${_editTx.toString()}");
        }
      }
      print("=================================");

      // 🎯 ডাটা এক্সট্র্যাকশন ও অটো-ফিল ফিক্স
      if (_editTx is Map) {
        titleController.text = (_editTx['title'] ?? "").toString();
        amountController.text = (_editTx['amount'] ?? "").toString();
        _selectedType = _editTx['type'] ?? 'Expense';
        categoryController.text = (_editTx['category'] ?? _editTx['note'] ?? "").toString();
      } else {
        titleController.text = (_editTx.title ?? "").toString();
        amountController.text = (_editTx.amount ?? "").toString();
        _selectedType = _editTx.type ?? 'Expense';

        // 💡 মডেল অবজেক্টের আসল প্রোপার্টি 'note' রিড করা হচ্ছে
        String tempCategory = "";
        try {
          tempCategory = _editTx.note ?? "";
        } catch (_) {}

        // যদি অবজেক্ট প্রোপার্টি খালি থাকে তবে ইন্টারনাল ম্যাপের মাধ্যমে খোঁজার ব্যাকআপ চেষ্টা
        if (tempCategory.isEmpty) {
          try {
            final dynamicAsMap = _editTx.toMap();
            tempCategory = dynamicAsMap['category'] ?? dynamicAsMap['note'] ?? "";
          } catch (_) {}
        }
        categoryController.text = tempCategory;
      }

      // ডেট ফরম্যাট নিখুঁতভাবে হ্যান্ডেল করার লজিক
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
      dateController.text = DateFormat('yyyy-MM-dd').format(_selectedDateTime);
    } else {
      dateController.text = DateFormat('yyyy-MM-dd').format(_selectedDateTime);
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
    final primaryColor = const Color(0xFF2E7D32);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F6),
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
              // 🔄 ১. ইনকাম/এক্সপেন্স টগল কার্ড
              Row(
                children: [
                  _buildTypeSelectionCard(
                    type: 'Expense',
                    label: 'Expense',
                    icon: Icons.arrow_upward_rounded,
                    activeColor: Colors.red.shade700,
                    backgroundColor: Colors.red.shade50,
                  ),
                  const SizedBox(width: 16),
                  _buildTypeSelectionCard(
                    type: 'Income',
                    label: 'Income',
                    icon: Icons.arrow_downward_rounded,
                    activeColor: Colors.green.shade700,
                    backgroundColor: Colors.green.shade50,
                  ),
                ],
              ),

              const SizedBox(height: 28),
              _buildSectionTitle("Transaction Details"),
              const SizedBox(height: 12),

              // 📝 ২. টাইটেল কাস্টম টেক্সট ফিল্ড
              CustomTextField(
                controller: titleController,
                hintText: "Title (e.g., Salary, Rent, Grocery)",
                prefixIcon: Icons.edit_note_rounded,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "দয়া করে একটি সঠিক টাইটেল দিন";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // 💰 ৩. অ্যামাউন্ট কাস্টম টেক্সট ফিল্ড
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
                    return "সঠিক টাকার পরিমাণ উল্লেখ করুন";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // 📅 ৪. কাস্টম ডেট পিকার ফিল্ড
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
                          colorScheme: ColorScheme.light(
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
                      _selectedDateTime = pickedDate;
                      dateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
                    });
                  }
                },
              ),
              const SizedBox(height: 16),

              // ✉️ ৫. ক্যাটাগরি/নোট ফিল্ড
              CustomTextField(
                controller: categoryController,
                hintText: "Category or Short Note (Optional)",
                prefixIcon: Icons.category_outlined,
                maxLines: 2,
              ),

              const SizedBox(height: 40),

              // 🚀 ৬. কাস্টম বাটন
              Obx(() => CustomButton(
                title: _isEditMode ? "Update Transaction" : "Save Transaction",
                icon: Icons.check_circle_outline_rounded,
                backgroundColor: primaryColor,
                isLoading: controller.isLoading.value,
                onTap: () async {
                  if (_formKey.currentState!.validate()) {
                    final String formattedDateStr = dateController.text;
                    bool success = false;

                    if (_isEditMode) {
                      success = await controller.updateTransaction(
                        id: _editTx is Map ? _editTx['id'] : _editTx.id,
                        title: titleController.text.trim(),
                        amount: double.parse(amountController.text),
                        type: _selectedType,
                        date: formattedDateStr,
                        note: categoryController.text.trim().isEmpty ? null : categoryController.text.trim(),
                      );
                    } else {
                      success = await controller.addTransaction(
                        title: titleController.text.trim(),
                        amount: double.parse(amountController.text),
                        type: _selectedType,
                        date: formattedDateStr,
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

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.bold,
        color: Color(0xFF616161),
        letterSpacing: 0.3,
      ),
    );
  }

  Widget _buildTypeSelectionCard({
    required String type,
    required String label,
    required IconData icon,
    required Color activeColor,
    required Color backgroundColor,
  }) {
    final bool isSelected = _selectedType == type;

    return Expanded(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 56,
        child: Material(
          color: isSelected ? backgroundColor : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: isSelected ? activeColor : Colors.grey.shade200,
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
                  color: isSelected ? activeColor : Colors.grey.shade400,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    color: isSelected ? activeColor : Colors.grey.shade600,
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