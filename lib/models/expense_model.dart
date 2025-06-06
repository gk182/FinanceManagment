import 'package:cloud_firestore/cloud_firestore.dart';

class Expense {
  final String id;
  final double amount;
  final String description;
  final DateTime date;
  final String category;

  Expense({
    required this.id,
    required this.amount,
    required this.description,
    required this.date,
    required this.category,
  });

  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'] as String,
      amount: (map['amount'] as num).toDouble(),
      description: map['description'] as String,
      date: (map['date'] as DateTime),
      category: map['category'] as String,
    );
  }

  factory Expense.fromFirestore(Map<String, dynamic> data, String docId) {
    return Expense(
      id: docId,
      amount: (data['amount'] as num).toDouble(),
      description: data['description'] as String,
      date: (data['date'] as Timestamp).toDate(),
      category: data['category'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'description': description,
      'date': date,
      'category': category,
    };
  }
}
