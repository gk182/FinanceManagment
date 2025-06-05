import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'add_expense_page.dart';
import 'add_income_page.dart';
import '../categories/category_page.dart';

final String uid =
    'testUser123'; // ✅ Hoặc dùng FirebaseAuth.instance.currentUser?.uid nếu có login

class TransactionPage extends StatelessWidget {
  const TransactionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 27, 231, 173),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        foregroundColor: Colors.blueAccent,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CategoryPage()),
          );
        },
        child: const Icon(Icons.category),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              'Transaction',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Total Balance
            StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance
                      .collection('users')
                      .doc(uid)
                      .collection('transactions')
                      .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                }

                final transactions = snapshot.data!.docs;

                double totalIncome = 0;
                double totalExpense = 0;

                for (var doc in transactions) {
                  final data = doc.data() as Map<String, dynamic>;
                  final amount = (data['amount'] ?? 0).toDouble();
                  final type = data['type'] ?? '';

                  if (type == 'income') {
                    totalIncome += amount;
                  } else if (type == 'expense') {
                    totalExpense += amount;
                  }
                }

                final totalBalance = totalIncome - totalExpense;

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            children: [
                              const Text(
                                'Total Balance',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black54,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '\$${totalBalance.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 16),

            // Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AddIncomePage(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.call_made),
                      label: const Text('Income'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AddExpensePage(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.call_received),
                      label: const Text('Expense'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // List of transactions
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFEFFFF7),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                ),
                child: StreamBuilder<QuerySnapshot>(
                  stream:
                      FirebaseFirestore.instance
                          .collection('users')
                          .doc(uid)
                          .collection('transactions')
                          .orderBy('date', descending: true)
                          .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final transactions = snapshot.data!.docs;

                    if (transactions.isEmpty) {
                      return const Center(child: Text('No transactions yet.'));
                    }

                    return ListView.builder(
                      itemCount: transactions.length,
                      itemBuilder: (context, index) {
                        final data =
                            transactions[index].data() as Map<String, dynamic>;

                        final int? iconCode = data['iconCode'];

                        final IconData icon =
                            (iconCode != null)
                                ? IconData(
                                  iconCode,
                                  fontFamily: 'MaterialIcons',
                                )
                                : Icons.category;

                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: const Color(0xFFDFF5ED),
                            child: Icon(icon, color: Colors.black),
                          ),
                          title: Text(
                            data['description'] ?? '',
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                          subtitle: Text(
                            '${data['category']} • ${(data['date'] as Timestamp).toDate().day}/${(data['date'] as Timestamp).toDate().month}/${(data['date'] as Timestamp).toDate().year}',
                            style: const TextStyle(fontSize: 12),
                          ),
                          trailing: Text(
                            '${data['type'] == 'income' ? '+' : '-'} \$${data['amount'].toStringAsFixed(2)}',
                            style: TextStyle(
                              color:
                                  data['type'] == 'income'
                                      ? Colors.green
                                      : Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
