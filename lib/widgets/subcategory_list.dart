import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pigalukuvendors/providers/products_provider.dart';
import 'package:pigalukuvendors/services/firebase_services.dart';
import 'package:provider/provider.dart';

class SubCategoryList extends StatefulWidget {
  const SubCategoryList({Key? key}) : super(key: key);

  @override
  State<SubCategoryList> createState() => _SubCategoryListState();
}

class _SubCategoryListState extends State<SubCategoryList> {

  final FirebaseServices _services = FirebaseServices();


  @override
  Widget build(BuildContext context) {


    var provider = Provider.of<ProductProvider>(context);


    return Dialog(
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            color: Theme.of(context).primaryColor,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Select Subcategory",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.close, color: Colors.white,)
                  )
                ],
              ),
            ),
          ),
          FutureBuilder<DocumentSnapshot>(
            future: _services.category.doc(provider.selectedCategory).get(),
            builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot){
              if (snapshot.hasError) {
                return const Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.done) {
                Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;

                return Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            const Text("Main Category: ",),
                            FittedBox(
                              child: Text(
                                provider.selectedCategory,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        ),
                      ),
                      const Divider(thickness: 3,),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListView.builder(
                            itemBuilder: (BuildContext context, int index){
                              return ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: CircleAvatar(
                                  child: Text("${index + 1}"),
                                ),
                                title: Text(data['subCat'][index]['name']),
                                onTap: () {
                                  provider.selectSubCategory(data['subCat'][index]['name']);
                                  Navigator.pop(context);
                                },
                              );
                            },
                            itemCount: data["subCat"] == null ? 0 : data["subCat"].length,
                          ),
                        ),
                      )
                    ],
                  ),
                );

              }

              return const Center(
                child: CircularProgressIndicator(),
              );

            },
          )
        ],
      ),
    );
  }
}
