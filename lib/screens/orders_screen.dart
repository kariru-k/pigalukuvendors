
import 'package:chips_choice/chips_choice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pigalukuvendors/services/order_services.dart';
import 'package:pigalukuvendors/widgets/order_summary_card.dart';
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
    'All Orders', "Ordered", "Rejected", "Cancelled", 'Accepted', "Assigned a Delivery Person" ,'Picked Up',
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
                            return OrderSummaryCard(data: data, document: document);
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

}