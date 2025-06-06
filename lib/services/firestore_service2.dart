// // chuẩn bị xóa file này

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class FirestoreService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   Future<void> initUserData() async {
//     final user = _auth.currentUser;
//     if (user == null) throw Exception("User not logged in");

//     final uid = user.uid;
//     final userDoc = _firestore.collection('users').doc(uid);

//     // Tạo categories
//     await userDoc.collection('categories').doc('cate1').set({
//       'name': 'Ăn uống',
//       'type': 'expense',
//       'iconCode': 58732,
//       'fontFamily': 'MaterialIcons',
//       'color': '#FF7043',
//     });

//     // Tạo income
//     await userDoc.collection('incomes').doc('income1').set({
//       'categoryId': 'cate1',
//       'amount': 500000,
//       'date': Timestamp.now(),
//       'description': 'Lương tháng 5',
//     });

//     // Tạo expense
//     await userDoc.collection('expenses').doc('expense1').set({
//       'categoryId': 'cate1',
//       'amount': 200000,
//       'date': Timestamp.now(),
//       'description': 'Ăn trưa',
//     });
//   }
// }
