import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  @override
   @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: null//AppBar(
          // title: Text(
          //   'Websona',
          // ),
          // centerTitle: true,
          // backgroundColor: Colors.white,
          // // elevation: 0,
          // // // give the app bar rounded corners
          // // shape: RoundedRectangleBorder(
          // //   borderRadius: BorderRadius.only(
          // //     bottomLeft: Radius.circular(20.0),
          // //     bottomRight: Radius.circular(20.0),
          // //   ),
          // // ),
          // // leading: Icon(
          // //   Icons.menu,
          // // ),
        // ),
        ,body: Column(
          children: <Widget>[
            // construct the profile details widget here

          Container(
            height: 300,
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.cover, image: AssetImage('asset/img/angryimg.png'))),
          ),

            // the tab bar with two items
            SizedBox(
              height: 72,
              child: AppBar(
                bottom: TabBar(
                  tabs: [
                    Tab(
                      text: "LOGIN",
                    ),
                    Tab(
                      text: "SIGN UP",
                    ),
                  ],
                ),
              ),
            ),

            // create widgets for each tab bar here
            Expanded(
              child: TabBarView(
                children: [
                  // first tab bar view widget
                  Container(
                     color: Colors.red,
                    child: Center(
                      child: Text(
                        'Bike',
                      ),
                    ),
                  ),

                  // second tab bar viiew widget
                  Container(
                     color: Colors.pink,
                    child: Center(
                      child: Text(
                        'Car',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


          // SizedBox(
          //   height: 20,
          // ),
          // Padding(
          //   padding: const EdgeInsets.all(20.0),
          //   child: Row(
          //     children: <Widget>[
          //       IconButton(icon: Icon(Icons.person), onPressed: null),
          //       Expanded(
          //           child: Container(
          //               margin: EdgeInsets.only(right: 20, left: 10),
          //               child: TextField(
          //                 decoration: InputDecoration(hintText: 'Username'),
          //               )))
          //     ],
          //   ),
          // ),
          // Padding(
          //   padding: const EdgeInsets.all(20.0),
          //   child: Row(
          //     children: <Widget>[
          //       IconButton(icon: Icon(Icons.lock), onPressed: null),
          //       Expanded(
          //           child: Container(
          //               margin: EdgeInsets.only(right: 20, left: 10),
          //               child: TextField(
          //                 decoration: InputDecoration(hintText: 'Password'),
          //               ))),
          //     ],
          //   ),
          // ),
          // SizedBox(
          //   height: 20,
          // ),
          // Padding(
          //   padding: const EdgeInsets.all(20.0),
          //   child: ClipRRect(
          //     borderRadius: BorderRadius.circular(5),
          //     child: Container(
          //       height: 60,
          //       child: RaisedButton(
          //         onPressed: () {},
          //         color: Color(0xFF00a79B),
          //         child: Text(
          //           'SIGN IN',
          //           style: TextStyle(
          //               color: Colors.white,
          //               fontWeight: FontWeight.bold,
          //               fontSize: 20),
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
          // SizedBox(
          //   height: 20,
          // ),
          // InkWell(
          //   onTap: (){
          //     Navigator.pushNamed(context, 'SignUp');
          //   },
          //             child: Center(
          //     child: RichText(
          //       text: TextSpan(
          //           text: 'Don\'t have an account?',
          //           style: TextStyle(color: Colors.black),
          //           children: [
          //             TextSpan(
          //               text: 'SIGN UP',
          //               style: TextStyle(
          //                   color: Colors.teal, fontWeight: FontWeight.bold),
          //             )
          //           ]),
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }
}