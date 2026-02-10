import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            GoogleSignIn().signOut();
            context.go('/login');
          },
          child: Text('logout'),
        ),
      ),
    );
  }
}