import 'package:finance_app/constants/colors.dart';
import 'package:finance_app/models/income_model.dart';
import 'package:finance_app/services/auth_service.dart';
import 'package:finance_app/services/financial_service.dart';
import 'package:finance_app/widgets/apptext.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class IncomeTransactionsScreen extends StatelessWidget {
  const IncomeTransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double totalIncome =
        ModalRoute.of(context)!.settings.arguments as double;
    final finService = Provider.of<UserFinService>(context, listen: false);
    final authSerivce = Provider.of<AuthSerive>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: AppText(data: "All Income"),
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
                return FutureBuilder<List<IncomeModel>>(
                    future: finService.getAllIncome(userData.id),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        if (snapshot.hasData) {
                          final List<IncomeModel> incomes = snapshot.data!;
                          return Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppText(
                                  data: "Total: $totalIncome",
                                  color: textColor,
                                  size: 18,
                                ),
                                Expanded(
                                    child: ListView.builder(
                                        itemCount: incomes.length,
                                        itemBuilder: (context, index) {
                                          final income = incomes[index];
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
                                                                data: income
                                                                    .description),
                                                            AppText(
                                                                data: income
                                                                    .amount
                                                                    .toString()),
                                                            AppText(
                                                                data:
                                                                    "Added at: ${DateFormat('MMMM dd, yyyy hh:mm a').format(income.createdAt)}"),
                                                          ],
                                                        ),
                                                      );
                                                    });
                                              },
                                              title: AppText(
                                                data: income.description,
                                                color: scaffoldColor,
                                              ),
                                              subtitle: AppText(
                                                data: income.amount.toString(),
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
