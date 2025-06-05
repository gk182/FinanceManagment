import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddCategoryPage extends StatefulWidget {
  const AddCategoryPage({super.key});

  @override
  State<AddCategoryPage> createState() => _AddCategoryPageState();
}

class _AddCategoryPageState extends State<AddCategoryPage> {
  final _nameController = TextEditingController();
  String _type = 'income';

  // Danh sách icon có thể chọn
  final Map<String, IconData> _availableIcons = {
    'Salary': Icons.attach_money,
    'Food': Icons.restaurant,
    'Transport': Icons.directions_bus,
    'User': Icons.person,
    'Bank': Icons.account_balance,
    'Gift': Icons.card_giftcard,
    'Groceries': Icons.shopping_bag,
    'Rent': Icons.home,
  };

  String _selectedIconName = 'Salary';
  int _iconCode = Icons.attach_money.codePoint;

  String _colorHex = '#4CAF50'; // bạn có thể làm danh sách chọn màu nếu cần

  Future<void> _saveCategory() async {
    final uid = 'testUser123'; // dùng uid cố định cho test

    final name = _nameController.text.trim();

    if (name.isEmpty) return;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('categories')
        .add({
          'name': name,
          'type': _type,
          'iconCode': _iconCode,
          'fontFamily': 'MaterialIcons',
          'color': _colorHex,
        });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text('New Category', textAlign: TextAlign.center),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Tên danh mục
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              hintText: 'Write...',
              filled: true,
              fillColor: Color(0xFFEFFFF7),
            ),
          ),
          const SizedBox(height: 12),

          // Chọn loại: income / expense
          ToggleButtons(
            isSelected: [_type == 'income', _type == 'expense'],
            onPressed: (index) {
              setState(() {
                _type = index == 0 ? 'income' : 'expense';
              });
            },
            borderRadius: BorderRadius.circular(12),
            selectedColor: Colors.white,
            fillColor: Colors.teal,
            children: const [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text('INCOME'),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text('EXPENSES'),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Chọn biểu tượng
          const Text(
            'Select Icon',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          DropdownButton<String>(
            value: _selectedIconName,
            isExpanded: true,
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _selectedIconName = value;
                  _iconCode = _availableIcons[value]!.codePoint;
                });
              }
            },
            items:
                _availableIcons.entries.map((entry) {
                  return DropdownMenuItem<String>(
                    value: entry.key,
                    child: Center(child: Icon(entry.value)),
                  );
                }).toList(),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(onPressed: _saveCategory, child: const Text('Save')),
      ],
    );
  }
}
