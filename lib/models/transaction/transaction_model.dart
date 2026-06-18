class TransactionModel {
  final String id;
  final String title;
  final double amount;
  final String type;
  final DateTime dateTime;
  final String? note;

  TransactionModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.type,
    required this.dateTime,
    this.note,
  });

  factory TransactionModel.fromMap(Map<dynamic, dynamic> map) {
    DateTime parsedDate;

    if (map['dateTime'] != null) {
      String dateStr = map['dateTime'].toString();

      if (dateStr.contains('•')) {
        try {
          String pureDateStr = dateStr.split('•').first.trim();
          parsedDate = DateTime.tryParse(pureDateStr) ?? DateTime.now();
        } catch (_) {
          parsedDate = DateTime.now();
        }
      } else {
        parsedDate = DateTime.tryParse(dateStr) ?? DateTime.now();
      }
    } else {
      parsedDate = DateTime.now();
    }

    return TransactionModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      amount: (map['amount'] ?? 0).toDouble(),
      type: map['type'] ?? '',
      dateTime: parsedDate,
      note: map['category'] ?? map['note'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'type': type,
      'dateTime': dateTime.toIso8601String(),
      'category': note,
    };
  }
}