import 'package:easy_projects/shared/loading.dart';
import 'package:easy_projects/services/auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    var user = AuthService().user;

    if (user != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(),
            Container(
              width: 100,
              height: 100,
              margin: const EdgeInsets.only(top: 50),
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                border: Border.all(color: Colors.blue, width: 2),
                borderRadius: BorderRadius.circular(16),
                image: DecorationImage(
                  image: NetworkImage(user.photoURL ??
                      'https://www.gravatar.com/avatar/placeholder'),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                user.displayName ?? '',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            const Spacer(),
            ElevatedButton(
              child: const Text('Sair'),
              onPressed: () async {
                await AuthService().signOut();
                if (mounted) {
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil('/', (route) => false);
                }
              },
            ),
            const Spacer(),
          ],
        ),
      );
    } else {
      return const Loader();
    }
  }
}
