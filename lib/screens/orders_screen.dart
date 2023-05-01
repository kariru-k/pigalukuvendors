
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chips_choice/chips_choice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:pigalukuvendors/services/order_services.dart';
import 'package:provider/provider.dart';

import '../providers/order_provider.dart';


class OrderScreen extends StatefulWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {

  OrderServices orderServices = OrderServices();
  int tag = 0;
  List<String> options = [
    'All Orders', "Ordered", "Rejected", "Cancelled", 'Accepted', 'Picked Up',
    'On the Way', 'Delivered'
  ];
  User? user = FirebaseAuth.instance.currentUser;


  @override
  Widget build(BuildContext context) {

    var orderProvider = Provider.of<OrderProvider>(context);


    return Scaffold(
        backgroundColor: Colors.grey[300],
        body: Column(
          children: [
            SizedBox(
              height: 56,
              width: MediaQuery.of(context).size.width,
              child: ChipsChoice<int>.single(
                choiceStyle: const C2ChipStyle(
                    borderRadius: BorderRadius.all(Radius.circular(3))
                ),
                value: tag,
                onChanged: (val){
                  if (val ==0) {
                    setState(() {
                      orderProvider.status = null;
                    });
                  }
                  setState((){
                    tag = val;
                    orderProvider.status = null;
                    orderProvider.filterOrder(options[val]);
                  });
                },
                choiceItems: C2Choice.listFrom<int, String>(
                  source: options,
                  value: (i, v) => i,
                  label: (i, v) => v,
                ),
              ),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: orderServices.orders
                  .where("seller.sellerId", isEqualTo: user!.uid)
                  .where("orderStatus", isEqualTo: tag > 0 ? orderProvider.status : null)
                  .snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.data!.size == 0) {
                  return Center(
                    child: Text(tag > 0 ? "No ${options[tag]} orders yet" : "No orders yet"),
                  );
                }

                return Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          children: snapshot.data!.docs.map((DocumentSnapshot document) {
                            Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                            return Container(
                              color: Colors.white,
                              child: Column(
                                children: [
                                  ListTile(
                                    horizontalTitleGap: 0,
                                    leading: const CircleAvatar(
                                      radius: 14,
                                      child: Icon(CupertinoIcons.square_list, size: 18, color: Colors.pinkAccent,),
                                    ),
                                    title: Text(
                                      data["orderStatus"],
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: data["orderStatus"] == "Rejected"
                                              ? Colors.red[900]
                                              : data["orderStatus"] == "Accepted"
                                              ? Colors.green.shade900
                                              : Colors.blueGrey
                                          ,
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                    subtitle: Text(
                                      "On ${DateFormat.yMMMd().format(DateTime.parse(data["timestamp"]))}",
                                      style: const TextStyle(
                                          fontSize: 12
                                      ),
                                    ),
                                    trailing: Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        FittedBox(
                                          child: Row(
                                            children: [
                                              const Text(
                                                "Payment Method: ",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold
                                                ),
                                              ),
                                              Text(
                                                data["cod"]  ? "Cash on Delivery" : "Online Payment",
                                                style: const TextStyle(
                                                    color: Colors.purpleAccent,
                                                    fontWeight: FontWeight.bold
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Text(
                                          "Amount: Kshs. ${data["total"]}",
                                          style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  ExpansionTile(
                                    title: const Text(
                                      "Order details",
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.black
                                      ),
                                    ),
                                    subtitle: const Text(
                                      "View order Details",
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey
                                      ),
                                    ),
                                    children: [
                                      ListView.builder(
                                          shrinkWrap: true,
                                          physics: const NeverScrollableScrollPhysics(),
                                          itemCount: data["products"].length,
                                          itemBuilder: (BuildContext context, int index){
                                            return ListTile(
                                              leading: CircleAvatar(
                                                backgroundColor: Colors.white,
                                                child: CachedNetworkImage(
                                                  imageUrl: data["products"][index]["productImage"],
                                                  fit: BoxFit.scaleDown,
                                                ),
                                              ),
                                              title: Text(
                                                  data["products"][index]["productName"]
                                              ),
                                              subtitle: Text(
                                                "Quantity: ${data["products"][index]["qty"].toString()}",
                                              ),
                                            );
                                          }
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 12.0, right: 12, top: 8, bottom: 8),
                                        child: Card(
                                          elevation: 4,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    const Text("Seller: ",style: TextStyle(fontWeight: FontWeight.bold),),
                                                    Text(data["seller"]["shopName"])
                                                  ],
                                                ),
                                                if (data["discount"] != 0 && data["discount"] != null) ...[
                                                  Row(
                                                    children: [
                                                      const Text("Discount: ",style: TextStyle(fontWeight: FontWeight.bold),),
                                                      Text(
                                                        "Kshs. ${data["discount"].toString()}",
                                                      )
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      const Text("Discount Code Used: ",style: TextStyle(fontWeight: FontWeight.bold),),
                                                      Text(
                                                        data["discountCode"].toString(),
                                                      )
                                                    ],
                                                  )
                                                ],
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  const Divider(height: 3, color: Colors.grey,),
                                  data["orderStatus"] == "Accepted"
                                      ?
                                  Container(
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

                                              },
                                              style: TextButton.styleFrom(
                                                  backgroundColor: Colors.blueGrey
                                              ),
                                              child: const Text(
                                                "Assign Delivery person",
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
                                                showDialog(title: "Cancel Order", status: "Cancelled", documentId: document.id);
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
                                  )
                                      :
                                  data["orderStatus"] == "Rejected"
                                      ?
                                  Container()
                                      :
                                  Container(
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
                                                  showDialog(title: "Accept Order", status: "Accepted", documentId: document.id);
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
                                                  showDialog(title: "Reject Order", status: "Rejected", documentId: document.id);
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
                                  ),
                                  const Divider(height: 3, color: Colors.grey,),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        )
    );
  }
  showDialog({title, status, documentId}){
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
                    orderServices.updateOrderStatus(documentId, status).then((value){
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
                    EasyLoading.show(status: "Rejecting order...");
                    orderServices.updateOrderStatus(documentId, status).then((value){
                      EasyLoading.showSuccess("Successfully rejected the order");
                    });
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Cancel",
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  )
              )
            ],
          );
        }
    );
  }
}