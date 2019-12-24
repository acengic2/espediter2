import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spediter/routes/homePage.dart';

import 'listOfRoutes.dart';


void main() => runApp(ShowLoadingRoutes());

class ShowLoadingRoutes extends StatefulWidget {

//String email;
//final FirebaseUser user;

//constructor sending parameters email and user 
 // ShowLoadingRoutes({Key key, this.user, this.email}) : super(key: key);

  

  @override
  _ShowLoadingRoutes createState() => _ShowLoadingRoutes();
}

class _ShowLoadingRoutes extends State<ShowLoadingRoutes> {
 // bool _loadingInProgress;

// String email;
// final FirebaseUser user;


  _ShowLoadingRoutes();

  @override
  void initState() {
    super.initState();
   // _loadingInProgress = true;
    loadData();
  }

  @override
  Widget build(BuildContext context) {
   // if (_loadingInProgress) {
      return Scaffold(
          body: Center(
              child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: 22),
            child: CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(
                  Color.fromRGBO(3, 54, 255, 1.0)),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 16.0),
            child: Text(
              'Ruta se kreira',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'RobotoMono',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Container(
            child: Text(
              'Molimo vas sačekajte trenutak.',
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'RobotoMono',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          
        ],
      )));
    // } else {

    //   Navigator.of(context)
    //         .push(MaterialPageRoute(builder: (context) => NoRoutesScreenPage()));
    // }
  }
  // loading screen for 2 seconds 
  Future<Timer> loadData() async {
  return new Timer(Duration(seconds: 2), onDoneLoading);
}
//when loading screen is done redicret to home page 
// parameters user and email
onDoneLoading() async {
  Navigator.of(context).push(MaterialPageRoute(builder: (context) => ListOfRoutes()));
}

}
