
import 'package:flutter/material.dart';
import 'package:pigalukuvendors/screens/coupons_screen.dart';
import 'package:pigalukuvendors/screens/dashboard_screen.dart';
import 'package:pigalukuvendors/screens/product_screen.dart';

import '../screens/banner_screen.dart';

class DrawerServices{


  Widget drawerScreen(title){
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
    return const MainScreen();
  }
}