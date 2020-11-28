import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'GenerateQrScreen.dart';

const String API_URL = "https://api.thewebsonaapp.com";

class MyCodes extends StatefulWidget {
  @override
  _MyCodesState createState() => _MyCodesState();
}

//info class
class Info {
  List<dynamic> litems;
  int counter;
  Info(this.litems, this.counter);
}

class _MyCodesState extends State<MyCodes> {
  Info info;

  void changeState() {
    setState(() {});
  }

  void loadCodes(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    Response response = await get(
      API_URL + "/user/" + prefs.getString('email'),
      headers: <String, String>{
        'authorization': await getAuthorizationToken(context)
      },
    );

    var data = jsonDecode(response.body);
    var codes = data['codes'];
    setState(() {
      info.litems = codes;
      info.counter = codes.length;
    });
  }

  @override
  void initState() {
    super.initState();
    info = new Info([], 0);
    loadCodes(context);
  }

  createDialog(BuildContext context, dynamic code) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              child: Container(
                  height: 500.0,
                  margin: EdgeInsets.all(20.0),
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: 200.0,
                        height: 200.0,
                        margin: EdgeInsets.only(top: 20, bottom: 20),
                        decoration: new BoxDecoration(
                          image: new DecorationImage(
                            image: new NetworkImage(code['url']),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Center(
                        child: Text('Code',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 40.0,
                                fontFamily: 'sans-serif-light',
                                color: Colors.black)),
                      ),
                      RaisedButton(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(80.0),
                            side: BorderSide(color: Colors.blue, width: 2)),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Dismiss',
                            style: TextStyle(fontSize: 20, color: Colors.blue)),
                      ),
                    ],
                  )));
        });
  }

//Navigator.of(context).pop();
  final TextEditingController eCtrl = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Codes',
      home: Scaffold(
          appBar: AppBar(
            title: const Text(
              '  My Codes',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
            ),
            backgroundColor: Colors.transparent,
            bottomOpacity: 0.0,
            elevation: 0.0,
            centerTitle: false,
            automaticallyImplyLeading: false,
            actions: <Widget>[
              Padding(
                  padding: EdgeInsets.only(right: 20.0),
                  child: GestureDetector(
                    onTap: () {
                      if (info.counter < 5) {
                        // go to the QR page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GenerateQrScreen(
                              info: info,
                              changeStateCallBack: changeState,
                            ),
                          ),
                        );
                      }
                    },
                    child: Icon(
                      Icons.add,
                      size: 26.0,
                      color: Colors.blue,
                    ),
                  )),
            ],
          ),
          body: new Column(
            children: <Widget>[
              new Expanded(
                  child: GridView.builder(
                      padding: EdgeInsets.all(25.0),
                      itemCount: info.litems.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 25.0,
                          mainAxisSpacing: 25.0),
                      itemBuilder: (BuildContext ctxt, int index) {
                        return new Material(
                            color: Colors.white.withOpacity(0.0),
                            child: InkWell(
                              splashColor: Colors.white,
                              child: Container(
                                height: 50.0,
                                width: 50.0,
                                color: Colors.transparent,
                                child: Container(
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: AssetImage(
                                                'asset/img/background.png')),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(25.0))),
                                    child: new Center(
                                      child: new Text(
                                        "Code " + index.toString(),
                                        style: TextStyle(
                                            fontSize: 22, color: Colors.white),
                                        textAlign: TextAlign.center,
                                      ),
                                    )),
                              ),
                              onTap: () {
                                createDialog(context, info.litems[index]);
                              },
                            ));
                      }))
            ],
          )),
    );
  }
}
