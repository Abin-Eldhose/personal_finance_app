// ignore_for_file: use_build_context_synchronously

import 'package:finance_app/constants/colors.dart';
import 'package:finance_app/models/user_model.dart';
import 'package:finance_app/services/auth_service.dart';
import 'package:finance_app/widgets/appbutton.dart';
import 'package:finance_app/widgets/apptext.dart';
import 'package:finance_app/widgets/customtextformfiled.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _regKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthSerive>(context);
    return Scaffold(
      body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _regKey,
            child: CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomTextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Enter your name";
                            }
                            return null;
                          },
                          controller: _nameController,
                          hintText: "Name"),
                      const SizedBox(
                        height: 20,
                      ),
                      CustomTextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Enter your email";
                            }
                            return null;
                          },
                          controller: _phoneController,
                          hintText: "Enter your number"),
                      const SizedBox(
                        height: 20,
                      ),
                      CustomTextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Enter can't be empty";
                            }
                            return null;
                          },
                          controller: _emailController,
                          hintText: "Email"),
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
                          controller: _passwordController,
                          hintText: "Password"),
                      const SizedBox(
                        height: 20,
                      ),
                      AppButton(
                          height: 60,
                          width: 180,
                          color: const Color.fromRGBO(76, 175, 80, 1),
                          onTap: () async {
                            var uuid = Uuid().v1();
                            if (_regKey.currentState!.validate()) {
                              showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  });

                              UserModel user = UserModel(
                                  id: uuid,
                                  email: _emailController.text.trim(),
                                  password: _passwordController.text.trim(),
                                  name: _nameController.text.trim(),
                                  number: _phoneController.text.trim(),
                                  status: 1);

                              final res = await authService.registerUser(user);
                              Navigator.pop(context);

                              if (res == true) {
                                Navigator.pop(context);
                              }
                            }
                          },
                          child: AppText(
                            data: "Register",
                            color: textColor,
                          )),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AppText(
                            data: "Already have an account ?",
                            color: textColor,
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, 'login');
                            },
                            child: AppText(
                              data: "Login",
                              color: textButtonColor,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          )),
    );
  }
}
