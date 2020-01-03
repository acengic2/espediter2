import 'package:flutter/material.dart';

const blueColor = Color.fromRGBO(3, 54, 255, 1);
const textColorGray80 = Color.fromRGBO(0, 0, 0, 0.8);
const textColorGray60 = Color.fromRGBO(0, 0, 0, 0.6);

class BtnVratiteSe extends StatelessWidget {
  final String buttonText = "VRATITE SE";

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: () {},
      color: Colors.white,
      child: Text(
        buttonText,
        style:
            TextStyle(fontSize: 14, fontFamily: "Roboto", color: Colors.black),
      ),
    );
  }
}
