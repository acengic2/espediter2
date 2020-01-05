import 'package:flutter/material.dart';
import 'package:spediter/screens/companyScreens/createRoute/createRouteScreen.dart';



class FloatingActionButton1 extends StatelessWidget {
  final String buttonText = "VRATITE SE";
  final String tooltip = "+";
  final Icon icon = Icon(Icons.add);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateRoute()),
          );
        },
        tooltip: tooltip,
        child: icon,
        backgroundColor: blueColor,
      ),
    );
  }
}
