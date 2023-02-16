import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pigalukuvendors/providers/auth_provider.dart';
import 'package:pigalukuvendors/screens/home_screen.dart';
import 'package:pigalukuvendors/screens/login_screen.dart';
import 'package:pigalukuvendors/screens/register_screen.dart';
import 'package:pigalukuvendors/screens/splash_screen.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => AuthProvider())
    ],
    child: const MyApp(),
  ));
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
        RegisterScreen.id:(context) => const RegisterScreen(),
        HomeScreen.id:(context) => const HomeScreen(),
        LoginScreen.id:(context) => const LoginScreen()
      },
    );
  }
}



