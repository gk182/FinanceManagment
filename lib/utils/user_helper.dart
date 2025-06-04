import 'package:firebase_auth/firebase_auth.dart';

class UserHelper {
  static String? get uid => FirebaseAuth.instance.currentUser?.uid;
}

// Cách sử dụng:
// import 'package:your_project_name/helpers/user_helper.dart';

// void someFunction() {
//   final userId = UserHelper.uid;
//   if (userId != null) {
//     print('UID người dùng hiện tại là: $userId');
//   } else {
//     print('Chưa đăng nhập');
//   }
// }
