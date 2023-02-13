import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:pigalukuvendors/providers/auth_provider.dart';
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




  @override
  Widget build(BuildContext context) {
    final _authData = Provider.of<AuthProvider>(context);

    return Form(
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
                return null;
              },
              maxLength: 12,
              decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.phone),
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
                return null;
              },
              maxLength: 12,
              decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.phone_android_sharp),
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
                            _addressTextController.text = "${_authData.shopAddress}, ${_authData.shopStreet}, ${_authData.shopLocality}";
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
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("Processing Data")
                        )
                    );
                  } else {
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Kindly add a Profile Picture")
                      )
                  );
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
