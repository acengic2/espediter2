import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:email_validator/email_validator.dart';
import 'package:spediter/auth/loading.dart';

import 'noInternetOnLogin.dart';

void main() => runApp(Login());

class Login extends StatefulWidget {
  Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var err;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var _focusNode = new FocusNode();
  var focusNode = new FocusNode();
  String _email = '', _password = '', userExist, passExist, id;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final db = Firestore.instance;
  int onceToast = 0, onceBtnPressed = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomPadding: false,
        body: new GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: ListView(
            physics: NeverScrollableScrollPhysics(),
            children: <Widget>[
              Center(
                child: Container(
                  margin: EdgeInsets.only(top: 72.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image.asset('assets/img/Logo.png'),
                          Container(
                            margin: EdgeInsets.only(left: 16.0),
                            child: Text('e-Špediter',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'RobotoMono',
                                  fontWeight: FontWeight.w500,
                                )),
                          ),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Form(
                            key: _formKey,
                            child: Column(
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(
                                      bottom: 24.0,
                                      left: 24.0,
                                      right: 24.0,
                                      top: 24.0),
                                  child: TextFormField(
                                    focusNode: focusNode,

                                    autocorrect: false,
                                    keyboardType: TextInputType.visiblePassword,
                                    autofocus: true,
                                    enableInteractiveSelection: false,
                                    autovalidate: false,

                                    decoration: InputDecoration(
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(4.0)),
                                          borderSide: BorderSide(
                                              color: Color.fromRGBO(
                                                  0, 0, 0, 0.12)),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(4.0)),
                                          borderSide: BorderSide(
                                            color: Colors.red,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(4.0)),
                                          borderSide: BorderSide(
                                              color: Color.fromRGBO(
                                                  3, 54, 255, 1.0)),
                                        ),
                                        labelText: 'email',
                                        hasFloatingPlaceholder: true,
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.0))),
                                    validator: (input) {
                                      if (input == '') {
                                        if (onceToast == 0) {
                                          final snackBar = SnackBar(
                                            duration: Duration(seconds: 2),
                                            behavior: SnackBarBehavior.floating,
                                            backgroundColor:
                                                Color.fromRGBO(28, 28, 28, 1.0),
                                            content:
                                                Text('Email polje je prazno'),
                                            action: SnackBarAction(
                                              label: 'Undo',
                                              onPressed: () {},
                                            ),
                                          );
                                          Scaffold.of(context)
                                              .showSnackBar(snackBar);
                                          onceToast = 1;
                                        }
                                        return '';
                                      } else if (!EmailValidator.validate(
                                          input, true)) {
                                        if (onceToast == 0) {
                                          final snackBar = SnackBar(
                                            duration: Duration(seconds: 2),
                                            behavior: SnackBarBehavior.floating,
                                            backgroundColor:
                                                Color.fromRGBO(28, 28, 28, 1.0),
                                            content: Text('Email nije validan'),
                                            action: SnackBarAction(
                                              label: 'Undo',
                                              onPressed: () {},
                                            ),
                                          );
                                          Scaffold.of(context)
                                              .showSnackBar(snackBar);
                                          onceToast = 1;
                                        }
                                        return '';
                                      } else if (userExist != 'User postoji') {
                                        if (onceToast == 0) {
                                          final snackBar = SnackBar(
                                            duration: Duration(seconds: 2),
                                            behavior: SnackBarBehavior.floating,
                                            backgroundColor:
                                                Color.fromRGBO(28, 28, 28, 1.0),
                                            content: Text(
                                                'User sa unesenim emailom ne postoji'),
                                            action: SnackBarAction(
                                              label: 'Undo',
                                              onPressed: () {},
                                            ),
                                          );
                                          Scaffold.of(context)
                                              .showSnackBar(snackBar);
                                          onceToast = 1;
                                        }
                                        return '';
                                      }
                                      return null;
                                    },
                                    onChanged: (input) {
                                      setState(() {
                                        _email = input;
                                      });
                                    },
                                    //  (val) => !EmailValidator.validate(val,true)
                                    // ? 'Not a valid email' : null,
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      bottom: 24.0, left: 24.0, right: 24.0),
                                  child: TextFormField(
                                    focusNode: _focusNode,
                                    decoration: InputDecoration(
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(4.0)),
                                          borderSide: BorderSide(
                                              color: Color.fromRGBO(
                                                  0, 0, 0, 0.12)),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(4.0)),
                                          borderSide: BorderSide(
                                            color: Colors.red,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(4.0)),
                                          borderSide: BorderSide(
                                              color: Color.fromRGBO(
                                                  3, 54, 255, 1.0)),
                                        ),
                                        labelText: 'lozinka',
                                        hasFloatingPlaceholder: true,
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.0))),
                                    validator: (input) {
                                      if (input == '') {
                                        if (onceToast == 0) {
                                          final snackBar = SnackBar(
                                            duration: Duration(seconds: 2),
                                            behavior: SnackBarBehavior.floating,
                                            backgroundColor:
                                                Color.fromRGBO(28, 28, 28, 1.0),
                                            content: Text(
                                                'Password polje je prazno'),
                                            action: SnackBarAction(
                                              label: 'Undo',
                                              onPressed: () {},
                                            ),
                                          );
                                          Scaffold.of(context)
                                              .showSnackBar(snackBar);
                                          onceToast = 1;
                                        }
                                        return '';
                                      } else if (input.length < 6) {
                                        if (onceToast == 0) {
                                          final snackBar = SnackBar(
                                            duration: Duration(seconds: 2),
                                            behavior: SnackBarBehavior.floating,
                                            backgroundColor:
                                                Color.fromRGBO(28, 28, 28, 1.0),
                                            content: Text(
                                                'Password mora biti veći od 6 karaktera'),
                                            action: SnackBarAction(
                                              label: 'Undo',
                                              onPressed: () {},
                                            ),
                                          );
                                          Scaffold.of(context)
                                              .showSnackBar(snackBar);
                                          onceToast = 1;
                                        }
                                        return '';
                                      } else if (passExist != 'Pass postoji') {
                                        if (onceToast == 0) {
                                          final snackBar = SnackBar(
                                            duration: Duration(seconds: 2),
                                            behavior: SnackBarBehavior.floating,
                                            backgroundColor:
                                                Color.fromRGBO(28, 28, 28, 1.0),
                                            content:
                                                Text('Password nije tačan'),
                                            action: SnackBarAction(
                                              label: 'Undo',
                                              onPressed: () {},
                                            ),
                                          );
                                          Scaffold.of(context)
                                              .showSnackBar(snackBar);
                                          onceToast = 1;
                                        }
                                        return '';
                                      }
                                      return null;
                                    },
                                    obscureText: true,
                                    onChanged: (input) {
                                      setState(() {
                                        _password = input;
                                      });
                                    },
                                  ),
                                ),
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
                                        borderRadius:
                                            BorderRadius.circular(4.0),
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
                                      onPressed: () async {
                                        try {
                                          final result =
                                              await InternetAddress.lookup(
                                                  'google.com');
                                          if (result.isNotEmpty &&
                                              result[0].rawAddress.isNotEmpty) {
                                            print('connected');
                                          }
                                        } on SocketException catch (_) {
                                          print('not connected');
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      NoInternetConnectionLogInSrceen()));
                                        }

                                        FocusScopeNode currentFocus =
                                            FocusScope.of(context);
                                        if (!currentFocus.hasPrimaryFocus) {
                                          currentFocus.unfocus();
                                        }

                                        if (_email == '' && _password == '') {
                                          if (onceToast == 0) {
                                            final snackBar = SnackBar(
                                              backgroundColor: Color.fromRGBO(
                                                  28, 28, 28, 1.0),
                                              duration: Duration(seconds: 2),
                                              behavior:
                                                  SnackBarBehavior.floating,
                                              content:
                                                  Text('Oba polja su prazna'),
                                              action: SnackBarAction(
                                                label: 'Undo',
                                                onPressed: () {},
                                              ),
                                            );
                                            Scaffold.of(context)
                                                .showSnackBar(snackBar);
                                            onceToast = 1;
                                            Timer(Duration(seconds: 2), () {
                                              onceToast = 0;
                                            });
                                          }
                                        } else {
                                          if (onceBtnPressed == 0) {
                                            signIn(
                                                _email, _password, userExist);
                                            onceBtnPressed = 1;
                                          }
                                        }
                                      },
                                    ),
                                  ),
                                ),
                                Column(
                                  children: <Widget>[
                                    FutureBuilder(
                                      future: doesPassAlreadyExist(_password),
                                      builder: (context,
                                          AsyncSnapshot<bool> result) {
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
                                Column(
                                  children: <Widget>[
                                    FutureBuilder(
                                      future: doesNameAlreadyExist(_email),
                                      builder: (context,
                                          AsyncSnapshot<bool> result) {
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
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  signIn(_email, _password, userExist) async {
    final _formState = _formKey.currentState;
    if (_formState.validate()) {
      try {
        AuthResult result = await _auth.signInWithEmailAndPassword(
            email: _email, password: _password);
        FirebaseUser user = result.user;
        String userEmail = user.email;
        // print('SADSADSADDSADSAD $userEmail');
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ShowLoading(user: user, email: userEmail)));
        print('User ' + user.email + ' je uspjesno logovan');
        return print(user);
      } catch (e) {
        err = e.message;
        print(e.message);
      }
    }
  }

// provjera emaila
  Future<bool> doesNameAlreadyExist(String name) async {
    final QuerySnapshot result = await Firestore.instance
        .collection('LoggedUsers')
        .where('email', isEqualTo: name)
        .limit(1)
        .getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    return documents.length == 1;
  }

  // provjera sifre
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
