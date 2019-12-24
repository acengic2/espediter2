import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:retry/retry.dart';

void main() => runApp(NoInternetConnectionLogInSrceen());

const blueColor = Color.fromRGBO(3, 54, 255, 1);
const textColorGray80 = Color.fromRGBO(0, 0, 0, 0.8);
const textColorGray60 = Color.fromRGBO(0, 0, 0, 0.6);

class NoInternetConnectionLogInSrceen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NoInternetConnectionPage(title: 'No connection screen'),
    );
    // return MaterialApp(
    //   title: 'No connection screen',
    //   home: NoInternetConnectionPage(title: 'No connection screen'),
    // );
  }
}

class NoInternetConnectionPage extends StatefulWidget {
  NoInternetConnectionPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _NoInternetConnectionPageState createState() =>
      _NoInternetConnectionPageState();
}

class _NoInternetConnectionPageState extends State<NoInternetConnectionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // margin:EdgeInsets.only(top: 257.0) ,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Nemate mreže',
                  style: TextStyle(
                      fontSize: 16,
                      fontFamily: "Roboto",
                      color: textColorGray80),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8.0, bottom: 16.0),
                  child: Text(
                    "Nažalost nemate mreže. Riješite problem, pa pokušajte ponovno.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: "Roboto",
                        color: textColorGray60),
                  ),
                ),
                ButtonTheme(
                  minWidth: 154.0,
                  height: 36.0,
                  child: RaisedButton(
                    onPressed: () async {
                      try {
                        final result =
                            await InternetAddress.lookup('google.com');
                        if (result.isNotEmpty &&
                            result[0].rawAddress.isNotEmpty) {
                          print('connected');
                          Navigator.pop(this.context, false);
                        }
                      } on SocketException catch (_) {
                        print('not connected');
                        // Navigator.of(context).push(MaterialPageRoute(
                        //     builder: (context) =>
                        //         NoInternetConnectionLogInSrceen()));
                      }
                      //Navigator.pop(this.context, false);
                    },
                    color: blueColor,
                    child: Text(
                      "POKUŠAJTE PONOVO",
                      style: TextStyle(
                          fontSize: 14,
                          fontFamily: "Roboto",
                          color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> retri() async {
  // Create an HttpClient.
  final client = HttpClient();

  try {
    // Get statusCode by retrying a function
    final statusCode = await retry(
      () async {
        // Make a HTTP request and return the status code.
        final request = await client
            .getUrl(Uri.parse('https://www.google.com'))
            .timeout(Duration(seconds: 1));
        final response = await request.close().timeout(Duration(seconds: 1));
        await response.drain();
        return response.statusCode;
      },
      // Retry on SocketException or TimeoutException
      retryIf: (e) => e is SocketException || e is TimeoutException,
    );

    // Print result from status code
    if (statusCode == 200) {
      print('google.com is running');
    } else {
      print('google.com is not availble...');
    }
  } finally {
    // Always close an HttpClient from dart:io, to close TCP connections in the
    // connection pool. Many servers has keep-alive to reduce round-trip time
    // for additional requests and avoid that clients run out of port and
    // end up in WAIT_TIME unpleasantries...
    client.close();
  }
}
