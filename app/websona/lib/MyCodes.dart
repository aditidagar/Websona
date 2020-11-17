import 'package:flutter/material.dart';
import 'GenerateQrScreen.dart';

class MyCodes extends StatefulWidget {
  @override
  _MyCodesState createState() => _MyCodesState();
}

class _MyCodesState extends State<MyCodes> {
  List<String> litems = [];
  int counter = 0;
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
                      
                      if (counter < 5) {
                        litems.add("QR Code");
                        setState(() {});
                        counter = counter + 1;
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
                      itemCount: litems.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 25.0,
                          mainAxisSpacing: 25.0),
                      itemBuilder: (BuildContext ctxt, int index) {
                        return new Material(
                          color: Colors.white.withOpacity(0.0),
                          child : InkWell(
                            splashColor: Colors.white,
                            child : Container(
                          height: 50.0,
                          width: 50.0,
                          color: Colors.transparent,
                          child: Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: AssetImage(
                                          'asset/img/background.png')),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(25.0))),
                              child: new Center(
                                child: new Text(
                                  "QR Code",
                                  style: TextStyle(
                                      fontSize: 22, color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                              )),
                        ),
                        onTap: () {
                          print("Click");
                        },
                          )
                        );
                      }))
            ],
          )),
    );
  }
}
