import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:pigalukuvendors/services/firebase_services.dart';

class BannerCard extends StatelessWidget {
  const BannerCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    FirebaseServices services = FirebaseServices();


    return StreamBuilder<QuerySnapshot>(
      stream: services.vendorbanner.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }

        return SizedBox(
          height: 200,
          width: MediaQuery.of(context).size.width,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
              return Stack(
                children: [
                  SizedBox(
                    height: 180,
                    child: Card(
                      child: Image.network(data['imageurl'], fit: BoxFit.fill,),
                    ),
                  ),
                  Positioned(
                    right: 10,
                    top: 10,
                    child: CircleAvatar(
                      foregroundColor: Colors.white,
                      child: IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.red,),
                        onPressed: () {
                          EasyLoading.show(
                            status: "Deleting..."
                          );
                          services.deleteBanner(id: document.id);
                          EasyLoading.dismiss();
                        },
                      ),
                    ),
                  )
                ],
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
