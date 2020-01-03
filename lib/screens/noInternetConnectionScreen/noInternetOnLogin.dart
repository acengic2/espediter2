import 'dart:io';
import 'package:flutter/material.dart';
import 'package:spediter/screens/noInternetConnectionScreen/components/textTryAgain.dart';

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
  
      body: TryAgain(),
    
    );
  }
}
