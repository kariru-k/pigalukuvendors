import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class AuthProvider extends ChangeNotifier{

  late File? _image;
  bool isPicAvailable = false;
  final picker = ImagePicker();
  String pickererror = "";


  Future<File?> getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if(pickedFile != null){
      _image = File(pickedFile.path);
      notifyListeners();
    } else {
      pickererror = "No image selected";
      print("No image selected");
      notifyListeners();
    }

    return _image;

  }
}