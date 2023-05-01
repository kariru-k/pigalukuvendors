import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:pigalukuvendors/providers/auth_provider.dart';
import 'package:pigalukuvendors/providers/order_provider.dart';
import 'package:pigalukuvendors/providers/products_provider.dart';
import 'package:pigalukuvendors/screens/add_edit_coupon_screen.dart';
import 'package:pigalukuvendors/screens/add_new_product_screen.dart';
import 'package:pigalukuvendors/screens/coupons_screen.dart';
import 'package:pigalukuvendors/screens/home_screen.dart';
import 'package:pigalukuvendors/screens/login_screen.dart';
import 'package:pigalukuvendors/screens/product_screen.dart';
import 'package:pigalukuvendors/screens/register_screen.dart';
import 'package:pigalukuvendors/screens/reset_password_screen.dart';
import 'package:pigalukuvendors/screens/splash_screen.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => AuthProvider()),
      ChangeNotifierProvider(create: (_) => ProductProvider()),
      ChangeNotifierProvider(create: (_) => OrderProvider())
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
          primarySwatch: Colors.deepPurple,
          fontFamily: "Lato"
      ),
      builder: EasyLoading.init(),
      debugShowCheckedModeBanner: false,
      initialRoute: SplashScreen.id,
      routes: {
        SplashScreen.id:(context)=> const SplashScreen(),
        RegisterScreen.id:(context) => const RegisterScreen(),
        HomeScreen.id:(context) => const HomeScreen(),
        LoginScreen.id:(context) => const LoginScreen(),
        ResetPassword.id:(context) => const ResetPassword(),
        AddNewProduct.id:(context) => const AddNewProduct(),
        ProductScreen.id:(context) => const ProductScreen(),
        CouponScreen.id:(context) => const CouponScreen(),
        AddEditCoupon.id:(context) => const AddEditCoupon(document: null),
      },
    );
  }
}



