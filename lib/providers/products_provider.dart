
import 'package:flutter/cupertino.dart';

class ProductProvider with ChangeNotifier{

  String selectedCategory = 'not selected';

  selectCategory(selected){
    this.selectedCategory = selected;
    notifyListeners();
  }



}