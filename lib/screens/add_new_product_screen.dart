import 'package:flutter/material.dart';

class AddNewProduct extends StatelessWidget {
  static const String id = 'add-new-product-screen';
  const AddNewProduct({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: (){
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.arrow_back_sharp)
          ),
        ),
        body: Column(
          children: [
            Material(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Container(
                        child: Text("Products"),
                      ),
                    ),
                    ElevatedButton.icon(
                        onPressed: () {},
                        icon: Icon(Icons.save, color: Colors.white,),
                        label: Text("Save")
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
