import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:pigalukuvendors/screens/login_screen.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';

class ResetPassword extends StatefulWidget {
  static const String id = "reset-password";
  const ResetPassword({Key? key}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final _formKey = GlobalKey<FormState>();
  final _emailTextController = TextEditingController();
  bool _loading = false;





  @override
  Widget build(BuildContext context) {
    final authData = Provider.of<AuthProvider>(context);



    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: (){
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back_sharp)
        ),
      ),
      body: Form(
        key: _formKey,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Reset Your Password",
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                    fontSize: 30.0
                  ),
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
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          style: BorderStyle.solid,
                          width: 2
                        )
                      ),
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
                      hintText: "Enter Your Email",
                      prefixIcon: const Icon(Icons.email_outlined)
                  ),
                ),
                const SizedBox(height: 20,),
                const Text(
                  "An Email will be sent to your email address to allow you to reset the password",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Color.fromRGBO(255, 0, 0, 1.0),
                      fontSize: 15.0
                  ),
                ),
                const SizedBox(height: 20,),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          _loading = true;
                        });
                        authData.resetPassword(_emailTextController.text);
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Email sent successfully, check to reset password")
                            )
                        );
                      }
                      Navigator.pushReplacementNamed(context, LoginScreen.id);
                    },
                    child: _loading ? const CircularProgressIndicator() : const Text(
                      "Reset Password",
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
    );
  }
}
