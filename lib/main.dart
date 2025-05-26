import 'package:flutter/material.dart';
import 'core/firebase/firebase_config.dart';

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
    initFirebase()
        .then((_) {
          setState(() {
            _status = '✅ Firebase is initialized successfully!';
          });
        })
        .catchError((error) {
          setState(() {
            _status = '❌ Failed to initialize Firebase:\n$error';
          });
        });
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
