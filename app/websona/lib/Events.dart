import 'dart:convert';
import 'package:http/http.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:marquee_widget/marquee_widget.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'main.dart';

const String API_URL = "https://api.thewebsonaapp.com";

class Event extends StatefulWidget {
  @override
  _EventState createState() => _EventState();
}

class _EventState extends State<Event> {
  /*
  _id: ObjectId;
  codeId: string;
    owner: string;
    name: string;
    location: string;
    date: number; // Unix timestamp
    attendees: {
        firstName: string;
        lastName: string;
        email: string;
    }[];
   */
  List<dynamic> events = [];
  String eventPictures = 'https://picsum.photos/250?image=9';
  DateTime selectedDate = DateTime.now();

  loadEvents() async {
    Response response = await get(
      API_URL + "/events",
      headers: <String, String>{
        'authorization': await getAuthorizationToken(context)
      },
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      events = [];
      for (var ev in data) {
        events.add(ev);
      }
      setState(() {});
    }
  }

  @override
  initState() {
    super.initState();
    loadEvents();
  }

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
    final _formKey = GlobalKey<FormState>();

    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              child: Form(
                key: _formKey,
                child: Container(
                  height: 280,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: nameController,
                          decoration: InputDecoration(hintText: 'Name'),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter an event name';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: locationController,
                          decoration: InputDecoration(hintText: 'Location'),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter a location';
                            }
                            return null;
                          },
                        ),
                        new RaisedButton(
                          onPressed: () => _selectDate(context),
                          child: Text(
                              DateFormat("dd/MM/yyyy").format(selectedDate)),
                        ),
                        SizedBox(
                          width: 150.0,
                          child: RaisedButton(
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                Map<String, dynamic> event = {
                                  "name": nameController.text,
                                  "location": locationController.text,
                                  "date": selectedDate.millisecondsSinceEpoch
                                };

                                events.add(event);
                                setState(() {});
                                Navigator.of(context).pop();
                                createCodeDialog(context, event,
                                    createEvent: true);
                              }
                            },
                            child: Text(
                              "Create",
                              style: TextStyle(color: Colors.white),
                            ),
                            color: const Color(0xFF2196F3),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ));
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

  displayEvent(BuildContext context, Map<String, dynamic> event) {
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
                        child: Text(event['name']),
                        animationDuration:
                            Duration(seconds: event['name'].length ~/ 8),
                        backDuration:
                            Duration(seconds: event['name'].length ~/ 8),
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
                            event['location'],
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
                                  child: event['attendees'].length == null
                                      ? Text("0",
                                          style: TextStyle(
                                            fontSize: 55,
                                          ))
                                      : Text(
                                          event['attendees'].length.toString(),
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
                    itemCount: event['attendees'].length,
                    separatorBuilder: (BuildContext context, int index) =>
                        Divider(
                      color: Colors.white,
                    ),
                    itemBuilder: (BuildContext ctxt, int index) {
                      return new ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                                eventPictures), // no matter how big it is, it won't overflow
                          ),
                          tileColor: Colors.blue[50],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          title: Text(
                            event['attendees'][index]['firstName'] +
                                " " +
                                event['attendees'][index]['lastName'],
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                          ),
                          subtitle: Row(children: [
                            IconButton(
                              icon: FaIcon(FontAwesomeIcons.mailBulk),
                              iconSize: 15,
                            ),
                            Text(
                              event['attendees'][index]['email'],
                              overflow: TextOverflow.ellipsis,
                            )
                          ]));
                    },
                  ))
                ],
              ),
            ),
          );
        });
  }

  createCodeDialog(BuildContext context, Map<String, dynamic> event,
      {bool createEvent = false}) async {
    var qrKey = GlobalKey();
    String codeUrl = "";

    if (createEvent) {
      Response response = await post(
        API_URL + "/newCode?type=event",
        headers: <String, String>{
          "Content-Type": "application/json",
          'authorization': await getAuthorizationToken(context),
        },
      );

      if (response.statusCode == 201) {
        Map<dynamic, dynamic> data = jsonDecode(response.body);
        String codeId = data['codeId'];
        codeUrl = API_URL + '/code/' + codeId;
        if (await submitCreateEvent(codeId, event)) {
          loadEvents();
        }
      }
    } else {
      codeUrl = API_URL + "/code/" + event['codeId'];
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

  Future<bool> submitCreateEvent(
      String codeId, Map<String, dynamic> event) async {
    event["codeId"] = codeId;
    Response response = await post(API_URL + "/newEvent",
        headers: <String, String>{
          "Content-Type": "application/json",
          'authorization': await getAuthorizationToken(context)
        },
        body: jsonEncode(event));

    return response.statusCode == 201;
  }

  deleteEvent(dynamic id) async {
    print(id);
    Response response = await post(API_URL + "/deleteEvent",
        headers: <String, String>{
          "Content-Type": "application/json",
          'authorization': await getAuthorizationToken(context)
        },
        body: jsonEncode({"id": id}));

    print("delete response: " + response.statusCode.toString());
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
              itemCount: events.length,
              separatorBuilder: (BuildContext context, int index) => Divider(
                color: Colors.white,
              ),
              itemBuilder: (BuildContext ctxt, int index) {
                final item = events[index];
                return new Dismissible(
                    key: Key(item['codeId']),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) {
                      deleteEvent(item['_id']);
                      setState(() {
                        events.removeAt(index);
                      });
                      Scaffold.of(context).showSnackBar(
                          SnackBar(content: Text("Event deleted ")));
                    },
                    background: stackBehindDismiss(),
                    child: ListTile(
                        tileColor: Colors.blue[50],
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.horizontal()),
                        title: Text(
                          events[index]['name'],
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text(DateTime.fromMillisecondsSinceEpoch(
                                events[index]['date'])
                            .toString()),
                        trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              InkWell(
                                child: Icon(Icons.qr_code),
                                onTap: () {
                                  createCodeDialog(context, events[index]);
                                },
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              InkWell(
                                child: Icon(Icons.list),
                                onTap: () {
                                  displayEvent(context, events[index]);
                                },
                              ),
                            ])));
              },
            ))
          ],
        ),
      ),
    );
  }
}
