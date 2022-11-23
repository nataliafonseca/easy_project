import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Image.asset('assets/logo.png'),
        const SizedBox(
          height: 20,
        ),
        const Text('by man4s')
      ]),
    );
  }
}
