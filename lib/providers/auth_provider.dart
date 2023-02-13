import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_geocoder/geocoder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';

class AuthProvider extends ChangeNotifier{

  late File? _image;
  bool isPicAvailable = false;
  final picker = ImagePicker();
  String? pickererror;
  double? shopLatitude;
  double? shopLongitude;
  String? shopAddress;
  String? shopStreet;
  String? shopLocality;


  Future<File?> getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if(pickedFile != null){
      _image = File(pickedFile.path);
      notifyListeners();
    } else {
      pickererror = "No image selected";
      print("No image selected");
      notifyListeners();
    }

    return _image;

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

}