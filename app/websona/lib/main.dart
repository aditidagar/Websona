import 'package:flutter/material.dart';
import 'SignInScreen.dart';
import 'MyCodes.dart';
import 'package:websona/Events.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:flutter_qr_bar_scanner/qr_bar_scanner_camera.dart';

import 'GenerateQrScreen.dart';

const String API_URL = "http://api.thewebsonaapp.com";

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
  String _qrInfo = 'Scan a QR/Bar code';

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

  _qrCallback(String code) {
    setState(() {
      _camState = true;
      _qrInfo = code;
    });
  }

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

  void opencamera(context) async {
    showModalBottomSheet<dynamic>(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
        builder: (BuildContext bc) {
          if (this._camState) {
            return Container(
                height: MediaQuery.of(context).size.height * 0.5,
                margin: EdgeInsets.all(20.0),
                padding: EdgeInsets.all(10.0),
                child: Column(
                  children: <Widget>[
                    Text(
                      'Scan the QR code',
                      style:
                          TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 300,
                      width: 500,
                      child: QRBarScannerCamera(
                        onError: (context, error) => Text(
                          error.toString(),
                          style: TextStyle(color: Colors.red),
                        ),
                        qrCodeCallback: (code) {
                          _qrCallback(code);
                        },
                      ),
                    ),
                  ],
                ));
          }
          return Text("Profile page here");

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
