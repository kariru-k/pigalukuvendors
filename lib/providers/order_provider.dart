import 'package:flutter/cupertino.dart';

class OrderProvider with ChangeNotifier {

  String? status;
  int timeline = 0;

  filterOrder(status){
    this.status = status;
    notifyListeners();
  }
  filterTimeline(timeline){
    this.timeline = timeline;
    notifyListeners();
  }

}