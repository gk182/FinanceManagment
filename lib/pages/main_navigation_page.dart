import 'package:flutter/material.dart';
import 'package:finance_managment/components/bottom_navbar.dart'; // đổi đường dẫn nếu cần
import 'pages.dart';

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    HomePage(),
    AnalyticsPage(),
    TransactionPage(),
    CategoryPage(),
    ProfilePage(),
  ];

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: NavigationBarBottom(
        currentIndex: _selectedIndex,
        onTap: _onTabSelected,
      ),
    );
  }
}
