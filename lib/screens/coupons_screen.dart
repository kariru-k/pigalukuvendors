import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pigalukuvendors/screens/add_edit_coupon_screen.dart';
import 'package:pigalukuvendors/services/firebase_services.dart';


class CouponScreen extends StatelessWidget {
  const CouponScreen({Key? key}) : super(key: key);
  static const String id = "coupon-screen";

  @override
  Widget build(BuildContext context) {

    FirebaseServices services = FirebaseServices();

    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: services.coupons.where("sellerId", isEqualTo: services.user!.uid).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          if (!snapshot.hasData) {
            return const Center(
              child: Text("No coupons added yet"),
            );
          }

          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                        onPressed: (){
                          Navigator.pushNamed(context, AddEditCoupon.id);
                        },
                        child: const Text("Add New Coupon", style: TextStyle(color: Colors.white),)
                    ),
                  ),
                ],
              ),
              FittedBox(
                child: DataTable(
                    columns: const <DataColumn>[
                      DataColumn(label: Text("Title")),
                      DataColumn(label: Text("Rate")),
                      DataColumn(label: Text("Status")),
                      DataColumn(label: Text("Information")),
                      DataColumn(label: Text("Expiry Date")),
                    ],
                    rows: couponList(snapshot.data, context) as List<DataRow>
                ),
              )
            ],
          );
        },
      )
    );
  }

  List<DataRow>? couponList(QuerySnapshot? snapshot, context){
    List<DataRow>? newList = snapshot?.docs.map((DocumentSnapshot document){
      var date = document["expiryDate"];
      var expiry = DateFormat.yMMMd().add_jm().format(date.toDate());
      return DataRow(
        cells: [
          DataCell(Text(document["title"])),
          DataCell(Text(document["discountRate"].toString())),
          DataCell(Text(document["active"] ? "Active" : "Inactive")),
          DataCell(Text(expiry.toString())),
          DataCell(
              IconButton(
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => AddEditCoupon(document: document,)));
                  },
                  icon: const Icon(Icons.info_outlined)
              )
          ),
        ]
      );
    }).cast<DataRow>().toList();
    return newList;
  }
}