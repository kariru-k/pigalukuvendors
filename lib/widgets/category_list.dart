import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pigalukuvendors/providers/products_provider.dart';
import 'package:pigalukuvendors/services/firebase_services.dart';
import 'package:provider/provider.dart';

class CategoryList extends StatefulWidget {
  const CategoryList({Key? key}) : super(key: key);

  @override
  State<CategoryList> createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {

  FirebaseServices _services = FirebaseServices();


  @override
  Widget build(BuildContext context) {


    var _provider = Provider.of<ProductProvider>(context);


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
                  Text(
                    "Select Category",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.close, color: Colors.white,)
                  )
                ],
              ),
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: _services.category.snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
              if (snapshot.hasError) {
                return Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }

              return Expanded(
                child: ListView(
                  children: snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(data['image']),
                      ),
                      title: Text(data['name']),
                      onTap: () {
                        _provider.selectCategory(data['name']);
                        Navigator.of(context).pop();
                      },
                    );
                  }).toList(),
                ),
              );

            },
          )
        ],
      ),
    );
  }
}
