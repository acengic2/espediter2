import 'dart:async';
import 'package:flutter/material.dart';
import 'package:spediter/screens/loadingScreens/components/loadingComponent.dart';
import 'package:spediter/screens/routes/listOfRoutes.dart';


void main() => runApp(ShowLoadingRoutes());

class ShowLoadingRoutes extends StatefulWidget {
  final String userID;

//constructor sending parameters email and user
  ShowLoadingRoutes({Key key, this.userID}) : super(key: key);

  @override
  _ShowLoadingRoutes createState() => _ShowLoadingRoutes(userID: userID);
}

class _ShowLoadingRoutes extends State<ShowLoadingRoutes> {
//  bool _loadingInProgress;

  String userID;
// final FirebaseUser user;
   String firstMessage = "Ruta se kreira";
   String secondMessage = "Molim vas sačekajte trenutak.";
  _ShowLoadingRoutes({this.userID});

  @override
  void initState() {
    super.initState();
    //_loadingInProgress = true;
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    //if (_loadingInProgress) {
    return Scaffold(body: LoadingComponent(firstMessage, secondMessage));
  }

  // loading screen for 2 seconds
  Future<Timer> loadData() async {
    return new Timer(Duration(seconds: 3), onDoneLoading);
  }

//when loading screen is done redicret to home page
// parameters user and email
  onDoneLoading() async {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => ListOfRoutes(userID: userID)));
  }
}
