import 'package:easy_projects/login/login.dart';
import 'package:easy_projects/app_router.dart';
import 'package:easy_projects/services/auth.dart';
import 'package:flutter/material.dart';

class Entrypoint extends StatelessWidget {
  const Entrypoint({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: AuthService().userStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('loading');
        } else if (snapshot.hasError) {
          return const Center(
            child: Text("Error"),
          );
        } else if (snapshot.hasData) {
          return const AppRouter();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}
