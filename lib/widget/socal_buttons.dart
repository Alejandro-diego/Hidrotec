import 'package:flutter/material.dart';


class SocalButtns extends StatelessWidget {
   SocalButtns({
    Key? key, required this.onPressed
  }) : super(key: key);

  dynamic onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
            iconSize: 100,
            color: Colors.orange,
            onPressed: onPressed,
            icon: Image.asset("lib/image/google_button.png")),
      ],
    );
  }
}
