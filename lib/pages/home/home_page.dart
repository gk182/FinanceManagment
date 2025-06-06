import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import "../../utils/user_helper.dart";

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _selectedPeriod = 'Monthly';
  final String? uid = UserHelper.uid;

  double _totalIncome = 0.0;
  double _totalExpense = 0.0;
  double _totalBalance = 0.0;
  List<Map<String, dynamic>> _transactions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    setState(() => _isLoading = true);

    try {
      final now = DateTime.now();
      DateTime startDate;
      DateTime endDate = DateTime(now.year, now.month, now.day, 23, 59, 59);

      switch (_selectedPeriod) {
        case 'Daily':
          startDate = DateTime(now.year, now.month, now.day);
          break;
        case 'Weekly':
          final weekday = now.weekday;
          startDate = now.subtract(Duration(days: weekday - 1));
          startDate = DateTime(startDate.year, startDate.month, startDate.day);
          endDate = startDate.add(
            const Duration(days: 6, hours: 23, minutes: 59, seconds: 59),
          );
          break;
        case 'Monthly':
        default:
          startDate = DateTime(now.year, now.month, 1);
          endDate = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
          break;
      }

      final snapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(uid)
              .collection('transactions')
              .where(
                'date',
                isGreaterThanOrEqualTo: Timestamp.fromDate(startDate),
              )
              .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
              .orderBy('date', descending: true)
              .get();

      double income = 0.0;
      double expense = 0.0;
      List<Map<String, dynamic>> transactions = [];

      for (var doc in snapshot.docs) {
        final data = doc.data();
        data['id'] = doc.id;
        transactions.add(data);

        final amount = (data['amount'] as num).toDouble();
        if (data['type'] == 'income') {
          income += amount;
        } else {
          expense += amount;
        }
      }

      setState(() {
        _totalIncome = income;
        _totalExpense = expense;
        _totalBalance = income - expense;
        _transactions = transactions;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading transactions: $e');
      setState(() => _isLoading = false);
    }
  }

  Widget _buildPeriodSelector() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children:
            ['Daily', 'Weekly', 'Monthly'].map((period) {
              final isSelected = _selectedPeriod == period;
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() => _selectedPeriod = period);
                    _loadTransactions();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color:
                          isSelected
                              ? Colors.white.withOpacity(0.3)
                              : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      period,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }

  Widget _buildTransactionItem(Map<String, dynamic> transaction) {
    final isIncome = transaction['type'] == 'income';
    final amount = (transaction['amount'] as num).toDouble();
    final date = (transaction['date'] as Timestamp).toDate();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color:
                  isIncome
                      ? Colors.green.withOpacity(0.1)
                      : Colors.blue.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              IconData(
                transaction['iconCode'] ?? Icons.category.codePoint,
                fontFamily: 'MaterialIcons',
              ),
              color: isIncome ? Colors.green : Colors.blue,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction['category'] ?? 'Unknown',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  '${DateFormat('HH:mm').format(date)} - ${DateFormat('MMMM d').format(date)}',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ),
          Text(
            '${isIncome ? '+' : '-'}\$${amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: isIncome ? Colors.green : Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1BE7AD), Color(0xFF21C8A3)],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header

              // Welcome Text
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Hi, Welcome Back',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Total Balance
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.account_balance_wallet_outlined,
                          color: Colors.black,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Total Balance',
                          style: TextStyle(color: Colors.black, fontSize: 14),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '\$${_totalBalance.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Income and Expense
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.trending_up,
                                color: Colors.black,
                                size: 16,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Total Income',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '\$${_totalIncome.toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 40,
                      color: Colors.white.withOpacity(0.3),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.trending_down,
                                  color: Colors.black,
                                  size: 16,
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'Total Expense',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '-\$${_totalExpense.toStringAsFixed(2)}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Period Selector
              _buildPeriodSelector(),

              const SizedBox(height: 20),

              // Transactions List
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(30),
                    ),
                  ),
                  child:
                      _isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : _transactions.isEmpty
                          ? const Center(
                            child: Text(
                              'No transactions found',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                          )
                          : ListView.builder(
                            padding: const EdgeInsets.only(top: 20),
                            itemCount: _transactions.length,
                            itemBuilder: (context, index) {
                              return _buildTransactionItem(
                                _transactions[index],
                              );
                            },
                          ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
