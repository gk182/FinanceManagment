import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter/services.dart';
import 'viewmodels/income_viewmodel.dart';
import 'viewmodels/expense_viewmodel.dart';
import 'daily_analytics_view.dart'; // Import view phân tích theo ngày
import 'weekly_analytics_view.dart'; // Import view phân tích theo tuần
import 'monthly_analytics_view.dart'; // Import view phân tích theo tháng
import 'yearly_analytics_view.dart'; // Import view phân tích theo năm
import '../../constant/app_colors.dart';

class CalendarButton extends StatelessWidget {
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;
  final CalendarFormat format;

  const CalendarButton({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
    this.format = CalendarFormat.month,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.calendar_today),
      color: Colors.white,
      onPressed: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: DateTime(2020),
          lastDate: DateTime(2100),
        );
        if (picked != null) {
          onDateSelected(picked);
        }
      },
    );
  }
}

// Widget chính cho màn hình phân tích
class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  DateTime selectedDate = DateTime.now();

  void _onDateChanged(DateTime date) {
    setState(() {
      selectedDate = date;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text(
            'Analysis',
            style: TextStyle(fontWeight: FontWeight.bold),
          ), // Tiêu đề của AppBar
          systemOverlayStyle: SystemUiOverlayStyle.light,
          backgroundColor: AppColors.background, // Màu nền của AppBar
          elevation: 0, // Remove the shadow line
          automaticallyImplyLeading: false, // Ẩn nút back trên màn hình chính
          centerTitle: true, // Căn giữa tiêu đề AppBar
          bottom: TabBar(
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            // Tùy chỉnh style cho TabBar
            indicator: UnderlineTabIndicator(
              borderSide: BorderSide(color: Colors.white),
            ), // Remove indicator line
            indicatorColor:
                AppColors
                    .LightBlue, // Make indicator color transparent to remove potential line
            labelColor: Colors.white, // Màu của tab được chọn
            unselectedLabelColor: Colors.black, // Màu của tab chưa được chọn
            tabs: const [
              Tab(text: 'Daily'), // Tab phân tích theo ngày
              Tab(text: 'Weekly'), // Tab phân tích theo tuần
              Tab(text: 'Monthly'), // Tab phân tích theo tháng
              Tab(text: 'Yearly'), // Tab phân tích theo năm
            ],
          ),
        ),
        // Sử dụng Consumer2 để lắng nghe thay đổi từ cả IncomeViewModel và ExpenseViewModel
        body: Consumer2<IncomeViewModel, ExpenseViewModel>(
          builder: (context, incomeViewModel, expenseViewModel, child) {
            // Hiển thị loading indicator khi đang tải dữ liệu
            if (incomeViewModel.isLoading || expenseViewModel.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            // Tính tổng thu nhập
            final totalIncome = incomeViewModel.incomes.fold<double>(
              0,
              (sum, income) => sum + income.amount,
            );

            // Tính tổng chi tiêu
            final totalExpense = expenseViewModel.expenses.fold<double>(
              0,
              (sum, expense) => sum + expense.amount,
            );

            // Tính số dư tổng cộng
            final totalBalance = totalIncome - totalExpense;

            // Hiển thị nội dung tương ứng với từng tab
            return Column(
              children: [
                // Thêm CalendarButton ở đây để dùng chung cho tất cả tab
                Padding(
                  padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CalendarButton(
                        selectedDate: selectedDate,
                        onDateSelected: _onDateChanged,
                        // Có thể truyền format động nếu muốn
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color:
                          Colors
                              .white, // Background color for the rounded container
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(
                          40.0,
                        ), // Increase radius to match image
                        topRight: Radius.circular(
                          40.0,
                        ), // Increase radius to match image
                      ),
                    ),
                    clipBehavior:
                        Clip.antiAlias, // Clip content to the rounded corners
                    child: TabBarView(
                      children: [
                        // Nội dung tab phân tích theo ngày
                        DailyAnalyticsView(
                          incomes: incomeViewModel.incomes,
                          expenses: expenseViewModel.expenses,
                          selectedDate: selectedDate,
                          onDateChanged: _onDateChanged,
                        ),
                        // Nội dung tab phân tích theo tuần
                        WeeklyAnalyticsView(
                          incomes: incomeViewModel.incomes,
                          expenses: expenseViewModel.expenses,
                          selectedDate: selectedDate,
                          onDateChanged: _onDateChanged,
                        ),
                        // Nội dung tab phân tích theo tháng
                        MonthlyAnalyticsView(
                          incomes: incomeViewModel.incomes,
                          expenses: expenseViewModel.expenses,
                          selectedDate: selectedDate,
                          onDateChanged: _onDateChanged,
                        ),
                        // Nội dung tab phân tích theo năm
                        YearlyAnalyticsView(
                          incomes: incomeViewModel.incomes,
                          expenses: expenseViewModel.expenses,
                          selectedDate: selectedDate,
                          onDateChanged: _onDateChanged,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}