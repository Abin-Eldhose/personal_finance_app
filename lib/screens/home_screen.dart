import 'package:finance_app/constants/colors.dart';
import 'package:finance_app/models/user_model.dart';
import 'package:finance_app/services/auth_service.dart';
import 'package:finance_app/services/financial_service.dart';
import 'package:finance_app/widgets/apptext.dart';
import 'package:finance_app/widgets/dashboard_widget.dart';
import 'package:finance_app/widgets/mydivider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchInitialData(context);
    });
  }

  Future<void> _fetchInitialData(BuildContext context) async {
    final finService = Provider.of<UserFinService>(context, listen: false);
    final authService = Provider.of<AuthSerive>(context, listen: false);
    final userModel = await authService.getCurrentUser();
    if (userModel != null) {
      finService.calculateTotalIncomeForUser(userModel.id);
      finService.calculateTotalExpenseForUser(userModel.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final finService = Provider.of<UserFinService>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent.withOpacity(0.1),
      ),
      body: SingleChildScrollView(
        child: Consumer<AuthSerive>(
          builder: (context, authService, child) {
            return FutureBuilder<UserModel?>(
              future: authService.getCurrentUser(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  if (snapshot.hasData) {
                    final userData = snapshot.data;
                    return Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                child: Row(
                                  children: [
                                    AppText(
                                      data: "Welcome",
                                      color: textColor,
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    AppText(
                                      data: userData!.name,
                                      color: textColor,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 20),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(context, 'profile');
                                },
                                child: CircleAvatar(
                                  child: Text(userData.name[0]),
                                ),
                              )
                            ],
                          ),
                          const MyDivider(),
                          const SizedBox(
                            height: 20,
                          ),
                          DashboardItemWidget(
                            onTap1: () {
                              Navigator.pushNamed(context, 'allIncomeList',
                                  arguments: finService.totalIncome);
                            },
                            onTap2: () {
                              Navigator.pushNamed(context, 'allExpenseList',
                                  arguments: finService.toalExpense);
                            },
                            titleOne: "Income\n ${finService.totalIncome}",
                            titleTwo: "Expense\n ${finService.toalExpense}",
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          DashboardItemWidget(
                            onTap1: () {
                              Navigator.pushNamed(context, 'addIncome',
                                  arguments: userData.id);
                            },
                            onTap2: () {
                              Navigator.pushNamed(context, 'addExpense',
                                  arguments: userData.id);
                            },
                            titleOne: "Add income",
                            titleTwo: "Add Expense",
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppText(
                                  data: "Income vs Expense",
                                  color: textColor,
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                AspectRatio(
                                  aspectRatio: 1.3,
                                  child: PieChart(PieChartData(
                                      sectionsSpace: 10,
                                      sections: [
                                        PieChartSectionData(
                                            titleStyle: const TextStyle(
                                                color: textColor),
                                            color: chartColor1,
                                            value: finService.toalExpense,
                                            title: "Expense",
                                            radius: 60),
                                        PieChartSectionData(
                                            titleStyle: const TextStyle(
                                                color: textColor),
                                            color: chartColor2,
                                            value: finService.totalIncome,
                                            title: "Income",
                                            radius: 60),
                                      ])),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }
              },
            );
          },
        ),
      ),
    );
  }
}
