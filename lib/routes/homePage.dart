import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:spediter/routes/listOfRoutes.dart';
import 'package:spediter/routes/noRoutes.dart';
import 'package:spediter/usersPages/usersHome.dart';
import 'package:async/async.dart';

void main() => runApp(HomePage());
String userUid;

class HomePage extends StatefulWidget {
  // This widget is the root of your application.
  final FirebaseUser user;
  final String email;
  const HomePage({Key key, this.user, this.email}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
   
  
  @override
  Widget build(BuildContext context) {
    final AsyncMemoizer _memoizer = AsyncMemoizer();

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: 
               Column(
          children: <Widget>[
            FutureBuilder(
              future: checkForRole(),
              builder: (context, snapshot) {
                // ukoliko postoje podaci

                if (snapshot.hasData) {
                  print('IMA');
                  _memoizer.runOnce(() async {
                    await Future.delayed(Duration.zero, () {
                    return Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ListOfRoutes(userID: usID)));
                  });
                  });
                  
                  
                } 
                  return Center(child: ListOfRoutes(userID: usID));
                 
              },
            ),
          ],
        ),
      
    );
  }
}

String usID;
checkForID() async {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseUser user = await _auth.currentUser();

  Firestore.instance
      //goes to collection LoggedUsers on firebase
      .collection('LoggedUsers')
      // takes user.id
      .document(user.uid)
      .snapshots()
      .toString();

  usID = user.uid;
  print(usID);
}

checkForRole() {
  checkForID();
  return Firestore.instance
      .collection('LoggedUsers')
      .where('role', isEqualTo: 'company')
      .limit(1)
      .getDocuments();
}


// checkRole(DocumentSnapshot snapshot, BuildContext context) {
//   checkForID();
//   if (snapshot.data['role'] == "company") {
//     print('doslo dovdje');
//     return Future.delayed(Duration.zero, () {
//       Navigator.of(context).push(
//           MaterialPageRoute(builder: (context) => ListOfRoutes(userID: usID)));
//     });

//     //  return ListOfRoutes(userID: usID);
//   } else if (snapshot.data['role'] == "user") {
//     return Future.delayed(Duration.zero, () {
//       Navigator.of(context)
//           .push(MaterialPageRoute(builder: (context) => NoRoutes()));
//     });
//   } else {}
// }
