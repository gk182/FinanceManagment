import 'package:cloud_firestore/cloud_firestore.dart';

class Expense {
  final String id;
  final String categoryId;
  final double amount;
  final DateTime date;
  final String description;

  Expense({
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

  factory Expense.fromMap(String id, Map<String, dynamic> map) {
    return Expense(
      id: id,
      categoryId: map['categoryId'],
      amount: map['amount'].toDouble(),
      date: (map['date'] as Timestamp).toDate(),
      description: map['description'],
    );
  }
}
