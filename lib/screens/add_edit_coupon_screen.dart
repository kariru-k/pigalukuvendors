import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:pigalukuvendors/services/firebase_services.dart';

class AddEditCoupon extends StatefulWidget {
  static const String id = "update-coupon";
  const AddEditCoupon({Key? key, required this.document}) : super(key: key);
  final DocumentSnapshot? document;

  @override
  State<AddEditCoupon> createState() => _AddEditCouponState();
}

class _AddEditCouponState extends State<AddEditCoupon> {
  final _formKey = GlobalKey<FormState>();
  FirebaseServices services = FirebaseServices();
  DateTime selectedDate = DateTime.now();
  var dateText = TextEditingController();
  var couponTitle = TextEditingController();
  var discountPercent = TextEditingController();
  var couponDetails = TextEditingController();
  bool active = false;

  selectDate(context) async{
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 60))
    );
    
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        String formattedText = DateFormat("yyyy-MM-dd").format(selectedDate);
        dateText.text = formattedText;
      });
    }  
  }

  @override
  void initState() {
    if (widget.document != null) {
      setState(() {
        couponTitle.text = widget.document!["title"].toString();
        dateText.text = widget.document!["expiryDate"].toDate().toString();
        couponDetails.text = widget.document!["details"].toString();
        discountPercent.text = widget.document!["discountRate"].toString();
        active = widget.document!["active"];
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add New Coupon"),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: couponTitle,
                  validator: (value){
                    if (value!.isEmpty) {
                      return "Enter Coupon Title";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.zero,
                    labelText: "Coupon Title",
                    labelStyle: TextStyle(
                      color: Colors.grey
                    )
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: discountPercent,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Enter Discount Percentage";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                      contentPadding: EdgeInsets.zero,
                      labelText: "Discount Percentages",
                      labelStyle: TextStyle(
                          color: Colors.grey
                      )
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: dateText,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Enter Expiry Date";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.zero,
                      labelText: "Discount Expiry Date",
                      labelStyle: const TextStyle(
                          color: Colors.grey
                      ),
                      suffixIcon: InkWell(
                          onTap: (){
                            selectDate(context);
                          },
                          child: const Icon(Icons.date_range_outlined)
                      )
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: couponDetails,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Enter Coupon Details";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                      contentPadding: EdgeInsets.zero,
                      labelText: "Coupon details",
                      labelStyle: TextStyle(
                          color: Colors.grey
                      )
                  ),
                ),
              ),
              SwitchListTile(
                  activeColor: Theme.of(context).primaryColor,
                  contentPadding: EdgeInsets.zero,
                  title: const Text("Activate Coupon"),
                  value: active,
                  onChanged: (bool newValue){
                    setState(() {
                      active = !active;
                    });
                  }
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                        onPressed: (){
                          if (_formKey.currentState!.validate()) {
                            EasyLoading.show(status: "Please wait...");
                            services.saveCoupon(
                              document: widget.document,
                              title: couponTitle.text,
                              discountRate: int.parse(discountPercent.text),
                              details: couponDetails.text,
                              expiryDate: selectedDate,
                              active: active
                            ).then((value){
                              setState(() {
                                EasyLoading.showSuccess("Successfully added the coupon!", duration: const Duration(seconds: 3));
                                couponTitle.clear();
                                discountPercent.clear();
                                couponDetails.clear();
                                dateText.clear();
                                active = false;
                              });
                            });
                          }
                        },
                        child: const Text(
                          "Submit",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold
                          ),
                        )
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
