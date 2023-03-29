
import 'package:flutter/material.dart';
import 'package:pigalukuvendors/screens/coupons_screen.dart';
import 'package:pigalukuvendors/screens/dashboard_screen.dart';
import 'package:pigalukuvendors/screens/product_screen.dart';

class DrawerServices{


  Widget drawerScreen(title){
    if (title == "Dashboard") {
      return MainScreen();
    }
    if (title == "Product") {
      return ProductScreen();
    }
    if (title == "Coupons") {
      return CouponScreen();
    }
    return MainScreen();
  }
}