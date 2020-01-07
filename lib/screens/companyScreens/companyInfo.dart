import 'dart:async';
import 'dart:core';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spediter/screens/companyScreens/listOfRoutes/companyRoutes.dart';
import 'package:spediter/screens/companyScreens/listOfRoutes/listofRoutes.dart';
import 'package:spediter/screens/companyScreens/listOfRoutes/noRoutes.dart';
import 'package:spediter/screens/singIn/signIn.dart';
import 'package:spediter/utils/screenUtils.dart';
import 'package:flutter/rendering.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';

void main() => runApp(CompanyInfo());

// instanca na NoRoutes screen
NoRoutes noRoutes = new NoRoutes();

class CompanyInfo extends StatelessWidget {
  // This widget is the root of your application.
  final DocumentSnapshot post;
  final String userID;

  CompanyInfo({this.post, this.userID});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Profil',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      localizationsDelegates: [
        // ... lokalizacija jezika
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('bs'), // Bosnian
        const Locale('en'), // English
      ],
      home: CompanyInfoPage(post: post, userID: userID),
    );
  }
}

class CompanyInfoPage extends StatefulWidget {
  final DocumentSnapshot post;
  final String userID;

  CompanyInfoPage({this.post, this.userID});

  @override
  _CompanyInfoPageState createState() =>
      _CompanyInfoPageState(post: post, userID: userID);
}

class _CompanyInfoPageState extends State<CompanyInfoPage> {
  final DocumentSnapshot post;
  final String userID;

  _CompanyInfoPageState({this.post, this.userID});

  /// key za formu
  final _formKey = GlobalKey<FormState>();

  /// instanca za bazu
  final db = Firestore.instance;

  /// fokusi
  ///
  /// fokus za procenat
  /// fokus za dostupnost
  /// fokus za robu
  /// fokus za dimenzije
  /// fokus za pocetnu destinaciju
  /// fokus za krajnju destinaciju
  var focusImage = new FocusNode();
  var focusName = new FocusNode();
  var focusAbout = new FocusNode();
  var focusMail = new FocusNode();
  var focusPhone = new FocusNode();
  var focusWeb = new FocusNode();
  var focusLocation = new FocusNode();

  /// counteri za [Toast] i za [Button]
  int onceToast = 0, onceBtnPressed = 0;

  /// Stringovi
  ///
  /// companyID
  /// user id
  /// id
  /// medjudestinacija
  /// roba,dimenzije,odabraniDatumPolaska,odabraniDatumDolaska,krajnja destinacija,pocetna destinacija
  /// vrijemeDolaska,vrijemePolaska, odabranoVozilo,
  /// procenat i kapacitet
  String userUid;
  String id;
  String phone,
      webPage,
      location,
      companyName,
      urlLogo,
      companyDescription,
      mail;
  String phoneLast,
      webPageLast,
      locationLast,
      companyNameLast,
      urlLogoLast,
      companyDescriptionLast,
      mailLast;

  /// counteri za velicinu ekrana (responsive)
  /// i za postojanje ruta kod kompanije
  bool _screenUtilActive = true;
  bool imaliRuta = true;

  /// counter da li je btn diiseblan ili ne
  bool _isBtnDisabled = true;

  /// metoda koja provjerava da li je aktivan counter za screen aktivan
  setScreenSize() {
    if (!_screenUtilActive)
      Constant.setScreenAwareConstant(context);
    else
      Constant.setDefaultSize(context);
    setState(() {
      _screenUtilActive = !_screenUtilActive;
    });
  }

  /// metoda pomocu koje uzimamo ID od trenutno logovane kompanije/usera
  ///
  /// ulazimo u [Auth] dio firebase i na osnovu toga izvlacimo sve info o user u nasem slucaju kompaniji
  /// nakon cega dohvatamo kolekciju [LoggedUsers] i uzimamo [user.uid] i spremamo ga u varijablu [userID]
  // getUserid() async {
  //   final FirebaseAuth _auth = FirebaseAuth.instance;
  //   final FirebaseUser user = await _auth.currentUser();

