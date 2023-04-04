
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class ProductProvider with ChangeNotifier{

  String selectedCategory = 'not selected';
  String selectedSubCategory = 'not selected';
  final picker = ImagePicker();
  late File? image;
  String? pickererror;




  selectCategory(selected){
    selectedCategory = selected;
    notifyListeners();
  }

  selectSubCategory(selected){
    selectedSubCategory = selected;
    notifyListeners();
  }

  Future<File?> getProductImage() async {
    final pickedFile = await picker.pickImage(
        source: ImageSource.gallery, imageQuality: 20);

    if (pickedFile != null) {
      image = File(pickedFile.path);
      notifyListeners();
    } else {
      pickererror = "No image selected";
      notifyListeners();
    }

    return image;
  }


}