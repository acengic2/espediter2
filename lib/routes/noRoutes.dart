import 'dart:io';

import 'package:flutter/material.dart';
import '../auth/noInternetOnLogin.dart';
import './createRouteScreen.dart';

void main() => runApp(NoRoutes());

const blueColor = Color.fromRGBO(3, 54, 255, 1);
const textColorGray80 = Color.fromRGBO(0, 0, 0, 0.8);
const textColorGray60 = Color.fromRGBO(0, 0, 0, 0.6);

class NoRoutes extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ruta|Prazno',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: NoRoutesScreenPage(title: 'Rute|Prazno'),
    );
  }
}

class NoRoutesScreenPage extends StatefulWidget {
  NoRoutesScreenPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _NoRoutesScreenPageState createState() => _NoRoutesScreenPageState();
}

class _NoRoutesScreenPageState extends State<NoRoutesScreenPage> {
  Future<bool> _onBackPressed() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text("Do you want to logout the app?"),
            actions: <Widget>[
              FlatButton(
                child: Text("No"),
                onPressed: () => Navigator.pop(context, false),
              ),
              // FlatButton(
              // onPressed: () => exit(0),
              // /*Navigator.of(context).pop(true)*/
              // child: Text('Yes'),
              // ),
            ],
          ));

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Container(
          // margin:EdgeInsets.only(top: 257.0) ,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Nemate ruta',
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: "Roboto",
                        color: textColorGray80),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8.0, bottom: 16.0),
                    child: Text(
                      "Trenutno nemate nikakvih ruta. Molim vas kreirajte rutu.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 14,
                          fontFamily: "Roboto",
                          color: textColorGray60),
                    ),
                  ),
                  ButtonTheme(
                    minWidth: 154.0,
                    height: 36.0,
                    child: RaisedButton.icon(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  CreateRoute()));
                        // try {
                        //   final result =
                        //       await InternetAddress.lookup('google.com');
                        //   if (result.isNotEmpty &&
                        //       result[0].rawAddress.isNotEmpty) {
                        //     print('connected');
                        //     Navigator.push(
                        //       context,
                        //       MaterialPageRoute(
                        //           builder: (context) => CreateRoute()),
                        //     );
                        //   }
                        // } on SocketException catch (_) {
                        //   print('not connected');
                        //   Navigator.of(context).push(MaterialPageRoute(
                        //       builder: (context) =>
                        //           NoInternetConnectionLogInSrceen()));
                        // }
                      },
                      icon: Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                      label: Text(
                        "KREIRAJ RUTU",
                        style: TextStyle(
                            fontSize: 14,
                            fontFamily: "Roboto",
                            color: Colors.white),
                      ),
                      color: blueColor,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: new BottomAppBar(
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
                        image: new NetworkImage(
                            "https://miro.medium.com/max/3150/1*K9eLa_xSyEdjP7Q13Bx9ng.png")),
                  ),
                  //child: new Tab(icon: new Image.asset("assets/img/logo.png"),
                ),
                Container(
                  margin: EdgeInsets.only(left: 4.0),
                  child: IconButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  CreateRoute()));
                      // try {
                      //   final result =
                      //       await InternetAddress.lookup('google.com');
                      //   if (result.isNotEmpty &&
                      //       result[0].rawAddress.isNotEmpty) {
                      //     print('connected');
                      //     Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //           builder: (context) => CreateRoute()),
                      //     );
                      //   }
                      // } on SocketException catch (_) {
                      //   print('not connected');
                      //   Navigator.of(context).push(MaterialPageRoute(
                      //       builder: (context) =>
                      //           NoInternetConnectionLogInSrceen()));
                      // }
                    },
                    icon: Icon(Icons.info_outline),
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: Container(
          child: FloatingActionButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  CreateRoute()));
              // try {
              //   final result = await InternetAddress.lookup('google.com');
              //   if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
              //     print('connected');
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(builder: (context) => CreateRoute()),
              //     );
              //   }
              // } on SocketException catch (_) {
              //   print('not connected');
              //   Navigator.of(context).push(MaterialPageRoute(
              //       builder: (context) => NoInternetConnectionLogInSrceen()));
              // }
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => CreateRoute()),
              // );
            },
            tooltip: '+',
            child: Icon(Icons.add),
            backgroundColor: blueColor,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      ),
    );
  }
}
