import 'dart:io';
import 'package:flutter/material.dart';

void main() => runApp(NoInternetConnectionLogInSrceen());

const blueColor = Color.fromRGBO(3, 54, 255, 1);
const textColorGray80 = Color.fromRGBO(0, 0, 0, 0.8);
const textColorGray60 = Color.fromRGBO(0, 0, 0, 0.6);

const String noConnection = "Nazalost nemate mreze. Rijesite problem pa pokusajte ponovno.";

class NoInternetConnectionLogInSrceen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NoInternetConnectionPage(title: 'No connection screen'),
    );
  }
}

class NoInternetConnectionPage extends StatefulWidget {
  NoInternetConnectionPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _NoInternetConnectionPageState createState() =>
      _NoInternetConnectionPageState();
}

class _NoInternetConnectionPageState extends State<NoInternetConnectionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // margin:EdgeInsets.only(top: 257.0) ,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Nemate mreže',
                  style: TextStyle(
                      fontSize: 16,
                      fontFamily: "Roboto",
                      color: textColorGray80),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8.0, bottom: 16.0),
                  child: Text(
                    noConnection,
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
                  child: RaisedButton(
                    onPressed: () async {
                      try {
                        final result =
                            await InternetAddress.lookup('google.com');
                        if (result.isNotEmpty &&
                            result[0].rawAddress.isNotEmpty) {
                          Navigator.pop(this.context, false);
                        }
                      } on SocketException catch (_) {}
                    },
                    color: blueColor,
                    child: Text(
                      "POKUŠAJTE PONOVO",
                      style: TextStyle(
                          fontSize: 14,
                          fontFamily: "Roboto",
                          color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
