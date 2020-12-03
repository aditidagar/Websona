import 'dart:convert';
import 'package:http/http.dart';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:marquee_widget/marquee_widget.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:ui' as UI;

import 'main.dart';

const String API_URL = "https://api.thewebsonaapp.com";

class Event extends StatefulWidget {
  @override
  _EventState createState() => _EventState();
}

class _EventState extends State<Event> {
  DateTime selectedDate = DateTime.now();
  List<String> eventItems = [];
  List<String> eventDates = [];
  List<String> eventLocations = [];
  List<String> eventNames = [
    'Harsh Jhunjhunwala',
    'Aditi Dagar',
    'Ibrahim Fazili',
    'Saakshi Shah',
    'Gautam Gireesh'
  ];
  List<Map<String, String>> peopleInfo = [
    {'email': 'harsh.jhunjhunwa@mail.utoronto.ca'},
    {'email': 'aditi.dagar@mail.utoronto.ca'},
    {
      'email': 'ibrahim.fazili@mail.utoronto.ca'
    },
    {'email': 'saakshi.shah@mail.utoronto.ca'},
    {'email': 'gautam.gireesh@mail.utoronto.ca'}
  ];
  List<String> eventPictures = [
    'https://picsum.photos/250?image=9',
    'https://picsum.photos/250?image=10',
    'https://picsum.photos/250?image=11',
    'https://picsum.photos/250?image=12',
    'https://picsum.photos/250?image=13'
  ];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  createDialog(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController locationController = TextEditingController();
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            child: Container(
              height: 250,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(hintText: 'Name'),
                    ),
                    TextField(
                      controller: locationController,
                      decoration: InputDecoration(hintText: 'Location'),
                    ),
                    new RaisedButton(
                      onPressed: () => _selectDate(context),
                      child: Text("Select date"),
                    ),
                    SizedBox(
                      width: 150.0,
                      child: RaisedButton(
                        onPressed: () {
                          eventItems.add(nameController.text);
                          eventLocations.add(locationController.text);
                          eventDates.add(
                              "${selectedDate.day.toString().padLeft(2, '0')}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.year.toString()}");
                          setState(() {});
                          Navigator.of(context).pop();
                          createCodeDialog(context);
                        },
                        child: Text(
                          "Create",
                          style: TextStyle(color: Colors.white),
                        ),
                        color: const Color(0xFF1BC0C5),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  Widget stackBehindDismiss() {
    return Container(
      alignment: Alignment.centerRight,
      padding: EdgeInsets.only(right: 20.0),
      color: Colors.red,
      child: Icon(
        Icons.delete,
        color: Colors.white,
      ),
    );
  }

  displayLinks(int index) {
    return Column(children: [
      for (var i in peopleInfo[index].keys)
        if (i == 'email')
          Row(children: [
            IconButton(
              icon: FaIcon(FontAwesomeIcons.mailBulk),
              iconSize: 15,
            ),
            Text(
              peopleInfo[index]['email'],
              overflow: TextOverflow.ellipsis,
            )
          ])
    ]);
  }

  displayEvent(BuildContext context, String eventName, String eventLoc) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(150),
              child: AppBar(
                  titleSpacing: 1.0,
                  leading: InkWell(
                      child: new Icon(
                        Icons.arrow_back_ios,
                        color: Colors.black,
                        size: 22.0,
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      }),
                  title: Container(
                      width: 250,
                      child: Marquee(
                        child: Text(eventName),
                        animationDuration:
                            Duration(seconds: eventName.length ~/ 8),
                        backDuration: Duration(seconds: eventName.length ~/ 8),
                        pauseDuration: Duration(seconds: 1),
                      )),
                  backgroundColor: Colors.blue,
                  bottomOpacity: 0.0,
                  elevation: 12.0,
                  centerTitle: false,
                  automaticallyImplyLeading: false,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(70),
                  )),
                  flexibleSpace: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: EdgeInsets.only(left: 30, top: 20),
                          child: Text(
                            eventLoc,
                            style: TextStyle(fontSize: 24),
                          ),
                        ),
                      ),
                      Expanded(
                          flex: 1,
                          child: Padding(
                            padding: EdgeInsets.only(left: 80, top: 55),
                            child: Container(
                              width: 80,
                              height: 80,
                              child: Padding(
                                padding: EdgeInsets.only(left: 45, top: 12),
                                child: Container(
                                  child: Text(eventNames.length.toString(),
                                      style: TextStyle(
                                        fontSize: 55,
                                      )),
                                ),
                              ),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.blue[100]),
                            ),
                          )),
                    ],
                  )),
            ),
            body: new Container(
              padding: new EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  new Align(
                      alignment: Alignment.centerLeft,
                      child: new Text("Participants",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                              fontSize: 30))),
                  new Expanded(
                      child: ListView.separated(
                    padding: EdgeInsets.only(top: 15),
                    itemCount: eventNames.length,
                    separatorBuilder: (BuildContext context, int index) =>
                        Divider(
                      color: Colors.white,
                    ),
                    itemBuilder: (BuildContext ctxt, int index) {
                      return new ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(eventPictures[
                                index]), // no matter how big it is, it won't overflow
                          ),
                          tileColor: Colors.blue[50],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          title: Text(
                            eventNames[index],
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                          ),
                          subtitle: displayLinks(index));
                    },
                  ))
                ],
              ),
            ),
          );
        });
  }

  createCodeDialog(BuildContext context) async{
    var qrKey = GlobalKey();
    String codeUrl = "";
    
    Response response = await post(API_URL + "/newCode?type=event",
        headers: <String, String>{
          "Content-Type": "application/json",
          'authorization': await getAuthorizationToken(context),
        },
      );
    
    if (response.statusCode == 201) {
      Map<dynamic, dynamic> data = jsonDecode(response.body);
      String codeId = data['codeId'];
      codeUrl = API_URL + '/code/' + codeId;
      uploadCode(data['putUrl'], qrKey);
    }

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
                        child: RepaintBoundary(
                                key: qrKey,
                                child: QrImage(
                                  data: codeUrl,
                                  size: 200,
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

  uploadCode(String url, dynamic key) {
    Future.delayed(const Duration(milliseconds: 2000), () {
          _getWidgetImage(key).then((value) async {
            var bytes = base64Decode(value);
            var client = Client();
            var request = Request('PUT', Uri.parse(url));
            request.headers.addAll({"Content-Type": "image/png"});
            request.bodyBytes = bytes;
            var streamedResponse = await client.send(request).then((res) {
              print(res.statusCode);
            });
            client.close();
          });
        });
  }

  Future<String> _getWidgetImage(dynamic qrKey) async {
    try {
      RenderRepaintBoundary boundary = qrKey.currentContext.findRenderObject();

      UI.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData byteData =
          await image.toByteData(format: UI.ImageByteFormat.png);
      var pngBytes = byteData.buffer.asUint8List();
      var bs64 = base64Encode(pngBytes);
      return bs64;
    } catch (exception) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '  Events',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
        ),
        backgroundColor: Colors.transparent,
        bottomOpacity: 0.0,
        elevation: 0.0,
        centerTitle: false,
        automaticallyImplyLeading: false,
      ),
      body: new Container(
        padding: new EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: ListTile(
                tileColor: Color(0xFFEAF4FE),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.horizontal()),
                title: Text(
                  "Create New Event",
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.w600),
                ),
                trailing: Icon(
                  Icons.add_circle,
                  color: Colors.blue[200],
                  size: 40,
                ),
                onTap: () {
                  createDialog(context);
                },
              ),
            ),
            new Expanded(
                child: ListView.separated(
              padding: EdgeInsets.only(top: 15),
              itemCount: eventItems.length,
              separatorBuilder: (BuildContext context, int index) => Divider(
                color: Colors.white,
              ),
              itemBuilder: (BuildContext ctxt, int index) {
                final item = eventItems[index];
                return new Dismissible(
                    key: Key(item),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) {
                      // if (direction == DismissDirection.endToStart) {
                      setState(() {
                        eventDates.removeAt(index);
                        eventItems.removeAt(index);
                        eventLocations.removeAt(index);
                      });
                      Scaffold.of(context).showSnackBar(
                          SnackBar(content: Text("Event deleted ")));
                      // }
                    },
                    background: stackBehindDismiss(),
                    child: ListTile(
                      tileColor: Colors.blue[50],
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.horizontal()),
                      title: Text(
                        eventItems[index],
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(eventDates[index]),
                      trailing: InkWell(
                        child: Icon(Icons.list),
                        onTap: () {
                          displayEvent(context, eventItems[index],
                              eventLocations[index]);
                        },
                      ),
                    ));
              },
            ))
          ],
        ),
      ),
    );
  }
}
