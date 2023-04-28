import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pigalukuvendors/screens/edit_view_product.dart';
import 'package:pigalukuvendors/services/firebase_services.dart';

class UnpublishedProducts extends StatelessWidget {
  const UnpublishedProducts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    FirebaseServices services = FirebaseServices();
    User? user = FirebaseAuth.instance.currentUser;

    return StreamBuilder(
      stream: services.products.where("seller.sellerUid", isEqualTo: user!.uid).where("published", isEqualTo: false).snapshots(),
      builder: (context, snapshot){
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          child: FittedBox(
            child: DataTable(
                showBottomBorder: true,
                dataRowHeight: 100,
                headingRowColor: MaterialStateProperty.all(Colors.grey[200]),
                columns: const <DataColumn>[
                  DataColumn(label: Text("Product Name")),
                  DataColumn(label: Text("Image")),
                  DataColumn(label: Text("Info")),
                  DataColumn(label: Text("Actions")),
                ],
                rows: _productDetails(snapshot.data!, context)
            ),
          ),
        );
      },
    );
  }

  List<DataRow>_productDetails(QuerySnapshot snapshot, context){
    List<DataRow> newList = snapshot.docs.map((DocumentSnapshot? document){
      return DataRow(
          cells: [
            DataCell(
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(document!['productName'], style: const TextStyle(fontSize: 20),),
                  subtitle: Text("Item Code: ${document["productId"]}", style: const TextStyle(fontSize: 15)),
                )
            ),
            DataCell(
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                      children: [
                        Image.network(document['productImage'], height: 75, width: 75,),
                      ]
                  ),
                )
            ),
            DataCell(
              IconButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => EditViewProduct(productId: document["productId"])));
                },
                icon: const Icon(Icons.info_outline),
              )
            ),
            DataCell(
              popUpButton(document)
            )
          ]
      );
    }).toList();

    return newList;
  }

  Widget popUpButton(data, {BuildContext? context}){
    return PopupMenuButton<String>(
      onSelected: (String value) {

        FirebaseServices services = FirebaseServices();


        if (value == "publish") {
          services.publishProduct(
              id: data["productId"]
          );
        }

        if (value == "delete") {
          services.deleteProduct(
              id: data["productId"]
          );
        }




      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
            value: "publish",
            child: ListTile(
              leading: Icon(Icons.check),
              title: Text("Publish"),
            )
        ),
        const PopupMenuItem<String>(
            value: "Delete",
            child: ListTile(
              leading: Icon(Icons.delete_outline),
              title: Text("Delete Product Details"),
            )
        )
      ],
    );
  }

}
