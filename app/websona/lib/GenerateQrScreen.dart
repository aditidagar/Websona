import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:qr_flutter/qr_flutter.dart';

const String API_URL = "https://api.thewebsonaapp.com";

class GenerateQrScreen extends StatefulWidget {
  final info;
  final _callback;

  GenerateQrScreen({@required this.info, @required changeStateCallBack})
      : _callback = changeStateCallBack;

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
  Uint8List qrImage;
  TextEditingController qrController = TextEditingController();
  var qrKey = GlobalKey();
  void handleSubmit() async {
    Response response = await post(API_URL + "/newCode",
        headers: <String, String>{'Content-Type': 'application/json'},
        body: jsonEncode(<String, dynamic>{
          'socials': [
            {'social': 'snapchat', 'username': dropdownValue},
            {'social': 'snapchat', 'username': dropdownValue},
            {'social': 'snapchat', 'username': dropdownValue},
            {'social': 'snapchat', 'username': dropdownValue}
          ]
        }));

    if (response.statusCode == 200) {
      //Navigate to QR Codes Page

      debugPrint("Working");
    }
  }

  void _getWidgetImage() async {
    try {
      RenderRepaintBoundary boundary = qrKey.currentContext.findRenderObject();

      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      var pngBytes = byteData.buffer.asUint8List();
      var bs64 = base64Encode(pngBytes);
      debugPrint(bs64.length.toString());
      qrImage = pngBytes;
    } catch (exception) {}
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QR Code',
      home: Scaffold(
          appBar: AppBar(
            title: const Text(
              '  QR Code',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
            ),
            backgroundColor: Colors.transparent,
            bottomOpacity: 0.0,
            elevation: 0.0,
            centerTitle: false,
            automaticallyImplyLeading: false,
          ),
          body: Center(
            child: Column(
              children: <Widget>[
                RepaintBoundary(
                  key: qrKey,
                  child: QrImage(
                    data: qrData,
                    size: 200,
                  ),
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
                                  controller: qrController,
                                  // obscureText: true,
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
                    _getWidgetImage();
                    widget.info.litems.add(qrController.text);
                    widget.info.counter = widget.info.counter + 1;
                    widget?._callback();
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Create",
                    style: TextStyle(fontSize: 20.0),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
