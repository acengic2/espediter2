import 'dart:async';
import 'package:flutter/material.dart';
import 'listOfRoutesref.dart';

void main() => runApp(ShowLoadingRoutes());

class ShowLoadingRoutes extends StatefulWidget {
  String userID;
  String id;


//constructor sending parameters email and user
  ShowLoadingRoutes({Key key, this.userID, this.id}) : super(key: key);

  @override
  _ShowLoadingRoutes createState() => _ShowLoadingRoutes(userID: userID, id: id);
}

class _ShowLoadingRoutes extends State<ShowLoadingRoutes> {
//  bool _loadingInProgress;

  String userID;
  String id;
// final FirebaseUser user;

  _ShowLoadingRoutes({this.userID, this.id});

  @override
  void initState() {
    super.initState();
    //_loadingInProgress = true;
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    //if (_loadingInProgress) {
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
  }

  // loading screen for 2 seconds
  Future<Timer> loadData() async {
    return new Timer(Duration(seconds: 3), onDoneLoading);
  }

//when loading screen is done redicret to home page
// parameters user and email
  onDoneLoading() async {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => ListOfRoutesRef()));
  }
}
