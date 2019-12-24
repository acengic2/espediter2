import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spediter/auth/noInternetConnection.dart';
import 'package:spediter/routes/createRouteScreen.dart';
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
      
      var  loggedUserID = snapshot.data['user_id'];

      print('Isprintan aksjbfasjbf ID: ' + loggedUserID);

    // getUserIDFromRoutes();
    return adminPage(snapshot);


    return adminPage(snapshot);
  } else if (snapshot.data['role'] == "user") {
    return userPage(snapshot);
  }
}
//if is a user go to list of routes
Center userPage(DocumentSnapshot snapshot) {
  
  return Center(child: ListOfUsersRoutes());
  
}
// if is a admin go to no routes page
Center adminPage(DocumentSnapshot snapshot) {
  return Center(child: NoRoutes());
}



 Future<List<LoggedUsers>> _getEventsFromFirestore() async {
CollectionReference ref = Firestore.instance.collection('Rute');
QuerySnapshot eventsQuery = await ref
    .where("user_id", isEqualTo: userUid)
    .getDocuments();
print(userUid + "SADSADASDASIFHADIGHADIUHGIDUAHGADIHGDIAUGHAIFGDGDAG");
HashMap<String, LoggedUsers> eventsHashMap = new HashMap<String, LoggedUsers>();

eventsQuery.documents.forEach((document) {
  eventsHashMap.putIfAbsent(document['user_id'], () => new LoggedUsers(
      email: document['email'],
      password: document['password'],
      role: document['role'],
      userId: document['user_id']));
});
print(eventsHashMap.values.toList());
print("DSADSADSA");
return eventsHashMap.values.toList();
}

class LoggedUsers {

  static final String columnEmail = "email";
  static final String columnPassword = "password";
  static final String columnRole = "role";
    static final String columnUserId = "user_id";

    LoggedUsers({
       this.email,
       this.password,
      this.role,
      this.userId
    });

    final String email;
  final int password;
  final String role;
  final String userId;


  Map toMap() {
    Map<String, dynamic> map = {
      columnEmail: email,
      columnPassword: password,
      columnRole: role,
      columnUserId: userId,
  
    };

    return map;
  }

  static LoggedUsers fromMap(Map map) {
    return new LoggedUsers(
        email: map[columnEmail],
        password: map[columnPassword],
        role: map[columnRole],
        userId: map[columnUserId],
     );
  }



}

