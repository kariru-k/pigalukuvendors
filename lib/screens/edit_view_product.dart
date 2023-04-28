import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:pigalukuvendors/services/firebase_services.dart';
import 'package:provider/provider.dart';

import '../providers/products_provider.dart';
import '../sizes/sizes.dart';
import '../widgets/category_list.dart';
import '../widgets/subcategory_list.dart';

class EditViewProduct extends StatefulWidget {
  final String productId;

  const EditViewProduct({super.key, required this.productId});

  @override
  State<EditViewProduct> createState() => _EditViewProductState();
}

class _EditViewProductState extends State<EditViewProduct> {

  final FirebaseServices services = FirebaseServices();
  final formKey = GlobalKey<FormState>();

  var brandText = TextEditingController();
  var itemCodeText = TextEditingController();
  var productNameText = TextEditingController();
  var priceText = TextEditingController();
  var descriptionText = TextEditingController();
  final _categoryTextController = TextEditingController();
  final _subCategoryTextController = TextEditingController();
  final List<MultiSelectItem<ClothSize>> _clothsizes = clothsizes.map((value) => MultiSelectItem<ClothSize>(value, value.size)).toList();
  final List<MultiSelectItem<ShoeSize>> _shoesizes = shoeSizes.map((value) => MultiSelectItem<ShoeSize>(value, value.size.toString())).toList();
  final List<MultiSelectItem<TrouserSize>> _trouserSizes = trouserSizes.map((value) => MultiSelectItem<TrouserSize>(value, value.size.toString())).toList();
  String? collectiondropdownValue;
  String? genderdropdownValue;
  List sizes = [];
  Map<String, dynamic> quantities = {};
  final List<String> _collections = [
    "Featured Products",
    "Best Selling",
    "Recently Added"
  ];
  final List<String> _genders = [
    "Male",
    "Female",
    "Unisex"
  ];
  String? image;
  File? _image;
  DocumentSnapshot? doc;
  bool _editing = true;




  @override
  void initState() {
    getProductDetails();
    super.initState();
  }

  Future<void>getProductDetails() async {
    services.products.doc(widget.productId).get().then((DocumentSnapshot document){
      if(document.exists){
        setState(() {
          doc = document;
          brandText.text = document["brand"];
          itemCodeText.text = document["itemCode"];
          productNameText.text = document["productName"];
          priceText.text = document["price"].toString();
          image = document["productImage"];
          descriptionText.text = document["description"];
          _categoryTextController.text = document["category"]["categoryName"];
          _subCategoryTextController.text = document["category"]["subCategoryName"];
          collectiondropdownValue = document["collection"];
          genderdropdownValue = document["gender"];
          quantities = document["quantity"];

          for (var item in quantities.entries){
            sizes.add(item.key);
          }

          sizes.sort();

        });
      }
    });
  }



