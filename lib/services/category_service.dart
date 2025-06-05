import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

Future<void> addDefaultCategories(String uid) async {
  final userDoc = FirebaseFirestore.instance.collection('users').doc(uid);

  final defaultCategories = [
    {
      'name': 'Ăn uống',
      'type': 'expense',
      'iconCode': Icons.fastfood.codePoint,
      'fontFamily': Icons.fastfood.fontFamily,
      'color': '#FF7043',
    },
    {
      'name': 'Di chuyển',
      'type': 'expense',
      'iconCode': Icons.directions_car.codePoint,
      'fontFamily': Icons.directions_car.fontFamily,
      'color': '#29B6F6',
    },
    {
      'name': 'Giải trí',
      'type': 'expense',
      'iconCode': Icons.movie.codePoint,
      'fontFamily': Icons.movie.fontFamily,
      'color': '#BA68C8',
    },
    {
      'name': 'Mua sắm',
      'type': 'expense',
      'iconCode': Icons.shopping_bag.codePoint,
      'fontFamily': Icons.shopping_bag.fontFamily,
      'color': '#FFB74D',
    },
    {
      'name': 'Học tập',
      'type': 'expense',
      'iconCode': Icons.school.codePoint,
      'fontFamily': Icons.school.fontFamily,
      'color': '#4FC3F7',
    },
    {
      'name': 'Y tế',
      'type': 'expense',
      'iconCode': Icons.local_hospital.codePoint,
      'fontFamily': Icons.local_hospital.fontFamily,
      'color': '#E57373',
    },
    {
      'name': 'Tiết kiệm',
      'type': 'expense',
      'iconCode': Icons.savings.codePoint,
      'fontFamily': Icons.savings.fontFamily,
      'color': '#81C784',
    },
    {
      'name': 'Lương',
      'type': 'income',
      'iconCode': Icons.attach_money.codePoint,
      'fontFamily': Icons.attach_money.fontFamily,
      'color': '#66BB6A',
    },
    {
      'name': 'Thưởng',
      'type': 'income',
      'iconCode': Icons.card_giftcard.codePoint,
      'fontFamily': Icons.card_giftcard.fontFamily,
      'color': '#FFD54F',
    },
    {
      'name': 'Khác',
      'type': 'expense',
      'iconCode': Icons.category.codePoint,
      'fontFamily': Icons.category.fontFamily,
      'color': '#90A4AE',
    },
  ];

  for (int i = 0; i < defaultCategories.length; i++) {
    final cateId = 'cate${i + 1}';
    await userDoc.collection('categories').doc(cateId).set(defaultCategories[i]);
  }
}
