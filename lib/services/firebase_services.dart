import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class FirebaseServices {

  User? user = FirebaseAuth.instance.currentUser;

  CollectionReference category = FirebaseFirestore.instance.collection("category");
  CollectionReference products = FirebaseFirestore.instance.collection("products");
  CollectionReference vendorbanner = FirebaseFirestore.instance.collection("vendorbanner");
  CollectionReference coupons = FirebaseFirestore.instance.collection("coupons");
  CollectionReference deliveryPersons = FirebaseFirestore.instance.collection("deliverypersons");
  CollectionReference vendors = FirebaseFirestore.instance.collection("vendors");
  CollectionReference orders = FirebaseFirestore.instance.collection("orders");
  CollectionReference customers = FirebaseFirestore.instance.collection("users");

  Future<void>publishProduct({required id}){
    return products.doc(id).update({
      "published" : true
    });
  }

  Future<void>unpublishProduct({required id}){
    return products.doc(id).update({
      "published" : false
    });
  }

  Future<void>deleteProduct({required id}){
    return products.doc(id).delete();
  }

  Future<void>saveBanner(url){
    return vendorbanner.add({
      'imageurl': url,
      'sellerUid': user!.uid
    });
  }

  Future<void>deleteBanner({required id}){
    return vendorbanner.doc(id).delete();
  }

  Future<void>saveCoupon({document, title, discountRate, expiryDate, details, active}){
    if (document == null) {
      return coupons.doc(title).set({
        'title': title,
        "discountRate": discountRate,
        "expiryDate": expiryDate,
        "details": details,
        "active": active,
        "sellerId": user!.uid
      });
    }
    return coupons.doc(title).update({
      'title': title,
      "discountRate": discountRate,
      "expiryDate": expiryDate,
      "details": details,
      "active": active,
      "sellerId": user!.uid
    });
  }

  Future<DocumentSnapshot>getShopDetails() async{
    DocumentSnapshot doc = await vendors.doc(user!.uid).get();
    return doc;
  }

  Future<DocumentSnapshot>getCustomerDetails(id) async{
    DocumentSnapshot doc = await customers.doc(id).get();
    return doc;
  }

  Future<void>selectDeliveryPerson({orderId, location, name, phoneNumber, image}){
    var result = orders.doc(orderId).update({
      "deliveryBoy" : {
        "location": location,
        "name": name,
        "phone": phoneNumber,
        "image": image
      }
    });

    return result;
  }


}