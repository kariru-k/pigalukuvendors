import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_geocoder/geocoder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';

class AuthProvider extends ChangeNotifier{

  late File? image;
  bool isPicAvailable = false;
  final picker = ImagePicker();
  String? pickererror;
  double? shopLatitude;
  double? shopLongitude;
  String? shopAddress;
  String? shopLocality;
  String? error;
  String? email;


  Future<File?> getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 20);

    if(pickedFile != null){
      image = File(pickedFile.path);
      notifyListeners();
    } else {
      pickererror = "No image selected";
      print("No image selected");
      notifyListeners();
    }

    return image;

  }

  Future getCurrentAddress() async{
    Location location  = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    locationData = await location.getLocation();

    shopLatitude = locationData.latitude!;
    shopLongitude = locationData.longitude!;
    notifyListeners();

    final coordinates = Coordinates(shopLatitude, shopLongitude);
    var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    shopAddress = first.addressLine;
    shopLocality = first.featureName;
    print("${first.featureName} : ${first.addressLine}");

    notifyListeners();

    return shopAddress;

  }

  Future<UserCredential?> registerVendor(email, password) async{

    this.email = email;
    notifyListeners();

    UserCredential? userCredential;
    try {
      userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password
      );
    } on FirebaseAuthException catch (e) {
      if(e.code == "weak_password") {
        error = e.code;
        print("weak password");
        notifyListeners();
      } else if (e.code == "email-already-in-use"){
        error = e.code;
        print("account exists");
        notifyListeners();
      }
    } catch (e) {
      error = e.toString();
      notifyListeners();
      print(e);
    }

    return userCredential;
  }


  Future<UserCredential?> loginVendor(email, password) async{

    this.email = email;
    notifyListeners();

    UserCredential? userCredential;
    try {
      userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password
      );
    } on FirebaseAuthException catch (e) {
      error = e.code;
      notifyListeners();
    } catch (e) {
      error = e.toString();
      notifyListeners();
      print(e);
    }

    return userCredential;
  }


  Future<void> resetPassword(email) async{

    this.email = email;
    notifyListeners();
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      error = e.code;
      notifyListeners();
    } catch (e) {
      error = e.toString();
      notifyListeners();
      print(e);
    }
  }

  Future<void>saveVendorataToDb({
    String? url,
    String? shopName,
    String? ownerName,
    String? ownerNumber,
    String? storePhoneNumber,
    String? description
  }) async{


    User? user = FirebaseAuth.instance.currentUser;

    DocumentReference _vendors = FirebaseFirestore.instance
        .collection("vendors")
        .doc(user?.uid);

    _vendors.set({
      'uid': user?.uid,
      'url': url,
      'shopName': shopName,
      'ownerName': ownerName,
      'email': email,
      'ownerNumber': ownerNumber,
      'storePhoneNumber': storePhoneNumber,
      'description': description,
      'address': "$shopAddress, $shopLocality",
      'location': GeoPoint(shopLatitude!, shopLongitude!),
      'shopOpen': true,
      'rating': 0.00,
      'totalRating': 0,
      'isTopPicked': true,
      'accVerified': true
    });

    return;
}
}