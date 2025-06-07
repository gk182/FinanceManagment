import 'package:flutter/material.dart';
import '../../models/income_model.dart';
import '../../models/expense_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:finance_managment/constant/app_colors.dart';

// import 'dart:math';

// Widget hiển thị phân tích theo năm
class YearlyAnalyticsView extends StatelessWidget {
  final List<Income> incomes;
  final List<Expense> expenses;
  final DateTime selectedDate;
  final Function(DateTime) onDateChanged;

  const YearlyAnalyticsView({
    super.key,
    required this.incomes,
    required this.expenses,
    required this.selectedDate,
    required this.onDateChanged,
  });

  // Phương thức hỗ trợ lọc các giao dịch trong năm được chọn
  List<dynamic> _filterTransactionsForYear(
    List<dynamic> transactions,
    DateTime selectedDay,
  ) {
    final startOfYear = DateTime(selectedDay.year, 1, 1);
    final endOfYear = DateTime(selectedDay.year, 12, 31);

    return transactions.where((transaction) {
      if (transaction is Income || transaction is Expense) {
        final date = transaction.date;
        return date.isAfter(startOfYear.subtract(const Duration(days: 1))) &&
            date.isBefore(endOfYear.add(const Duration(days: 1)));
      }
      return false;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    // Lọc các giao dịch cho năm được chọn
    final yearlyIncomes = _filterTransactionsForYear(
      incomes,
      selectedDate,
    );
    final yearlyExpenses = _filterTransactionsForYear(
      expenses,
      selectedDate,
    );

    // Kết hợp các giao dịch trong năm
    final yearlyTransactions = [
      ...yearlyIncomes.map(
        (inc) => {
          'amount': (inc as Income).amount,
          'date': (inc as Income).date,
          'isIncome': true,
          'description': (inc as Income).description,
        },
      ),
      ...yearlyExpenses.map(
        (exp) => {
          'amount': (exp as Expense).amount,
          'date': (exp as Expense).date,
          'isIncome': false,
          'description': (exp as Expense).description,
        },
      ),
    ];

    // Nhóm các giao dịch theo tháng trong năm và tính tổng cho mỗi tháng
    Map<int, double> incomeTotalsPerMonth = {};
    Map<int, double> expenseTotalsPerMonth = {};

    for (var transaction in yearlyTransactions) {
      final month = (transaction['date'] as DateTime).month;
      final amount = transaction['amount'] as double;
      final isIncome = transaction['isIncome'] as bool;

      if (isIncome) {
        incomeTotalsPerMonth[month] =
            (incomeTotalsPerMonth[month] ?? 0) + amount;
      } else {
        expenseTotalsPerMonth[month] =
            (expenseTotalsPerMonth[month] ?? 0) + amount;
      }
    }

    // Tạo dữ liệu cho biểu đồ cột
    List<BarChartGroupData> barGroups = [];
    for (int i = 1; i <= 12; i++) {
      // Duyệt qua các tháng (1 đến 12)
      final incomeAmount = incomeTotalsPerMonth[i] ?? 0;
      final expenseAmount = expenseTotalsPerMonth[i] ?? 0;

      barGroups.add(
        BarChartGroupData(
          x: i, // Sử dụng tháng làm giá trị x
          barRods: [
            BarChartRodData(
              toY: incomeAmount,
              color: Colors.green,
              width: 10,
            ), // Thu nhập
            BarChartRodData(
              toY: expenseAmount, // Chi tiêu (hiển thị dương)
              color: Colors.red,
              width: 10,
            ),
          ],
        ),
      );
    }

    // Tính tổng thu nhập trong năm
    final totalYearlyIncome = yearlyIncomes.fold<double>(
      0,
      (sum, income) => sum + (income as Income).amount,
    );

    // Tính tổng chi tiêu trong năm
    final totalYearlyExpense = yearlyExpenses.fold<double>(
      0,
      (sum, expense) => sum + (expense as Expense).amount,
    );

    // Tính số dư trong năm
    final yearlyBalance = totalYearlyIncome - totalYearlyExpense;

    final minY = 0.0;

    // Calculate maxY
    final maxY =
        (totalYearlyIncome > totalYearlyExpense
            ? totalYearlyIncome
            : totalYearlyExpense) *
        1.2;

    // Calculate interval for approximately 4 intervals (5 labels including 0 and maxY)
    final interval = (maxY / 4) > 0 ? (maxY / 4) : 1.0;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.whiteBackground, // Background color for the rounded container
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0), // Rounded top-left corner
          topRight: Radius.circular(20.0), // Rounded top-right corner
        ),
      ),
      clipBehavior: Clip.antiAlias, // Clip content to the rounded corners
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${selectedDate.year}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Card tổng quan số dư trong năm
                  Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    elevation: 4,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Yearly Balance', // Số dư trong năm
                            style: Theme.of(
                              context,
                            ).textTheme.titleMedium?.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '\$${yearlyBalance.toStringAsFixed(2)}',
                            style: Theme.of(
                              context,
                            ).textTheme.headlineSmall?.copyWith(
                              color:
                                  yearlyBalance >= 0
                                      ? Colors.green
                                      : Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Hàng hiển thị thu nhập và chi tiêu
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Card thu nhập
                      Expanded(
                        child: Card(
                          elevation: 4,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Income', // Thu nhập
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium?.copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '\$${totalYearlyIncome.toStringAsFixed(2)}',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleLarge?.copyWith(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Card chi tiêu
                      Expanded(
                        child: Card(
                          elevation: 4,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Expense', // Chi tiêu
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium?.copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '\$${totalYearlyExpense.toStringAsFixed(2)}',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleLarge?.copyWith(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Biểu đồ phân tích theo năm
                  Card(
                    elevation: 4,
                    color: const Color(0xFFDFF7E2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: AspectRatio(
                        aspectRatio: 1.7, // Adjust this ratio as needed
                        child: BarChart(
                          BarChartData(
                            barGroups: barGroups,
                            titlesData: FlTitlesData(
                              // Cấu hình trục Y bên trái
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 50,
                                  // Use the calculated interval to define label positions
                                  interval: interval,
                                  getTitlesWidget: (value, meta) {
                                    // Format the value with thousand separators
                                    final formatter = NumberFormat(
                                      '#,###',
                                      'en_US', // Change locale to en_US for $ symbol formatting
                                    );

                                    // Simply return the formatted text widget for the value provided by the library
                                    return Text(
                                      // ignore: prefer_interpolation_to_compose_strings
                                      '\$' + formatter.format(value),
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 10,
                                      ),
                                    );
                                  },
                                ),
                              ),
                              // Cấu hình trục X phía dưới
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) {
                                    // Hiển thị số tháng
                                    return Text(
                                      value.toInt().toString(),
                                      style: const TextStyle(fontSize: 10),
                                      textAlign: TextAlign.center,
                                    );
                                  },
                                  interval: 1,
                                  reservedSize: 20,
                                ),
                              ),
                              // Ẩn trục trên và phải
                              topTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              rightTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                            ),

                            borderData: FlBorderData(
                              show: true,
                              border: Border.all(color: Colors.grey, width: 1),
                            ),
                            gridData: FlGridData(
                              show: true,
                              drawVerticalLine: false,
                              drawHorizontalLine: true,
                              horizontalInterval:
                                  interval, // Use the calculated interval here as well
                              getDrawingHorizontalLine: (value) {
                                return FlLine(
                                  color: Colors.grey,
                                  strokeWidth: 0.5,
                                );
                              },
                            ),

                            alignment: BarChartAlignment.spaceAround,
                            maxY: maxY,
                            minY: minY, // minY là 0
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                  // Yearly Transactions List
                  const Text(
                    'Yearly Transactions',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: yearlyTransactions.length,
                    separatorBuilder:
                        (context, index) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final transaction = yearlyTransactions[index];
                      return _buildTransactionCard(transaction);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method for individual transaction cards
  Widget _buildTransactionCard(dynamic transaction) {
    final isIncome = transaction['isIncome'] as bool;
    final icon = isIncome ? Icons.arrow_upward : Icons.arrow_downward;
    final color = isIncome ? Colors.green : Colors.red;
    final amount =
        isIncome
            ? '+${NumberFormat.currency(locale: 'en_US', symbol: '\$').format(transaction['amount'])}'
            : '-${NumberFormat.currency(locale: 'en_US', symbol: '\$').format(transaction['amount'])}';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction['description'] ?? 'No description',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormat(
                    'dd/MM/yyyy',
                  ).format(transaction['date'] as DateTime),
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
