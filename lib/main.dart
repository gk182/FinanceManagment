import 'package:flutter/material.dart';
import 'core/firebase/firebase_config.dart';
import './pages/pages.dart';

void main() async {
  initFirebase();
  runApp(const FinWiseApp());
}

class FinWiseApp extends StatelessWidget {
  const FinWiseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FinWise',
      debugShowCheckedModeBanner: false,
      routes: {
        '/login': (_) => const LoginPage(),
        '/register': (_) => const RegisterPage(),
        '/home': (_) => const HomePage(),
      },
      home: const SplashPage(),
    );
  }
}
