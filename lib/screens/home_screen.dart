import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pigalukuvendors/screens/login_screen.dart';

class HomeScreen extends StatelessWidget {
  static const String id = "home-screen";
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: ElevatedButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.pushReplacementNamed(context, LoginScreen.id);
              },
              child: const Text(
                "LOG OUT",
                style: TextStyle(
                  fontFamily: "Anton"
                ),
              )
          ),
        ),
      ),
    );
  }
}
