
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class ProductProvider with ChangeNotifier{

  String selectedCategory = 'not selected';
  String selectedSubCategory = 'not selected';
  String? categoryImage;
  final picker = ImagePicker();
  late File? image;
  String? pickererror;
  String? shopName;
  String? producturl;




  selectCategory(selected, categoryImage){
    selectedCategory = selected;
    categoryImage = categoryImage;
    notifyListeners();
  }

  selectSubCategory(selected){
    selectedSubCategory = selected;
    notifyListeners();
  }

  getShopName(shopName){
    this.shopName = shopName;
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

    producturl = downloadUrl;
    notifyListeners();
    return downloadUrl;
  }


  Future<void>?saveProductDataToDb(
      {
        required productName,
        required description,
        required brand,
        required price,
        required collection,
        required gender,
        required itemCode,
        required quantity,
        required context,
        required category,
        required subcategory,
      }){
    var timeStamp = DateTime.now().microsecondsSinceEpoch;
    User? user = FirebaseAuth.instance.currentUser;
    CollectionReference products = FirebaseFirestore.instance.collection("products");
    try {
      products.doc(timeStamp.toString()).set({
        'seller': {
          'shopName': shopName,
          'sellerUid': user!.uid
        },
        "productName": productName,
        "description": description,
        "brand": brand,
        "price": price,
        "collection": collection,
        "gender": gender,
        "itemCode": itemCode,
        "category": {
          'categoryName': category,
          'subCategoryName': subcategory,
        },
        "quantity": quantity,
        "published": false,
        "productId": timeStamp.toString(),
        "productImage": producturl
      });
      alertDialog(
          context: context,
          title: "SAVE DATA",
          content: "Product Details saved successfully"
      );
    } on Exception catch (e) {
      alertDialog(
          context: context,
          title: "Error Saving data",
          content: e.toString()
      );
    }
    return null;
  }


  alertDialog({required context, required title, required content}){
    return showCupertinoDialog(
        context: context,
        builder: (BuildContext context){
          return CupertinoAlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              CupertinoDialogAction(
                child: const Text("OK"),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        }
    );
  }

}