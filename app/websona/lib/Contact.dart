import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class Contact extends StatefulWidget {
  final person;

  Contact({@required this.person});

  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<Contact> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: new Container(
      padding: new EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
              padding: EdgeInsets.only(top: 30.0),
              child: new Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  InkWell(
                      child: new Icon(
                        Icons.arrow_back_ios,
                        color: Colors.black,
                        size: 22.0,
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      }),
                  Padding(
                    padding: EdgeInsets.only(left: 0.0),
                    child: new Text('Contacts',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                            fontFamily: 'sans-serif-light',
                            color: Colors.black)),
                  )
                ],
              )),
          Container(
            width: 140.0,
            height: 140.0,
            margin: EdgeInsets.only(top: 20),
            decoration: new BoxDecoration(
              shape: BoxShape.circle,
              image: new DecorationImage(
                image: new ExactAssetImage('asset/img/background.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
              child: Text(widget.person.name[0],
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 40.0,
                      fontFamily: 'sans-serif-light',
                      color: Colors.white)),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: ListTile(
              title: Text(
                widget.person.name,
                style: TextStyle(
                    fontSize: 28,
                    color: Colors.black,
                    fontWeight: FontWeight.w600),
              ),
              onTap: () {},
            ),
          ),
          Expanded(
              child: ListView.separated(
            padding: EdgeInsets.only(top: 15),
            itemCount: widget.person.socialLinks.length,
            separatorBuilder: (BuildContext context, int index) => Divider(
              color: Colors.white,
            ),
            itemBuilder: (BuildContext ctxt, int index) {
              return new ListTile(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.horizontal()),
                title: Text(
                  widget.person.socialLinks[index],
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.w600),
                ),
                //subtitle: Text(eventDates[index]),
                leading: Icon(Icons.keyboard_arrow_right_rounded),
                onTap: () {
                  //code to see each event here
                },
              );
            },
          ))
        ],
      ),
    ));
  }
}
