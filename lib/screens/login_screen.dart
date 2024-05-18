import 'package:finance_app/constants/colors.dart';
import 'package:finance_app/services/auth_service.dart';
import 'package:finance_app/widgets/appbutton.dart';
import 'package:finance_app/widgets/apptext.dart';
import 'package:finance_app/widgets/customtextformfiled.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  final _loginKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final authserive = Provider.of<AuthSerive>(context);
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        width: double.infinity,
        height: double.infinity,
        child: Form(
          key: _loginKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //form and button
              CustomTextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Enter your email";
                    }
                    return null;
                  },
                  controller: _emailController,
                  hintText: "email"),
              const SizedBox(
                height: 20,
              ),
              CustomTextFormField(
                  validator: (value) {
                    if (value!.isNotEmpty) {
                      if (value.length < 6) {
                        return "password should be atleast 6 characters";
                      }
                      return null;
                    }
                    return "Enter a Password";
                  },
                  obscureText: true,
                  controller: _passwordController,
                  hintText: "password"),

              const SizedBox(
                height: 20,
              ),

              AppButton(
                  height: 60,
                  width: 180,
                  color: const Color.fromRGBO(76, 175, 80, 1),
                  onTap: () async {
                    if (_loginKey.currentState!.validate()) {
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          });

                      final user = await authserive.loginUser(
                          _emailController.text.trim(),
                          _passwordController.text);
                      Navigator.pop(context);
                      if (user != null) {
                        Navigator.pushNamedAndRemoveUntil(
                            context, 'home', (route) => false,
                            arguments: user);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: AppText(
                          data: "No user exists",
                          color: textColor,
                        )));
                      }
                    }
                  },
                  child: AppText(
                    data: "Login",
                    color: textColor,
                  )),

              const SizedBox(
                height: 20,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppText(
                    data: "Don't have an account ?",
                    color: textColor,
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, 'register');
                    },
                    child: AppText(
                      data: "Register",
                      color: textButtonColor,
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
