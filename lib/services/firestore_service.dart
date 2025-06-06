// // chuẩn bị xóa file này

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import '../models/user_model.dart';

// class FirestoreService {
//   final FirebaseFirestore _db = FirebaseFirestore.instance;

//   Future<void> initUserData() async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user == null) throw Exception("Chưa đăng nhập");

//     final docRef = _db.collection('users').doc(user.uid);
//     final snapshot = await docRef.get();

//     if (!snapshot.exists) {
//       final appUser = AppUser(uid: user.uid, email: user.email ?? '');
//       await docRef.set(appUser.toMap());
//     }
//   }
// }

