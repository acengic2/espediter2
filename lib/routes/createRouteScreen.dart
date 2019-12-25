import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:responsive_container/responsive_container.dart';
import 'package:spediter/routes/form.dart';
import './inderdestination.dart';
import 'package:spediter/routes/noRoutes.dart';
import 'package:flutter/rendering.dart';
import 'listOfRoutes.dart';

void main() => runApp(CreateRoute());

const blueColor = Color.fromRGBO(3, 54, 255, 1);
const textColorGray80 = Color.fromRGBO(0, 0, 0, 0.8);
const textColorGray60 = Color.fromRGBO(0, 0, 0, 0.6);
NoRoutes noRoutes = new NoRoutes();

class CreateRoute extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kreiraj Rutu',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // localizationsDelegates: [
      //   // ... app-specific localization delegate[s] here
      //   GlobalMaterialLocalizations.delegate,
      //   GlobalWidgetsLocalizations.delegate,
      // ],
      // supportedLocales: [
      //   const Locale('bs'), // Bosnian
      //   const Locale('en'), // English
      // ],
      home: CreateRouteScreenPage(title: 'Kreiraj Rutu'),
    );
  }
}

class CreateRouteScreenPage extends StatefulWidget {
  CreateRouteScreenPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _CreateRouteScreenPageState createState() => _CreateRouteScreenPageState();
}

class _CreateRouteScreenPageState extends State<CreateRouteScreenPage> {
  List<InterdestinationForm> interdestinations = [];

  final format = DateFormat("dd MMMM");
  final formatTime = DateFormat("HH:mm");
  final formatP = DateFormat('dd/MM/yyyy');
  // key za formu
  final _formKey = GlobalKey<FormState>();
  // instanca za bazu
  final db = Firestore.instance;

  // fokusi
  var focusPercentage = new FocusNode();
  var focusCapacity = new FocusNode();
  var focusGoods = new FocusNode();
  var focusDimensions = new FocusNode();
  var focusStarting = new FocusNode();
  var focusEnding = new FocusNode();

  int onceToast = 0, onceBtnPressed = 0;

  var controller = new MaskedTextController(
    mask: '0.00',
  );

  // variables
  String userUid;
  String userID;
  String id;
//  ScrollController _scroll;
  String listOfInterdestinations = "";
  String goodsVar = '',
      dimensionsVar = '',
      selectedDateStringP,
      selectedDateStringD,
      endingDestination,
      startingDestination,
      vehicleVar,
      stringKonacnoP,
      stringKonacnoD,
      timeP,
      formatted,
      formatted2,
      timeD;
  int percentageVar;
  String capacityVar;
  String capacityBaza;

  DateTime selectedDateP;
  DateTime selectedDateD;

  // DateTime selectedDateP = DateTime.now();
  // DateTime selectedDateD = DateTime.now();

  // DROPDOWN LISTA VOZILA
  List<Vehicle> _vehicle = Vehicle.getVehicle();
  List<DropdownMenuItem<Vehicle>> _dropdownMenuItems;
  Vehicle _selectedVehicle;

  bool _isBtnDisabled = true;

  getUserid() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final FirebaseUser user = await _auth.currentUser();

    Firestore.instance
        .collection('LoggedUsers') //goes to collection LoggedUsers on firebase
        .document(user.uid) // takes user.id
        .snapshots()
        .toString();

