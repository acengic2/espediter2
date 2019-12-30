import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:spediter/routes/companyRoutes.dart';
import './createRouteScreen.dart';
import './companyRoutes.dart';
import 'createRouteScreen.dart';


void main() => runApp(ListOfRoutes());


/// varijable
/// 
/// varijable u kojoj smo spremili boje
/// plava
/// crna sa 80% opacity
/// crna sa 60^ opacity
const blueColor = Color.fromRGBO(3, 54, 255, 1);
const textColorGray80 = Color.fromRGBO(0, 0, 0, 0.8);
const textColorGray60 = Color.fromRGBO(0, 0, 0, 0.6);

/// desni,lijevi,srednji kontejner za prikaz informacija o aktivnim rutama
final leftSection = new Container();
final middleSection = new Container();
final rightSection = new Container();

String capacityString;

class ListOfRoutes extends StatelessWidget {

  /// id trenutno  logovanog usera [userID]
  String userID;
  ListOfRoutes({this.userID});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ListOfRoutesPage(userID: userID),
    );
  }
}

class ListOfRoutesPage extends StatefulWidget {

  /// id kompanije [userID]
  String userID;
  ListOfRoutesPage({this.userID});

  @override
  State<StatefulWidget> createState() {
    return _ListOfRoutesPageState(userID: userID);
  }
}

class _ListOfRoutesPageState extends State<ListOfRoutesPage> {
  ///instanca na bazu
  final db = Firestore.instance;

  /// id kompanije [userID]
  String userID;
  bool imaliRuta = true;

  _ListOfRoutesPageState({this.userID});


/// overridana metoda iz [ScreenUtils] klase 
/// koristi se za responsive 
  @override
  Widget build(BuildContext context) {
    double defaultScreenWidth = 400.0;
    double defaultScreenHeight = 810.0;
    ScreenUtil.instance = ScreenUtil(
      width: defaultScreenWidth,
      height: defaultScreenHeight,
      allowFontScaling: true,
    )..init(context);

    return Scaffold(
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
              // ukoliko postoje podaci
              // vrati Column oi mapiraj kroz iste podatke
              if (snapshot.hasData) {
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
      ///BottomNavigationBar
      ///
      ///u BottomNavigationBaru imamo ikonicu kompanije
      ///info ikonicu 
      ///i + btn na kojem dodajemo novu rutu i koji nas vodi na [CreateRoutes]
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
    );
  }

///Card buildItem
///
///ovdje kreiramo nasu karticu
///uzimamo informacije kroz koje smo mapirali u Future f-ji iznad 
///i spremamo ih u dizajnirane kartice
  Card buildItem(DocumentSnapshot doc) {

    // DATUM POLASKA
    String date = doc.data['departure_date'];
    String dateReversed = date.split('/').reversed.join();
    String departureDate =
        DateFormat("d MMM").format(DateTime.parse(dateReversed));

    // KAPACITET
    capacityString = doc.data['capacity'];

    /// left section u koji spremamo datum polaska
    final leftSection = new Container(
        height: 32,
        width: 62,
        margin: EdgeInsets.only(top: 8, bottom: 16),
        decoration: new BoxDecoration(
          shape: BoxShape.rectangle,
          color: blueColor,
          borderRadius: BorderRadius.all(Radius.circular(1.0)),
        ),
        child: Center(
          child: Padding(
          padding: EdgeInsets.only(left: 8.0, right: 8.0),
          child: new RichText(
            text: new TextSpan(
              children: <TextSpan>[
                new TextSpan(
                    text: departureDate,
                    style: new TextStyle(
                      fontSize: ScreenUtil.instance.setSp(13.0),
                      color: Colors.white,
                      fontFamily: "Roboto",
                    )),
              ],
            ),
          ),
        ))
        );


    ///middle section u koji spremamo kapacitet 
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
                        color: Colors.black.withOpacity(0.6),
                        fontFamily: "Roboto",
                      )),
                  new TextSpan(
                    text: ('$capacityString t'),
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

    
    /// DOSTUPNOST
    String availability = doc.data['availability'];
 

    ///right section u koji spremamo dostupnost
    final rightSection = new Stack(
      children: <Widget>[
        Container(
          width: ScreenUtil.instance.setWidth(142.0),
          height: 32,
          margin: EdgeInsets.only(top: 8, bottom: 16, left: 0.0, right: 1.0),
          decoration: BoxDecoration(
              border:
                  Border.all(width: 1.0, color: Colors.black.withOpacity(0.12)),
              borderRadius: BorderRadius.all(Radius.circular(1.0))),
        ),
        Container(
            margin: EdgeInsets.only(top: 9),
            child: LinearPercentIndicator(
              padding: EdgeInsets.only(left: 1),
              width: ScreenUtil.instance.setWidth(141.0),
              lineHeight: 30.0,
              percent: (double.parse(availability)) / 100,
              center: RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                        text: 'Popunjenost: ',
                        style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: ScreenUtil.instance.setSp(12.0),
                            color: Colors.black.withOpacity(0.6))),
                    TextSpan(
                      text: ('${doc.data['availability']} %'),
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: ScreenUtil.instance.setSp(12.0),
                          fontWeight: FontWeight.bold,
                          color: Colors.black.withOpacity(0.8)),
                    ),
                  ],
                ),
              ),
              linearStrokeCap: LinearStrokeCap.butt,
              backgroundColor: Colors.white,
              progressColor: Color.fromRGBO(3, 54, 255, 0.12),
            ))
      ],
    );

    /// Card Widget u koji spremamo svaki od sekcija [right,left,middle]
    /// i na osnovu toga kreiramo karticu
  

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
                      text: '${doc.data['starting_destination']}, ',
                      style: new TextStyle(
                        fontSize: 20.0,
                        color: Colors.black.withOpacity(0.8),
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
                      text: ('${doc.data['interdestination']}'),
                      style: new TextStyle(
                        fontSize: 20.0,
                        color: Colors.black.withOpacity(0.6),
                        fontFamily: "Roboto",
                      )),
                  new TextSpan(
                    text: ('${doc.data['ending_destination']}'),
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
}
