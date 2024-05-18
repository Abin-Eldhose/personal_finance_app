import 'package:finance_app/constants/colors.dart';
import 'package:finance_app/models/expense_model.dart';
import 'package:finance_app/services/financial_service.dart';
import 'package:finance_app/widgets/appbutton.dart';
import 'package:finance_app/widgets/apptext.dart';
import 'package:finance_app/widgets/customtextformfiled.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class AddExpenseScreen extends StatefulWidget {
  final uid;
  const AddExpenseScreen({super.key, this.uid});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _expenseKey = GlobalKey<FormState>();
  String? category;
  var expenseCategories = [
    'Housing',
    'Transportation',
    'Food and Groceries',
    'Healthcare',
    'Debt Payments',
    'Entertainment',
    'Personal Care',
    'Clothing and Accessories',
    'Utilities and Bills',
    'Savings and Investments',
    'Education',
    'Travel',
  ];

  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final finService = Provider.of<UserFinService>(context);
    final String userid = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        title: AppText(
          data: "Add Expense",
          color: textColor,
        ),
        backgroundColor: Colors.transparent.withOpacity(0.1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          child: Form(
            key: _expenseKey,
            child: CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Column(
                    children: [
                      DropdownButtonFormField(
                        dropdownColor: scaffoldColor,
                        style: const TextStyle(color: textColor),
                        value: category,
                        onChanged: (value) {
                          setState(() {
                            category = value as String;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Select a category';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: textColor)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: textColor)),
                            hintText: "Select Category",
                            hintStyle: const TextStyle(color: textColor)),
                        items: expenseCategories
                            .map((item) => DropdownMenuItem(
                                  value: item,
                                  child: AppText(data: item),
                                ))
                            .toList(),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      CustomTextFormField(
                        controller: _descController,
                        hintText: "Description",
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Description can't be empty";
                          } else {
                            return null;
                          }
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      CustomTextFormField(
                        type: TextInputType.number,
                        controller: _amountController,
                        hintText: "Amount",
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter valid amount";
                          } else {
                            return null;
                          }
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      AppButton(
                          onTap: () {
                            var uuid = const Uuid().v1();
                            if (_expenseKey.currentState!.validate()) {
                              ExpenseModel exp = ExpenseModel(
                                  id: uuid,
                                  uid: userid,
                                  amount: double.parse(_amountController.text),
                                  category: category.toString(),
                                  description: _descController.text,
                                  createdAt: DateTime.now());
                              finService.addExpense(exp);

                              Navigator.pop(context);
                            }
                          },
                          color: Colors.green,
                          width: 200,
                          height: 50,
                          child: AppText(
                            data: "Add Expense",
                            color: textColor,
                          ))
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
