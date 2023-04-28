import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class FirebaseServices {

  User? user = FirebaseAuth.instance.currentUser;

  CollectionReference category = FirebaseFirestore.instance.collection("category");
  CollectionReference products = FirebaseFirestore.instance.collection("products");
  CollectionReference vendorbanner = FirebaseFirestore.instance.collection("vendorbanner");
  CollectionReference coupons = FirebaseFirestore.instance.collection("coupons");


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


}