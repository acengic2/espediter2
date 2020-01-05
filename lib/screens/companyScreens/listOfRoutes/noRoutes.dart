import 'package:flutter/material.dart';
import 'package:spediter/screens/companyScreens/listOfRoutes/components/bottomAppBar.dart';
import 'package:spediter/screens/companyScreens/listOfRoutes/components/floatingActionButton.dart';

void main() => runApp(NoRoutes());

const blueColor = Color.fromRGBO(3, 54, 255, 1);
const textColorGray80 = Color.fromRGBO(0, 0, 0, 0.8);
const textColorGray60 = Color.fromRGBO(0, 0, 0, 0.6);

const noRoutesString = "Trenutno nemate nikakvih ruta. Molim vas kreirajte rutu.";

class NoRoutes extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Container(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: <
                    Widget>[
              Text(
                'Nemate ruta',
                style: TextStyle(
                    fontSize: 16, fontFamily: "Roboto", color: textColorGray80),
              ),
              Padding(
                padding: EdgeInsets.only(top: 8.0, bottom: 16.0),
                child: Text(
                 noRoutesString ,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 14,
                      fontFamily: "Roboto",
                      color: textColorGray60),
                ),
              ),
            
            ]),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar1(),
      floatingActionButton: FloatingActionButton1(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}
