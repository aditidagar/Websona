import 'package:flutter/material.dart';
import 'SignUpScreen.dart';
import 'Main.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:qr_flutter/qr_flutter.dart';

const String API_URL =
    "https://api.thewebsonaapp.com";

class GenerateQrScreen extends StatefulWidget {
  @override
  _GenerateQrScreenState createState() => _GenerateQrScreenState();
}

class _GenerateQrScreenState extends State<GenerateQrScreen> {
  //Add some state initialization later
  String dropdownValue = 'Social Media 1';
  String dropdownValue2 = 'Social Media 2';
  String dropdownValue3 = 'Social Media 3';
  String dropdownValue4 = 'Social Media 4';
  String qrData = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        children: <Widget>[
          QrImage(
            data: qrData,
            size: 200,
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: <Widget>[
                Expanded(
                    child: Container(
                        margin: EdgeInsets.only(right: 20, left: 10),
                        child: new Theme(
                          data: new ThemeData(primaryColor: Colors.blue),
                          child: TextField(
                            obscureText: true,
                            enableSuggestions: false,
                            autocorrect: false,
                            decoration: InputDecoration(
                              hintText: 'Enter QR Name',
                              suffixStyle: TextStyle(color: Colors.red),
                            ),
                          ),
                        )))
              ],
            ),
          ),
          Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(right: 10, left: 10),
                      child: DropdownButton<String>(
                        value: dropdownValue,
                        // icon: Icon(Icons.arrow_downward),
                        iconSize: 24,
                        elevation: 16,
                        style: TextStyle(color: Colors.deepPurple),
                        underline: Container(
                          height: 2,
                          color: Colors.deepPurpleAccent,
                        ),
                        onChanged: (String newValue) {
                          setState(() {
                            qrData = qrData + newValue;
                            qrData = qrData + ", ";
                            dropdownValue = newValue;
                          });
                        },
                        items: <String>[
                          'Social Media 1',
                          'Social Media 2',
                          'Social Media 3',
                          'Social Media 4'
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  )
                ],
              )),
          Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(right: 10, left: 10),
                      child: DropdownButton<String>(
                        value: dropdownValue2,
                        icon: Icon(Icons.arrow_downward),
                        iconSize: 24,
                        elevation: 16,
                        style: TextStyle(color: Colors.deepPurple),
                        underline: Container(
                          height: 2,
                          color: Colors.deepPurpleAccent,
                        ),
                        onChanged: (String newValue) {
                          setState(() {
                            qrData = qrData + newValue;
                            qrData = qrData + ", ";
                            dropdownValue2 = newValue;
                          });
                        },
                        items: <String>[
                          'Social Media 1',
                          'Social Media 2',
                          'Social Media 3',
                          'Social Media 4'
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  )
                ],
              )),
          Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(right: 10, left: 10),
                      child: DropdownButton<String>(
                        value: dropdownValue3,
                        icon: Icon(Icons.arrow_downward),
                        iconSize: 24,
                        elevation: 16,
                        style: TextStyle(color: Colors.deepPurple),
                        underline: Container(
                          height: 2,
                          color: Colors.deepPurpleAccent,
                        ),
                        onChanged: (String newValue) {
                          setState(() {
                            qrData = qrData + newValue;
                            qrData = qrData + ", ";
                            dropdownValue3 = newValue;
                          });
                        },
                        items: <String>[
                          'Social Media 1',
                          'Social Media 2',
                          'Social Media 3',
                          'Social Media 4'
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  )
                ],
              )),
          Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(right: 10, left: 10),
                      child: DropdownButton<String>(
                        value: dropdownValue4,
                        icon: Icon(Icons.arrow_downward),
                        iconSize: 24,
                        elevation: 16,
                        style: TextStyle(color: Colors.deepPurple),
                        underline: Container(
                          height: 2,
                          color: Colors.deepPurpleAccent,
                        ),
                        onChanged: (String newValue) {
                          setState(() {
                            qrData = qrData + newValue;
                            qrData = qrData + ", ";
                            dropdownValue4 = newValue;
                          });
                        },
                        items: <String>[
                          'Social Media 1',
                          'Social Media 2',
                          'Social Media 3',
                          'Social Media 4'
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  )
                ],
              )),
          FlatButton(
            color: Colors.blue,
            textColor: Colors.white,
            disabledColor: Colors.grey,
            disabledTextColor: Colors.black,
            padding: EdgeInsets.all(8.0),
            splashColor: Colors.blueAccent,
            onPressed: () {
              /*...*/
            },
            child: Text(
              "Create",
              style: TextStyle(fontSize: 20.0),
            ),
          ),
        ],
      ),
    ));
  }
}
