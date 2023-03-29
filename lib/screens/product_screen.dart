import 'package:flutter/material.dart';
import 'package:pigalukuvendors/screens/add_new_product_screen.dart';


class ProductScreen extends StatelessWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
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
                      child: Row(
                        children: [
                          Text("Products"),
                          SizedBox(width: 10,),
                          CircleAvatar(
                            backgroundColor: Colors.black54,
                            maxRadius: 8,
                            child: FittedBox(
                              child: Padding(
                                padding: const EdgeInsets.all(6),
                                child: Text(
                                  "20",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold
                                ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(context, AddNewProduct.id);
                      },
                      icon: Icon(Icons.add, color: Colors.white,),
                      label: Text("Add New Product")
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
