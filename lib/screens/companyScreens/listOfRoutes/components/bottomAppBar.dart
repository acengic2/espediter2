import 'package:flutter/material.dart';
import 'package:spediter/screens/companyScreens/companyInfo.dart';
import 'package:spediter/screens/companyScreens/listOfRoutes/info.dart';


class BottomAppBar1 extends StatelessWidget {
 
  final String userID;
  BottomAppBar1({this.userID});

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
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CompanyInfo(userID: userID)));
              },
              child: Container(
                  width: 30,
                  height: 30,
                  margin: EdgeInsets.only(left: 16.0),
                  decoration: new BoxDecoration(
                    shape: BoxShape.circle,
                    image: new DecorationImage(
                      fit: BoxFit.fill,
                      image: image,
                    ),
                  )),
            ),
            Container(
              margin: EdgeInsets.only(left: 4.0, bottom: 0),
              child: IconButton(
                iconSize: 35,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Info(userID: userID)),
                  );
                },
                icon: Icon(
                    
                  Icons.info_outline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
