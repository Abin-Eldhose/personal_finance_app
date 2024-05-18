import 'package:finance_app/constants/colors.dart';
import 'package:finance_app/models/expense_model.dart';
import 'package:finance_app/services/auth_service.dart';
import 'package:finance_app/services/financial_service.dart';
import 'package:finance_app/widgets/apptext.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ExpenseTransactionsScreen extends StatelessWidget {
  const ExpenseTransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double totalExpense =
        ModalRoute.of(context)!.settings.arguments as double;
    final finService = Provider.of<UserFinService>(context, listen: false);
    final authSerivce = Provider.of<AuthSerive>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: AppText(data: "All expenses"),
      ),
      body: FutureBuilder(
          future: authSerivce.getCurrentUser(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (snapshot.hasData) {
                final userData = snapshot.data!;
                return FutureBuilder<List<ExpenseModel>>(
                    future: finService.getAllExpense(userData.id),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        if (snapshot.hasData) {
                          final List<ExpenseModel> expenses = snapshot.data!;
                          return Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppText(
                                  data: "Total: $totalExpense",
                                  color: textColor,
                                  size: 18,
                                ),
                                Expanded(
                                    child: ListView.builder(
                                        itemCount: expenses.length,
                                        itemBuilder: (context, index) {
                                          final expense = expenses[index];
                                          return Card(
                                            elevation: 5,
                                            child: ListTile(
                                              onTap: () {
                                                showModalBottomSheet(
                                                    context: context,
                                                    builder: (context) {
                                                      return Container(
                                                        height: 200,
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        padding:
                                                            const EdgeInsets
                                                                .all(20.0),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            AppText(
                                                                data: expense
                                                                    .category),
                                                            AppText(
                                                                data: expense
                                                                    .description),
                                                            AppText(
                                                                data: expense
                                                                    .amount
                                                                    .toString()),
                                                            AppText(
                                                                data:
                                                                    "Added at: ${DateFormat('MMMM dd, yyyy hh:mm a').format(expense.createdAt)}"),
                                                          ],
                                                        ),
                                                      );
                                                    });
                                              },
                                              title: AppText(
                                                data: expense.category,
                                                color: scaffoldColor,
                                              ),
                                              subtitle: AppText(
                                                data: expense.amount.toString(),
                                                color: scaffoldColor,
                                              ),
                                            ),
                                          );
                                        }))
                              ],
                            ),
                          );
                        } else {
                          return Container();
                        }
                      }
                    });
              } else {
                return Container();
              }
            }
          }),
    );
  }
}
