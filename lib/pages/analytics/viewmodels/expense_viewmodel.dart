import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../models/expense_model.dart';
import '../../../utils/user_helper.dart';

class ExpenseViewModel extends ChangeNotifier {
  List<Expense> _expenses = [];
  bool _isLoading = false;

  List<Expense> get expenses => _expenses;
  bool get isLoading => _isLoading;

  ExpenseViewModel() {
    _loadExpenses();
  }

  Future<void> _loadExpenses() async {
    _isLoading = true;
    notifyListeners();

    try {
      final snapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(UserHelper.uid)
              .collection('transactions')
              .where('type', isEqualTo: 'expense')
              .get();

      _expenses =
          snapshot.docs
              .map((doc) => Expense.fromFirestore(doc.data(), doc.id))
              .toList();
    } catch (e) {
      debugPrint('Error loading expenses: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refresh() async {
    await _loadExpenses();
  }

  Future<void> loadExpenses() async {
    _isLoading = true;
    notifyListeners();

    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('expenses').get();
      _expenses =
          snapshot.docs
              .map((doc) => Expense.fromFirestore(doc.data(), doc.id))
              .toList();
    } catch (e) {
      print('Error loading expenses: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
