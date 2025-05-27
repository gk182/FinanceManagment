import 'package:flutter/material.dart';
import 'core/firebase/firebase_config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized(); // Đảm bảo binding đã được khởi tạo
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const FirebaseInitScreen(),
    );
  }
}

class FirebaseInitScreen extends StatefulWidget {
  const FirebaseInitScreen({super.key});

  @override
  State<FirebaseInitScreen> createState() => _FirebaseInitScreenState();
}

class _FirebaseInitScreenState extends State<FirebaseInitScreen> {
  String _status = 'Loading...';

  @override
  void initState() {
    super.initState();
    _initializeFirebaseAndCheckServices();
  }

  Future<void> _initializeFirebaseAndCheckServices() async {
    try {
      await initFirebase();

      // Kiểm tra Firebase Auth
      final user = FirebaseAuth.instance.currentUser;
      final authStatus = user != null
          ? '✅ Auth: Logged in as ${user.email}'
          : '✅ Auth: Chưa đăng nhập';

      // Kiểm tra Firestore
      final doc = await FirebaseFirestore.instance
          .collection('test')
          .doc('check')
          .get();

      final firestoreStatus = doc.exists
          ? '✅ Firestore: Document exists'
          : '✅ Firestore: Document does not exist';

      setState(() {
        _status = '✅ Firebase is initialized successfully!\n\n'
            '$authStatus\n'
            '$firestoreStatus';
      });
    } catch (error) {
      setState(() {
        _status = '❌ Failed to initialize or access Firebase:\n$error';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Firebase Initialization Example')),
      body: Center(
        child: Text(
          _status,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
