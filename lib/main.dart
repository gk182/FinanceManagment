import 'package:finance_managment/pages/main_navigation_page.dart';
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
        '/welcome': (_) => const WelcomePage(),
        '/login': (_) => const LoginPage(),
        '/register': (_) => const RegisterPage(),
        '/reset-password': (context) => const ResetPasswordPage(),
        '/home': (_) => const MainNavigationPage(),
      },
      home: const SplashPage(),
    );
  }
}
