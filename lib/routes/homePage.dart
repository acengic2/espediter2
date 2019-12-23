import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spediter/auth/noInternetConnection.dart';
import 'package:spediter/routes/noRoutes.dart';

import 'package:spediter/usersPages/usersHome.dart';

void main() => runApp(HomePage());
String userUid;

class HomePage extends StatelessWidget {
  // This widget is the root of your application.
  final FirebaseUser user;
  final String email;

  const HomePage({Key key, this.user, this.email}) : super(key: key);

  @override
  Widget build(BuildContext context) {

  //   void inputData() async {
  //   final FirebaseUser user = await auth.currentUser();
  //   final uid = user.uid
  //   // here you write the codes to input the data into firestore
  // }   



    userUid = Firestore.instance
        .collection('LoggedUsers') //goes to collection LoggedUsers on firebase
        .document(user.uid) // takes user.id
        .snapshots()
        .toString();
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: StreamBuilder<DocumentSnapshot>(
          stream: Firestore.instance
              .collection('LoggedUsers') //goes to collection LoggedUsers on firebase
              .document(user.uid) // takes user.id
              .snapshots(),
          builder:
              (BuildContext contex, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text(
                  'Error: ${snapshot.error}'); //error if there is no snapshot
            }
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                return Text("Loading..."); // if you have to wait for connection
              default:
                return checkRole(snapshot.data);
            }
          }),
    );
  }
}

// method for checking a role
Center checkRole(DocumentSnapshot snapshot) {

  
  print(
      "sadsadadadsdasdshfdhgfjglkte54352saasdsad3532543654767987098098-dasd  ====    " +
          userUid.toString());
  if (snapshot.data['role'] == "company") {
    return adminPage(snapshot);

  } else if (snapshot.data['role'] == "user") {
    return userPage(snapshot);
  }

  // if (snapshot.data['role'] == "klient") {

  //   if(snapshot.data['user.uid'] == snapshot.data['user_id']){

  //     return userPage(snapshot);
  //   }
  //   else if(snapshot.data['user_id'] == "2")
  //   {
  //     return adminPage(snapshot);
  //   }
  // } else {
  //   return userPage(snapshot);
  // }
}

//if is a user go to list of routes
Center userPage(DocumentSnapshot snapshot) {
  return Center(child: ListOfUsersRoutes());
}

// if is a admin go to no routes page
Center adminPage(DocumentSnapshot snapshot) {
  return Center(child: NoRoutes());
}
