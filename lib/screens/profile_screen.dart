import 'package:finance_app/constants/colors.dart';
import 'package:finance_app/models/user_model.dart';
import 'package:finance_app/services/auth_service.dart';
import 'package:finance_app/widgets/apptext.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final authservice = Provider.of<AuthSerive>(context);
    return Scaffold(
      appBar: AppBar(
        title: AppText(
          data: "Profile",
          color: textColor,
        ),
        backgroundColor: Colors.transparent.withOpacity(0.1),
      ),
      body: Center(
        child: FutureBuilder<UserModel?>(
            future: authservice.getCurrentUser(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else {
                if (snapshot.hasData) {
                  final user = snapshot.data!;
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 60,
                        child: AppText(
                          data: user.name[0].toUpperCase(),
                          size: 60,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      AppText(
                        data: "Name : ${user.name}",
                        color: textColor,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      AppText(
                        data: "Email : ${user.email}",
                        color: textColor,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      AppText(
                        data: "Phone : ${user.number}",
                        color: textColor,
                      ),
                    ],
                  );
                } else {
                  return Container();
                }
              }
            }),
      ),
    );
  }
}
