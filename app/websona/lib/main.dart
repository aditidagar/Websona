/// Flutter code sample for BottomNavigationBar

// This example shows a [BottomNavigationBar] as it is used within a [Scaffold]
// widget. The [BottomNavigationBar] has three [BottomNavigationBarItem]
// widgets and the [currentIndex] is set to index 0. The selected item is
// amber. The `_onItemTapped` function changes the selected item's index
// and displays a corresponding message in the center of the [Scaffold].
//
// ![A scaffold with a bottom navigation bar containing three bottom navigation
// bar items. The first one is selected.](https://flutter.github.io/assets-for-api-docs/assets/material/bottom_navigation_bar.png)

import 'package:flutter/material.dart';
import 'SignInScreen.dart';




void main() => runApp(MyApp());

/// This is the main application widget.
class MyApp extends StatelessWidget {
  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
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
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Codes',
      style: optionStyle,
    ),
    Text(
      'Index 1: Contacts',
      style: optionStyle,
    ),
    Text(
      'Index 2: Events',
      style: optionStyle,
    ),
    Text(
      'Index 3: Setttings',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("WebSona"),
      ),
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

  void opencamera(context) {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
        builder: (BuildContext bc) {
          return Container(
            alignment: Alignment.topCenter,
            margin: EdgeInsets.all(30),
            height: MediaQuery.of(context).size.height * 0.6,
            // decoration: BoxDecoration(
            //     borderRadius: BorderRadius.only(
            //         topLeft: Radius.circular(40),
            //         topRight: Radius.circular(40))),
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: 70,
                  child: SelectableText("Cancel",
                      onTap: () => {Navigator.pop(context)},
                      style: TextStyle(color: Colors.blue[800])),
                ),
                // style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                Text(
                  'Scan the QR code',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        });
  }
}

// class MyFloatingActionButton extends StatefulWidget {
//   @override
//   createState() => new _MyFloatingActionButtonState();
// }

// class _MyFloatingActionButtonState extends State<MyFloatingActionButton> {
//   bool showFab = true;
//   @override
//   Widget build(BuildContext context) {
//     return showFab
//         ? FloatingActionButton(
//             onPressed: () {
//               var bottomSheetController = showBottomSheet(
//                   context: context,
//                   builder: (context) => Container(
//                         color: Colors.grey[300],
//                         height: 400,
//                       ));
//               showFoatingActionButton(false);
//               bottomSheetController.closed.then((value) {
//                 showFoatingActionButton(true);
//               });
//             },
//             child: Icon(Icons.add),
//           )
//         : Container();
//   }

//   void showFoatingActionButton(bool value) {
//     setState(() {
//       showFab = value;
//     });
//   }
// }