  @override
  Widget build(BuildContext context) {

    var provider = Provider.of<ProductProvider>(context);


    List<MultiSelectItem> getItems(category, subcategory){
      if(category == "Clothes"){
        if (subcategory == "Jeans" || subcategory == "Trousers") {
          return _trouserSizes;
        } else {
          return _clothsizes;
        }
      } else {
        return _shoesizes;
      }
    }


    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
              onPressed: () {
                setState(() {
                  _editing = false;
                });
              },
              child: const Text("Edit", style: TextStyle(color: Colors.white),)
          )
        ],
      ),
      bottomSheet: SizedBox(
        height: 60,
        child: Row(
          children: [
            Expanded(
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    color: Colors.black87 ,
                    child: const Center(
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                            color: Colors.white
                        ),
                      ),
                    ),
                  ),
                )
            ),
            Expanded(
                child: InkWell(
                  onTap: () {
                    if (formKey.currentState!.validate()) {
                      EasyLoading.show(status: "Saving...");
                      if (_image != null) {
                        provider.uploadProductImage(_image!.path, productNameText.text).then((url){
                          if(url != null){
                            EasyLoading.dismiss();
                            provider.updateProduct(
                                productName: productNameText.text,
                                description: descriptionText.text,
                                brand: brandText.text,
                                price: int.parse(priceText.text),
                                collection: collectiondropdownValue,
                                gender: genderdropdownValue,
                                itemCode: itemCodeText.text,
                                quantity: quantities,
                                context: context,
                                category: _categoryTextController.text,
                                subcategory: _subCategoryTextController.text,
                                productId: widget.productId,
                                image: url
                            );
                          }
                        });
                      }  else {
                        provider.updateProduct(
                            productName: productNameText.text,
                            description: descriptionText.text,
                            brand: brandText.text,
                            price: int.parse(priceText.text),
                            collection: collectiondropdownValue,
                            gender: genderdropdownValue,
                            itemCode: itemCodeText.text,
                            quantity: quantities,
                            context: context,
                            category: _categoryTextController.text,
                            subcategory: _subCategoryTextController.text,
                            productId: widget.productId,
                            image: image);
                        EasyLoading.dismiss();
                      }
                      provider.resetProvider();
                    }
                  },
                  child: AbsorbPointer(
                    absorbing: _editing,
                    child: Container(
                      color: Colors.pinkAccent ,
                      child: const Center(
                        child: Text(
                          "Save",
                          style: TextStyle(
                            color: Colors.white
                          ),
                        ),
                      ),
                    ),
                  ),
                )
            )
          ],
        ),
      ),
      body: doc == null ? const Center(child: CircularProgressIndicator()) : Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height / 9),
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: ListView(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              children: [
                AbsorbPointer(
                  absorbing: _editing,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 80,
                            height: 30,
                            child: TextFormField(
                              controller: brandText,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.only(left: 10, right: 10),
                                hintText: "Brand",
                                hintStyle: const TextStyle(color: Colors.grey),
                                border: const OutlineInputBorder(),
                                filled: true,
                                fillColor: Theme.of(context).primaryColor.withOpacity(.1)
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              const Text("Item Code: "),
                              SizedBox(
                                width: 80,
                                child: TextFormField(
                                  controller: itemCodeText,
                                  style: const TextStyle(fontSize: 12),
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.zero,

                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            height: 50,
                            child: TextFormField(
                              maxLines: 2,
                              controller: productNameText,
                              style: const TextStyle(fontSize: 25),
                              decoration: const InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.all(10.0),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          SizedBox(
                            child: TextFormField(
                              controller: priceText,
                              style: const TextStyle(fontSize: 16),
                              decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.all(10.0),
                                  border: InputBorder.none,
                                  prefixText: "Kshs. "
                              ),
                            ),
                          ),
                        ],
                      ),
                      Center(
                        child: InkWell(
                          onTap: () {
                            provider.getProductImage().then((element){
                              setState(() {
                                _image = element;
                              });
                            });
                          },
                          child: _image != null ? Image.file(
                            _image!,
                            height: 400,
                          ) :Image.network(
                            image.toString(),
                            height: 400,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10,),
                      const Text(
                        "About This Product",
                        style: TextStyle(
                          fontSize: 20
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: TextFormField(
                          maxLines: null,
                          controller: descriptionText,
                          keyboardType: TextInputType.multiline,
                          style: const TextStyle(
                            color: Colors.black87,
                            fontStyle: FontStyle.italic,
                            fontSize: 15
                          ),
                          decoration: const InputDecoration(
                            border: InputBorder.none
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            const Text(
                              "Category",
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16
                              ),
                            ),
                            const SizedBox(width: 10,),
                            Expanded(
                              child: AbsorbPointer(
                                absorbing: true,
                                child: TextFormField(
                                  controller: _categoryTextController,
                                  decoration: const InputDecoration(
                                      labelText: "Category", //Price before discount
                                      hintText: "No Category Selected",
                                      labelStyle: TextStyle(
                                          color: Colors.grey
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.grey,
                                          )
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.grey,
                                          )
                                      )
                                  ),
                                  validator: (value){
                                    if(value!.isEmpty){
                                      return "Select Category Name";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                            Visibility(
                              visible: _editing ? false : true,
                              child: IconButton(
                                  onPressed: (){
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context){
                                          return const CategoryList();
                                        }
                                    ).whenComplete((){
                                      setState(() {
                                        _categoryTextController.text = provider.selectedCategory!;
                                        _subCategoryTextController.clear();
                                      });
                                    });
                                  },
                                  icon: const Icon(Icons.edit_outlined)
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            const Text(
                              "Sub Category",
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16
                              ),
                            ),
                            const SizedBox(width: 10,),
                            Expanded(
                              child: AbsorbPointer(
                                absorbing: true,
                                child: TextFormField(
                                  controller: _subCategoryTextController,
                                  decoration: const InputDecoration(
                                      labelText: "Subcategory",
                                      hintText: "No SubCategory Selected",
                                      labelStyle: TextStyle(
                                          color: Colors.grey
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.grey,
                                          )
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.grey,
                                          )
                                      )
                                  ),
                                  validator: (value){
                                    if(value!.isEmpty){
                                      return "Select Subcategory Name";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                            Visibility(
                              visible: _editing ? false : true,
                              child: IconButton(
                                  onPressed: (){
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context){
                                          return const SubCategoryList();
                                        }
                                    ).whenComplete((){
                                      setState(() {
                                        _subCategoryTextController.text = provider.selectedSubCategory!;
                                      });
                                    });
                                  },
                                  icon: const Icon(Icons.edit_outlined)
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            const Text(
                              "Collection",
                              style: TextStyle(color: Colors.grey),
                            ),
                            const SizedBox(width: 10,),
                            DropdownButton<String>(
                              hint: const Text("Select Collection"),
                              items: _collections.map<DropdownMenuItem<String>>((String value){
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (String? value){
                                setState(() {
                                  collectiondropdownValue = value;
                                });
                              },
                              value: collectiondropdownValue,
                              icon: const Icon(Icons.arrow_drop_down_circle_sharp),

                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            const Text(
                              "Gender",
                              style: TextStyle(color: Colors.grey),
                            ),
                            const SizedBox(width: 10,),
                            DropdownButton<String>(
                              hint: const Text("Select Gender of clothes"),
                              items: _genders.map<DropdownMenuItem<String>>((String value){
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (String? value){
                                setState(() {
                                  genderdropdownValue = value;
                                });
                              },
                              value: genderdropdownValue,
                              icon: const Icon(Icons.arrow_drop_down_circle_sharp),

                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: MultiSelectDialogField(
                          initialValue: sizes,
                          buttonText: const Text(
                            "Select Size",
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                color: Colors.grey
                            ),
                          ),
                          title: const Text("Sizes"),
                          items: getItems(_categoryTextController.text, _subCategoryTextController.text),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.grey,
                                  width: 1
                              )
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Required Size";
                            }
                            return null;
                          },
                          onConfirm: (value) {
                            for (var element in value) {
                              if(quantities.containsKey(element) == false){
                                setState(() {
                                  quantities[element.size.toString()] = 0;
                                });
                              }
                            }
                          },
                          onSelectionChanged: (value) {
                            setState(() {
                              sizes = [];
                              sizes = value;
                            });
                          },
                        ),
                      ),
                      Column(
                        children: [
                          for (var element in quantities.entries) ... [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Text(element.key),
                                  ),
                                  const SizedBox(width: 5,),
                                  Expanded(
                                    flex: 3,
                                    child: TextFormField(
                                      validator: (value) {
                                        if(value!.isEmpty){
                                          return "Enter a Quantity";
                                        }
                                        return null;
                                      },
                                      initialValue: element.value.toString(),
                                      keyboardType: TextInputType.number,
                                      onChanged: (value) {
                                        setState(() {
                                          quantities[element.key] = int.parse(value);
                                        });
                                      },
                                      decoration: const InputDecoration(
                                          labelText: "Quantity",
                                          labelStyle: TextStyle(
                                              color: Colors.grey
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.grey,
                                              )
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.grey,
                                              )
                                          )
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ]
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
