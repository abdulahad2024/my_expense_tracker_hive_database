class TransactionModel {
  final String id;
  final String title;
  final double amount;
  final String type;
  final DateTime dateTime;
  final String? category;

  TransactionModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.type,
    required this.dateTime,
    this.category,
  });

  factory TransactionModel.fromMap(Map<dynamic, dynamic> map) {
    return TransactionModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      amount: (map['amount'] ?? 0).toDouble(),
      type: map['type'] ?? '',
      dateTime: map['dateTime'] != null
          ? DateTime.parse(map['dateTime'])
          : DateTime.now(),
      category: map['category'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'type': type,
      'dateTime': dateTime.toIso8601String(),
      'category': category,
    };
  }
}