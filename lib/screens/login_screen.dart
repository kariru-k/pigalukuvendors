import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:pigalukuvendors/providers/auth_provider.dart';
import 'package:pigalukuvendors/screens/home_screen.dart';
import 'package:pigalukuvendors/screens/reset_password_screen.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  static const String id = "login-screen";

  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  Icon? icon;
  bool _visible = false;
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  bool _loading = false;


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

    return SafeArea(
      child: Scaffold(
        body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(40.0),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text(
                        "LOGIN",
                        style: TextStyle(
                          fontFamily: "Anton",
                          fontSize: 50
                        ),
                      ),
                      const SizedBox(width: 20,),
                      Image.asset(
                          "images/pigaluku_logo.png",
                        height: 80,
                        width: 100,
                      )
                    ],
                  ),
                  const SizedBox(height: 20,),
                  TextFormField(
                    controller: _emailTextController,
                    validator: (value){
                      if(value!.isEmpty){
                        return "Enter Email";
                      }
                      final bool isValid = EmailValidator.validate(_emailTextController.text);
                      if(!isValid){
                        return "This Email is invalid";
                      }
                      setState(() {
                        _emailTextController.text = value;
                      });
                      return null;
                    },
                    decoration: InputDecoration(
                        enabledBorder: const OutlineInputBorder(),
                        errorBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                              style: BorderStyle.solid,
                              width: 2,
                              color: Colors.redAccent
                          ),
                        ),
                        focusColor: Theme.of(context).primaryColor,
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: BorderSide(
                                style: BorderStyle.solid,
                                width: 2,
                                color: Theme.of(context).primaryColor
                            )
                        ),
                        contentPadding: EdgeInsets.zero,
                        hintText: "Email",
                        prefixIcon: const Icon(Icons.email_outlined)
                    ),
                  ),
                  const SizedBox(height: 20,),
                  TextFormField(
                    controller: _passwordTextController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter Password";
                      }
                      if (value.length < 6) {
                        return "Your password is too short. Min 6 characters";
                      }
                      setState(() {
                        _passwordTextController.text = value;
                      });
                      return null;
                      },
                    obscureText: _visible == false ? true : false,
                    decoration: InputDecoration(
                        enabledBorder: const OutlineInputBorder(),
                        focusColor: Theme.of(context).primaryColor,
                        errorBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                              style: BorderStyle.solid,
                              width: 2,
                              color: Colors.redAccent
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: BorderSide(
                                style: BorderStyle.solid,
                                width: 2,
                                color: Theme.of(context).primaryColor
                            )
                        ),
                      contentPadding: EdgeInsets.zero,
                      hintText: "Password",
                      prefixIcon: const Icon(Icons.vpn_key_outlined),
                      suffixIcon: IconButton(
                        icon: _visible ? const Icon(Icons.visibility) : const Icon(Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            _visible = !_visible;
                          });
                        },
                      )
                    ),
                  ),
                  const SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: TextButton(
                            onPressed: () {
                              Navigator.pushReplacementNamed(context, ResetPassword.id);
                            },
                            child: const Text(
                              "Forgot Password?",
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue
                              ),
                            )
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20,),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor
                      ),
                      onPressed: () {
                        if(_formKey.currentState!.validate()){
                          setState(() {
                            _loading = true;
                          });
                          _authData.loginVendor(_emailTextController.text, _passwordTextController.text).then((credential){
                            if(credential != null){
                              setState(() {
                                _loading = false;
                              });
                              Navigator.pushReplacementNamed(context, HomeScreen.id);
                            } else {
                              setState(() {
                                _loading = false;
                              });
                              scaffoldMessage(_authData.error);
                            }
                          });
                        } else {
                          scaffoldMessage("Error brother");
                        }
                      },
                      child: _loading ?  const LinearProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                        backgroundColor: Colors.transparent,
                      ): const Text(
                        "LOG IN",
                        style: TextStyle(
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
