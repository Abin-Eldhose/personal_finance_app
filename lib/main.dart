import 'package:finance_app/constants/colors.dart';
import 'package:finance_app/models/expense_model.dart';
import 'package:finance_app/models/income_model.dart';
import 'package:finance_app/models/user_model.dart';
import 'package:finance_app/screens/add_expense_screen.dart';
import 'package:finance_app/screens/add_income_screen.dart';
import 'package:finance_app/screens/expense_list_screen.dart';
import 'package:finance_app/screens/home_screen.dart';
import 'package:finance_app/screens/income_list_screen.dart';
import 'package:finance_app/screens/login_screen.dart';
import 'package:finance_app/screens/profile_screen.dart';
import 'package:finance_app/screens/register_screen.dart';
import 'package:finance_app/screens/splash_screen.dart';
import 'package:finance_app/services/auth_service.dart';
import 'package:finance_app/services/financial_service.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';

void main() async {
  //initialize hive
  await Hive.initFlutter();

  //register hive adapter
  Hive.registerAdapter(UserModelAdapter());
  Hive.registerAdapter(IncomeModelAdapter());
  Hive.registerAdapter(ExpenseModelAdapter());

  //call the opened box
  await AuthSerive().openBox();
  await UserFinService().openIncomeBox();
  await UserFinService().openExpenseBox();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthSerive()),
        ChangeNotifierProvider(create: (context) => UserFinService()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Finance App',
        theme: ThemeData(
          scaffoldBackgroundColor: scaffoldColor,
          textTheme: const TextTheme(
              displaySmall: TextStyle(color: Colors.white, fontSize: 17)),
          useMaterial3: true,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
          'login': (context) => const LoginScreen(),
          'register': (context) => const RegisterScreen(),
          'home': (context) => const HomeScreen(),
          'addExpense': (context) => const AddExpenseScreen(),
          'addIncome': (context) => const AddIncomeScreen(),
          'profile': (context) => const ProfileScreen(),
          'allExpenseList': (context) => const ExpenseTransactionsScreen(),
          'allIncomeList': (context) => const IncomeTransactionsScreen(),
        },
      ),
    );
  }
}
