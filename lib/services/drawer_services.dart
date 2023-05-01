
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:pigalukuvendors/screens/dashboard_screen.dart';
import 'package:pigalukuvendors/screens/login_screen.dart';
import 'package:pigalukuvendors/screens/product_screen.dart';

import '../screens/banner_screen.dart';
import '../screens/coupons_screen.dart';
import '../screens/orders_screen.dart';

class DrawerServices{


  Widget drawerScreen(title, context){
    if (title == "Dashboard") {
      return const MainScreen();
    }
    if (title == "Product") {
      return const ProductScreen();
    }
    if (title == "Coupons") {
      return const CouponScreen();
    }
    if (title == "Banner") {
      return const BannerScreen();
    }
    if (title == "Orders") {
      return const OrderScreen();
    }



    if (title == "Log Out") {
      EasyLoading.show(status: "Signing Out");
      FirebaseAuth.instance.signOut().then((value){
        EasyLoading.dismiss();
        Navigator.pushReplacementNamed(context, LoginScreen.id);
      });
    }  
    return const MainScreen();
  }
}