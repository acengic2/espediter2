import 'package:flutter/material.dart';
import 'package:spediter/auth/singIn/singInLogic.dart';


void main() => runApp(Login());

class Login extends StatefulWidget {
  Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // banner za debug mode
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        // prazan prostor prilikom podizanja tastature
        resizeToAvoidBottomPadding: false,
        body: SingInBody(),
        //  detektor klika za zatvaranje tastature
      ),
    );
  }
}
