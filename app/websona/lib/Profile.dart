import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main.dart';

class ProfilePage extends StatefulWidget {
  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _nameController;
  static List<String> _mediaLink = [];
  static List<String> media = [];
  String _name = '';
  String _email = '';
  String _phone = '';

  static bool _status = true;
  File _image;
  String dropdownValue = 'Please choose a social link';
  List<String> _socialLinks = [
    'LinkedIn',
    'Instagram',
    'SnapChat',
    'Facebook',
    'WeChat',
    'Twitter'
  ];

  void initializeProfile() async {
    final prefs = await SharedPreferences.getInstance();

    Response response = await get(
        "http://10.0.2.2:3000/user/" + prefs.getString('email'),
        headers: <String, String>{
          'authorization': await getAuthorizationToken(context),
        });

    final responseBody = jsonDecode(response.body);
    List<String> mediaLink_temp = [];
    List<String> media_temp = [];
    for (int index = 0; index < responseBody['socials'].length; index++) {
      setState(() {
        media_temp.add(responseBody['socials'][index]['social']);
        mediaLink_temp.add(responseBody['socials'][index]['username']);
      });
    }

    setState(() {
      _email = prefs.getString('email');
      _name = responseBody['name'];
      _phone = responseBody['phone'];
      media = media_temp;
      _mediaLink = mediaLink_temp;
    });
  }

  Future<void> updateProfile() async {
    String lastName = _name.split(" ")[_name.split(" ").length - 1];
    String firstName = _name.substring(0, _name.length - lastName.length - 1);

    var socialProject = [];
    for (int index = 0; index < media.length; index++) {
      socialProject
          .add({'social': media[index], 'username': _mediaLink[index]});
    }
    Response response = await post("http://10.0.2.2:3000/updateUser",
        headers: <String, String>{
          'authorization': await getAuthorizationToken(context),
          'Content-Type': 'application/json'
        },
        body: jsonEncode({
          'firstName': firstName,
          'lastName': lastName,
          'email': _email,
          'phone': _phone,
          'socials': socialProject
        }));
  }

  final FocusNode myFocusNode = FocusNode();

