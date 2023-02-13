import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pigalukuvendors/screens/auth_screen.dart';
import 'package:pigalukuvendors/screens/home_screen.dart';
import 'package:pigalukuvendors/screens/splash_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primaryColor: Colors.deepPurpleAccent,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: SplashScreen.id,
      routes: {
        SplashScreen.id:(context)=> const SplashScreen(),
        AuthScreen.id:(context) => const AuthScreen(),
        HomeScreen.id:(context) => const HomeScreen()
      },
    );
  }
}



