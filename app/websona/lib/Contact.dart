import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Contact extends StatefulWidget {
  final person;

  Contact({@required this.person});

  @override
  MapScreenState createState() => MapScreenState();
}

//mapping for Icons
Map<String, IconData> iconMapping = {
  'Instagram' : FontAwesomeIcons.instagram,
  'Twitter': FontAwesomeIcons.twitter,
  'SnapChat': FontAwesomeIcons.snapchat,
  'LinkedIn': FontAwesomeIcons.linkedin,
  'Facebook': FontAwesomeIcons.facebook,
  'WeChat': FontAwesomeIcons.weixin,
};

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
              title: Center(
                  child: Text(
                widget.person.name,
                style: TextStyle(
                    fontSize: 28,
                    color: Colors.black,
                    fontWeight: FontWeight.w600),
              )),
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
              IconData iconSocial = FontAwesomeIcons.link;
              if (iconMapping[
                      '${widget.person.socialLinks[index].socialMedia}'] !=
                  null) {
                iconSocial = iconMapping[
                    '${widget.person.socialLinks[index].socialMedia}'];
              }
              return new Material(
                  //color: Colors.blue[50],
                  child: ListTile(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.horizontal()),
                title: Text(
                  widget.person.socialLinks[index].handle,
                  style: TextStyle(
                      fontSize: 19,
                      color: Colors.black,
                      fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  widget.person.socialLinks[index].socialMedia,
                  style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey,
                      fontWeight: FontWeight.w600),
                ),
                // ignore: missing_required_param
                leading: IconButton(
                  iconSize: 35.0,
                  icon: FaIcon(iconSocial,
                    color: Colors.black,
                  ),
                ),
                //Icon(Icons.keyboard_arrow_right_rounded),
                onTap: () {
                  //code to see each event here
                },
              ));
            },
          ))
        ],
      ),
    ));
  }
}
