import 'dart:convert';
import 'package:qr_flutter/qr_flutter.dart';
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
    info.litems = [];
    for (var code in codes) {
      if (!code.containsKey('type') || code['type'] == 'personal') {
        info.litems.add(code);
      }
    }

    info.counter = info.litems.length;
    setState(() {});
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
                  height: 410.0,
                  margin: EdgeInsets.all(20.0),
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    children: <Widget>[
                      Text('Code',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 40.0,
                              fontFamily: 'sans-serif-light',
                              color: Colors.black)),
                      Container(
                        width: 200.0,
                        height: 200.0,
                        margin: EdgeInsets.only(top: 20, bottom: 20),
                        child: QrImage(
                          data: API_URL + "/code/" + code["id"],
                          size: 200,
                        ),
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
                      RaisedButton(
                        color: Colors.white60,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(80.0)),
                        //side: BorderSide(color: Colors.blue, width: 2)),
                        onPressed: () {
                          //implement to delete instead
                          Navigator.pop(context);
                        },
                        child: const Text('Delete',
                            style:
                                TextStyle(fontSize: 14, color: Colors.black)),
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
                      } else if (info.counter >= 5) {
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: Text('Codes Limit Reached'),
                            content: Text(
                                'To add a new code, remove one or more of the existing codes.'),
                            actions: [
                              FlatButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text("Ok"))
                            ],
                            elevation: 24.0,
                          ),
                          barrierDismissible: true,
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
                              child: Stack(
                                children: <Widget>[
                                  Container(
                                      decoration: new BoxDecoration(
                                          color: Colors.white),
                                      alignment: Alignment.center,
                                      height: 240,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              (Radius.circular(25.0))),
                                          color: Colors.blue[300],
                                        ),
                                      )),
                                  Align(
                                    alignment: Alignment.center,
                                    child: Icon(Icons.qr_code_scanner,
                                        color: Colors.white10, size: 140),
                                  ),
                                  Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      "Code " + index.toString(),
                                      style: TextStyle(
                                          fontSize: 28,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  )
                                ],
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
