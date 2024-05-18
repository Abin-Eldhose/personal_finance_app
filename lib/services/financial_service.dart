//open boxes one for income and one for expense
// add income
//add expense
//get all income by uid(user id)

//delete
//edit

import 'package:finance_app/models/expense_model.dart';
import 'package:finance_app/models/income_model.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

class UserFinService with ChangeNotifier {
  static const String _incomeBoxName = 'incomes';
  static const String _expenseBoxName = 'expenses';

  double _totalIncome = 0.0;
  double _totalExpense = 0.0;

  double get totalIncome => _totalIncome;
  double get toalExpense => _totalExpense;

  Future<void> calculateTotalIncomeForUser(String userId) async {
    await _calculateTotalIncome(userId);
    notifyListeners();
  }

  Future<void> calculateTotalExpenseForUser(String userId) async {
    await _calculateTotalExpense(userId);
    notifyListeners();
  }

  //open the box for income
  Future<Box<IncomeModel>> openIncomeBox() async {
    return await Hive.openBox<IncomeModel>(_incomeBoxName);
  }

  //open box for expense
  Future<Box<ExpenseModel>> openExpenseBox() async {
    return await Hive.openBox<ExpenseModel>(_expenseBoxName);
  }

  //method for adding income
  Future<void> addIncome(IncomeModel income) async {
    final incomeBox = await openIncomeBox();
    await incomeBox.add(income);
    await _calculateTotalIncome(income.uid);
    notifyListeners();
  }

  //method for adding expesnse
  Future<void> addExpense(ExpenseModel expense) async {
    final expenseBox = await openExpenseBox();
    await expenseBox.add(expense);
    await _calculateTotalExpense(expense.uid);
    notifyListeners();
  }

  //calculate total income for user
  Future<void> _calculateTotalIncome(String uid) async {
    //store all the income
    final List<IncomeModel> incomes = await getAllIncome(uid);

    //add to the previous total income
    _totalIncome = incomes.fold(
        0.0, (previousValue, income) => previousValue + income.amount);
  }

  //get all income
  Future<List<IncomeModel>> getAllIncome(String uid) async {
    final incomeBox = await openIncomeBox();
    return incomeBox.values.where((income) => income.uid == uid).toList();
  }

  Future<void> _calculateTotalExpense(String uid) async {
    //store all the expenses
    final List<ExpenseModel> expenses = await getAllExpense(uid);

    //add to the previous total expense
    _totalExpense = expenses.fold(
        0.0, (previousValue, expense) => previousValue + expense.amount);
  }

  //get all expense
  Future<List<ExpenseModel>> getAllExpense(String uid) async {
    final expenseBox = await openExpenseBox();
    return expenseBox.values.where((expense) => expense.uid == uid).toList();
  }
}
