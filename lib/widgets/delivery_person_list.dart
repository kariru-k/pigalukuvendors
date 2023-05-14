import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geolocator/geolocator.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:pigalukuvendors/services/firebase_services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../services/order_services.dart';

class DeliveryPersonList extends StatefulWidget {
  const DeliveryPersonList({Key? key, required this.documentSnapshot,}) : super(key: key);
  final DocumentSnapshot documentSnapshot;

  @override
  State<DeliveryPersonList> createState() => _DeliveryPersonListState();
}

class _DeliveryPersonListState extends State<DeliveryPersonList> {
  FirebaseServices services = FirebaseServices();
  OrderServices orderServices = OrderServices();
  GeoPoint? shopLocation;

  @override
  void initState() {
    services.getShopDetails().then((value){
      if (mounted) {
        setState(() {
          shopLocation = value["location"];
        });
      }
    });
    super.initState();
  }

  Future<void> _launchUrl(number) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: number,
    );
    if (!await launchUrl(launchUri)) {
      throw Exception('Could not launch $number');
    }
  }

  void _launchMap(GeoPoint location, String name)async{
    final availableMaps = await MapLauncher.installedMaps;
    await availableMaps.first.showMarker(
        coords: Coords(location.latitude, location.longitude),
        title: name
    );
  }


  @override
  Widget build(BuildContext context) {


    return Dialog(
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppBar(
              title: const Text("Select Delivery Person", style: TextStyle(color: Colors.white),),
              iconTheme: const IconThemeData(color: Colors.white),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: services.deliveryPersons.where("accVerified", isEqualTo: true).snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.data!.size == 0) {
                  return const Center(
                    child: Text("No Delivery Persons Nearby"),
                  );
                }

                return Expanded(
                  child: ListView(
                    children: snapshot.data!.docs.map((DocumentSnapshot document){

                      GeoPoint location = document["location"];
                      double distanceInMeters = shopLocation == null ? 0.0 : Geolocator.distanceBetween(shopLocation!.latitude, shopLocation!.longitude, location.latitude, location.longitude) / 1000;

                      if (distanceInMeters > 10) {
                        return Container();
                      }

                      return Column(
                        children: [
                          ListTile(
                            onTap: (){
                              EasyLoading.show(status: "Assigning Delivery Person");
                              services.selectDeliveryPerson(
                                orderId: widget.documentSnapshot.id,
                                phoneNumber: document["phoneNumber"],
                                location: location,
                                image: document["url"],
                                name: document["name"]
                              ).then((value){
                                EasyLoading.showSuccess("Assigned Delivery Person");
                                Navigator.pop(context);
                                orderServices.updateOrderStatus(widget.documentSnapshot.id, "Assigned A Delivery Person");
                              });
                            },
                            leading: CircleAvatar(
                              backgroundColor: Colors.white,
                              child: CachedNetworkImage(imageUrl: document["url"]),
                            ),
                            title: Text(document["name"]),
                            subtitle: Text("${distanceInMeters.toStringAsFixed(2)}km away"),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                    onPressed: (){
                                      _launchMap(location, document["name"]);
                                    },
                                    icon: const Icon(Icons.map)
                                ),
                                IconButton(
                                    onPressed: (){
                                      _launchUrl(document['phoneNumber']);
                                    },
                                    icon: const Icon(Icons.phone)
                                ),
                              ],
                            ),
                          ),
                          const Divider(height: 5, color: Colors.grey,)
                        ],
                      );
                    }).toList(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
