import 'package:flutter/material.dart';
import 'package:pigalukuvendors/providers/products_provider.dart';
import 'package:pigalukuvendors/widgets/category_list.dart';
import 'package:provider/provider.dart';

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
  String? dropdownValue;


  var _categoryTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    var _provider = Provider.of<ProductProvider>(context);


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
                                    child: SizedBox(
                                      width: 150,
                                      height: 150,
                                      child: Card(
                                        child: Center(child: Text("Product Image"),),
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
                                                dropdownValue = value;
                                              });
                                            },
                                            value: dropdownValue,
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
                                                });
                                              });
                                            },
                                            icon: Icon(Icons.edit_outlined)
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                        Center(
                          child: Text("Inventory"),
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
