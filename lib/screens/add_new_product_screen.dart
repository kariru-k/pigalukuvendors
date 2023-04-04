import 'dart:io';

import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:pigalukuvendors/providers/products_provider.dart';
import 'package:pigalukuvendors/widgets/category_list.dart';
import 'package:provider/provider.dart';

import '../sizes/sizes.dart';
import '../widgets/subcategory_list.dart';

class AddNewProduct extends StatefulWidget {
  static const String id = 'add-new-product-screen';
  const AddNewProduct({Key? key}) : super(key: key);

  @override
  State<AddNewProduct> createState() => _AddNewProductState();
}

class _AddNewProductState extends State<AddNewProduct> {


  final _formKey = GlobalKey<FormState>();

  List<String> _collections = [
    "Featured Products",
    "Best Selling",
    "Recently Added"
  ];

  List<String> _genders = [
    "Male",
    "Female",
    "Unisex"
  ];

  String? collectiondropdownValue;
  String? genderdropdownValue;


  List<MultiSelectItem<ClothSize>> _clothsizes = clothsizes.map((value) => MultiSelectItem<ClothSize>(value, value.size)).toList();
  List<MultiSelectItem<ShoeSize>> _shoesizes = shoeSizes.map((value) => MultiSelectItem<ShoeSize>(value, value.size.toString())).toList();
  List<MultiSelectItem<TrouserSize>> _trouserSizes = trouserSizes.map((value) => MultiSelectItem<TrouserSize>(value, value.size.toString())).toList();



  var _categoryTextController = TextEditingController();
  var _subcategoryTextController = TextEditingController();
  File? _image;
  bool _visiblecategory = false;
  bool _visiblesubcategory = false;
  bool _track = false;



  @override
  Widget build(BuildContext context) {

    var _provider = Provider.of<ProductProvider>(context);

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

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: (){
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.arrow_back_sharp)
          ),
        ),
        body: Form(
          key: _formKey,
          child: Column(
            children: [
              Material(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Container(
                          child: Text("Products"),
                        ),
                      ),
                      ElevatedButton.icon(
                          onPressed: () {},
                          icon: Icon(Icons.save, color: Colors.white,),
                          label: Text("Save")
                      )
                    ],
                  ),
                ),
              ),
              TabBar(
                labelColor: Theme.of(context).primaryColor,
                indicatorColor: Theme.of(context).primaryColor,
                unselectedLabelColor: Colors.black54,
                tabs: [
                  Tab(text: "GENERAL",),
                  Tab(text: "INVENTORY",)
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Card(
                    child: TabBarView(
                      children: [
                        ListView(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                        labelText: "Product Name",
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
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                          labelText: "Description",
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
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: InkWell(
                                      onTap: () {
                                        _provider.getProductImage().then((image){
                                          setState(() {
                                            _image = image;
                                          });
                                        });
                                      },
                                      child: SizedBox(
                                        width: 150,
                                        height: 150,
                                        child: Card(
                                          child: _image == null ? Center(child: Text("Add Product Image")) : Image.file(_image as File),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextFormField(
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                          labelText: "Price",
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
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextFormField(
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                          labelText: "Compared Price",//Price before discount
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
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      child: Row(
                                        children: [
                                          Text(
                                            "Collection",
                                            style: TextStyle(color: Colors.grey),
                                          ),
                                          SizedBox(width: 10,),
                                          DropdownButton<String>(
                                            hint: Text("Select Collection"),
                                            items: _collections.map<DropdownMenuItem<String>>((String value){
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
                                            icon: Icon(Icons.arrow_drop_down_circle_sharp),

                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      child: Row(
                                        children: [
                                          Text(
                                            "Gender",
                                            style: TextStyle(color: Colors.grey),
                                          ),
                                          SizedBox(width: 10,),
                                          DropdownButton<String>(
                                            hint: Text("Select Gender of clothes"),
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
                                            icon: Icon(Icons.arrow_drop_down_circle_sharp),

                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextFormField(
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                          labelText: "Brand",//Price before discount
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
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextFormField(
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                          labelText: "Item Code",//Price before discount
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
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Text(
                                            "Category",
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 16
                                          ),
                                        ),
                                        SizedBox(width: 10,),
                                        Expanded(
                                          child: TextFormField(
                                            controller: _categoryTextController,
                                            decoration: InputDecoration(
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
                                          ),
                                        ),
                                        IconButton(
                                            onPressed: (){
                                              showDialog(
                                                  context: context,
                                                  builder: (BuildContext context){
                                                    return CategoryList();
                                                  }
                                              ).whenComplete((){
                                                setState(() {
                                                  _categoryTextController.text = _provider.selectedCategory;
                                                  _visiblecategory = true;
                                                });
                                              });
                                            },
                                            icon: Icon(Icons.edit_outlined)
                                        )
                                      ],
                                    ),
                                  ),
                                  Visibility(
                                    visible: _visiblecategory,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Text(
                                            "Sub Category",
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 16
                                            ),
                                          ),
                                          SizedBox(width: 10,),
                                          Expanded(
                                            child: TextFormField(
                                              controller: _subcategoryTextController,
                                              decoration: InputDecoration(
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
                                            ),
                                          ),
                                          IconButton(
                                              onPressed: (){
                                                showDialog(
                                                    context: context,
                                                    builder: (BuildContext context){
                                                      return SubCategoryList();
                                                    }
                                                ).whenComplete((){
                                                  setState(() {
                                                    _subcategoryTextController.text = _provider.selectedSubCategory;
                                                    _visiblesubcategory = true;
                                                  });
                                                });
                                              },
                                              icon: Icon(Icons.edit_outlined)
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    visible: _visiblesubcategory,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: MultiSelectDialogField(
                                        buttonText: Text(
                                          "Select Size",
                                          style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            color: Colors.grey
                                          ),
                                        ),
                                        title: Text("Sizes"),
                                        items: getItems(_categoryTextController.text, _subcategoryTextController.text),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.grey,
                                            width: 1
                                          )
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "Required";
                                          }
                                          return null;
                                        },
                                        onConfirm: (val) {

                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        SingleChildScrollView(
                          child: Column(
                            children: [
                              SwitchListTile(
                                title: Text("Track Inventory"),
                                subtitle: Text(
                                  "Switch ON to track Inventory",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12
                                  ),
                                ),
                                activeColor: Theme.of(context).primaryColor,
                                onChanged: (selected) {
                                  setState(() {
                                    _track = !_track;
                                  });
                                },
                                value: _track,
                              ),
                              Visibility(
                                visible: _track,
                                child: SizedBox(
                                  height: 300,
                                  width: double.infinity,
                                  child: Card(
                                    elevation: 3,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: TextField(
                                              decoration: InputDecoration(
                                                  labelText: "Inventory Quantity",
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
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: TextField(
                                              decoration: InputDecoration(
                                                  labelText: "Inventory Low Stock Quantity",
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
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
