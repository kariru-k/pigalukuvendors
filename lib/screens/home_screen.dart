import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:pigalukuvendors/services/drawer_services.dart';

import '../widgets/drawer_menu_widget.dart';

class HomeScreen extends StatefulWidget {
  static const String id = "home-screen";
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final DrawerServices _services = DrawerServices();
  final GlobalKey<SliderDrawerState> _sliderDrawerKey =
  GlobalKey<SliderDrawerState>();
  String? title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SliderDrawer(
          appBar: SliderAppBar(
              appBarHeight: 80,
              appBarColor: Colors.deepPurple,
              trailing: Row(
                children: [
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(CupertinoIcons.search)
                  ),
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(CupertinoIcons.bell)
                  )
                ],
              ),
              title: Text(title != null ? title.toString() : "Vendor Dashboard",
                  style: const TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.w700
                  )
              )
          ),
          key: _sliderDrawerKey,
          sliderOpenSize: 250,
          slider: SliderView(
            onItemClick: (title) {
              _sliderDrawerKey.currentState!.closeSlider();
              setState(() {
                this.title = title;
              });
            },
          ),
          child: _services.drawerScreen(title),
        )
    );
  }
}
