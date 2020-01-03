import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spediter/screens/loadingScreens/loading.dart';
import 'package:spediter/screens/noInternetConnectionScreen/noInternetOnLogin.dart';

class FormLogIn extends StatefulWidget {
  @override
  _FormState createState() => _FormState();
}

var err;

final FirebaseAuth _auth = FirebaseAuth.instance;

var _focusNode = new FocusNode();

var focusNode = new FocusNode();

String _email = '', _password = '', userExist, passExist, id, userID;

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

final db = Firestore.instance;

int onceToast = 0, onceBtnPressed = 0;

class _FormState extends State<FormLogIn> {
  ///VARIJABLE
  ///
  ///error, instanca na auth
  /// fokusi za email i pass polje
  /// email,pass, da li user postoji, da li sifra postoji, docID, i userID
  /// GlobalKey za formu
  /// instanca na firebase bazu
  /// counteri za toast i btn

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Form(
          // form key na osnovu kojeg kupimo podatke sa forme
          key: _formKey,
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(
                    bottom: 24.0, left: 24.0, right: 24.0, top: 24.0),
                child:

                    // EMAIL textform field

                    TextFormField(
                  focusNode: focusNode,

                  autocorrect: false,

                  keyboardType: TextInputType.visiblePassword,

                  autofocus: true,

                  enableInteractiveSelection: false,

                  autovalidate: false,

                  // dekoracija fielda

                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4.0)),
                        borderSide:
                            BorderSide(color: Color.fromRGBO(0, 0, 0, 0.12)),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4.0)),
                        borderSide: BorderSide(
                          color: Colors.red,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4.0)),
                        borderSide:
                            BorderSide(color: Color.fromRGBO(3, 54, 255, 1.0)),
                      ),
                      labelText: 'email',
                      hasFloatingPlaceholder: true,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0))),

                  // VALIDACIJA fielda

                  validator: (input) {
                    //  polje ne smije biti prazno

                    if (input == '') {
                      if (onceToast == 0) {
                        final snackBar = SnackBar(
                          duration: Duration(seconds: 2),
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Color.fromRGBO(28, 28, 28, 1.0),
                          content: Text('Email polje je prazno'),
                          action: SnackBarAction(
                            label: 'Undo',
                            onPressed: () {},
                          ),
                        );

                        Scaffold.of(context).showSnackBar(snackBar);

                        onceToast = 1;
                      }

                      return '';
                    }

                    // email mora biti validan [____@___.___]

                    else if (!EmailValidator.validate(input, true)) {
                      if (onceToast == 0) {
                        final snackBar = SnackBar(
                          duration: Duration(seconds: 2),
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Color.fromRGBO(28, 28, 28, 1.0),
                          content: Text('Email nije validan'),
                          action: SnackBarAction(
                            label: 'Undo',
                            onPressed: () {},
                          ),
                        );

                        Scaffold.of(context).showSnackBar(snackBar);

                        onceToast = 1;
                      }

                      return '';
                    }

                    // da li taj email stvarno postoji u bazi

                    else if (userExist != 'User postoji') {
                      if (onceToast == 0) {
                        final snackBar = SnackBar(
                          duration: Duration(seconds: 2),
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Color.fromRGBO(28, 28, 28, 1.0),
                          content: Text('User sa unesenim emailom ne postoji'),
                          action: SnackBarAction(
                            label: 'Undo',
                            onPressed: () {},
                          ),
                        );

                        Scaffold.of(context).showSnackBar(snackBar);

                        onceToast = 1;
                      }

                      return '';
                    }

                    return null;
                  },

                  // na promjenu u polju setamo state

                  // email == input

                  onChanged: (input) {
                    setState(() {
                      _email = input;
                    });
                  },
                ),
              ),

              Container(
                margin: EdgeInsets.only(bottom: 24.0, left: 24.0, right: 24.0),
                child:

                    // PASSWORD textform field

                    TextFormField(
                  focusNode: _focusNode,

                  obscureText: true,

                  //  dekoracija fielda

                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4.0)),
                        borderSide:
                            BorderSide(color: Color.fromRGBO(0, 0, 0, 0.12)),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4.0)),
                        borderSide: BorderSide(
                          color: Colors.red,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4.0)),
                        borderSide:
                            BorderSide(color: Color.fromRGBO(3, 54, 255, 1.0)),
                      ),
                      labelText: 'lozinka',
                      hasFloatingPlaceholder: true,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0))),

                  // VALIDACIJA fielda

                  validator: (input) {
                    // polje ne smije biti prazno

                    if (input == '') {
                      if (onceToast == 0) {
                        final snackBar = SnackBar(
                          duration: Duration(seconds: 2),
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Color.fromRGBO(28, 28, 28, 1.0),
                          content: Text('Password polje je prazno'),
                          action: SnackBarAction(
                            label: 'Undo',
                            onPressed: () {},
                          ),
                        );

                        Scaffold.of(context).showSnackBar(snackBar);

                        onceToast = 1;
                      }

                      return '';
                    }

                    // pass mora biti veci od 6 karaktera

                    else if (input.length < 6) {
                      if (onceToast == 0) {
                        final snackBar = SnackBar(
                          duration: Duration(seconds: 2),
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Color.fromRGBO(28, 28, 28, 1.0),
                          content:
                              Text('Password mora biti veći od 6 karaktera'),
                          action: SnackBarAction(
                            label: 'Undo',
                            onPressed: () {},
                          ),
                        );

                        Scaffold.of(context).showSnackBar(snackBar);

                        onceToast = 1;
                      }

                      return '';
                    }

                    // da li ta sifra postoji u bazi i da li odgovara unesenom mailu

                    else if (passExist != 'Pass postoji') {
                      if (onceToast == 0) {
                        final snackBar = SnackBar(
                          duration: Duration(seconds: 2),
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Color.fromRGBO(28, 28, 28, 1.0),
                          content: Text('Password nije tačan'),
                          action: SnackBarAction(
                            label: 'Undo',
                            onPressed: () {},
                          ),
                        );

                        Scaffold.of(context).showSnackBar(snackBar);

                        onceToast = 1;
                      }

                      return '';
                    }

                    return null;
                  },

                  //  setanje state-a

                  // password == input

                  onChanged: (input) {
                    setState(() {
                      _password = input;
                    });
                  },
                ),
              ),

              // container -> constrainedBox -> u kojem se nalazi button PRIJAVA

              Container(
                margin: EdgeInsets.only(
                  left: 24.0,
                  right: 24.0,
                  bottom: 284.0,
                ),
                child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      minWidth: double.infinity,
                    ),
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0),
                      ),

                      child: Text(
                        'PRIJAVA',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: 'RobotoMono',
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      color: Color.fromRGBO(3, 54, 255, 1.0),

                      // na press btn-a

                      onPressed:

                          // provjera internet konekcije

                          () async {
                        try {
                          final result =
                              await InternetAddress.lookup('google.com');

                          if (result.isNotEmpty &&
                              result[0].rawAddress.isNotEmpty) {
                            print('connected');
                          }
                        } on SocketException catch (_) {
                          print('not connected');

                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  NoInternetConnectionLogInSrceen()));
                        }

                        // zatvaranje tastature na klik dugmeta

                        FocusScopeNode currentFocus = FocusScope.of(context);

                        if (!currentFocus.hasPrimaryFocus) {
                          currentFocus.unfocus();
                        }

                        // provjera da li su oba polja prazna -> email && password

                        if (_email == '' && _password == '') {
                          if (onceToast == 0) {
                            final snackBar = SnackBar(
                              backgroundColor: Color.fromRGBO(28, 28, 28, 1.0),
                              duration: Duration(seconds: 2),
                              behavior: SnackBarBehavior.floating,
                              content: Text('Oba polja su prazna'),
                              action: SnackBarAction(
                                label: 'Undo',
                                onPressed: () {},
                              ),
                            );

                            Scaffold.of(context).showSnackBar(snackBar);

                            onceToast = 1;

                            Timer(Duration(seconds: 2), () {
                              onceToast = 0;
                            });
                          }
                        }

                        // ukoliko nisu prazna izvrsi slj funkcije -> [signIn]

                        // setamo counter [onceBtnPressed] na 1 nakon jednog klika kako bi

                        // zabranili mogucnost vise klikova

                        else {
                          if (onceBtnPressed == 0) {
                            signIn(_email, _password, userExist);

                            onceBtnPressed = 1;
                          }
                        }
                      },
                    )),
              ),

              /// FUTURE BUILDER

              //

              // ovdje provjeravamo da li password zaista postoji u bazi

              // dok se provjerava printamo [Loading]

              // ukoliko postoji =>  String [passExist] = Pass postoji

              // ukoliko ne postoji =>  String [passExist] = Pass ne postoji

              Column(
                children: <Widget>[
                  FutureBuilder(
                    future: doesPassAlreadyExist(_password),
                    builder: (context, AsyncSnapshot<bool> result) {
                      if (!result.hasData) {
                        onceToast = 0;

                        onceBtnPressed = 0;

                        print('LOADING');

                        return Container(
                          width: 0,
                          height: 0,
                        );
                      } // future still needs to be finished (loading)

                      if (result.data) {
                        passExist = 'Pass postoji';

                        onceToast = 0;

                        onceBtnPressed = 0;

                        return Container(
                          width: 0,
                          height: 0,
                        );
                      } // result.data is the returned bool from doesNameAlreadyExists

                      else {
                        passExist = 'Pass ne postoji';

                        onceToast = 0;

                        onceBtnPressed = 0;

                        return Container(
                          width: 0,
                          height: 0,
                        );
                      }
                    },
                  ),
                ],
              ),

              /// FUTURE BUILDER

              //

              // ovdje provjeravamo da li Email/User zaista postoji u bazi

              // dok se provjerava printamo [Loading]

              // ukoliko postoji =>  String [userExist] = User postoji

              // ukoliko ne postoji =>  String [userExist] = User ne postoji

              Column(
                children: <Widget>[
                  FutureBuilder(
                    future: doesNameAlreadyExist(_email),
                    builder: (context, AsyncSnapshot<bool> result) {
                      if (!result.hasData) {
                        onceToast = 0;

                        onceBtnPressed = 0;

                        print('LOADING');

                        return Container(
                          width: 0,
                          height: 0,
                        );
                      } // future still needs to be finished (loading)

                      if (result.data) {
                        onceToast = 0;

                        onceBtnPressed = 0;

                        userExist = 'User postoji';

                        return Container(
                          width: 0,
                          height: 0,
                        );
                      } // result.data is the returned bool from doesNameAlreadyExists

                      else {
                        onceToast = 0;

                        onceBtnPressed = 0;

                        userExist = 'User ne postoji';

                        passExist = 'Pass ne postoji';

                        return Container(
                          width: 0,
                          height: 0,
                        );
                      }
                    },
                  ), //FutureBuilder
                ], //<Widget>
              ), //Column
            ], //<Widget>
          ), //Column
        )
      ],
    ); //FORM
  }

  /// SIGNIN metoda
  ///
  /// metoda koja prima email i password
  /// async metoda
  /// ukoliko su validacije koje smo kreirali na textFormFields prosle
  /// onda prelazimo na upis email-a i passworda u bazu [Auth dio baze]
  /// nakon upisa povratnu informaciju spremamo u result, zatim sve informacije vezane za usera spremamo
  /// u varijablu [FirebaseUser user], nakon cega izvlacimo ID, email, i user info
  /// ukoliko sve ovo bude uspjesno, navigiramo na slj screen [ShowLoadingScreen]
  /// cjelokupna metoda upisa je umotana u try-catch blok
  /// catch-amo error ukoliko ga ima i printamo u konzolu
  signIn(_email, _password, userExist) async {
    final _formState = _formKey.currentState;
    if (_formState.validate()) {
      try {
        AuthResult result = await _auth.signInWithEmailAndPassword(
            email: _email, password: _password);
        FirebaseUser user = result.user;
        String userEmail = user.email;
        userID = user.uid;
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                ShowLoading(user: user, email: userEmail, userID: userID)));
        return print(user);
      } catch (e) {
        err = e.message;
        print(e.message);
      }
    }
  }

  /// provjera emaila
  ///
  /// ovdje nam se nalazi logika za provjeru email-a,
  /// odnosno da li user zaista postoji u bazi
  /// metoda je tipa bool
  /// spajamo se na kolekciju [LoggedUsers], gdje postavljamo query
  /// da li je email == unesenom email-u
  /// limitiramo nasu pretragu na 1 document i vracamo
  Future<bool> doesNameAlreadyExist(String name) async {
    final QuerySnapshot result = await Firestore.instance
        .collection('LoggedUsers')
        .where('email', isEqualTo: name)
        .limit(1)
        .getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    return documents.length == 1;
  }

  /// provjera sifre
  ///
  /// ovdje nam se nalazi logika za provjeru passworda,
  /// odnosno da li pass zaista postoji u bazi
  /// metoda je tipa bool
  /// spajamo se na kolekciju [LoggedUsers], gdje postavljamo query
  /// da li je pass == unesenom passwordu
  /// limitiramo nasu pretragu na 1 document i vracamo
  Future<bool> doesPassAlreadyExist(String name) async {
    final QuerySnapshot result = await Firestore.instance
        .collection('LoggedUsers')
        .where('password', isEqualTo: name)
        .limit(1)
        .getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    return documents.length == 1;
  }
}
