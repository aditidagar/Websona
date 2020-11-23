import 'package:flutter/material.dart';
import 'SignInScreen.dart';
import 'MyCodes.dart';
import 'package:websona/Events.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
// import 'package:flutter_qr_bar_scanner/qr_bar_scanner_camera.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import 'GenerateQrScreen.dart';

const String API_URL = "http://api.thewebsonaapp.com";

const flashOn = 'FLASH ON';
const flashOff = 'FLASH OFF';
const frontCamera = 'FRONT CAMERA';
const backCamera = 'BACK CAMERA';

void main() => runApp(MyApp());

Future<String> getAuthorizationToken(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  if (prefs.getInt('tokenExpiryTime') <=
      DateTime.now().millisecondsSinceEpoch) {
    // tokens expired, get new tokens
    final secureStorage = new FlutterSecureStorage();
    String password = await secureStorage.read(key: 'websona-password');
    // no password found in keychain, ask user to login so we can get new auth tokens
    if (password == null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SignInScreen(),
        ),
      );

      return null;
    }

    // obtain new token
    Response response = await post(API_URL + "/login",
        headers: <String, String>{'Content-Type': 'application/json'},
        body: jsonEncode(<String, String>{
          'email': prefs.getString('email'),
          'password': password
        }));
    final responseBody = jsonDecode(response.body);
    await prefs.setString('access_token', responseBody['accessToken']);
    prefs.setInt(
        'tokenExpiryTime',
        (responseBody['tokenExpiryTime'] * 1000) +
            DateTime.now().millisecondsSinceEpoch);
  }

  return 'Bearer ' + prefs.getString('access_token');
}

/// This is the main application widget.
class MyApp extends StatelessWidget {
  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyStatefulWidget(),
    );
  }
}

/// This is the stateful widget that the main application instantiates.
class MyStatefulWidget extends StatefulWidget {
  MyStatefulWidget({Key key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _selectedIndex = 0;
  bool _camState = true;
  // String _qrInfo = 'Scan a QR codee';
  var qrText = 'Scan a Code';
  var flashState = flashOn;
  var cameraState = frontCamera;
  QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  final List<Widget> _widgetOptions = <Widget>[
    MyCodes(),
    //GenerateQrScreen(),
    Text(
      'Index 1: Contacts',
      style: optionStyle,
    ),
    Event(),
    Text(
      'Index 3: Setttings',
      style: optionStyle,
    ),
  ];

  // _qrCallback(String code) {
  //   print("seSTate called");
  //   setState(() {
  //     _camState = false;
  //     _qrInfo = code;
  //   });
  // }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // if (index == 0) {
      //   // go to the my codes page
      //   Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => MyCodes(),
      //     ),
      //   );
      // }
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        key: Key('bottom'),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code_scanner),
            label: 'My Codes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            label: 'Contacts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: 'Events',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.black,
        showUnselectedLabels: true,
        onTap: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          opencamera(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        _camState = false;
        qrText = scanData;
      });
    });
  }

  void opencamera(context) async {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
        builder: (BuildContext bc) {
          return Container(
              height: 2000,
              margin: EdgeInsets.all(20.0),
              padding: EdgeInsets.all(10.0),
              child: Column(
                children: <Widget>[
                  Container(
                    width: 180.0,
                    height: 180.0,
                    margin: EdgeInsets.only(top: 20, bottom: 20),
                    decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      image: new DecorationImage(
                        image: new ExactAssetImage('asset/img/background.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Center(
                      child: Text("J",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 60.0,
                              fontFamily: 'sans-serif-light',
                              color: Colors.white)),
                    ),
                  ),
                  Center(
                    child: Text("Jane Smith",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 40.0,
                            fontFamily: 'sans-serif-light',
                            color: Colors.black)),
                  ),
                  const SizedBox(height: 30),
                  RaisedButton(
                    color: Colors.blue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(80.0)),
                    onPressed: () {
                      //CODE HERE FOR 'ADD CONTACT'
                    },
                    child: const Text('Add Contact',
                        style: TextStyle(fontSize: 20, color: Colors.white)),
                  ),
                  const SizedBox(height: 10),
                  RaisedButton(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(80.0),
                        side: BorderSide(color: Colors.blue, width: 2)),
                    onPressed: () {
                      //CODE HERE FOR 'DISMISS'
                    },
                    child: const Text('Dismiss',
                        style: TextStyle(fontSize: 20, color: Colors.blue)),
                  ),
                  // Text(
                  //   'Scan the QR code',
                  //   style: this._camState == true
                  //       ? TextStyle(fontSize: 26, fontWeight: FontWeight.bold)
                  //       : TextStyle(fontSize: 12),
                  //   textAlign: TextAlign.center,
                  // ),
                  // SizedBox(
                  //   height: 350,
                  //   width: 300,
                  //   child: QRView(
                  //     key: qrKey,
                  //     onQRViewCreated: _onQRViewCreated,
                  //     overlay: QrScannerOverlayShape(
                  //       borderColor: Colors.red,
                  //       borderRadius: 10,
                  //       borderLength: 30,
                  //       borderWidth: 10,
                  //       cutOutSize: 300,
                  //     ),
                  //   ),
                  // ),
                  // Text(qrText, style: TextStyle(color: Colors.black)),
                ],
              ));

          // Container();
          // child: Row(
          //   children: <Widget>[
          //     SizedBox(
          //       width: 70,
          //       child: SelectableText("Cancel",
          //           onTap: () => {Navigator.pop(context)},
          //           style: TextStyle(color: Colors.blue[800])),
          //     ),
          //     Text(
          //       'Scan the QR code',
          //       style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          //       textAlign: TextAlign.center,
          //     ),
          //   ],
          //     child: QRBarScannerCamera(
          //             onError: (context, error) => Text(
          //               error.toString(),
          //               style: TextStyle(color: Colors.red),
          //             ),
          //             qrCodeCallback: (code) {
          //               _qrCallback(code);
          //             },
          //           ),
          //         ),
          //         Text(
          //           _qrInfo,
          //           style: TextStyle(color: Colors.black26),
          //         ),
          //     ),
          //   );
          // });
        });
  }
}