  //   Firestore.instance
  //       .collection('LoggedUsers')
  //       .document(user.uid)
  //       .snapshots()
  //       .toString();
  //   userID = user.uid;
  // }

  /// bool f-ja koju smo ubacili u [BackButtonInterceptor], koja mora vratiti true ili false.
  /// u kojoj na klik back btn-a
  /// provjeravamo da li company ima rute ili ne i na osnovu toga ih
  /// redirectamo na [NoRoutes] ili na [ListOfRoutes]
  bool myInterceptor(bool stopDefaultButtonEvent) {
    CompanyRutes().getCompanyRoutes(userID).then((QuerySnapshot docs) {
      if (docs.documents.isNotEmpty) {
        print('NOT EMPRY');
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ListOfRoutes(
                  userID: userID,
                )));
      } else {
        print('EMPTU');

        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => NoRoutes()));
      }
    });
    // Do some stuff.
    return true;
  }

  /// initState metoda - lifecycle metoda koja se izvrsi prije nego se load-a sam screen
  /// u njoj pozivamo metodu [getUserID()] , setamo [Toast] counter na 0,
  /// ubacujemo u dropdown listu [_dropdownMenuItems] vozila,
  /// aktiviramo [BackButtonInterceptor] i dodajemo mu f-ju [myInterceptor]
  @override
  void initState() {
    super.initState();
    //getUserid();
    onceToast = 0;
    BackButtonInterceptor.add(myInterceptor);
  }

  ///dispose back btn-a nakon njegovog koristenja
  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }

  Future getPosts(String id) async {
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore
        .collection('Company')
        .where('company_id', isEqualTo: id)
        .getDocuments();
    return qn.documents;
  }

  @override
  Widget build(BuildContext context) {
    /// RESPONSIVE
    ///
    /// iz klase [ScreenUtils]
    double defaultScreenWidth = 400.0;
    double defaultScreenHeight = 810.0;
    ScreenUtil.instance = ScreenUtil(
      width: defaultScreenWidth,
      height: defaultScreenHeight,
      allowFontScaling: true,
    )..init(context);

    return Scaffold(
      resizeToAvoidBottomPadding: false,

      appBar: AppBar(
        /// u appBaru kreiramo X iconicu na osnovu koje izlazimo iz [CreateRoutes] i idemo na [ListOfRoutes]
        backgroundColor: Colors.white,
        leading: IconButton(
          color: Colors.black,
          icon: Icon(Icons.clear),
          onPressed: () {
            /// provjera da li company ima ili nema ruta na osnovu koje im pokazujemo screen
            CompanyRutes().getCompanyRoutes(userID).then((QuerySnapshot docs) {
              if (docs.documents.isNotEmpty) {
                print('NOT EMPRY');
                imaliRuta = true;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ListOfRoutes(
                            userID: userID,
                          )),
                );
              } else {
                print('EMPTU');
                imaliRuta = false;
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => NoRoutes()));
              }
            });
          },
        ),
        title: const Text('Profil',
            style: TextStyle(color: Color.fromRGBO(0, 0, 0, 0.8))),
      ),
      body:

          /// GestureDetector na osnovu kojeg zavaramo tastaturu na klik izvan njenog prostora
          Builder(
        builder: (context) => new GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(new FocusNode());
              onceToast = 0;
            },
            child: FutureBuilder(
                future: getPosts(userID),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        urlLogo = snapshot.data[index].data['url_logo'];
                        companyName = snapshot.data[index].data['company_name'];
                        companyDescription =
                            snapshot.data[index].data['company_description'];
                        mail = snapshot.data[index].data['email'];
                        phone = snapshot.data[index].data['phone'];
                        webPage = snapshot.data[index].data['webpage'];
                        location = snapshot.data[index].data['location'];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            /// POCETAK FORME
                            Form(
                              key: _formKey,
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.only(
                                        bottom: 2,
                                        left: 16.0,
                                        right: 16.0,
                                        top: 15),
                                    child: TextFormField(
                                      initialValue: urlLogo,
                                      focusNode: focusImage,
                                      decoration: InputDecoration(
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(4.0)),
                                            borderSide: BorderSide(
                                                color: Color.fromRGBO(
                                                    0, 0, 0, 0.12)),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(4.0)),
                                              borderSide: BorderSide(
                                                  color: Color.fromRGBO(
                                                      0, 0, 0, 0.12))),
                                          labelText: 'Url Profilne Slike',
                                          labelStyle: TextStyle(
                                              color:
                                                  Color.fromRGBO(0, 0, 0, 0.5)),
                                          hasFloatingPlaceholder: true,
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5.0))),
                                      onChanged: (input) {
                                        setState(() {
                                          urlLogoLast = input;
                                          onceToast = 0;
                                          onceBtnPressed = 0;
                                          areFieldsEmpty();
                                        });
                                      },
                                    ),
                                  ),

                                  Container(
                                    margin: EdgeInsets.only(
                                        bottom: 2,
                                        left: 16.0,
                                        right: 16.0,
                                        top: 11.5),
                                    child: TextFormField(
                                      initialValue: companyName,
                                      focusNode: focusName,
                                      decoration: InputDecoration(
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(4.0)),
                                            borderSide: BorderSide(
                                                color: Color.fromRGBO(
                                                    0, 0, 0, 0.12)),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(4.0)),
                                              borderSide: BorderSide(
                                                  color: Color.fromRGBO(
                                                      0, 0, 0, 0.12))),
                                          labelText: 'Korisničko Ime',
                                          labelStyle: TextStyle(
                                              color:
                                                  Color.fromRGBO(0, 0, 0, 0.5)),
                                          hasFloatingPlaceholder: true,
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5.0))),
                                      onChanged: (input) {
                                        setState(() {
                                          companyNameLast = input;
                                          onceToast = 0;
                                          onceBtnPressed = 0;
                                          areFieldsEmpty();
                                        });
                                      },
                                    ),
                                  ),

                                  /// Popunjenost u procentimaaaaaaaaaaaaaaaaa
                                  Container(
                                    margin: EdgeInsets.only(
                                        bottom: 2,
                                        left: 16.0,
                                        right: 16.0,
                                        top: 11.5),
                                    child: TextFormField(
                                      initialValue: companyDescription,
                                      focusNode: focusAbout,
                                      decoration: InputDecoration(
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(4.0)),
                                            borderSide: BorderSide(
                                                color: Color.fromRGBO(
                                                    0, 0, 0, 0.12)),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(4.0)),
                                              borderSide: BorderSide(
                                                  color: Color.fromRGBO(
                                                      0, 0, 0, 0.12))),
                                          labelText: 'Kratki Opis',
                                          labelStyle: TextStyle(
                                              color:
                                                  Color.fromRGBO(0, 0, 0, 0.5)),
                                          hasFloatingPlaceholder: true,
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5.0))),
                                      onChanged: (input) {
                                        setState(() {
                                          companyDescriptionLast = input;
                                          onceToast = 0;
                                          onceBtnPressed = 0;
                                          areFieldsEmpty();
                                        });
                                      },
                                    ),
                                  ),
                                  ////// kapacitet u tonamaaaaaaaa
                                  Container(
                                    margin: EdgeInsets.only(
                                        bottom: 2,
                                        left: 16.0,
                                        right: 16.0,
                                        top: 11.5),
                                    child: TextFormField(
                                      initialValue: mail,
                                      focusNode: focusMail,
                                      decoration: InputDecoration(
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(4.0)),
                                            borderSide: BorderSide(
                                                color: Color.fromRGBO(
                                                    0, 0, 0, 0.12)),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(4.0)),
                                              borderSide: BorderSide(
                                                  color: Color.fromRGBO(
                                                      0, 0, 0, 0.12))),
                                          labelText: 'Mail',
                                          labelStyle: TextStyle(
                                              color:
                                                  Color.fromRGBO(0, 0, 0, 0.5)),
                                          hasFloatingPlaceholder: true,
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5.0))),
                                      onChanged: (input) {
                                        setState(() {
                                          mailLast = input;
                                          onceToast = 0;
                                          onceBtnPressed = 0;
                                          areFieldsEmpty();
                                        });
                                      },
                                    ),
                                  ),

                                  Container(
                                    margin: EdgeInsets.only(
                                        bottom: 2,
                                        left: 16.0,
                                        right: 16.0,
                                        top: 11.5),
                                    child: TextFormField(
                                      initialValue: phone,
                                      focusNode: focusPhone,
                                      decoration: InputDecoration(
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(4.0)),
                                            borderSide: BorderSide(
                                                color: Color.fromRGBO(
                                                    0, 0, 0, 0.12)),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(4.0)),
                                              borderSide: BorderSide(
                                                  color: Color.fromRGBO(
                                                      0, 0, 0, 0.12))),
                                          labelText: 'Telefon',
                                          labelStyle: TextStyle(
                                              color:
                                                  Color.fromRGBO(0, 0, 0, 0.5)),
                                          hasFloatingPlaceholder: true,
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5.0))),
                                      onChanged: (input) {
                                        setState(() {
                                          phoneLast = input;
                                          onceToast = 0;
                                          onceBtnPressed = 0;
                                          areFieldsEmpty();
                                        });
                                      },
                                    ),
                                  ),

                                  Container(
                                    margin: EdgeInsets.only(
                                        bottom: 2,
                                        left: 16.0,
                                        right: 16.0,
                                        top: 11.5),
                                    child: TextFormField(
                                      initialValue: webPage,
                                      focusNode: focusWeb,
                                      decoration: InputDecoration(
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(4.0)),
                                            borderSide: BorderSide(
                                                color: Color.fromRGBO(
                                                    0, 0, 0, 0.12)),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(4.0)),
                                              borderSide: BorderSide(
                                                  color: Color.fromRGBO(
                                                      0, 0, 0, 0.12))),
                                          labelText: 'Web Stranica',
                                          labelStyle: TextStyle(
                                              color:
                                                  Color.fromRGBO(0, 0, 0, 0.5)),
                                          hasFloatingPlaceholder: true,
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5.0))),
                                      onChanged: (input) {
                                        setState(() {
                                          webPageLast = input;
                                          onceToast = 0;
                                          onceBtnPressed = 0;
                                          areFieldsEmpty();
                                        });
                                      },
                                    ),
                                  ),

                                  Container(
                                    margin: EdgeInsets.only(
                                        bottom: 2,
                                        left: 16.0,
                                        right: 16.0,
                                        top: 11.5),
                                    child: TextFormField(
                                      initialValue: location,
                                      focusNode: focusLocation,
                                      decoration: InputDecoration(
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(4.0)),
                                            borderSide: BorderSide(
                                                color: Color.fromRGBO(
                                                    0, 0, 0, 0.12)),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(4.0)),
                                              borderSide: BorderSide(
                                                  color: Color.fromRGBO(
                                                      0, 0, 0, 0.12))),
                                          labelText: 'Lokacija',
                                          labelStyle: TextStyle(
                                              color:
                                                  Color.fromRGBO(0, 0, 0, 0.5)),
                                          hasFloatingPlaceholder: true,
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5.0))),
                                      onChanged: (input) {
                                        setState(() {
                                          locationLast = input;
                                          onceToast = 0;
                                          onceBtnPressed = 0;
                                          areFieldsEmpty();
                                        });
                                      },
                                    ),
                                  ),

                                  /// BUTTOON
                                  Container(
                                    margin: EdgeInsets.only(
                                      left: 16.0,
                                      right: 16.0,
                                      top: 8,
                                    ),
                                    child: ConstrainedBox(
                                      constraints: const BoxConstraints(
                                        minWidth: double.infinity,
                                      ),
                                      child: RaisedButton(
                                          disabledColor:
                                              Color.fromRGBO(219, 219, 219, 1),
                                          disabledTextColor:
                                              Color.fromRGBO(0, 0, 0, 1),
                                          color: Color.fromRGBO(3, 54, 255, 1),
                                          textColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(4.0),
                                          ),
                                          child: Text(
                                            'SAČUVAJ PROMJENE',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontFamily: 'Roboto',
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          onPressed: _isBtnDisabled
                                              ? null
                                              : () {
                                                  FocusScopeNode currentFocus =
                                                      FocusScope.of(context);
                                                  if (!currentFocus
                                                      .hasPrimaryFocus) {
                                                    currentFocus.unfocus();

                                                    if (urlLogoLast == null) {
                                                      urlLogoLast = urlLogo;
                                                    }
                                                    if (companyNameLast ==
                                                        null) {
                                                      companyNameLast =
                                                          companyName;
                                                    }
                                                    if (companyDescriptionLast ==
                                                        null) {
                                                      companyDescriptionLast =
                                                          companyDescription;
                                                    }
                                                    if (mailLast == null) {
                                                      mailLast = mail;
                                                    }
                                                    if (phoneLast == null) {
                                                      phoneLast = phone;
                                                    }
                                                    if (webPageLast == null) {
                                                      webPageLast = webPage;
                                                    }
                                                    if (locationLast == null) {
                                                      locationLast = location;
                                                    }

                                                    if (companyDescriptionLast ==
                                                            '' ||
                                                        mailLast == '' ||
                                                        locationLast == '' ||
                                                        companyNameLast == '' ||
                                                        urlLogoLast == '' ||
                                                        phoneLast == '' ||
                                                        webPageLast == '') {
                                                      if (onceToast == 0) {
                                                        final snackBar =
                                                            SnackBar(
                                                          duration: Duration(
                                                              seconds: 2),
                                                          behavior:
                                                              SnackBarBehavior
                                                                  .floating,
                                                          backgroundColor:
                                                              Color.fromRGBO(28,
                                                                  28, 28, 1.0),
                                                          content: Text(
                                                              'Sva polja moraju biti popunjena.'),
                                                          action:
                                                              SnackBarAction(
                                                            label: 'Undo',
                                                            onPressed: () {},
                                                          ),
                                                        );
                                                        Scaffold.of(context)
                                                            .showSnackBar(
                                                                snackBar);
                                                        onceToast = 1;
                                                        Timer(
                                                            Duration(
                                                                seconds: 2),
                                                            () {
                                                          onceToast = 0;
                                                        });
                                                      }
                                                    } else {
                                                      updateData(snapshot
                                                          .data[index]
                                                          .documentID);
                                                      print(snapshot.data[index]
                                                          .documentID);
                                                      print(
                                                          'URL: -$urlLogoLast-');
                                                      print(
                                                          'Name: -$companyNameLast-');
                                                      print(
                                                          'Desc: -$companyDescriptionLast-');
                                                      print(
                                                          'Mail: -$mailLast-');
                                                      print(
                                                          'Phone: -$phoneLast-');
                                                      print(
                                                          'Web: -$webPageLast-');
                                                      print(
                                                          'Loaction: -$locationLast-');
                                                    }
                                                  }
                                                }),
                                    ),
                                  ),
                                  Container(
                                    margin:
                                        EdgeInsets.only(top: 16, bottom: 16),
                                    height: 8,
                                    decoration: BoxDecoration(
                                        border: Border(
                                      top: BorderSide(
                                          width: 1,
                                          color: Color.fromRGBO(0, 0, 0, 0.12)),
                                      bottom: BorderSide(
                                          width: 1,
                                          color: Color.fromRGBO(0, 0, 0, 0.12)),
                                    )),
                                    child: Divider(
                                      thickness: 8,
                                      color: Color.fromRGBO(0, 0, 0, 0.03),
                                    ),
                                  ),
                                  Container(
                                      alignment: Alignment(-1.0, 0.0),
                                      height: 51,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            margin: EdgeInsets.only(
                                                top: 2, left: 16),
                                            //height: 21,
                                            //width: 89,
                                            child: Text(
                                              'Kontakt mail',
                                              style: TextStyle(
                                                  fontFamily: 'Roboto',
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(
                                                bottom: 10, left: 16),
                                            //height: 19,
                                            //width: 130,
                                            child: Text(
                                              'support@ešped.com',
                                              style: TextStyle(
                                                  fontFamily: 'Roboto',
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ),
                                        ],
                                      )),
                                  Divider(
                                    thickness: 1,
                                    color: Color.fromRGBO(0, 0, 0, 0.12),
                                  ),
                                  Container(
                                      alignment: Alignment(-1.0, 0.0),
                                      height: 52,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            margin: EdgeInsets.only(
                                                top: 2, left: 16),
                                            //height: 21,
                                            //width: 89,
                                            child: Text(
                                              'Kontakt telefon',
                                              style: TextStyle(
                                                  fontFamily: 'Roboto',
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(
                                                bottom: 10, left: 16),
                                            //height: 19,
                                            //width: 130,
                                            child: Text(
                                              '062 667-266',
                                              style: TextStyle(
                                                  fontFamily: 'Roboto',
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ),
                                        ],
                                      )),
                                  Divider(
                                    thickness: 1,
                                    color: Color.fromRGBO(0, 0, 0, 0.12),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      print('ODJAVAAAAAAAAAAA');
                                      _signOut();
                                    },
                                    child: Container(
                                      alignment: Alignment(-1.0, 0.0),
                                      height: 56,
                                      child: Container(
                                        margin: EdgeInsets.only(
                                            top: 17, left: 15, bottom: 18),
                                        //height: 21,
                                        //width: 89,
                                        child: Text(
                                          'Odjava',
                                          style: TextStyle(
                                              fontFamily: 'Roboto',
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        );
                      },
                    );
                  } else {
                    return SizedBox();
                  }
                })),
      ),
    );
  }

  // funckija koja provjerava da li su polja prazna i enable/disable btn
  areFieldsEmpty() {
    if ((companyDescriptionLast == null ||
            companyDescriptionLast == '' ||
            companyDescriptionLast == companyDescription) &&
        (mailLast == null || mailLast == '' || mailLast == mail) &&
        (locationLast == '' ||
            locationLast == null ||
            locationLast == location) &&
        (companyNameLast == '' ||
            companyNameLast == null ||
            companyNameLast == companyName) &&
        (urlLogoLast == '' || urlLogoLast == null || urlLogoLast == urlLogo) &&
        (phoneLast == null || phoneLast == '' || phoneLast == phone) &&
        (webPageLast == null || webPageLast == '' || webPageLast == webPage)) {
      _isBtnDisabled = true;
      // } else if ((locationLast != location || mailLast != mail || companyDescriptionLast != companyDescription
      //             || companyNameLast != companyName || urlLogoLast != urlLogo || phoneLast != phone || webPageLast != webPage) &&
      //     (mailLast == null || mailLast == '' || locationLast == '' || locationLast == null || companyNameLast == '' || companyNameLast == null
      //     || urlLogoLast == '' || urlLogoLast == null || phoneLast == null || phoneLast == '' || webPageLast == null || webPageLast == ''
      //     || companyDescriptionLast == null || companyDescriptionLast == '')){
      //   _isBtnDisabled = true;
    } else {
      _isBtnDisabled = false;
    }
  }

  //  funckija za update todo
  updateData(String docID) async {
    await db.collection('Company').document(docID).updateData({
      'company_description': '$companyDescriptionLast',
      'company_name': '$companyNameLast',
      'email': '$mailLast',
      'location': '$locationLast',
      'phone': '$phoneLast',
      'url_logo': '$urlLogoLast',
      'webpage': '$webPageLast',
    });
    print('Update uspjesan');
  }

  void _signOut() async {
    await FirebaseAuth.instance.signOut();
    Future<FirebaseUser> Function() user = FirebaseAuth.instance.currentUser;
    //print('$user');
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => Login()));
  }
}
