import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
          child: DataTable(
              showBottomBorder: true,
              dataRowHeight: 100,
              headingRowColor: MaterialStateProperty.all(Colors.grey[200]),
              columns: const <DataColumn>[
                DataColumn(label: Text("Product Name")),
                DataColumn(label: Text("Image")),
                DataColumn(label: Text("Actions")),
              ],
              rows: _productDetails(snapshot.data!)
          ),
        );
      },
    );
  }

  List<DataRow>_productDetails(QuerySnapshot snapshot){
    List<DataRow> newList = snapshot.docs.map((DocumentSnapshot? document){
      return DataRow(
          cells: [
            DataCell(
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(document!['productName']),
                  subtitle: Text("Item Code: " + document['itemCode']),
                )
            ),
            DataCell(
                Image.network(document['productImage'], height: 50, width: 50,)
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

        FirebaseServices _services = FirebaseServices();


        if (value == "publish") {
          _services.publishProduct(
              id: data["productId"]
          );
        }

        if (value == "delete") {
          _services.deleteProduct(
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
            value: "preview",
            child: ListTile(
              leading: Icon(Icons.info_outline),
              title: Text("Preview"),
            )
        ),
        const PopupMenuItem<String>(
            value: "Edit",
            child: ListTile(
              leading: Icon(Icons.edit_outlined),
              title: Text("Edit Product Details"),
            )
        ),
        const PopupMenuItem<String>(
            value: "Edit",
            child: ListTile(
              leading: Icon(Icons.delete_outline),
              title: Text("Edit Product Details"),
            )
        )
      ],
    );
  }

}
