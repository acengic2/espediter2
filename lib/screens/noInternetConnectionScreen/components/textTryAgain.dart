import 'package:flutter/material.dart';

const blueColor = Color.fromRGBO(3, 54, 255, 1);
const textColorGray80 = Color.fromRGBO(0, 0, 0, 0.8);
const textColorGray60 = Color.fromRGBO(0, 0, 0, 0.6);

class TryAgain extends StatelessWidget {
  
  String tryAgainStingFirstMessage = "Nemate mreže";
  String tryAgainStingSecondMessage ="Nažalost nemate mreže. Riješite problem pa pokušajte ponovno.";
  String buttonText = "POKUSAJTE PONOVO";
  

 

  @override
  Widget build(BuildContext context) {
return Container(
        // margin:EdgeInsets.only(top: 257.0) ,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  tryAgainStingFirstMessage,
                  style: TextStyle(
                      fontSize: 16,
                      fontFamily: "Roboto",
                      color: textColorGray80),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8.0, bottom: 16.0),
                  child: Text(
                    tryAgainStingSecondMessage,
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
                    onPressed: () {},
                    color: blueColor,
                    child: Text(buttonText,
                      
                      style: TextStyle(
                          fontSize: 14,
                          fontFamily: "Roboto",
                          color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
  }
}