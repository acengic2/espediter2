import 'package:flutter/material.dart';

class Logo extends StatelessWidget {

  final String imagePath = 'assets/img/Logo.png';
  final String logoText = "e-Špediter";
  
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image.asset(imagePath),
        Container(
          margin: EdgeInsets.only(left: 16.0),
          child: Text(logoText,
              style: TextStyle(
                fontSize: 20,
                fontFamily: 'RobotoMono',
                fontWeight: FontWeight.w500,
              )),
        ),
      ],
    );
  }
}
