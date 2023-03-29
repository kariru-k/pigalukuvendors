import 'dart:io';

import 'package:email_validator/email_validator.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:pigalukuvendors/providers/auth_provider.dart';
import 'package:pigalukuvendors/screens/home_screen.dart';
import 'package:pigalukuvendors/screens/register_screen.dart';
import 'package:provider/provider.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({Key? key}) : super(key: key);

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final _confirmpasswordTextController = TextEditingController();
  final _addressTextController = TextEditingController();
  final _shopNameTextController = TextEditingController();
  final _descriptionTextController = TextEditingController();
  String? email;
  String? password;
  String? shopName;
  String? ownerName;
  String? ownerMobile;
  String? storeMobile;
  bool _isLoading = false;



  Future<String?>uploadFile(filePath) async {
    File file = File(filePath);


    FirebaseStorage _storage = FirebaseStorage.instance;

    try {
      await _storage
          .ref("uploads/shopProfilePic/${_shopNameTextController.text}").putFile(file);
      ;
    } on FirebaseException catch(e) {
      print(e.code);
    }

    String downloadUrl = await _storage
        .ref("uploads/shopProfilePic/${_shopNameTextController.text}")
        .getDownloadURL();

    return downloadUrl;
  }



  @override
  Widget build(BuildContext context) {
    final _authData = Provider.of<AuthProvider>(context);


    scaffoldMessage(message){
      return ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(message)
          )
      );
    }

    return _isLoading ? Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
      ),
    ) : Form(
      key: _formKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              validator: (value){
                if(value!.isEmpty){
                  return "Enter Shop Name";
                }
                setState(() {
                  _shopNameTextController.text = value;
                });
                setState(() {
                  shopName = value;
                });
                return null;
              },
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.add_business_sharp),
                labelText: "Business Name",
                focusColor: Theme.of(context).primaryColor,
                errorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                        style: BorderStyle.solid,
                        width: 2,
                        color: Colors.redAccent
                    ),
                ),
                enabledBorder: const OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    style: BorderStyle.solid,
                    width: 2,
                    color: Theme.of(context).primaryColor
                  )
                )
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              validator: (value){
                if(value!.isEmpty){
                  return "Enter Owner Name";
                }
                setState(() {
                  ownerName = value;
                });
                return null;
              },
              decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.person_outline_sharp),
                  labelText: "Owner Name",
                  contentPadding: EdgeInsets.zero,
                  focusColor: Theme.of(context).primaryColor,
                  enabledBorder: const OutlineInputBorder(),
                  errorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                        style: BorderStyle.solid,
                        width: 2,
                        color: Colors.redAccent
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 2,
                          color: Theme.of(context).primaryColor
                      )
                  )
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              keyboardType: TextInputType.phone,
              validator: (value){
                if(value!.isEmpty){
                  return "Enter Owner Phone Number";
                }
                setState(() {
                  ownerMobile = value;
                });
                return null;
              },
              maxLength: 9,
              decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.phone),
                  prefixText: "+254",
                  labelText: "Owner Phone Number",
                  contentPadding: EdgeInsets.zero,
                  focusColor: Theme.of(context).primaryColor,
                  enabledBorder: const OutlineInputBorder(),
                  errorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                        style: BorderStyle.solid,
                        width: 2,
                        color: Colors.redAccent
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 2,
                          color: Theme.of(context).primaryColor
                      )
                  )
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              keyboardType: TextInputType.phone,
              validator: (value){
                if(value!.isEmpty){
                  return "Enter Store Phone Number";
                }
                setState(() {
                  storeMobile = value;
                });
                return null;
              },
              maxLength: 9,
              decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.phone_android_sharp),
                  prefixText: "+254",
                  labelText: "Store Phone Number",
                  contentPadding: EdgeInsets.zero,
                  focusColor: Theme.of(context).primaryColor,
                  enabledBorder: const OutlineInputBorder(),
                  errorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                        style: BorderStyle.solid,
                        width: 2,
                        color: Colors.redAccent
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 2,
                          color: Theme.of(context).primaryColor
                      )
                  )
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _emailTextController,
              keyboardType: TextInputType.emailAddress,
              validator: (value){
                if(value!.isEmpty){
                  return "Enter Email Address";
                }
                final bool isValid = EmailValidator.validate(_emailTextController.text);
                if(!isValid){
                  return "This Email is invalid";
                }
                setState(() {
                  email = value;
                });
                return null;
              },
              decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.email_sharp),
                  labelText: "Email Address",
                  contentPadding: EdgeInsets.zero,
                  focusColor: Theme.of(context).primaryColor,
                  enabledBorder: const OutlineInputBorder(),
                  errorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                        style: BorderStyle.solid,
                        width: 2,
                        color: Colors.redAccent
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 2,
                          color: Theme.of(context).primaryColor
                      )
                  )
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
              validator: (value){
                if(value!.isEmpty){
                  return "Enter a password";
                }
                if(value.length < 6){
                  return "Minimum number of characters is 6";
                }
                setState(() {
                  password = value;
                });
                return null;
              },
              decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.password_sharp),
                  labelText: "Choose a Password",
                  contentPadding: EdgeInsets.zero,
                  focusColor: Theme.of(context).primaryColor,
                  enabledBorder: const OutlineInputBorder(),
                  errorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                        style: BorderStyle.solid,
                        width: 2,
                        color: Colors.redAccent
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 2,
                          color: Theme.of(context).primaryColor
                      )
                  )
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
              validator: (value){
                if(value!.isEmpty){
                  return "Please retype your password";
                }
                if(_passwordTextController.text != _confirmpasswordTextController.text){
                  return "Your passwords do not match";
                }
                return null;
              },
              decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.password_sharp),
                  labelText: "Confirm your Password",
                  contentPadding: EdgeInsets.zero,
                  focusColor: Theme.of(context).primaryColor,
                  enabledBorder: const OutlineInputBorder(),
                  errorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                        style: BorderStyle.solid,
                        width: 2,
                        color: Colors.redAccent
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 2,
                          color: Theme.of(context).primaryColor
                      )
                  )
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _addressTextController,
              validator: (value){
                if(value!.isEmpty){
                  return "Enter the Business Location";
                }
                if (_authData.shopLatitude == null) {
                  return "Enter the Business Location";
                }  
                
                
                return null;
              },
              maxLines: 6,
              decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.contact_mail_outlined),
                  labelText: "Business Location",
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.location_searching_sharp),
                    onPressed: () {
                      _addressTextController.text = "Locating... \n Please wait...";
                      _authData.getCurrentAddress().then((address){
                        if(address != null){
                          setState(() {
                            _addressTextController.text = "${_authData.shopAddress}, ${_authData.shopStreet}, ${_authData.shopSubLocality} ${_authData.shopLocality}";
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Location not determined")
                              )
                          );
                        }
                      });
                    },
                  ),
                  focusColor: Theme.of(context).primaryColor,
                  enabledBorder: const OutlineInputBorder(),
                  errorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                        style: BorderStyle.solid,
                        width: 2,
                        color: Colors.redAccent
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 2,
                          color: Theme.of(context).primaryColor
                      )
                  )
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              onChanged: (value) {
                _descriptionTextController.text = value;
              },
              decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.comment),
                  labelText: "Business Description",
                  contentPadding: EdgeInsets.zero,
                  focusColor: Theme.of(context).primaryColor,
                  enabledBorder: const OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 2,
                          color: Theme.of(context).primaryColor
                      )
                  )
              ),
            ),
          ),
          const SizedBox(height: 20,),
          ElevatedButton(
              onPressed: () {
                if(_authData.isPicAvailable == true){

                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      _isLoading = true;
                    });
                    _authData.registerVendor(email, password).then((credential){

                      if(credential?.user?.uid != null){

                        uploadFile(_authData.image?.path).then((url) {

                          if(url != null){

                            _authData.saveVendorataToDb(
                              url: url,
                              shopName: shopName,
                              storePhoneNumber: storeMobile,
                              ownerName: ownerName,
                              ownerNumber: ownerMobile,
                              description: _descriptionTextController.text
                            ).then((value){
                              setState(() {
                                _formKey.currentState?.reset();
                                _isLoading = false;
                              });
                              Navigator.pushReplacementNamed(context, HomeScreen.id);
                            });


                          } else {
                            scaffoldMessage("Failed to upload Shop Profile Picture");
                          }

                        });

                      } else {
                        scaffoldMessage(_authData.error);
                        Navigator.pushReplacementNamed(context, RegisterScreen.id);
                      }
                    });
                  } else {
                  }
                } else {
                  scaffoldMessage("Please add your shop's profile picture");
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor
              ),
              child: const Text("REGISTER")
          )
        ],
      ),
    );
  }
}
