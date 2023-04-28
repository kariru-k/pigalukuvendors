import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pigalukuvendors/providers/products_provider.dart';
import 'package:pigalukuvendors/services/firebase_services.dart';
import 'package:provider/provider.dart';

import '../widgets/banner_card.dart';

class BannerScreen extends StatefulWidget {
  const BannerScreen({Key? key}) : super(key: key);

  @override
  State<BannerScreen> createState() => _BannerScreenState();
}

class _BannerScreenState extends State<BannerScreen> {


  FirebaseServices services = FirebaseServices();
  bool _visible = false;
  File? _image;
  final _imagePathText = TextEditingController();


  @override
  Widget build(BuildContext context) {

    var provider = Provider.of<ProductProvider>(context);



    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          const BannerCard(),
          const Divider(thickness: 3,),
          const SizedBox(height: 20,),
          const Center(
              child: Text(
                "ADD NEW BANNER",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              )
          ),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 150,
                  width: MediaQuery.of(context).size.width,
                  child: Card(
                    color: Colors.grey[200],
                    child: _image != null ? Image.file(_image!) : const Center(child: Text("No Image Selected"),),
                  ),
                ),
                TextFormField(
                  controller: _imagePathText,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.zero,
                    border: OutlineInputBorder()
                  ),
                ),
                const SizedBox(height: 20,),
                Visibility(
                  visible: _visible ? false : true,
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _visible = true;
                            });
                          },
                          child: const Text(
                            "Add New Banner",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: _visible,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                getBannerImage().then((value){
                                  if (_image != null) {
                                    setState(() {
                                      _imagePathText.text = _image!.path;
                                    });
                                  }  
                                });
                              },
                              child: const Text(
                                "Upload Image",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: AbsorbPointer(
                              absorbing: _image != null ? false : true,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _image == null ? Colors.grey : Theme.of(context).primaryColor
                                ),
                                onPressed: () {
                                  EasyLoading.show(status: "Saving Image");
                                  uploadBannerImage(_image!.path, provider.shopName).then((url){
                                    if (url != null) {
                                      services.saveBanner(url);
                                      setState(() {
                                        _imagePathText.clear();
                                        _image = null;
                                      });
                                      EasyLoading.dismiss();
                                      provider.alertDialog(
                                          context: context,
                                          title: "Banner Upload",
                                          content: "Banner Image Uploaded Successfully"
                                      );
                                    } else {
                                      EasyLoading.dismiss();
                                      provider.alertDialog(
                                          context: context,
                                          title: "Banner Upload",
                                          content: "Banner Upload Failed. Please Try Again"
                                      );
                                    }
                                  });
                                },
                                child: const Text(
                                  "Save",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red
                              ),
                              onPressed: () {
                                setState(() {
                                  _visible = false;
                                  _image = null;
                                });
                              },
                              child: const Text(
                                "Cancel",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      )
    );
  }

  Future<File?> getBannerImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
        source: ImageSource.gallery, imageQuality: 20);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    } else {
    }

    return _image;
  }

  Future<String?>uploadBannerImage(filePath, shopName) async {
    File file = File(filePath);
    var timeStamp = Timestamp.now();


    FirebaseStorage storage = FirebaseStorage.instance;

    try {
      await storage
          .ref("vendorbanner/$shopName$timeStamp").putFile(file);
    } on FirebaseException {

    }

    String downloadUrl = await storage
        .ref("vendorbanner/$shopName$timeStamp")
        .getDownloadURL();

    return downloadUrl;
  }
}
