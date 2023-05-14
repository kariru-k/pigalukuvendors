import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../services/firebase_services.dart';
import '../services/order_services.dart';

class OrderSummaryCard extends StatefulWidget {
  const OrderSummaryCard({Key? key, required this.data, required this.document}) : super(key: key);
  final Map<String, dynamic> data;
  final DocumentSnapshot document;

  @override
  State<OrderSummaryCard> createState() => _OrderSummaryCardState();
}

class _OrderSummaryCardState extends State<OrderSummaryCard> {
  OrderServices orderServices = OrderServices();
  FirebaseServices firebaseServices = FirebaseServices();


  DocumentSnapshot? customer;

  Future<void> _launchUrl(number) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: number,
    );
    if (!await launchUrl(launchUri)) {
      throw Exception('Could not launch $number');
    }
  }


  @override
  void initState() {
    firebaseServices.getCustomerDetails(widget.data["userID"]).then((value){
      setState(() {
        customer = value;
      });
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          ListTile(
            horizontalTitleGap: 0,
            leading: CircleAvatar(
              radius: 14,
              backgroundColor: Colors.white,
              child: Icon(
                CupertinoIcons.square_list,
                size: 18,
                color: orderServices.statusColor(widget.document),
              ),
            ),
            title: Text(
              widget.data["orderStatus"],
              style: TextStyle(
                  fontSize: 18,
                  color: orderServices.statusColor(widget.document),
                  fontWeight: FontWeight.bold
              ),
            ),
            subtitle: Text(
              "On ${DateFormat.yMMMd().format(DateTime.parse(widget.data["timestamp"]))}",
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
                        widget.data["cod"]  ? "Cash on Delivery" : "Online Payment",
                        style: const TextStyle(
                            color: Colors.purpleAccent,
                            fontWeight: FontWeight.bold
                        ),
                      )
                    ],
                  ),
                ),
                Text(
                  "Amount: Kshs. ${widget.data["total"]}",
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
                  itemCount: widget.data["products"].length,
                  itemBuilder: (BuildContext context, int index){
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: CachedNetworkImage(
                          imageUrl: widget.data["products"][index]["productImage"],
                          fit: BoxFit.scaleDown,
                        ),
                      ),
                      title: Text(
                          widget.data["products"][index]["productName"]
                      ),
                      subtitle: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Quantity: ${widget.data["products"][index]["qty"].toString()}",
                          ),
                          Text(
                            "Size: ${widget.data["products"][index]["size"]}",
                          ),
                        ],
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
                            Text(widget.data["seller"]["shopName"])
                          ],
                        ),
                        if (widget.data["discount"] != 0 && widget.data["discount"] != null) ...[
                          Row(
                            children: [
                              const Text("Discount: ",style: TextStyle(fontWeight: FontWeight.bold),),
                              Text(
                                "Kshs. ${widget.data["discount"].toString()}",
                              )
                            ],
                          ),
                          Row(
                            children: [
                              const Text("Discount Code Used: ",style: TextStyle(fontWeight: FontWeight.bold),),
                              Text(
                                widget.data["discountCode"].toString(),
                              )
                            ],
                          )
                        ],
                      ],
                    ),
                  ),
                ),
              ),
              const Text("Customer Details"),
              customer != null
                  ?
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 4,
                  child: ListTile(
                    contentPadding: const EdgeInsets.only(left: 8, right: 8),
                    trailing: IconButton(
                        onPressed: (){
                          _launchUrl(customer!["number"]);
                        },
                        icon: const Icon(Icons.phone)
                    ),
                    title: Row(
                      children: [
                        const Text("Name: "),
                        Text(customer!["firstName"], style: const TextStyle(fontWeight: FontWeight.w400, color: Colors.purple),),
                      ],
                    ),
                    subtitle: Column(
                      children: [
                        const SizedBox(height: 10,),
                        Row(
                          children: [
                            const Text("Phone Number: "),
                            Text(customer!["number"], style: const TextStyle(fontWeight: FontWeight.w400, color: Colors.purple),),
                          ],
                        ),
                        const SizedBox(height: 10,),
                        Row(
                          children: [
                            const Text("Address: "),
                            Expanded(child: Text(customer!["address"], style: const TextStyle(fontWeight: FontWeight.w400, color: Colors.purple),)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              )
                  :
              Container(),
              if (widget.data["deliveryBoy"] != null) ... [
                const Text("Delivery Person Details"),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 4,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: CachedNetworkImage(imageUrl: widget.document["deliveryBoy.image"]),
                      ),
                      title: Column(
                        children: [
                          Row(
                            children: [
                              const Text("Name: "),
                              Text(widget.document["deliveryBoy.name"], style: const TextStyle(fontWeight: FontWeight.w400, color: Colors.purple),),
                            ],
                          ),
                          Row(
                            children: [
                              const Text("Phone Number: "),
                              Text(widget.document["deliveryBoy.phone"], style: const TextStyle(fontWeight: FontWeight.w400, color: Colors.purple),),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ]
            ],
          ),
          const Divider(height: 3, color: Colors.grey,),
          orderServices.statusContainer(widget.data, widget.document, context),
        ],
      ),
    );
  }
}
