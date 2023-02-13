import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pigalukuvendors/screens/auth_screen.dart';

import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  static const String id = 'splash-screen';
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    Timer(
        const Duration(
            seconds: 3
        ), () {
      FirebaseAuth.instance.authStateChanges().listen((User? user) {
        if(user==null){
          Navigator.popAndPushNamed(context, AuthScreen.id);
        }else{
          Navigator.popAndPushNamed(context, HomeScreen.id);
        }
      });
    }
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('images/pigaluku_logo.png'),
              const SizedBox(height: 20,),
              const Text(
                'Clothing Store',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              )
            ],
          )
      ),
    );
  }
}
