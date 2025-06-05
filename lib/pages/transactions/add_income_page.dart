import 'package:finance_managment/utils/user_helper.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../../models/category_model.dart'; // ✅ Đảm bảo import đúng

class AddIncomePage extends StatefulWidget {
  final Map<String, dynamic>? existingData;
  final String? docId;

  const AddIncomePage({super.key, this.existingData, this.docId});

  @override
  State<AddIncomePage> createState() => _AddIncomePageState();
}

class _AddIncomePageState extends State<AddIncomePage> {
  final _amountController = TextEditingController();
  final _descController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  List<CategoryModel> _incomeCategories = [];
  int _selectedCategoryIndex = 0;

  final String? uid = UserHelper.uid; // ✅ Thay bằng FirebaseAuth nếu cần

  @override
  void initState() {
    super.initState();
    _fetchIncomeCategories().then((_) {
      if (widget.existingData != null) {
        final data = widget.existingData!;
        _amountController.text = data['amount'].toString();
        _descController.text = data['description'];
        _selectedDate = (data['date'] as Timestamp).toDate();

        final index = _incomeCategories.indexWhere(
          (cat) => cat.id == data['categoryId'],
        );
        if (index != -1) {
          _selectedCategoryIndex = index;
        }
        setState(() {}); // để render lại giao diện
      }
    });
  }

  Future<void> _fetchIncomeCategories() async {
    final snapshot =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('categories')
            .where('type', isEqualTo: 'income')
            .get();

    setState(() {
      _incomeCategories =
          snapshot.docs
              .map((doc) => CategoryModel.fromFirestore(doc.data(), doc.id))
              .toList();
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  void _addIncome() async {
    final amount = double.tryParse(_amountController.text) ?? 0;
    final desc = _descController.text.trim();

    if (amount <= 0 || desc.isEmpty || _incomeCategories.isEmpty) return;

    final category = _incomeCategories[_selectedCategoryIndex];

    final data = {
      'amount': amount,
      'description': desc,
      'category': category.name,
      'categoryId': category.id,
      'iconCode': category.iconCode,
      'fontFamily': 'MaterialIcons',
      'date': Timestamp.fromDate(_selectedDate),
      'type': 'income',
    };

    final transactionsRef = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('transactions');

    if (widget.docId != null) {
      await transactionsRef.doc(widget.docId).update(data);
    } else {
      await transactionsRef.add(data);
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existingData != null;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 27, 231, 173),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.white),
        title: Text(
          isEditing ? 'EDIT INCOME' : 'ADD NEW INCOME',
          style: const TextStyle(fontSize: 16, color: Colors.white),
        ),

        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),
            const Text(
              'Choose Category',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 70,
              child:
                  _incomeCategories.isEmpty
                      ? const Center(child: CircularProgressIndicator())
                      : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _incomeCategories.length,
                        itemBuilder: (context, index) {
                          final cat = _incomeCategories[index];
                          return GestureDetector(
                            onTap:
                                () => setState(
                                  () => _selectedCategoryIndex = index,
                                ),
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 6),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color:
                                    _selectedCategoryIndex == index
                                        ? const Color.fromARGB(195, 47, 54, 232)
                                        : const Color.fromARGB(
                                          255,
                                          115,
                                          132,
                                          225,
                                        ).withOpacity(0.4),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                IconData(
                                  cat.iconCode,
                                  fontFamily: 'MaterialIcons', // ❗ fix cứng
                                ),
                                color: Colors.white,
                              ),
                            ),
                          );
                        },
                      ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 27, 231, 173),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                ),
                child: Column(
                  children: [
                    TextFormField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: '\$26.00',
                        fillColor: const Color(0xFFEFFFF7),
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: _pickDate,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 20,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFFFF7),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(DateFormat.yMMMMd().format(_selectedDate)),
                            const Icon(Icons.calendar_today, size: 18),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: 'Description',
                        fillColor: const Color(0xFFEFFFF7),
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        width: 150,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _addIncome,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFEFFFF7),
                            foregroundColor: const Color.fromARGB(255, 8, 8, 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                          child: Text(
                            isEditing ? 'Update' : 'Add',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
