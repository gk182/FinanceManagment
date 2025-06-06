import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../models/income_model.dart';
import '../../../utils/user_helper.dart';

class IncomeViewModel extends ChangeNotifier {
  List<Income> _incomes = [];
  bool _isLoading = false;

  List<Income> get incomes => _incomes;
  bool get isLoading => _isLoading;

  IncomeViewModel() {
    _loadIncomes();
  }

  Future<void> _loadIncomes() async {
    _isLoading = true;
    notifyListeners();

    try {
      final snapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(UserHelper.uid)
              .collection('transactions')
              .where('type', isEqualTo: 'income')
              .get();

      _incomes =
          snapshot.docs
              .map((doc) => Income.fromFirestore(doc.data(), doc.id))
              .toList();
    } catch (e) {
      debugPrint('Error loading incomes: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refresh() async {
    await _loadIncomes();
  }

  Future<void> loadIncomes() async {
    _isLoading = true;
    notifyListeners();

    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('incomes').get();
      _incomes =
          snapshot.docs
              .map((doc) => Income.fromFirestore(doc.data(), doc.id))
              .toList();
    } catch (e) {
      print('Error loading incomes: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
