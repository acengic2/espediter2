import 'package:flutter/material.dart';

class LoadingComponent extends StatelessWidget {
  
  String loadingStingFirstMessage;
  String loadingStingSecondMessage;

  LoadingComponent(
      this.loadingStingFirstMessage, this.loadingStingSecondMessage);

  @override
  Widget build(BuildContext context) {
    return Center(
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
            loadingStingFirstMessage,
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'RobotoMono',
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        Container(
          child: Text(
            loadingStingSecondMessage,
            style: TextStyle(
              fontSize: 14,
              fontFamily: 'RobotoMono',
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    ));
  }
}
