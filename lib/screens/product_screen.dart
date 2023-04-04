import 'package:flutter/material.dart';
import 'package:pigalukuvendors/screens/add_new_product_screen.dart';


class ProductScreen extends StatelessWidget {
  static const String id = 'product-screen';
  const ProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
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
                      child: Row(
                        children: const [
                          Text("Products"),
                          SizedBox(width: 10,),
                          CircleAvatar(
                            backgroundColor: Colors.black54,
                            maxRadius: 8,
                            child: FittedBox(
                              child: Padding(
                                padding: EdgeInsets.all(6),
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
                    ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pushNamed(context, AddNewProduct.id);
                        },
                        icon: const Icon(Icons.add, color: Colors.white,),
                        label: const Text("Add New Product")
                    )
                  ],
                ),
              ),
            ),
            TabBar(
              labelColor: Theme.of(context).primaryColor,
              indicatorColor: Theme.of(context).primaryColor,
              unselectedLabelColor: Colors.black54,
              tabs: const [
                Tab(text: "PUBLISHED",),
                Tab(text: "UNPUBLISHED",)
              ],
            ),
            const Expanded(
              child: TabBarView(
                children: [
                  Center(
                    child: Text("Published Products"),
                  ),
                  Center(
                    child: Text("Unpublished Products"),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
