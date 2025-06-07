import 'package:flutter/material.dart';
import '../../models/income_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:finance_managment/constant/app_colors.dart';
// Widget hiển thị phân tích theo ngày
class DailyAnalyticsView extends StatelessWidget {
  final List<dynamic> incomes; // Danh sách thu nhập
  final List<dynamic> expenses; // Danh sách chi tiêu
  final DateTime selectedDate;
  final Function(DateTime) onDateChanged;

  const DailyAnalyticsView({
    super.key,
    required this.incomes,
    required this.expenses,
    required this.selectedDate,
    required this.onDateChanged,
  });

  // Phương thức hỗ trợ lọc các giao dịch trong ngày được chọn
  List<dynamic> _filterTransactionsForSelectedDay(
    List<dynamic> transactions,
    DateTime selectedDay,
  ) {
    final targetDay = DateTime(
      selectedDay.year,
      selectedDay.month,
      selectedDay.day,
    );

    return transactions
        .where(
          (transaction) =>
              (transaction as dynamic).date.year == targetDay.year &&
              (transaction as dynamic).date.month == targetDay.month &&
              (transaction as dynamic).date.day == targetDay.day,
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    // Lọc các giao dịch cho ngày được chọn
    final dailyIncomes = _filterTransactionsForSelectedDay(
      incomes,
      selectedDate,
    );
    final dailyExpenses = _filterTransactionsForSelectedDay(
      expenses,
      selectedDate,
    );

    // Kết hợp và sắp xếp các giao dịch theo thời gian cho biểu đồ và danh sách chi tiết
    final allDailyTransactions = [
      ...dailyIncomes.map(
        (inc) => {
          'amount': (inc as dynamic).amount,
          'date': (inc as dynamic).date,
          'isIncome': true,
          'original': inc, // Keep a reference to the original object
        },
      ),
      ...dailyExpenses.map(
        (exp) => {
          'amount': (exp as dynamic).amount,
          'date': (exp as dynamic).date,
          'isIncome': false,
          'original': exp, // Keep a reference to the original object
        },
      ),
    ]..sort((a, b) => (a['date'] as DateTime).compareTo(b['date'] as DateTime));

    // Tạo dữ liệu cho biểu đồ cột (sử dụng allDailyTransactions)
    List<BarChartGroupData> barGroups = [];
    for (int i = 0; i < allDailyTransactions.length; i++) {
      final transaction = allDailyTransactions[i];
      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: transaction['amount'],
              color: transaction['isIncome'] ? Colors.green : Colors.red,
              width: 15,
            ),
          ],
        ),
      );
    }

    // Tính tổng thu nhập trong ngày
    final totalDailyIncome = dailyIncomes.fold<double>(
      0,
      (sum, income) => sum + (income as dynamic).amount,
    );

    // Tính tổng chi tiêu trong ngày
    final totalDailyExpense = dailyExpenses.fold<double>(
      0,
      (sum, expense) => sum + (expense as dynamic).amount,
    );

    // Tính số dư trong ngày
    final dailyBalance = totalDailyIncome - totalDailyExpense;

    // Tính toán giá trị cho trục Y
    final maxY =
        (totalDailyIncome > totalDailyExpense
            ? totalDailyIncome
            : totalDailyExpense) *
        1.2;
    final minY = 0.0;

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
                  '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // CalendarButton(
                //   selectedDate: selectedDate,
                //   onDateSelected: (date) {
                //     onDateChanged(date);
                //   },
                // ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Card tổng quan số dư trong ngày
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
                            'Daily Balance',
                            style: Theme.of(
                              context,
                            ).textTheme.titleMedium?.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '\$${dailyBalance.toStringAsFixed(2)}',
                            style: Theme.of(
                              context,
                            ).textTheme.headlineSmall?.copyWith(
                              color:
                                  dailyBalance >= 0 ? Colors.green : Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
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
                                  'Income',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium?.copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '\$${totalDailyIncome.toStringAsFixed(2)}',
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
                                  'Expense',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium?.copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '\$${totalDailyExpense.toStringAsFixed(2)}',
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
                  const SizedBox(height: 16),
                  // Biểu đồ phân tích theo ngày
                  Card(
                    elevation: 4,
                    color: const Color(0xFFDFF7E2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SizedBox(
                        height: 200,
                        child: BarChart(
                          BarChartData(
                            barGroups: barGroups,
                            titlesData: FlTitlesData(
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 50,
                                  // Use the calculated interval to define label positions
                                  interval: interval,
                                  getTitlesWidget: (
                                    double value,
                                    TitleMeta meta,
                                  ) {
                                    // Format the value with thousand separators
                                    final formatter = NumberFormat(
                                      '#,###',
                                      'vi_VN',
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
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) {
                                    if (value.toInt() <
                                        allDailyTransactions.length) {
                                      final transactionTime =
                                          (allDailyTransactions[value
                                                  .toInt()]['date']
                                              as DateTime);
                                      return Text(
                                        '${transactionTime.hour}:${transactionTime.minute.toString().padLeft(2, '0')}',
                                        style: const TextStyle(fontSize: 10),
                                        textAlign: TextAlign.center,
                                      );
                                    }
                                    return Container();
                                  },
                                  reservedSize: 20,
                                ),
                              ),
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
                  // Daily Transactions List
                  const Text(
                    'Daily Transactions',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: allDailyTransactions.length,
                    separatorBuilder:
                        (context, index) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final transactionMap = allDailyTransactions[index];
                      // Pass the original transaction object to the helper method
                      final originalTransaction = transactionMap['original'];
                      if (originalTransaction != null) {
                        return _buildTransactionCard(originalTransaction);
                      } else {
                        return Container(); // Handle case where original object is missing
                      }
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

  Widget _buildTransactionCard(dynamic transaction) {
    final isIncome = transaction is Income;
    final icon = isIncome ? Icons.arrow_upward : Icons.arrow_downward;
    final color = isIncome ? Colors.green : Colors.red;
    final amount =
        isIncome
            ? '+\$${transaction.amount.toStringAsFixed(2)}'
            : '-\$${transaction.amount.toStringAsFixed(2)}';

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
                  transaction.description,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormat('dd/MM/yyyy').format(transaction.date),
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
