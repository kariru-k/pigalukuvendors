import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:pigalukuvendors/widgets/delivery_person_list.dart';

class OrderServices {
  CollectionReference orders = FirebaseFirestore.instance.collection("orders");


  Future<void>updateOrderStatus(documentId, status){
    var result = orders.doc(documentId).update({
      "orderStatus": status
    });
    return result;
  }

  showMyDialog({required title,required status,required documentId,required context}){
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context){
          return CupertinoAlertDialog(
            title: Text(title),
            content: const Text("Are you sure?"),
            actions: [
              TextButton(
                  onPressed: (){
                    EasyLoading.show(status: "Updating order...");
                    updateOrderStatus(documentId, status).then((value){
                      EasyLoading.showSuccess("Successfully updated order");
                    });
                    Navigator.pop(context);
                  },
                  child: Text(
                    "OK",
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  )
              ),
              TextButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Go Back",
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  )
              )
            ],
          );
        }
    );
  }

  Widget statusContainer(data, document, context){
    if (data["orderStatus"] == "Accepted") {
      return Container(
        color: Colors.grey.shade300,
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton(
                  onPressed: (){
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return DeliveryPersonList(documentSnapshot: document,);
                        }
                    );
                  },
                  style: TextButton.styleFrom(
                      backgroundColor: Colors.blueGrey
                  ),
                  child: const Text(
                    "Select Delivery Person",
                    style: TextStyle(
                        color: Colors.white
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton(
                  onPressed: (){
                    showMyDialog(title: "Cancel Order", status: "Cancelled", documentId: document.id, context: context);
                  },
                  style: TextButton.styleFrom(
                      backgroundColor: Colors.red
                  ),
                  child: const Text(
                    "Cancel",
                    style: TextStyle(
                        color: Colors.white
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
    if(data["orderStatus"] == "Ordered"){
      return Container(
        color: Colors.grey[300],
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextButton(
                    onPressed: (){
                      showMyDialog(title: "Accept Order", status: "Accepted", documentId: document.id, context: context);
                    },
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.blueGrey
                    ),
                    child: const Text(
                      "Accept",
                      style: TextStyle(
                          color: Colors.white
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextButton(
                    onPressed: (){
                      showMyDialog(title: "Reject Order", status: "Rejected", documentId: document.id, context: context);
                    },
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.red
                    ),
                    child: const Text(
                      "Reject",
                      style: TextStyle(
                          color: Colors.white
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  Color statusColor(DocumentSnapshot document){
    if (document["orderStatus"] == "Accepted") {
      return Colors.blueGrey.shade400;
    }
    if (document["orderStatus"] == "Rejected" || document["orderStatus"] == "Cancelled") {
      return Colors.red;
    }
    if (document["orderStatus"] == "Picked Up") {
      return Colors.pink.shade900;
    }
    if (document["orderStatus"] == "On the way") {
      return Colors.purple.shade900;
    }
    if (document["orderStatus"] == "Delivered") {
      return Colors.green.shade900;
    }
    return Colors.orange;
  }

  Icon statusIcon(DocumentSnapshot document){
    if (document["orderStatus"] == "Accepted") {
      return Icon(Icons.assignment_turned_in_outlined, color: statusColor(document),);
    }
    if (document["orderStatus"] == "Rejected" || document["orderStatus"] == "Cancelled") {
      return Icon(Icons.cancel_outlined, color: statusColor(document),);
    }
    if (document["orderStatus"] == "Picked Up") {
      return Icon(Icons.cases, color: statusColor(document),);
    }
    if (document["orderStatus"] == "On the way") {
      return Icon(Icons.delivery_dining_outlined, color: statusColor(document),);
    }
    if (document["orderStatus"] == "Delivered") {
      return Icon(Icons.shopping_bag_rounded, color: statusColor(document),);
    }
    return Icon(Icons.assignment_turned_in_outlined, color: statusColor(document),);

  }



}