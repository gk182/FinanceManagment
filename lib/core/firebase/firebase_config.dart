import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '../../../firebase_options.dart'; // đường dẫn đúng nếu bạn dùng FlutterFire CLI

Future<void> initFirebase() async {
  try {
    // Đảm bảo binding được khởi tạo trước khi dùng Firebase
    WidgetsFlutterBinding.ensureInitialized();

    // Khởi tạo Firebase với cấu hình đúng platform
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    debugPrint('✅ Firebase initialized successfully');
  } catch (e, stackTrace) {
    debugPrint('❌ Firebase initialization failed: $e');
    debugPrintStack(stackTrace: stackTrace);
    rethrow; // ném lỗi lại để xử lý bên ngoài nếu cần
  }
}
