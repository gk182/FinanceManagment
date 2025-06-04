import 'package:cloud_firestore/cloud_firestore.dart';

class Income {
  final String id;
  final String categoryId;
  final double amount;
  final DateTime date;
  final String description;

  Income({
    required this.id,
    required this.categoryId,
    required this.amount,
    required this.date,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'categoryId': categoryId,
      'amount': amount,
      'date': Timestamp.fromDate(date),
      'description': description,
    };
  }

  factory Income.fromMap(String id, Map<String, dynamic> map) {
    return Income(
      id: id,
      categoryId: map['categoryId'],
      amount: map['amount'].toDouble(),
      date: (map['date'] as Timestamp).toDate(),
      description: map['description'],
    );
  }
}
