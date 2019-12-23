import 'dart:collection';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import './createRouteScreen.dart';

void main() => runApp(ListOfRoutes());

const blueColor = Color.fromRGBO(3, 54, 255, 1);
const textColorGray80 = Color.fromRGBO(0, 0, 0, 0.8);
const textColorGray60 = Color.fromRGBO(0, 0, 0, 0.6);

final leftSection = new Container();
final middleSection = new Container();
final rightSection = new Container();

class ListOfRoutes extends StatelessWidget {
  String id;
  ListOfRoutes({this.id});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ListOfRoutesPage(id: id),
    );
  }
}

class ListOfRoutesPage extends StatefulWidget {
  String id;
  ListOfRoutesPage({this.id});

  @override
  State<StatefulWidget> createState() {
    return _ListOfRoutesPageState(id: id);
  }
}

class _ListOfRoutesPageState extends State<ListOfRoutesPage> {
  final db = Firestore.instance;
  String id;
  _ListOfRoutesPageState({this.id});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        body: ListView(children: <Widget>[
          Container(
            child: StreamBuilder<QuerySnapshot>(
              stream: db.collection('Rute').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData ) {
                    return Column(
                      children: snapshot.data.documents
                          .map((doc) => buildItem(doc))
                          .toList(),
                    );
                  
                } else {
                  return SizedBox();
                }
              },
            ),
          ),
        ]),
        bottomNavigationBar: new BottomAppBar(
          child: Container(
            height: 56.0,
            width: 360.0,
            child: new Row(
              children: <Widget>[
                Container(
                  width: 20,
                  height: 20,
                  margin: EdgeInsets.only(left: 16.0),
                  decoration: new BoxDecoration(
                    shape: BoxShape.circle,
                    image: new DecorationImage(
                        fit: BoxFit.fill,
                        image: new NetworkImage(
                            "https://miro.medium.com/max/3150/1*K9eLa_xSyEdjP7Q13Bx9ng.png")),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 4.0),
                  child: IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CreateRoute()),
                      );
                    },
                    icon: Icon(Icons.info_outline),
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: Container(
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreateRoute()),
              );
            },
            tooltip: '+',
            child: Icon(Icons.add),
            backgroundColor: blueColor,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      ),
    );
  }

  Card buildItem(DocumentSnapshot doc) {
    // dummy.toString().replaceFirst("[", "").replaceFirst("]", "");


    String date = doc.data['departure_date'];
    String dateReversed = date.split('/').reversed.join();
    String departureDate =
        DateFormat("d MMM").format(DateTime.parse(dateReversed));

    final leftSection = new Container(
        height: 32,
        width: 62,
        margin: EdgeInsets.only(top: 8, bottom: 16),
        decoration: new BoxDecoration(
          shape: BoxShape.rectangle,
          color: blueColor,
          borderRadius: BorderRadius.all(Radius.circular(1.0)),
        ),
        child: Padding(
          padding: EdgeInsets.only(left: 8.0, top: 6.0, right: 8.0),
          child: new RichText(
            text: new TextSpan(
              children: <TextSpan>[
                new TextSpan(
                    text: departureDate,
                    style: new TextStyle(
                      fontSize: 14.0,
                      color: Colors.white,
                      fontFamily: "RobotoMono",
                    )),
              ],
            ),
          ),
        ));

    final middleSection = new Container(
        height: 32,
        width: 110,
        margin: EdgeInsets.only(left: 4.0, right: 4.0, top: 8, bottom: 16),
        decoration: new BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(1.0)),
          border: new Border.all(
            color: Colors.black.withOpacity(0.12),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new RichText(
              text: new TextSpan(
                children: <TextSpan>[
                  new TextSpan(
                      text: 'Kapacitet: ',
                      style: new TextStyle(
                        fontSize: 14.0,
                        color: Colors.black.withOpacity(0.8),
                        fontFamily: "Roboto",
                      )),
                  new TextSpan(
                    text: ('${doc.data['capacity']} t'),
                    style: new TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0,
                      color: Colors.black.withOpacity(0.8),
                      fontFamily: "Roboto",
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));

    String availability = doc.data['availability'];

    final rightSection = new Container(
      // width: 140,
      // height: 32,
      margin: EdgeInsets.only(top: 8, bottom: 16, left: 0.0, right: 0.0),
      decoration: BoxDecoration(
          border: Border.all(width: 1.0, color: Colors.black.withOpacity(0.12)),
          borderRadius: BorderRadius.all(Radius.circular(1.0))),
      child: new Padding(
        padding: EdgeInsets.only(left: 0.0, right: 0.0),
        child: new LinearPercentIndicator(
          width: 150.0,
          lineHeight: 30.0,
          percent: (double.parse(availability)) / 100,
          center: RichText(
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(
                    text: 'Popunjenost: ',
                    style: TextStyle(
                        fontFamily: 'RobotoMono',
                        fontSize: 14,
                        color: Colors.black.withOpacity(0.8))),
                TextSpan(
                  text: ('${doc.data['availability']} %'),
                  style: TextStyle(
                      fontFamily: 'RobotoMono',
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.black.withOpacity(0.8)),
                ),
              ],
            ),
          ),
          linearStrokeCap: LinearStrokeCap.butt,
          backgroundColor: Colors.white,
          progressColor: Color.fromRGBO(3, 54, 255, 0.12),
        ),
      ),
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new RichText(
              text: new TextSpan(
                children: <TextSpan>[
                  new TextSpan(
                      text: '${doc.data['starting_destination']}',
                      style: new TextStyle(
                        fontSize: 20.0,
                        color: Colors.black.withOpacity(0.8),
                        fontWeight: FontWeight.bold,
                        fontFamily: "Roboto",
                      )),
                  new TextSpan(
                      text: ('${doc.data['interdestination']}'),
                      style: new TextStyle(
                        fontSize: 20.0,
                        color: Colors.black.withOpacity(0.8),
                        fontFamily: "Roboto",
                      )),
                  new TextSpan(
                    text: (', ${doc.data['ending_destination']}'),
                    style: new TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                      color: Colors.black.withOpacity(0.8),
                      fontFamily: "Roboto",
                    ),
                  ),
                ],
              ),
            ),

            // Text(
            //   '${doc.data['starting_destination']}${doc.data['interdestination']}, ${doc.data['ending_destination']} ',
            //   style: TextStyle(fontSize: 20),
            // ),
            Row(
              children: <Widget>[leftSection, middleSection, rightSection],
            )
          ],
        ),
      ),
    );
  }

  Future<bool> _onBackPressed() {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Do you want to logout the app?"),
              actions: <Widget>[
                FlatButton(
                  child: Text("No"),
                  onPressed: () => Navigator.pop(context, false),
                ),
                FlatButton(
                  onPressed: () => exit(0),
                  /*Navigator.of(context).pop(true)*/
                  child: Text('Yes'),
                ),
              ],
            ));
  }

  getAllValues() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final FirebaseUser user = await _auth.currentUser();

    Firestore.instance.collection('Rute').document(user.uid).snapshots();
    String idd = 'zWD6EOOFv28b7y5KHGzP';
    DocumentSnapshot snapshot = await db.collection('Rute').document(id).get();
    print('KONJ');
    print(snapshot.data['user_id']);

    CollectionReference ref = Firestore.instance.collection('Ruta');
    QuerySnapshot eventsQuery = await ref
    .where('user_id', isEqualTo: id)
    .getDocuments();
HashMap<String, LoggedUsers > eventsHashMap = new HashMap<String, LoggedUsers>();

eventsQuery.documents.forEach((document) {
 eventsHashMap.putIfAbsent(document['user_id'], () => new LoggedUsers(
      email: document['email'],
      password: document['password'],
      role: document['role'],
      userId: document['user_id']));


});
print( eventsHashMap.values.toList());
return eventsHashMap.values.toList();
  }

  //  static Future<List<AustinFeedsMeEvent>> _getEventsFromFirestore() async {


// HashMap<String, AustinFeedsMeEvent> eventsHashMap = new HashMap<String, AustinFeedsMeEvent>();

// eventsQuery.documents.forEach((document) {
//   eventsHashMap.putIfAbsent(document['id'], () => new AustinFeedsMeEvent(
//       name: document['name'],
//       time: document['time'],
//       description: document['description'],
//       url: document['event_url'],
//       photoUrl: _getEventPhotoUrl(document['group']),
//       latLng: _getLatLng(document)));
// });

// return eventsHashMap.values.toList();
// }
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
  }}