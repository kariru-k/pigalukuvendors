import 'package:flutter/material.dart';

class SliderMenuItem extends StatelessWidget {
  final String title;
  final IconData iconData;
  final Function(String)? onTap;

  const SliderMenuItem(
      {Key? key,
        required this.title,
        required this.iconData,
        required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap?.call(title);
      },
      child: Container(
        decoration: const BoxDecoration(
          border: Border(
            // ignore: prefer_const_constructors
            bottom: BorderSide(
              color: Colors.grey
            )
          )
        ),
        child: SizedBox(
          height: 50,
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Row(
              children: [
                Icon(iconData, color: Colors.black54, size: 18,),
                const SizedBox(width: 10,),
                Text(title, style: const TextStyle(color: Colors.black54, fontSize: 16),)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
