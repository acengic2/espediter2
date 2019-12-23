import 'package:flutter/material.dart';

void main() => runApp(NoInternetConnectionLogInSrceen());

const blueColor = Color.fromRGBO(3, 54, 255, 1);
const textColorGray80 = Color.fromRGBO(0, 0, 0, 0.8);
const textColorGray60 = Color.fromRGBO(0, 0, 0, 0.6);

class NoInternetConnectionLogInSrceen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'No connection screen',
      home: NoInternetConnectionPage(title: 'No connection screen'),
    );
  }
}

class NoInternetConnectionPage extends StatefulWidget {
  NoInternetConnectionPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _NoInternetConnectionPageState createState() => _NoInternetConnectionPageState();
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
                  'Nemate mreze',
                      style: TextStyle(
                      fontSize: 16,
                      fontFamily: "Roboto",
                      color: textColorGray80),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8.0, bottom: 16.0),
                  child: Text(
                    "Nazalost nemate mreze. Rijesite problem pa pokusajte ponovno.",
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
                    onPressed: () {},
                    color: blueColor,
                    child: Text(
                      "POKUSAJTE PONOVO",
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