    userID = user.uid;
    print('Ovo je user id ' + userID);
  }

  @override
  void initState() {
    _dropdownMenuItems = buildDropdownMenuItems(_vehicle);
    //_selectedVehicle = _dropdownMenuItems[0].value;
    super.initState();

    getUserid();
    onceToast = 0;
  }

  List<DropdownMenuItem<Vehicle>> buildDropdownMenuItems(List vehicles) {
    List<DropdownMenuItem<Vehicle>> items = List();

    for (Vehicle vehicle in vehicles) {
      items.add(DropdownMenuItem(value: vehicle, child: Text(vehicle.name)));
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    void onDelete(Interdestination _interdestination) {
      setState(() {
        var find = interdestinations.firstWhere(
          (it) => it.interdestination == _interdestination,
          orElse: () => null,
        );
        if (find != null)
          interdestinations.removeAt(interdestinations.indexOf(find));
      });
    }

    ///on add form
    void onAddForm() {
      setState(() {
        var _interdestination = Interdestination();
        interdestinations.add(InterdestinationForm(
          interdestination: _interdestination,
          onDelete: () => onDelete(_interdestination),
          onAdd: () => onAddForm(),
        ));
      });
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          color: Colors.black,
          icon: Icon(Icons.clear),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ListOfRoutes(userID: userID)),
            );
          },
        ),
        title: const Text('Kreiranje Rute',
            style: TextStyle(color: Color.fromRGBO(0, 0, 0, 0.8))),
      ),
      body: Builder(
        builder: (context) => new GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
            onceToast = 0;
          },
          child: ListView(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        ///datum i vrijeme polaska
                        Container(
                          margin: EdgeInsets.only(
                              bottom: 8, left: 16.0, right: 16.0, top: 16),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 5,
                                child: Container(
                                  height: 36.0,
                                  padding:
                                      EdgeInsets.only(left: 4.0, right: 4.0),
                                  child: DateTimeField(
                                    // style: TextStyle(fontSize: 10.0),
                                    resetIcon: null,
                                    readOnly: true,
                                    decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(4.0)),
                                        borderSide: BorderSide(
                                            color:
                                                Color.fromRGBO(0, 0, 0, 0.12)),
                                      ),
                                      hintText: 'Datum polaska',
                                      contentPadding: EdgeInsets.fromLTRB(
                                          20.0, 10.0, 20.0, 10.0),
                                    ),
                                    format: format,
                                    onShowPicker:
                                        (context, currentValue) async {
                                      final DateTime picked =
                                          await showDatePicker(
                                              context: context,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime(2018),
                                              lastDate: DateTime(2100));
                                      setState(() {
                                        selectedDateP = picked;
                                        if (selectedDateP == null) {
                                          selectedDateP = DateTime.now();
                                        } else {
                                          selectedDateP = picked;
                                        }
                                      });
                                      setState(() {
                                        formatted =
                                            formatP.format(selectedDateP);
                                        if (selectedDateP == null) {
                                          selectedDateP = DateTime.now();
                                        } else {
                                          selectedDateP = picked;
                                        }
                                      });
                                      return selectedDateP;
                                    },
                                    onChanged: (input) {
                                      onceToast = 0;
                                      onceBtnPressed = 0;
                                      areFieldsEmpty();
                                    },
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 5,
                                child: Container(
                                  height: 36.0,
                                  margin:
                                      EdgeInsets.only(left: 4.0, right: 4.0),
                                  child: DateTimeField(
                                    resetIcon: null,
                                    readOnly: true,
                                    //textAlign: TextAlign.center,
                                    decoration: InputDecoration(
                                      hintText: "Vrijeme polaska",
                                      contentPadding: EdgeInsets.fromLTRB(
                                          20.0, 10.0, 20.0, 10.0),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(4.0)),
                                        borderSide: BorderSide(
                                            color:
                                                Color.fromRGBO(0, 0, 0, 0.12)),
                                      ),
                                    ),
                                    format: formatTime,
                                    onShowPicker:
                                        (context, currentValue) async {
                                      // currentValue = DateTime.now();s
                                      final time = await showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.fromDateTime(
                                            currentValue ?? DateTime.now()),
                                      );
                                      setState(() {
                                        timeP = time.toString();
                                      });
                                      if (timeP == 'null') {
                                        timeP = '';
                                      } else if (timeP != 'null') {
                                        return DateTimeField.convert(time);
                                      }
                                    },
                                    onChanged: (input) {
                                      onceToast = 0;
                                      onceBtnPressed = 0;
                                      areFieldsEmpty();
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        /// DEstinaije polaksa

                        Container(
                            margin: EdgeInsets.only(
                                bottom: 2, left: 16.0, right: 16.0, top: 2),
                            child: Row(children: <Widget>[
                              Expanded(
                                  flex: 1,
                                  child: Container(
                                    margin: EdgeInsets.only(bottom: 10.0),
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: <Widget>[
                                        Container(
                                          child: Icon(
                                            Icons.brightness_1,
                                            color:
                                                Color.fromRGBO(3, 54, 255, 1.0),
                                            size: 15.0,
                                          ),
                                        ),
                                        Container(
                                          child: Icon(
                                            Icons.brightness_1,
                                            color:
                                                Color.fromRGBO(3, 54, 255, 0.2),
                                            size: 30.0,
                                          ),
                                        )
                                      ],
                                    ),
                                  )),
                              Expanded(
                                  flex: 9,
                                  child: Container(
                                      margin: EdgeInsets.only(
                                          left: 9, bottom: 8, right: 5),
                                      height: 36,
                                      child: TextFormField(
                                        textCapitalization:
                                            TextCapitalization.sentences,
                                        //   onFieldSubmitted: (term) => _add(),
                                        decoration: InputDecoration(
                                            hasFloatingPlaceholder: false,
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(4.0)),
                                              borderSide: BorderSide(
                                                  color: Color.fromRGBO(
                                                      0, 0, 0, 0.12)),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(4.0)),
                                                borderSide: BorderSide(
                                                    color: Color.fromRGBO(
                                                        0, 0, 0, 0.12))),
                                            labelText: 'Startna destinacija',
                                            labelStyle: TextStyle(
                                                color: Color.fromRGBO(
                                                    0, 0, 0, 0.5)),
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        5.0))),
                                        onChanged: (input) {
                                          setState(() {
                                            onceToast = 0;
                                            onceBtnPressed = 0;
                                            startingDestination = input;
                                            areFieldsEmpty();
                                          });
                                        },
                                      )))
                            ])),

                        // Medju dest

                        Container(
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: SizedBox(
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    addAutomaticKeepAlives: true,
                                    itemCount: interdestinations.length,
                                    itemBuilder: (_, i) => interdestinations[i]
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        ///KRajna destinacije

                        Container(
                            margin: EdgeInsets.only(
                                bottom: 2, left: 16.0, right: 16.0, top: 2),
                            child: Row(children: <Widget>[
                              Expanded(
                                  flex: 1,
                                  child: Container(
                                    margin: EdgeInsets.only(bottom: 10.0),
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: <Widget>[
                                        Container(
                                          child: Icon(
                                            Icons.brightness_1,
                                            color:
                                                Color.fromRGBO(174, 7, 37, 1.0),
                                            size: 15.0,
                                          ),
                                        ),
                                        Container(
                                          child: Icon(
                                            Icons.brightness_1,
                                            color:
                                                Color.fromRGBO(174, 7, 37, 0.2),
                                            size: 30.0,
                                          ),
                                        )
                                      ],
                                    ),
                                  )),
                              Expanded(
                                  flex: 9,
                                  child: Container(
                                      margin: EdgeInsets.only(
                                          left: 9, bottom: 8, right: 5),
                                      height: 36,
                                      child: TextFormField(
                                        onTap: onAddForm,
                                        textCapitalization:
                                            TextCapitalization.sentences,
                                        // onFieldSubmitted: (term) => _add(),

                                        decoration: InputDecoration(
                                            hasFloatingPlaceholder: false,
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(4.0)),
                                              borderSide: BorderSide(
                                                  color: Color.fromRGBO(
                                                      0, 0, 0, 0.12)),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(4.0)),
                                                borderSide: BorderSide(
                                                    color: Color.fromRGBO(
                                                        0, 0, 0, 0.12))),
                                            labelText: 'Krajnja destinacija',
                                            labelStyle: TextStyle(
                                                color: Color.fromRGBO(
                                                    0, 0, 0, 0.5)),
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        5.0))),
                                        onChanged: (input) {
                                          setState(() {
                                            onceToast = 0;
                                            onceBtnPressed = 0;
                                            endingDestination = input;
                                            areFieldsEmpty();
                                          });
                                        },
                                      )))
                            ])),

                        Container(
                          margin: EdgeInsets.only(
                              bottom: 11.5, left: 16.0, right: 16.0, top: 2),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 5,
                                child: Container(
                                  height: 36.0,
                                  padding:
                                      EdgeInsets.only(left: 4.0, right: 4.0),
                                  child: DateTimeField(
                                    // style: TextStyle(fontSize: 10.0),
                                    resetIcon: null,
                                    readOnly: true,
                                    decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(4.0)),
                                        borderSide: BorderSide(
                                            color:
                                                Color.fromRGBO(0, 0, 0, 0.12)),
                                      ),
                                      hintText: 'Datum dolaska',
                                      contentPadding: EdgeInsets.fromLTRB(
                                          20.0, 10.0, 20.0, 10.0),
                                    ),
                                    format: format,

                                    onShowPicker:
                                        (context, currentValue) async {
                                      final DateTime picked =
                                          await showDatePicker(
                                              context: context,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime(2018),
                                              lastDate: DateTime(2100));
                                      setState(() {
                                        selectedDateD = picked;
                                        if (selectedDateD == null) {
                                          selectedDateD = DateTime.now();
                                        } else {
                                          selectedDateD = picked;
                                        }
                                      });
                                      setState(() {
                                        formatted2 =
                                            formatP.format(selectedDateD);
                                        if (selectedDateD == null) {
                                          selectedDateD = DateTime.now();
                                        } else {
                                          selectedDateD = picked;
                                        }
                                      });
                                      return selectedDateD;
                                    },
                                    onChanged: (input) {
                                      onceToast = 0;
                                      onceBtnPressed = 0;
                                      areFieldsEmpty();
                                    },
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 5,
                                child: Container(
                                  height: 36.0,
                                  margin:
                                      EdgeInsets.only(left: 4.0, right: 4.0),
                                  child: DateTimeField(
                                    resetIcon: null,
                                    readOnly: true,
                                    decoration: InputDecoration(
                                        hintText: "Vrijeme dolaska",
                                        contentPadding: EdgeInsets.fromLTRB(
                                            20.0, 10.0, 20.0, 10.0),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(4.0)),
                                          borderSide: BorderSide(
                                              color: Color.fromRGBO(
                                                  0, 0, 0, 0.12)),
                                        )),
                                    format: formatTime,
                                    onShowPicker:
                                        (context, currentValue) async {
                                      final time1 = await showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.fromDateTime(
                                            currentValue ?? DateTime.now()),
                                      );
                                      setState(() {
                                        timeD = time1.toString();
                                        // if(timeD == def)
                                      });
                                      if (timeD == 'null') {
                                        timeD = '';
                                      } else if (timeD != 'null') {
                                        return DateTimeField.convert(time1);
                                      }
                                    },
                                    onChanged: (input) {
                                      onceToast = 0;
                                      onceBtnPressed = 0;
                                      areFieldsEmpty();
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

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
                        ),

                        ////// Popunjenost u procentimaaaaaaaaaaaaaaaaa
                        Container(
                          margin: EdgeInsets.only(
                              bottom: 2, left: 16.0, right: 16.0, top: 11.5),
                          child: TextFormField(
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: false),
                            focusNode: focusPercentage,
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4.0)),
                                  borderSide: BorderSide(
                                      color: Color.fromRGBO(0, 0, 0, 0.12)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4.0)),
                                    borderSide: BorderSide(
                                        color: Color.fromRGBO(0, 0, 0, 0.12))),
                                labelText: 'Popunjenost u procentima',
                                labelStyle: TextStyle(
                                    color: Color.fromRGBO(0, 0, 0, 0.5)),
                                hasFloatingPlaceholder: true,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0))),
                            onChanged: (input) {
                              setState(() {
                                //var one = int.parse(input);
                                if (input != '') {
                                  percentageVar = int.parse(input);
                                } else {
                                  percentageVar = null;
                                }
                                onceToast = 0;
                                onceBtnPressed = 0;
                                areFieldsEmpty();
                              });
                            },
                          ),
                        ),

                        ////// kapacitet y tonamaaaaaaaa

                        Container(
                          margin: EdgeInsets.only(
                              bottom: 4.5, left: 16.0, right: 16.0, top: 4.5),
                          child: TextFormField(
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                            controller: controller,
                            focusNode: focusCapacity,
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4.0)),
                                  borderSide: BorderSide(
                                      color: Color.fromRGBO(0, 0, 0, 0.12)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4.0)),
                                    borderSide: BorderSide(
                                        color: Color.fromRGBO(0, 0, 0, 0.12))),
                                labelText: 'Kapacitet u tonama',
                                labelStyle: TextStyle(
                                    color: Color.fromRGBO(0, 0, 0, 0.5)),
                                hasFloatingPlaceholder: true,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0))),
                            onChanged: (input) {
                              setState(() {
                                capacityVar = input;
                                onceToast = 0;
                                onceBtnPressed = 0;
                                areFieldsEmpty();
                              });
                            },
                          ),
                        ),

                        //// VRSTE VOZILAAAA
                        ///
                        ResponsiveContainer(
                          heightPercent:
                              (68.0 / MediaQuery.of(context).size.height) * 100,
                          widthPercent: 100.0,
                          child: Container(
                            margin: EdgeInsets.only(
                                bottom: 4.5, left: 16.0, right: 16.0, top: 4.5),
                            decoration: ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    width: 1.0,
                                    style: BorderStyle.solid,
                                    color: Color.fromRGBO(0, 0, 0, 0.12)),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.0)),
                              ),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 10.0, top: 5.0),
                              child: DropdownButton(
                                // JUSUF - Izbacio ubacio hint i disabledHint:
                                hint: Text('Vrsta Vozila'),
                                disabledHint: Text('Vrsta Vozila'),
                                value: _selectedVehicle,
                                style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: "Roboto",
                                    color: Color.fromRGBO(0, 0, 0, 0.5)),
                                isExpanded: true,
                                items: _dropdownMenuItems,
                                underline: Container(color: Colors.white),
                                onChanged: onChangeDropdownItem,
                              ),
                            ),
                          ),
                        ),

                        // VRSTE ROBEEEEEEEEEE
                        Container(
                          margin: EdgeInsets.only(
                              bottom: 4.5, left: 16.0, right: 16.0, top: 4.5),
                          child: TextFormField(
                            textCapitalization: TextCapitalization.sentences,
                            focusNode: focusGoods,
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4.0)),
                                  borderSide: BorderSide(
                                      color: Color.fromRGBO(0, 0, 0, 0.12)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4.0)),
                                    borderSide: BorderSide(
                                        color: Color.fromRGBO(0, 0, 0, 0.12))),
                                labelText: 'Vrsta robe',
                                labelStyle: TextStyle(
                                    color: Color.fromRGBO(0, 0, 0, 0.5)),
                                hasFloatingPlaceholder: true,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0))),
                            onChanged: (input) {
                              setState(() {
                                goodsVar = input;
                                onceToast = 0;
                                onceBtnPressed = 0;
                                areFieldsEmpty();
                              });
                            },
                          ),
                        ),

                        ///DIMENZIJEEE
                        Container(
                          margin: EdgeInsets.only(
                              bottom: 4.5, left: 16.0, right: 16.0, top: 8),
                          child: TextFormField(
                            textCapitalization: TextCapitalization.sentences,
                            focusNode: focusDimensions,
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4.0)),
                                  borderSide: BorderSide(
                                      color: Color.fromRGBO(0, 0, 0, 0.12)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4.0)),
                                    borderSide: BorderSide(
                                        color: Color.fromRGBO(0, 0, 0, 0.12))),
                                labelText: 'Dimenzije',
                                hintText: '16m x 2.5m x 3m',
                                labelStyle: TextStyle(
                                    color: Color.fromRGBO(0, 0, 0, 0.5)),
                                hasFloatingPlaceholder: true,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0))),
                            onChanged: (input) {
                              setState(() {
                                dimensionsVar = input;
                                onceToast = 0;
                                onceBtnPressed = 0;
                                areFieldsEmpty();
                              });
                            },
                          ),
                        ),

                        /// BUTTOON
                        Container(
                          margin: EdgeInsets.only(
                            left: 16.0,
                            right: 16.0,
                            bottom: 56.0,
                            top: 8,
                          ),
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(
                              minWidth: double.infinity,
                            ),
                            child: RaisedButton(
                                disabledColor: Color.fromRGBO(219, 219, 219, 1),
                                disabledTextColor: Color.fromRGBO(0, 0, 0, 1),
                                color: Color.fromRGBO(3, 54, 255, 1),
                                textColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                child: Text(
                                  'KREIRAJ RUTU',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                onPressed: _isBtnDisabled
                                    ? null
                                    : () {
                                        // async {
                                        //     try {
                                        //       final result =
                                        //           await InternetAddress.lookup(
                                        //               'google.com');
                                        //       if (result.isNotEmpty &&
                                        //           result[0].rawAddress.isNotEmpty) {
                                        //         print('connected');
                                        //         Navigator.push(
                                        //           context,
                                        //           MaterialPageRoute(
                                        //               builder: (context) =>
                                        //                   CreateRoute()),
                                        //         );
                                        //       }
                                        //     } on SocketException catch (_) {
                                        //       print('not connected');
                                        //       Navigator.of(context).push(
                                        //           MaterialPageRoute(
                                        //               builder: (context) =>
                                        //                   NoInternetConnectionLogInSrceen()));
                                        //     }

                                        FocusScopeNode currentFocus =
                                            FocusScope.of(context);
                                        if (!currentFocus.hasPrimaryFocus) {
                                          currentFocus.unfocus();
                                        }
                                        if ((percentageVar == null) ||
                                            (dimensionsVar == '') ||
                                            (capacityVar == null) ||
                                            (goodsVar == '') ||
                                            (endingDestination == '') ||
                                            (startingDestination == '') ||
                                            (selectedDateD == null) ||
                                            (selectedDateP == null) ||
                                            (timeD == null) ||
                                            (timeP == null)) {
                                          if (onceToast == 0) {
                                            final snackBar = SnackBar(
                                              duration: Duration(seconds: 2),
                                              behavior:
                                                  SnackBarBehavior.floating,
                                              backgroundColor: Color.fromRGBO(
                                                  28, 28, 28, 1.0),
                                              content: Text(
                                                  'Sva polja moraju biti popunjena'),
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
                                        } else if (percentageVar < 0 ||
                                            percentageVar > 100) {
                                          if (onceToast == 0) {
                                            final snackBar = SnackBar(
                                              duration: Duration(seconds: 2),
                                              behavior:
                                                  SnackBarBehavior.floating,
                                              backgroundColor: Color.fromRGBO(
                                                  28, 28, 28, 1.0),
                                              content: Text(
                                                  'Unesite broj od 0 do 100'),
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
                                        }
                                        TimeOfDay t = TimeOfDay(
                                            hour: int.parse(DateFormat('kk:mm')
                                                .format(DateTime.now())
                                                .split(":")[0]),
                                            minute: int.parse(
                                                DateFormat('kk:mm')
                                                    .format(DateTime.now())
                                                    .split(":")[1]));
                                        if (formatted2.compareTo(formatP
                                                .format(DateTime.now())) <
                                            0) {
                                          if (onceToast == 0) {
                                            final snackBar = SnackBar(
                                              duration: Duration(seconds: 2),
                                              behavior:
                                                  SnackBarBehavior.floating,
                                              backgroundColor: Color.fromRGBO(
                                                  28, 28, 28, 1.0),
                                              content: Text(
                                                  'Datum dolaska ne može biti manji od današnjeg datuma.'),
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
                                        } else if (formatted2.compareTo(formatP
                                                .format(DateTime.now())) ==
                                            0) {
                                          if (timeD.compareTo(t.toString()) <
                                              0) {
                                            if (onceToast == 0) {
                                              final snackBar = SnackBar(
                                                duration: Duration(seconds: 2),
                                                behavior:
                                                    SnackBarBehavior.floating,
                                                backgroundColor: Color.fromRGBO(
                                                    28, 28, 28, 1.0),
                                                content: Text(
                                                    'Datum dolaska je jednak današnjem datumu, ali vrijeme dolaska ne može biti manje od trenutnog vremena.'),
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
                                          }
                                          if (timeD.compareTo(t.toString()) ==
                                              0) {
                                            if (onceToast == 0) {
                                              final snackBar = SnackBar(
                                                duration: Duration(seconds: 2),
                                                behavior:
                                                    SnackBarBehavior.floating,
                                                backgroundColor: Color.fromRGBO(
                                                    28, 28, 28, 1.0),
                                                content: Text(
                                                    'Datum dolaska i vrijeme dolaska ne mogu biti jednaki današnjem datumu i trenutnom vremenu.'),
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
                                          }
                                        } else if (formatted2.compareTo(formatP
                                                .format(DateTime.now())) >
                                            0) {
                                          if (formatted.compareTo(formatted2) >
                                              0) {
                                            if (onceToast == 0) {
                                              final snackBar = SnackBar(
                                                duration: Duration(seconds: 2),
                                                behavior:
                                                    SnackBarBehavior.floating,
                                                backgroundColor: Color.fromRGBO(
                                                    28, 28, 28, 1.0),
                                                content: Text(
                                                    'Datum polaska ne može biti veći od datuma dolaska.'),
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
                                          } else if (formatted
                                                  .compareTo(formatted2) ==
                                              0) {
                                            if (timeP.compareTo(timeD) > 0) {
                                              if (onceToast == 0) {
                                                final snackBar = SnackBar(
                                                  duration:
                                                      Duration(seconds: 2),
                                                  behavior:
                                                      SnackBarBehavior.floating,
                                                  backgroundColor:
                                                      Color.fromRGBO(
                                                          28, 28, 28, 1.0),
                                                  content: Text(
                                                      'Vrijeme polaska ne može biti veće od vremena dolaska, ako su datumi jednaki.'),
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
                                            } else if (timeP.compareTo(timeD) ==
                                                0) {
                                              if (onceToast == 0) {
                                                final snackBar = SnackBar(
                                                  duration:
                                                      Duration(seconds: 2),
                                                  behavior:
                                                      SnackBarBehavior.floating,
                                                  backgroundColor:
                                                      Color.fromRGBO(
                                                          28, 28, 28, 1.0),
                                                  content: Text(
                                                      'Datumi i vremena ne mogu biti jednaki.'),
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
                                            }
                                        } else {
                                          if (onceBtnPressed == 0) {
                                            print('btn kreiraj');
                                            onSave();
                                            createData();
                                            onceBtnPressed = 1;
                                          }
                                        }
                                        }
                                      }),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
        // ),]
      ),
    );
  }

  ///on save forms
  void onSave() {
    if (interdestinations.length > 0) {
      var allValid = true;
      interdestinations.forEach((form) => allValid = allValid);
      if (allValid) {
        var data = interdestinations.map((it) => it.interdestination).toList();

        print(data.length);
        for (int i = 0; i < data.length; i++) {
          listOfInterdestinations += ', ${data[i].interdestinationData}';
        }
        print(listOfInterdestinations);
      }
    }
  }

// funckija koja provjerava da li su polja prazna i enable/disable btn
  areFieldsEmpty() {
    if ((percentageVar != null) &&
        (dimensionsVar != '' && dimensionsVar != null) &&
        (capacityVar != null && capacityVar != '') &&
        (goodsVar != '' && goodsVar != null) &&
        (endingDestination != '' && endingDestination != null) &&
        (startingDestination != '' && startingDestination != null) &&
        (selectedDateD != null) &&
        (selectedDateP != null) &&
        (timeD != null && timeD != '' && timeD != 'Vrijeme dolaska') &&
        (timeP != null && timeP != '' && timeP != 'Vrijeme polaska') &&
        (_selectedVehicle != null)) {
      _isBtnDisabled = false;
    } else if ((percentageVar == null) ||
        (dimensionsVar == '' || dimensionsVar == null) ||
        (capacityVar == null || capacityVar == '') ||
        (goodsVar == '' || goodsVar == null) ||
        (endingDestination == '' || endingDestination == null) ||
        (startingDestination == '' || startingDestination == null) ||
        (selectedDateD == null) ||
        (selectedDateP == null) ||
        (timeD == null || timeD == '' || timeD == 'Vrijeme dolaska') ||
        (timeP == null || timeP == '' || timeP == 'Vrijeme polaska') ||
        (_selectedVehicle == null)) {
      _isBtnDisabled = true;
    }
  }

  // funkcija koja snima informacije u bazu
  createData() async {
    DocumentReference ref = await db.collection('Rute').add({
      'availability': '$percentageVar',
      'capacity': '$capacityVar',
      'ending_destination': '$endingDestination',
      'starting_destination': '$startingDestination',
      'interdestination': '$listOfInterdestinations',
      'arrival_date': '$formatted2',
      'arrival_time': '$timeP',
      'departure_time': '$timeD',
      'departure_date': '$formatted',
      'dimensions': '$dimensionsVar',
      'goods': '$goodsVar',
      'vehicle': '$vehicleVar',
      'user_id': '$userID'
    });
    print('proslo1111');
    setState(() => id = ref.documentID);
    print(ref.documentID);
    print('Unos uspjesan');
    // navigiramo do ListOfRoutes i saljemo userID i id
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ListOfRoutes(userID: userID)),
    );
  }

  onChangeDropdownItem(Vehicle vehicle) {
    setState(() {
      _selectedVehicle = vehicle;
      vehicleVar = _selectedVehicle.name;
    });
    onceToast = 0;
    onceBtnPressed = 0;
    areFieldsEmpty();
  }
}

class Vehicle {
  int id;
  String name;

  Vehicle(this.id, this.name);

  static List<Vehicle> getVehicle() {
    return <Vehicle>[
      Vehicle(1, "Kiper"),
      Vehicle(2, "Cisterna"),
      Vehicle(3, "Kamion - kran"),
      Vehicle(4, "Šleper sa jednom poluprikolicom"),
      Vehicle(5, "Šleper sa dvije poluprikolice"),
      Vehicle(6, "Šleper sa više poluprikolica"),
      Vehicle(7, "Pick up"),
      Vehicle(8, "Kombi"),
      Vehicle(9, "Traktor"),
    ];
  }
}
