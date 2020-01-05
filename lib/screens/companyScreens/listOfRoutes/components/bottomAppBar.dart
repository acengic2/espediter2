
import 'package:flutter/material.dart';
import 'package:spediter/screens/companyScreens/listOfRoutes/info.dart';



class BottomAppBar1 extends StatelessWidget {
final NetworkImage image = new NetworkImage(
                            "https://miro.medium.com/max/3150/1*K9eLa_xSyEdjP7Q13Bx9ng.png");

  @override
  Widget build(BuildContext context) {
    return new BottomAppBar(
          child: Container(
            height: 56.0,
            width: 360.0,
            child: new Row(
              children: <Widget>[
                Container(
                  width: 20,
                  height: 20,
                  margin: EdgeInsets.only(left: 16.0),
                  decoration: new BoxDecoration(
                    shape: BoxShape.circle,
                    image: new DecorationImage(
                        fit: BoxFit.fill,
                        image:image,
                    ),
                )),
                Container(
                  margin: EdgeInsets.only(left: 4.0),
                  child: IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Info()),
                      );
                    },
                    icon: Icon(Icons.info_outline),
                  ),
                ),
              ],
            ),
          ),
        );
  }
}