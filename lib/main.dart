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
        '/home': (_) => const HomePage(),
        '/transaction': (_) => const TransactionPage(),
        '/add-expense': (_) => const AddExpensePage(),
        '/add-income': (_) => const AddIncomePage(),
        '/category': (_) => const CategoryPage(),
        '/add-category': (_) => const AddCategoryPage(),
      },
      home: const SplashPage(),
    );
  }
}
