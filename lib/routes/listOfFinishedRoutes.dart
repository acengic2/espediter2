import 'package:firebase_auth/firebase_auth.dart';
import './editRoutes.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:spediter/routes/companyRoutes.dart';
import './createRouteScreen.dart';
import './companyRoutes.dart';
import 'createRouteScreen.dart';

void main() => runApp(ListOfRoutesRef());

String userID;
String capacityString;

/// varijable
///
/// varijable u kojoj smo spremili boje
/// plava
/// crna sa 80% opacity
/// crna sa 60^ opacity
const greyColor = Color.fromRGBO(219, 219, 219, 1);
const textColorGray80 = Color.fromRGBO(0, 0, 0, 0.8);
const textColorGray60 = Color.fromRGBO(0, 0, 0, 0.6);

/// desni,lijevi,srednji kontejner za prikaz informacija o aktivnim rutama
final leftSection = new Container();
final middleSection = new Container();
final rightSection = new Container();

class ListOfRoutesRef extends StatefulWidget {
  @override
  _ListOfRoutesRefState createState() => _ListOfRoutesRefState();
}

getUserid() async {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseUser user = await _auth.currentUser();

  Firestore.instance
      .collection('LoggedUsers')
      .document(user.uid)
      .snapshots()
      .toString();
  userID = user.uid;
}

class _ListOfRoutesRefState extends State<ListOfRoutesRef> {
  @override
  void initState() {
    super.initState();
  }

  Future getPosts(String id) async {
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore
        .collection('FinishedRoutes')
        .where('user_id', isEqualTo: id)
        .orderBy('timestamp', descending: false)
        .getDocuments();
    return qn.documents;
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
        resizeToAvoidBottomPadding: false,
        body: Center(
          child: Container(
            child: FutureBuilder(
              future: getPosts(userID),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      /// DATUM
                      String date = snapshot.data[index].data['arrival_date'];
                      String dateReversed = date.split('/').reversed.join();
                      String arrivalDate = DateFormat("d MMM")
                          .format(DateTime.parse(dateReversed));


                      final leftSection = new Container(
                         
                           height: 32,
                          width: 110,
                          margin: EdgeInsets.only(top: 8, bottom: 16),
                          decoration: new BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: greyColor,
                            borderRadius:
                                BorderRadius.all(Radius.circular(1.0)),
                          ),
                          child: Center(
                              child: Padding(
                            padding: EdgeInsets.only(left: 8.0, right: 8.0),
                            child: new RichText(
                              text: new TextSpan(
                                children: <TextSpan>[
                                  new TextSpan(
                                      text: 'Završena ruta',
                                      style: new TextStyle(
                                        // fontSize:
                                        //     ScreenUtil.instance.setSp(13.0),
                                        color: Colors.black,
                                        fontFamily: "Roboto",
                                      )),
                                ],
                              ),
                            ),
                          )));

                      ///middle section u koji spremamo kapacitet
                      final middleSection = new Container(
                          height: 32,
                          width: 62,
                          margin: EdgeInsets.only(
                              left: 4.0, right: 4.0, top: 8, bottom: 16),
                          decoration: new BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: greyColor,
                            borderRadius:
                                BorderRadius.all(Radius.circular(1.0)),
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
                                      text: arrivalDate,
                                      style: new TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14.0,
                                        color: Colors.black.withOpacity(1.0),
                                        fontFamily: "Roboto",
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ));

                     

                      return GestureDetector(
                        onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) =>
                                    EditRoute(post: snapshot.data[index]))),
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                new RichText(
                                  text: new TextSpan(
                                    children: <TextSpan>[
                                      new TextSpan(
                                          text:
                                              '${snapshot.data[index].data['starting_destination']}, ',
                                          style: new TextStyle(
                                            fontSize: 20.0,
                                            color:
                                                Colors.black.withOpacity(0.8),
                                            fontWeight: FontWeight.bold,
                                            fontFamily: "Roboto",
                                          )),
                                      new TextSpan(
                                          style: new TextStyle(
                                        fontSize: 20.0,
                                        color: Colors.black.withOpacity(0.6),
                                        fontFamily: "Roboto",
                                      )),
                                      new TextSpan(
                                          text:
                                              ('${snapshot.data[index].data['interdestination']}'),
                                          style: new TextStyle(
                                            fontSize: 20.0,
                                            color:
                                                Colors.black.withOpacity(0.6),
                                            fontFamily: "Roboto",
                                          )),
                                      new TextSpan(
                                        text:
                                            ('${snapshot.data[index].data['ending_destination']}'),
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
                                Row(
                                  children: <Widget>[
                                    leftSection,
                                    middleSection,
                                    
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return SizedBox();
                }
              },
            ),
          ),
        ),
 

      ),
    );
  }


}
