import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pigalukuvendors/providers/products_provider.dart';
import 'package:pigalukuvendors/widgets/slider_menu_item.dart';
import 'package:provider/provider.dart';

import 'menu_item_class.dart';

class SliderView extends StatefulWidget {
  final Function(String)? onItemClick;

  const SliderView({Key? key, this.onItemClick}) : super(key: key);

  @override
  State<SliderView> createState() => _SliderViewState();
}

class _SliderViewState extends State<SliderView> {

  User? user = FirebaseAuth.instance.currentUser;
  var vendorData;

  @override
  void initState() {
    getVendorData();
    super.initState();
  }

  Future<DocumentSnapshot>getVendorData() async {
    var result = await FirebaseFirestore.instance.collection("vendors").doc(user!.uid).get();
    setState(() {
      vendorData = result;
    });

    return result;
  }


  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<ProductProvider>(context);
    provider.getShopName(vendorData != null ? vendorData.data()["shopName"] : "");

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(top: 30),
      child: ListView(
        children: <Widget>[
          const SizedBox(
            height: 4,
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: FittedBox(
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: Colors.grey,
                    child: CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(vendorData != null ? vendorData.data()["url"] : "images/pigaluku_logo.png"),
                      ),
                    ),
                  const SizedBox(width: 10,),
                  Text(
                    vendorData != null ?  vendorData.data()["shopName"]  : "Shop Name",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const SizedBox(
            height: 20,
          ),
          ...[
            Menu(Icons.dashboard_customize_outlined, 'Dashboard'),
            Menu(Icons.shopping_bag_outlined, 'Product'),
            Menu(CupertinoIcons.gift, 'Coupons'),
            Menu(Icons.list_alt_outlined, 'Orders'),
            Menu(Icons.stacked_bar_chart, 'Reports'),
            Menu(Icons.settings_outlined, 'Setting'),
            Menu(Icons.arrow_back_ios, 'LogOut')
          ]
              .map((menu) => SliderMenuItem(
              title: menu.title,
              iconData: menu.iconData,
              onTap: widget.onItemClick))
              .toList(),
        ],
      ),
    );
  }
}


