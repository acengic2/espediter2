import 'dart:core';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/rendering.dart';
import 'package:spediter/screens/companyScreens/listOfRoutes/companyRoutes.dart';
import 'package:spediter/screens/companyScreens/listOfRoutes/listofRoutes.dart';
import 'package:spediter/screens/companyScreens/listOfRoutes/noRoutes.dart';
import 'listOfRoutesRef.dart';

void main() => runApp(Info());

/// varijable
///
/// varijable u kojoj smo spremili boje
/// plava
/// crna sa 80% opacity
/// crna sa 60^ opacity
const blueColor = Color.fromRGBO(3, 54, 255, 1);
const textColorGray80 = Color.fromRGBO(0, 0, 0, 0.8);
const textColorGray60 = Color.fromRGBO(0, 0, 0, 0.6);

// instanca na NoRoutes screen
NoRoutes noRoutes = new NoRoutes();

class Info extends StatelessWidget {
  final String userID;
  Info({this.userID});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kreiraj Rutu',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      localizationsDelegates: [
        // ... lokalizacija jezika
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('bs'), // Bosnian
        const Locale('en'), // English
      ],
      home: InfoPage(userID: userID),
    );
  }
}

class InfoPage extends StatefulWidget {
  final String userID;
  InfoPage({this.userID});


  @override
  _InfoPageState createState() => _InfoPageState(userID: userID);
}

class _InfoPageState extends State<InfoPage> {
  final String userID;

  _InfoPageState({this.userID});

  /// instanca za bazu
  final db = Firestore.instance;

  int onceToast = 0, onceBtnPressed = 0;

  String userUid;

  String id;

  bool imaliRuta = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          /// u appBaru kreiramo X iconicu na osnovu koje izlazimo iz [CreateRoutes] i idemo na [ListOfRoutes]
          backgroundColor: Colors.white,
          leading: IconButton(
            color: Colors.black,
            icon: Icon(Icons.clear),
            onPressed: () {
               /// provjera da li company ima ili nema ruta na osnovu koje im pokazujemo screen
            CompanyRutes().getCompanyRoutes(userID).then((QuerySnapshot docs) {
              if (docs.documents.isNotEmpty) {
                print('NOT EMPRY');
                imaliRuta = true;
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ListOfRoutes(userID: userID,)),
                );
              } else {
                print('EMPTU');
                imaliRuta = false;
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => NoRoutes()));
              }
            });
            },
          ),
          title: const Text('Info',
              style: TextStyle(color: Color.fromRGBO(0, 0, 0, 0.8))),
        ),
        body:
          
            /// GestureDetector na osnovu kojeg zavaramo tastaturu na klik izvan njenog prostora
            Builder(
                builder: (context) => new GestureDetector(
                      onTap: () {
                        FocusScope.of(context).requestFocus(new FocusNode());
                        onceToast = 0;
                      },
                      child: ListView(
                        children: <Widget>[
                          Container(
                              margin: EdgeInsets.only(top: 22),
                              height: 150,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    height: 21,
                                    margin:
                                        EdgeInsets.only(left: 16.0, bottom: 8),
                                    child: Text(
                                      'Šta je e-Špediter?',
                                      style: TextStyle(
                                          color: Color.fromRGBO(0, 0, 0, 0.8),
                                          fontFamily: 'Roboto',
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                  Container(
                                    height: 104,
                                    margin: EdgeInsets.only(
                                        left: 16, right: 16, bottom: 16),
                                    child: Text(
                                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.' +
                                          ' Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
                                      style: TextStyle(
                                          color: Color.fromRGBO(0, 0, 0, 0.6),
                                          fontFamily: 'Roboto',
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                ],
                              )),
                          Container(
                            margin: EdgeInsets.only(bottom: 14),
                            height: 1,
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: Color.fromRGBO(0, 0, 0, 0.12),
                                        width: 1))),
                          ),
                          Container(
                              height: 106,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    height: 21,
                                    margin:
                                        EdgeInsets.only(left: 16.0, bottom: 8),
                                    child: Text(
                                      'Kako koristiti aplikaciju?',
                                      style: TextStyle(
                                          color: Color.fromRGBO(0, 0, 0, 0.8),
                                          fontFamily: 'Roboto',
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                  Container(
                                    height: 60,
                                    margin: EdgeInsets.only(
                                        left: 16, right: 16, bottom: 16),
                                    child: Text(
                                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
                                      style: TextStyle(
                                          color: Color.fromRGBO(0, 0, 0, 0.6),
                                          fontFamily: 'Roboto',
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                ],
                              )),
                          Container(
                            margin: EdgeInsets.only(bottom: 14),
                            height: 1,
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: Color.fromRGBO(0, 0, 0, 0.12),
                                        width: 1))),
                          ),
                          Container(
                              height: 150,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    height: 21,
                                    margin:
                                        EdgeInsets.only(left: 16.0, bottom: 8),
                                    child: Text(
                                      'Ko su naši partneri?',
                                      style: TextStyle(
                                          color: Color.fromRGBO(0, 0, 0, 0.8),
                                          fontFamily: 'Roboto',
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                  Container(
                                    height: 104,
                                    margin: EdgeInsets.only(
                                        left: 16, right: 16, bottom: 16),
                                    child: Text(
                                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. ' +
                                          'Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. ',
                                      style: TextStyle(
                                          color: Color.fromRGBO(0, 0, 0, 0.6),
                                          fontFamily: 'Roboto',
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                ],
                              )),
                          Container(
                            margin: EdgeInsets.only(bottom: 56),
                            height: 1,
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: Color.fromRGBO(0, 0, 0, 0.12),
                                        width: 1))),
                          ),
                        ],
                      ),
                    )));
  }
}

