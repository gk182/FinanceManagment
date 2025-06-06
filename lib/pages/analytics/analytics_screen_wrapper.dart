import 'package:finance_managment/pages/analytics/analytics_screen.dart';
import 'package:finance_managment/pages/analytics/viewmodels/expense_viewmodel.dart';
import 'package:finance_managment/pages/analytics/viewmodels/income_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AnalyticsScreenWrapper extends StatelessWidget {
  const AnalyticsScreenWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => IncomeViewModel()),
        ChangeNotifierProvider(create: (_) => ExpenseViewModel()),
      ],
      child: const AnalyticsScreen(),
    );
  }
}
