import 'package:finance_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  //go to login page after some delay
  @override
  void initState() {
    checkLoginState();
    super.initState();
  }

  Future<void> checkLoginState() async {
    await Future.delayed(Duration(seconds: 3));
    final authService = Provider.of<AuthSerive>(context, listen: false);
    //check the login state of user
    final isLoggedIn = await authService.isLoggedIn();
    if (isLoggedIn) {
      Navigator.pushNamedAndRemoveUntil(context, 'home', (route) => false);
    } else {
      Navigator.pushNamedAndRemoveUntil(context, 'login', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/img/logo.png',
              height: 120,
              width: 200,
            )
          ],
        ),
      ),
    );
  }
}
