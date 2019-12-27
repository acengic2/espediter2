import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spediter/routes/homePage.dart';

void main() => runApp(ShowLoading());

class ShowLoading extends StatefulWidget {
  String email;
  final FirebaseUser user;

//constructor sending parameters email and user
  ShowLoading({Key key, this.user, this.email}) : super(key: key);

  @override
  _ShowLoading createState() => _ShowLoading(user: user, email: email);
}

class _ShowLoading extends State<ShowLoading> {
  // bool _loadingInProgress;

  String email;
  final FirebaseUser user;

  _ShowLoading({this.user, this.email});

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
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
            'Registracija Korisnika',
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
  }

  // loading screen for 2 seconds
  Future<Timer> loadData() async {
    return new Timer(Duration(seconds: 2), onDoneLoading);
  }

//when loading screen is done redicret to home page
// parameters user and email
  onDoneLoading() async {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => HomePage(user: user, email: email)));
  }
}
