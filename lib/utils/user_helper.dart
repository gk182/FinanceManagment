import 'package:firebase_auth/firebase_auth.dart';

class UserHelper {
  static String? get uid => FirebaseAuth.instance.currentUser?.uid;
  static final user = FirebaseAuth.instance.currentUser!;

}

// Cách sử dụng:
// import 'package:finance_managment/utils/user_helper.dart';


// void someFunction() {
//   final userId = UserHelper.uid;
//   if (userId != null) {
//     print('UID người dùng hiện tại là: $userId');
//   } else {
//     print('Chưa đăng nhập');
//   }
// }
