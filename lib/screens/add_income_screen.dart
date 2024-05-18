import 'package:finance_app/constants/colors.dart';
import 'package:finance_app/models/income_model.dart';
import 'package:finance_app/services/financial_service.dart';
import 'package:finance_app/widgets/appbutton.dart';
import 'package:finance_app/widgets/apptext.dart';
import 'package:finance_app/widgets/customtextformfiled.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class AddIncomeScreen extends StatefulWidget {
  const AddIncomeScreen({super.key});

  @override
  State<AddIncomeScreen> createState() => _AddIncomeScreenState();
}

class _AddIncomeScreenState extends State<AddIncomeScreen> {
  final _incomeeKey = GlobalKey<FormState>();

  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final finService = Provider.of<UserFinService>(context);
    final String userid = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        title: AppText(
          data: "Add Income",
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
            key: _incomeeKey,
            child: CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Column(
                    children: [
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
                            if (_incomeeKey.currentState!.validate()) {
                              IncomeModel inc = IncomeModel(
                                  id: uuid,
                                  uid: userid,
                                  amount: double.parse(_amountController.text),
                                  description: _descController.text,
                                  createdAt: DateTime.now());
                              finService.addIncome(inc);

                              Navigator.pop(context);
                            }
                          },
                          color: Colors.green,
                          width: 200,
                          height: 50,
                          child: AppText(
                            data: "Add Income",
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
