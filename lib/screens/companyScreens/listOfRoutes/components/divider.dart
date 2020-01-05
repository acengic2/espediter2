import 'package:flutter/material.dart';


class Divider1 extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return  /// DIVIDER
                        Container(
                          height: 8,
                          decoration: BoxDecoration(
                              border: Border(
                            top: BorderSide(
                                width: 1, color: Color.fromRGBO(0, 0, 0, 0.12)),
                            bottom: BorderSide(
                                width: 1, color: Color.fromRGBO(0, 0, 0, 0.12)),
                          )),
                          child: Divider(
                            thickness: 8,
                            color: Color.fromRGBO(0, 0, 0, 0.03),
                          ),
                        );
  }
}