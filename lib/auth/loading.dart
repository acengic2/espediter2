import 'dart:async';
import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spediter/routes/companyRoutes.dart';
import 'package:spediter/routes/listOfRoutesref.dart';
import 'package:spediter/routes/noRoutes.dart';

void main() => runApp(ShowLoading());

  const String loadingString = "Molimo vas sačekajte trenutak.";

class ShowLoading extends StatefulWidget {
  /// Varijable
  ///
  /// email koji dobijamo iz signIn screena
  /// user i sve info o trenutno logovanom user-u
  final String email;
  final FirebaseUser user;
  final String userID;

  //konstruktor koji prima info i signIn screen-a i smjesta ih u varijable instancirane iznad
  ShowLoading({Key key, this.user, this.email, this.userID}) : super(key: key);

  @override
  _ShowLoading createState() =>
      _ShowLoading(user: user, email: email, userID: userID);
}

class _ShowLoading extends State<ShowLoading> {
  /// Varijable
  ///
  /// id trenutno logovanog usera [usID]
  String usID;

  /// metoda koja provjerava id trenutno logovanog usera
  ///
  /// kreiramo instancu na [FirebaseAuth _auth]
  /// zatim kreiramo [FirebaseUser user] iz instance [_auth]
  /// zatim pravimo konekciju na kolekciju [LoggedUsers], uzimamo [user.uid] i vracamo ga u vidu stringa
  /// zatim  ga spremamo u varijablu [usID] koju smo instancirali iznad
  checkForID() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final FirebaseUser user = await _auth.currentUser();
    Firestore.instance
        .collection('LoggedUsers')
        .document(user.uid)
        .snapshots()
        .toString();
    usID = user.uid;
  }

  /// metoda koja provjerava rolu, odnosno ulogu logovanog user-a
  ///
  /// da li je user - user  ili je user - kompanija ,
  /// na osnovu toga se izvrsava redirekcija
  ///  kreiramo konekciju na kolekciju [LoggedUsers] , zatim pisemo
  /// query gdje je role == 'company'
  /// limitiramo pretraguna 1 dokument
  checkForRole() {
    checkForID();
    return Firestore.instance
        .collection('LoggedUsers')
        .where('role', isEqualTo: 'company')
        .limit(1)
        .getDocuments();
  }
  // bool _loadingInProgress;

  ///VARIJABLE
  ///
  /// [email ] - email trenutno logovanog usera
  /// [user] - objekat koji sadrzi sve info o trenutno logovanom useru
  /// [userID] - user token trenutno logovanog usera
  String email;
  final FirebaseUser user;
  String userID;

  _ShowLoading({this.user, this.email, this.userID});

// init state f-ja koja se izvrsava prije nego se bilo sta ucita sa ovog screena
// u njoj se aktivira [loadData()] f-ja
  @override
  void initState() {
    super.initState();
    loadData();
  }

// Future f-ja koja se odvija na load ovog screena
//vraca Timer u trajanju od 2 sekunde, nakon cega se aktivira f-ja [onDoneLoading]
  Future<Timer> loadData() async {
    return new Timer(Duration(seconds: 2), onDoneLoading);
  }

  @override
  Widget build(BuildContext context) {
    final AsyncMemoizer _memoizer = AsyncMemoizer();
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
            'Registracija Korisnika',
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'RobotoMono',
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        Container(
          child: Text(
            loadingString,
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

  /// f-ja [onDoneLoading()] koja se aktivira nakon isteka Timera
  ///
  /// prilikom aktiviranja ove f-je provjeravamo Role (da li je company/user)
  /// nakon cega na osnovu te provjere redirektamo [na osnovu da li ja kompanija ima ruta ili ne ]
  /// na [NoRoutes] ili na [ListOfRoutes]
  onDoneLoading() async {
    checkForRole();
    CompanyRutes().getCompanyRoutes(userID).then((QuerySnapshot docs) {
      if (docs.documents.isNotEmpty) {
        print('NOT EMPRY');
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ListOfRoutesRef(
                  
                )));
      } else {
        print('EMPTU');
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => NoRoutes()));
      }
    });
  }
}
