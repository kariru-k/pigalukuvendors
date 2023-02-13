import 'package:flutter/material.dart';

class AuthScreen extends StatelessWidget {
  static const String id = 'auth-screen';
  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Authentication screen"),
      ),
    );
  }
}