  @override
  initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    _nameController = TextEditingController();
    initializeProfile();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: new Container(
      color: Colors.white,
      child: new Form(
        key: _formKey,
        child: new ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                new Container(
                  height: 250.0,
                  color: Colors.white,
                  child: new Column(
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.only(left: 20.0, top: 20.0),
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
                                padding: EdgeInsets.only(left: 25.0),
                                child: new Text('PROFILE',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0,
                                        fontFamily: 'sans-serif-light',
                                        color: Colors.black)),
                              )
                            ],
                          )),
                      Padding(
                        padding: EdgeInsets.only(top: 20.0),
                        child:
                            new Stack(fit: StackFit.loose, children: <Widget>[
                          new Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              new Container(
                                  width: 140.0,
                                  height: 140.0,
                                  decoration: new BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: new DecorationImage(
                                      image: NetworkImage(
                                          'https://picsum.photos/250?image=9'),
                                      fit: BoxFit.cover,
                                    ),
                                  )),
                            ],
                          ),
                          Padding(
                              padding: EdgeInsets.only(top: 90.0, right: 100.0),
                              child: new Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  new GestureDetector(
                                    child: new CircleAvatar(
                                      backgroundColor: Colors.red,
                                      radius: 25.0,
                                      child: new Icon(
                                        Icons.camera_alt,
                                        color: Colors.white,
                                      ),
                                    ),
                                    onTap: () => {_showPicker(context)},
                                  )
                                ],
                              )),
                        ]),
                      )
                    ],
                  ),
                ),
                new Container(
                  color: Color(0xffFFFFFF),
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 25.0),
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 25.0),
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                new Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    new Text(
                                      'Personal Information',
                                      style: TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                new Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    _status ? _getEditIcon() : new Container(),
                                  ],
                                )
                              ],
                            )),
                        Padding(
                            padding: EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 25.0),
                            child: new Row(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                new Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    new Text(
                                      'Name',
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ],
                            )),
                        Padding(
                            padding: EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 2.0),
                            child: new Row(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                new Flexible(
                                  child: new TextFormField(
                                    controller:
                                        TextEditingController(text: _name),
                                    keyboardType: TextInputType.text,
                                    textInputAction: TextInputAction.next,
                                    textCapitalization:
                                        TextCapitalization.words,
                                    decoration: const InputDecoration(
                                      hintText: "Enter Your Name",
                                    ),
                                    enabled: !_status,
                                    autofocus: !_status,
                                    validator: (name) {
                                      Pattern pattern =
                                          //
                                          r'^[a-zA-ZàáâäãåąčćęèéêëėįìíîïłńòóôöõøùúûüųūÿýżźñçčšžÀÁÂÄÃÅĄĆČĖĘÈÉÊËÌÍÎÏĮŁŃÒÓÔÖÕØÙÚÛÜŲŪŸÝŻŹÑßÇŒÆČŠŽ∂ð ,.-]+$';
                                      RegExp regex = new RegExp(pattern);
                                      if (!regex.hasMatch(name))
                                        return 'Invalid name';
                                      else
                                        return null;
                                    },
                                    onSaved: (value) => _name = value,
                                  ),
                                ),
                              ],
                            )),
                        Padding(
                            padding: EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 25.0),
                            child: new Row(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                new Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    new Text(
                                      'Email ID',
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ],
                            )),
                        Padding(
                            padding: EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 2.0),
                            child: new Row(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                new Flexible(
                                  child: new Text(_email),
                                ),
                              ],
                            )),
                        Padding(
                            padding: EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 25.0),
                            child: new Row(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                new Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    new Text(
                                      'Mobile',
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ],
                            )),
                        Padding(
                            padding: EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 2.0),
                            child: new Row(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                new Flexible(
                                  child: new TextFormField(
                                    controller:
                                        TextEditingController(text: _phone),
                                    keyboardType: TextInputType.emailAddress,
                                    textInputAction: TextInputAction.next,
                                    decoration: const InputDecoration(
                                        hintText: "Enter Mobile Number"),
                                    enabled: !_status,
                                    validator: (phoneNumber) {
                                      Pattern pattern =
                                          r'^(?:[+0]1)?[0-9]{10}$';
                                      RegExp regex = new RegExp(pattern);
                                      if (!regex.hasMatch(phoneNumber))
                                        return 'Enter Valid Phone Number';
                                      else
                                        return null;
                                    },
                                    onSaved: (value) => _phone = value,
                                  ),
                                ),
                              ],
                            )),
                        _status == false
                            ? Padding(
                                padding: EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 25.0),
                                child: new Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    new Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        new Text(
                                          'Links',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                ))
                            : Container(),
                        _status == false
                            ? Padding(
                                padding: EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 2.0),
                                child: new Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Container(
                                        width: 300,
                                        child: DropdownButton(
                                          hint: dropdownValue == null
                                              ? Text('Dropdown')
                                              : Text(
                                                  dropdownValue,
                                                  style: TextStyle(
                                                      color: Colors.blue),
                                                ),
                                          isExpanded: true,
                                          iconSize: 30.0,
                                          style: TextStyle(color: Colors.blue),
                                          items: _socialLinks.map(
                                            (val) {
                                              return DropdownMenuItem<String>(
                                                value: val,
                                                child: new Text(val),
                                              );
                                            },
                                          ).toList(),
                                          onChanged: (val) {
                                            setState(
                                              () {
                                                // dropdownValue = val;;
                                                if (media.contains(val) ==
                                                    false) {
                                                  media.insert(0, val);
                                                  _mediaLink.insert(0, null);
                                                }
                                              },
                                            );
                                          },
                                        ))
                                  ],
                                ))
                            : Container(),
                        Padding(
                          padding: _status == false
                              ? EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0)
                              : EdgeInsets.only(
                                  left: 10.0, right: 25.0, top: 2.0),
                          // child: Form(
                          //   key: _formKey,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // name textfield
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  'Social Links',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16),
                                ),
                                ..._getLinks(),
                                SizedBox(
                                  height: 40,
                                ),
                              ],
                            ),
                          ),
                        ),
                        // ),
                        !_status ? _getActionButtons() : new Container(),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    ));
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myFocusNode.dispose();
    super.dispose();
  }

  _imgFromCamera() async {
    final _picker = ImagePicker();
    PickedFile image =
        await _picker.getImage(source: ImageSource.camera, imageQuality: 50);

    setState(() {
      _image = File(image.path);
    });
  }

  Future _imgFromGallery() async {
    print("im here");
    final _picker = ImagePicker();
    PickedFile image =
        await _picker.getImage(source: ImageSource.gallery, imageQuality: 50);
    setState(() {
      _image = File(image.path);
    });
    final prefs = await SharedPreferences.getInstance();
    var _email = prefs.getString('email');
    Response response = await get(
      'http://10.0.2.2:3000/updateProfilePicture?email=$_email',
      headers: <String, String>{
        'authorization': await getAuthorizationToken(context),
      },
    );
  }

  Widget _getActionButtons() {
    return Padding(
      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 45.0),
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Container(
                  child: new RaisedButton(
                child: new Text("Save"),
                textColor: Colors.white,
                color: Colors.green,
                onPressed: () {
                  if (_formKey.currentState.validate() == true) {
                    _formKey.currentState.save();
                    setState(() {
                      _status = true;
                      updateProfile();
                      // fix this
                      FocusScope.of(context).requestFocus(new FocusNode());
                    });
                  }
                },
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(20.0)),
              )),
            ),
            flex: 2,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Container(
                  child: new RaisedButton(
                child: new Text("Cancel"),
                textColor: Colors.white,
                color: Colors.red,
                onPressed: () {
                  setState(() {
                    _status = true;
                    _formKey.currentState.reset();
                    FocusScope.of(context).requestFocus(new FocusNode());
                  });
                },
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(20.0)),
              )),
            ),
            flex: 2,
          ),
        ],
      ),
    );
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget _getEditIcon() {
    return new GestureDetector(
      child: new CircleAvatar(
        backgroundColor: Colors.red,
        radius: 14.0,
        child: new Icon(
          Icons.edit,
          color: Colors.white,
          size: 16.0,
        ),
      ),
      onTap: () {
        setState(() {
          _status = false;
        });
      },
    );
  }

  List<Widget> _getLinks() {
    List<Widget> linkTextfields = [];
    for (int i = 0; i < _mediaLink.length; i++) {
      linkTextfields.add(Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Row(
          children: [
            Expanded(child: FriendTextFields(i)),
            SizedBox(
              width: 16,
            ),
            // we need add button at last friends row
            _removeLink(i),
          ],
        ),
      ));
    }
    return linkTextfields;
  }

  /// add / remove button
  Widget _removeLink(int index) {
    return MapScreenState._status == false
        ? InkWell(
            onTap: () {
              _mediaLink.removeAt(index);
              media.removeAt(index);
              if (media.length == 0) {
                media = [''];
              }
              setState(() {});
            },
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.remove,
                color: Colors.white,
              ),
            ),
          )
        : Container();
  }
}

class FriendTextFields extends StatefulWidget {
  final int index;
  FriendTextFields(this.index);
  @override
  _FriendTextFieldsState createState() => _FriendTextFieldsState();
}

class _FriendTextFieldsState extends State<FriendTextFields> {
  TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _nameController.text = MapScreenState._mediaLink[widget.index] ?? '';
    });
    return Padding(
      padding: EdgeInsets.only(left: 5.0, right: 25.0, top: 2.0),
      child: Row(
        children: [
          Text(MapScreenState.media[widget.index]),
          SizedBox(width: 10),
          new Flexible(
              child: TextFormField(
            enabled: !MapScreenState._status,
            controller: _nameController,
            onSaved: (v) => {
              MapScreenState._mediaLink[widget.index] = v,
            },
            decoration:
                InputDecoration(hintText: 'Enter your social media link'),
            validator: (v) {
              if (v.trim().isEmpty) return 'Please enter something';
              return null;
            },
          ))
        ],
      ),
    );
  }
}
