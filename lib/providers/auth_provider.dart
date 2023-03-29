import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart' as loc;
import 'package:geolocator/geolocator.dart';

class AuthProvider extends ChangeNotifier {

  late File? image;
  bool isPicAvailable = false;
  final picker = ImagePicker();
  String? pickererror;
  double? shopLatitude;
  double? shopLongitude;
  String? shopAddress;
  String? shopStreet;
  String? shopSubLocality;
  String? shopLocality;
  String? error;
  String? email;

  Future<File?> getImage() async {
    final pickedFile = await picker.pickImage(
        source: ImageSource.gallery, imageQuality: 20);

    if (pickedFile != null) {
      image = File(pickedFile.path);
      notifyListeners();
    } else {
      pickererror = "No image selected";
      print("No image selected");
      notifyListeners();
    }

    return image;
  }

  Future getCurrentAddress() async {
    loc.Location location = loc.Location();

    bool serviceEnabled;
    LocationPermission permissionGranted;


    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }
    permissionGranted = await Geolocator.checkPermission();
    if (permissionGranted == LocationPermission.denied) {
      permissionGranted = await Geolocator.requestPermission();
      if (permissionGranted == LocationPermission.denied) {
        return Future.error("Location Permissions are denied");
      }
    }

    Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high
      );

    shopLatitude = position.latitude;
    shopLongitude = position.longitude;
    notifyListeners();

    var addresses = await placemarkFromCoordinates(
        shopLatitude!, shopLongitude!);
    var first = addresses.first;
    shopAddress = first.name;
    shopStreet = first.street;
    shopSubLocality = first.subLocality;
    shopLocality = first.locality;
    print("${first.locality} : ${first.subLocality}");
    print(shopAddress);

    notifyListeners();

    return shopAddress;
    }

  Future<UserCredential?> registerVendor(email, password) async {
      this.email = email;
      notifyListeners();

      UserCredential? userCredential;
      try {
        userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: email,
            password: password
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == "weak_password") {
          error = e.code;
          print("weak password");
          notifyListeners();
        } else if (e.code == "email-already-in-use") {
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


  Future<UserCredential?> loginVendor(email, password) async {
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

  Future<void> resetPassword(email) async {
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

  Future<void> saveVendorataToDb({
    String? url,
    String? shopName,
    String? ownerName,
    String? ownerNumber,
    String? storePhoneNumber,
    String? description
  }) async {
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