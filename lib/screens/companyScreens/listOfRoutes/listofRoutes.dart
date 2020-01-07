import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spediter/screens/companyScreens/listOfRoutes/components/bottomAppBar.dart';
import 'package:spediter/screens/companyScreens/listOfRoutes/components/divider.dart';
import 'package:spediter/screens/companyScreens/listOfRoutes/components/floatingActionButton.dart';
import 'package:spediter/screens/companyScreens/listOfRoutes/listOfFinishedRoutes.dart';
import 'package:spediter/screens/companyScreens/listOfRoutes/listOfRoutesref.dart';

class ListOfRoutes extends StatefulWidget {
  final String userID;
  ListOfRoutes({Key key, this.userID}) : super(key: key);

  @override
  _ListOfRoutesState createState() => _ListOfRoutesState(userID: userID);
}

getUserid() async {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseUser user = await _auth.currentUser();

//   Firestore.instance
//       .collection('LoggedUsers')
//       .document(user.uid)
//       .snapshots()
//       .toString();
//   userID = user.uid;
}

class _ListOfRoutesState extends State<ListOfRoutes> {
  String userID;
  String userIDF;

  _ListOfRoutesState({this.userID});

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // double defaultScreenWidth = 400.0;
    //   double defaultScreenHeight = 810.0;
    //   ScreenUtil.instance = ScreenUtil(
    //     width: defaultScreenWidth,
    //     height: defaultScreenHeight,
    //     allowFontScaling: true,
    //   )..init(context);

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: CustomScrollView(
            slivers: <Widget>[
              SliverList(
                delegate: SliverChildListDelegate([
                  Column(
                    children: <Widget>[
                      ListOfRoutesRef(userID: userID),
                      Divider1(),
                      ListOfFinishedRoutes(userID: userID),
                    ],
                  )
                ]),
              ),
            ],
          ),
          bottomNavigationBar: BottomAppBar1(userID: userID),
          floatingActionButton: FloatingActionButton1(),
          floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        ));
  }
}
