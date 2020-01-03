import 'package:flutter/material.dart';
import 'package:spediter/screens/noInternetConnectionScreen/components/btnVratiteSe.dart';
import 'package:spediter/screens/noInternetConnectionScreen/components/textTryAgain.dart';

void main() => runApp(NoInternetConnectionSrceen());




class NoInternetConnectionSrceen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'No connection screen',
      home: NoInternetConnectionPage2(title: 'No connection screen'),
    );
  }
}

class NoInternetConnectionPage2 extends StatefulWidget {
  NoInternetConnectionPage2({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _NoInternetConnectionPageState createState() =>
      _NoInternetConnectionPageState();
}

class _NoInternetConnectionPageState extends State<NoInternetConnectionPage2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Row(children: <Widget>[TryAgain(),
      BtnVratiteSe(),],) 
    );
  }
}
