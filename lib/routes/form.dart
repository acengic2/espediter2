import 'package:flutter/material.dart';
import './inderdestination.dart';

typedef OnDelete();
typedef OnAdd();

class InterdestinationForm extends StatefulWidget {
  final Interdestination interdestination;
  final state = _UserFormState();
  final OnDelete onDelete;
  final OnAdd onAdd;

  InterdestinationForm({
    Key key,
    this.interdestination,
    this.onDelete,
    this.onAdd,
  }) : super(key: key);

  @override
  _UserFormState createState() => state;

  bool isValid() => state.validate();
}

class _UserFormState extends State<InterdestinationForm> {
  final form = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(left: 18.0, right: 16.0),
        child: Row(children: <Widget>[
          Expanded(
              flex: 1,
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 0),
                    height: 12,
                    width: 0,
                    decoration: BoxDecoration(
                        border:
                            Border.all(color: Color.fromRGBO(0, 0, 0, 0.12))),
                  ),
                  Container(
                    child: Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        Container(
                            height: 20,
                            width: 20,
                            margin: EdgeInsets.only(right: 8, left: 16)),
                        Container(
                          height: 16,
                          width: 16,
                          child: Icon(
                            Icons.brightness_1,
                            color: Color.fromRGBO(0, 0, 0, 0.5),
                            size: 10.0,
                          ),
                        ),
                        Container(
                          child: Icon(
                            Icons.brightness_1,
                            color: Color.fromRGBO(0, 0, 0, 0.2),
                            size: 20.0,
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 0),
                    height: 12,
                    width: 0,
                    decoration: BoxDecoration(
                        border:
                            Border.all(color: Color.fromRGBO(0, 0, 0, 0.12))),
                  )
                ],
              )),
          Expanded(
              flex: 9,
              child: Container(
                  height: 36.0,
                  margin: EdgeInsets.only(
                    bottom: 8,
                    left: 12,
                    right: 5,
                  ),
                  child: TextFormField(
                    key: UniqueKey(),
                    onTap: widget.onAdd,
                    textCapitalization: TextCapitalization.sentences,
                    initialValue: widget.interdestination.interdestinationData,
                    onChanged: (val) =>
                        widget.interdestination.interdestinationData = val,
                    validator: (val) =>
                        val.length > 3 ? null : 'Unesite ime grada',
                    decoration: InputDecoration(
                        hasFloatingPlaceholder: false,
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
          Expanded(
              flex: 1,
              child: Container(
                margin: EdgeInsets.only(
                  bottom: 2.0,
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Container(
                      child: IconButton(
                        onPressed: widget.onDelete,
                        icon: Icon(Icons.clear),
                      ),
                    ),
                  ],
                ),
              )),
        ]));
  }

  ///form validator
  bool validate() {
    var valid = form.currentState.validate();
    if (valid) form.currentState.save();
    return valid;
  }
}
