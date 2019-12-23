import 'package:flutter/material.dart';
import './inderdestination.dart';

typedef OnDelete();


class InterdestinationForm extends StatefulWidget {
  final Interdestination interdestination;
  final state = _UserFormState();
  final OnDelete onDelete;

  
  InterdestinationForm(
      {Key key,
      this.interdestination,
      this.onDelete,
      })
      : super(key: key);


  @override
  _UserFormState createState() => state;

      bool isValid() => state.validate();

}

class _UserFormState extends State<InterdestinationForm> {
  final form = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(bottom: 2, left: 16.0, right: 16.0, top: 2),
        child: Row(children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
              child: Icon(
                Icons.brightness_1,
                color: Color.fromRGBO(112, 112, 112, 1),
                size: 20.0,
              ),
            ),
          ),
          Expanded(
              flex: 9,
              child: Container(
                  height: 36.0,
                  margin: EdgeInsets.only(
                      bottom: 8, left: 9, right: 5,),
                  child: TextFormField(
                    initialValue: widget.interdestination.interdestinationData,
                    onChanged: (val) =>
                        widget.interdestination.interdestinationData = val,
                         validator: (val) =>
                      val.length > 3 ? null : 'Unesite ime grada',
                    decoration: InputDecoration(
                        hasFloatingPlaceholder: false,
                        suffixIcon: IconButton(
                          onPressed: widget.onDelete,
                          icon: Icon(Icons.clear),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4.0)),
                          borderSide:
                              BorderSide(color: Color.fromRGBO(0, 0, 0, 0.12)),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(4.0)),
                            borderSide: BorderSide(
                                color: Color.fromRGBO(0, 0, 0, 0.12))),
                        labelText: 'Dodaj među destinaciju',
                        labelStyle:
                            TextStyle(color: Color.fromRGBO(0, 0, 0, 0.5)),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ))),
        ]));
  }
   ///form validator
  bool validate() {
    var valid = form.currentState.validate();
    if (valid) form.currentState.save();
    return valid;
  }

}



