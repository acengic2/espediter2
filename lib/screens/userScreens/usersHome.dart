import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:spediter/screens/companyScreens/createRoute/createRouteScreen.dart';
import 'package:spediter/screens/companyScreens/listOfRoutes/companyRoutes.dart';




void main() => runApp(ListOfUsersRoutes());

const blueColor = Color.fromRGBO(3, 54, 255, 1);
const textColorGray80 = Color.fromRGBO(0, 0, 0, 0.8);
const textColorGray60 = Color.fromRGBO(0, 0, 0, 0.6);

final leftSection = new Container();
final middleSection = new Container();
final rightSection = new Container();

class ListOfUsersRoutes extends StatelessWidget {
  /// id trenutne rute [id],
  /// id kompanije [userID]

  String userID;
  ListOfUsersRoutes({this.userID});
  
  
  

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ListOfUsersRoutesPage(userID: userID),
    );
  }
}

class ListOfUsersRoutesPage extends StatefulWidget {
   /// id trenutne rute [id],
  /// id kompanije [userID]
 
 
  String userID;
  ListOfUsersRoutesPage({ this.userID});

  @override
  State<StatefulWidget> createState() {
    return _ListOfUsersRoutesPageState(userID:userID);
  }
}

class _ListOfUsersRoutesPageState extends State<ListOfUsersRoutesPage> {
  ///instanca na bazu
  final db = Firestore.instance;
  /// id trenutne rute [id],
  /// id kompanije [userID]
  String userID;

  _ListOfUsersRoutesPageState({this.userID});

  @override
  void initState() { 
    super.initState();
 
    
    CompanyRutes().getCompanyRoutes(userID).then((QuerySnapshot docs) {
           if(docs.documents.isNotEmpty){
             print('NOT EMPRY');

        
           } else {
             print('EMPTU');           }
    } );
    
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        body: ListView(children: <Widget>[
        Container(
          // Future builder 
          //
          //u future se poziva metoda iz klase CompanyRoutes koja prima id
          //builder vraca context i snapshot koji koristimo kako bi mapirali kroz info
           child: FutureBuilder<QuerySnapshot>(
             future: CompanyRutes().getCompanyRoutes(userID),
              builder: (context, snapshot) {
                print('DOVDJE');
                print(userID);
                // ukoliko postoje podatci
                //vrati Column oi mapiraj kroz iste podatke
                if (snapshot.hasData) {
                   print('asasasas' + userID);
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
}