import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:map_launcher/map_launcher.dart';
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

  _launchMap(GeoPoint location, name) async {
    final availableMaps = await MapLauncher.installedMaps;
    await availableMaps.first.showMarker(
      coords: Coords(location.latitude, location.longitude),
      title: name,
    );
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
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ListTile(
            horizontalTitleGap: 0,
            leading: CircleAvatar(
              radius: 14,
              backgroundColor: Colors.white,
              child: orderServices.statusIcon(widget.document)
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
          customer != null
              ?
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const Text(
                  "Customer Details",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16
                  ),
                ),
                Card(
                  color: Colors.white54,
                  child: Column(
                    children: [
                      ListTile(
                        contentPadding: const EdgeInsets.only(left: 8, right: 8),

                        subtitle: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text("Name: ", style: TextStyle(fontWeight: FontWeight.bold,  color: Colors.black),),
                                Text(customer!["firstName"], style: const TextStyle(fontWeight: FontWeight.normal,),),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Phone Number: ",  style: TextStyle(fontWeight: FontWeight.bold,  color: Colors.black),),
                                Text(customer!["number"]),
                              ],
                            ),
                            const SizedBox(height: 10,),
                            Row(
                              children: [
                                const Text("Address: ",  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),),
                                Expanded(child: Text(customer!["address"])),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                              onPressed: (){
                                _launchUrl(customer!["number"]);
                              },
                              icon: Icon(Icons.phone, color: Theme.of(context).primaryColor,)
                          ),
                          const SizedBox(width: 30,),
                          IconButton(
                              onPressed: (){
                                _launchMap(customer!["location"], customer!["address"]);
                              },
                              icon: Icon(Icons.map, color: Theme.of(context).primaryColor,)
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
              :
          Container(),
          ExpansionTile(
            title: const Text(
              "Order details",
              style: TextStyle(
                  fontSize: 16,
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
