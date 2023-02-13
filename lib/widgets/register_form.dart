import 'package:flutter/material.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({Key? key}) : super(key: key);

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(3.0),
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
          )
        ],
      ),
    );
  }
}
