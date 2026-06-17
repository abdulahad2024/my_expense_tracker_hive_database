class TransactionModel {
  final String id;
  final String title;
  final double amount;
  final String type;
  final DateTime dateTime;
  final String? note; // স্ক্রিনের ক্যাটাগরি ভ্যালু এখানে স্টোর হয়

  TransactionModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.type,
    required this.dateTime,
    this.note,
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
      // 💡 সেফটি ফিক্স: ডাটাবেজে যদি 'category' বা 'note' যেকোনো নামে সেভ থাকে, সেটিকে ক্যাচ করবে
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
      'category': note, // ডাটাবেজে 'category' কি (Key) তেই রাইট হবে
    };
  }
}