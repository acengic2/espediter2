import 'package:flutter/services.dart';
import 'package:spediter/auth/signIn.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
    .then((_) {
      runApp(new MyApp());
    });

}
class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {


    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Login()
          // StreamBuilder(
          //   stream: Connectivity().onConnectivityChanged,
          //     builder: (BuildContext ctxt,
          //         AsyncSnapshot<ConnectivityResult> snapShot) {
          //       if (!snapShot.hasData) return ShowLoading();
          //       var result = snapShot.data;
          //       switch (result) {
          //         case ConnectivityResult.none:
          //           print("no net");
          //           return Center(child:NoInternetConnectionLogInSrceen());
          //         case ConnectivityResult.mobile:
          //         case ConnectivityResult.wifi:
          //           print("yes net");
          //           return Center(
          //             child: Login()
          //           );
          //         default:
          //           return Center(child:NoInternetConnectionLogInSrceen());
          //       }
          //     }
          //   ),

          ),
          );
  }
}
