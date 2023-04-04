
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class ProductProvider with ChangeNotifier{

  String selectedCategory = 'not selected';
  String selectedSubCategory = 'not selected';
  final picker = ImagePicker();
  late File? image;
  String? pickererror;
  String? shopName;




  selectCategory(selected){
    selectedCategory = selected;
    notifyListeners();
  }

  selectSubCategory(selected){
    selectedSubCategory = selected;
    notifyListeners();
  }

  getShopName(shopName){
    shopName = shopName;
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


  Future<String?>uploadProductImage(filePath, productName) async {
    File file = File(filePath);
    var timeStamp = Timestamp.now();


    FirebaseStorage storage = FirebaseStorage.instance;

    try {
      await storage
          .ref("productImage/$shopName$productName$timeStamp").putFile(file);
    } on FirebaseException {

    }

    String downloadUrl = await storage
        .ref("productImage/$shopName$productName$timeStamp")
        .getDownloadURL();

    return downloadUrl;
  }


  alertDialog({context, title, content}){
    return showCupertinoDialog(
        context: context,
        builder: (BuildContext context){
          return CupertinoAlertDialog(
            title: Text(title),
            content: Text(content),
            actions: const [
              CupertinoDialogAction(child: Text("OK"))
            ],
          );
        }
    );
  }

}