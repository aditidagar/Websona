import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'Main.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  String media1 = '';
  String media2 = '';
  String media3 = '';
  String media4 = '';
  String dropdownValue;
  String dropdownValue2;
  String dropdownValue3;
  String dropdownValue4;
  String qrData = '';
  static List<String> _mediaLink = [];
  static List<String> media = [];
  String _name = '';
  String _email = '';
  String _phone = '';
  Image qr;
  Uint8List bytes;

  Uint8List qrImage;
  TextEditingController qrController = TextEditingController();
  var qrKey = GlobalKey();

  void initializeProfile() async {
    final prefs = await SharedPreferences.getInstance();

    Response response = await get(API_URL + '/user/' + prefs.getString('email'),
        headers: <String, String>{
          'authorization': await getAuthorizationToken(context),
        });

    final responseBody = jsonDecode(response.body);
    List<String> mediaLink_temp = [];
    List<String> media_temp = [];
    for (int index = 0; index < responseBody['socials'].length; index++) {
      setState(() {
        media_temp.add(responseBody['socials'][index]['social']);
        mediaLink_temp.add(responseBody['socials'][index]['username']);
      });
    }

    setState(() {
      _email = prefs.getString('email');
      _name = responseBody['name'];
      _phone = responseBody['phone'];
      media = media_temp;
      _mediaLink = mediaLink_temp;
    });
  }

  void handleSubmit() async {
    Response response = await post(
        API_URL + "/newCode?type=personal&name=" + qrController.value.text,
        headers: <String, String>{
          "Content-Type": "application/json",
          'authorization': await getAuthorizationToken(context),
        },
        body: jsonEncode(<String, dynamic>{
          'socials': [
            {'social': media1, 'username': dropdownValue},
            {'social': media2, 'username': dropdownValue2},
            {'social': media3, 'username': dropdownValue3},
            {'social': media4, 'username': dropdownValue4}
          ]
        }));

    if (response.statusCode == 201) {
      Map<dynamic, dynamic> data = jsonDecode(response.body);
      String codeId = data['codeId'];
      qrData = API_URL + '/code/' + codeId;
      setState(() {});
    }
  }

  Future<String> _getWidgetImage() async {
    try {
      RenderRepaintBoundary boundary = qrKey.currentContext.findRenderObject();

      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      var pngBytes = byteData.buffer.asUint8List();
      var bs64 = base64Encode(pngBytes);
      return bs64;
    } catch (exception) {
      return null;
    }
  }

  @override
  initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    initializeProfile();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QR Code',
      home: Scaffold(
          resizeToAvoidBottomInset: false,
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
                                  dropdownValue = newValue;
                                  int index = media.indexOf(newValue);
                                  media1 = _mediaLink.elementAt(index);
                                });
                              },
                              items: media.map<DropdownMenuItem<String>>(
                                  (String value) {
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
                                  dropdownValue2 = newValue;
                                  int index = media.indexOf(newValue);
                                  media2 = _mediaLink.elementAt(index);
                                });
                              },
                              items: media.map<DropdownMenuItem<String>>(
                                  (String value) {
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
                                  dropdownValue3 = newValue;
                                  int index = media.indexOf(newValue);
                                  media3 = _mediaLink.elementAt(index);
                                });
                              },
                              items: media.map<DropdownMenuItem<String>>(
                                  (String value) {
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
                                  dropdownValue4 = newValue;
                                  int index = media.indexOf(newValue);
                                  media4 = _mediaLink.elementAt(index);
                                });
                              },
                              items: media.map<DropdownMenuItem<String>>(
                                  (String value) {
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
                    handleSubmit();
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
