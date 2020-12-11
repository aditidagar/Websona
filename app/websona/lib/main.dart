import 'package:flutter/material.dart';
import 'package:websona/SettingsScreen.dart';
import 'SignInScreen.dart';
import 'MyCodes.dart';
import 'Contacts.dart';
import 'qrscanner.dart';
import 'package:websona/Events.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

const String API_URL = "https://api.thewebsonaapp.com";
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

  // buggy rn, dont use it
  void checkLoggedIn(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString('email') != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MyStatefulWidget(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // checkLoggedIn(context);

    return MaterialApp(
      home: SignInScreen(),
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
  BuildContext global;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  final List<Widget> _widgetOptions = <Widget>[
    MyCodes(),
    Contacts(),
    Event(),
    SettingsScreen(),
  ];

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
        child: Icon(Icons.camera),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void opencamera(context) async {
    showModalBottomSheet<void>(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
        builder: (BuildContext bc) {
          return QRScanner();
        });
  }
}
