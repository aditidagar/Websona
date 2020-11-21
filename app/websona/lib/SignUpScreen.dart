import 'dart:convert';
import 'main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const Pattern emailRegexPattern =
    r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$";

RegExp emailValidator = new RegExp(emailRegexPattern);
const String API_URL = "https://api.thewebsonaapp.com";

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String firstName;
  bool isFirstNameError;
  FocusNode firstNameNode;

  String lastName;

  String email;
  bool emailError;
  FocusNode emailNode;

  String password;
  bool passwordError;
  FocusNode passwordNode;

  String confirmPassword;
  bool confirmPasswordError;
  FocusNode confirmPassNode;

  @override
  void initState() {
    super.initState();

    firstName = "";
    isFirstNameError = false;
    firstNameNode = new FocusNode();

    lastName = "";

    email = "";
    emailError = false;
    emailNode = new FocusNode();

    password = "";
    passwordError = false;
    passwordNode = new FocusNode();

    confirmPassword = "";
    confirmPasswordError = false;
    confirmPassNode = new FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    firstNameNode.dispose();
    emailNode.dispose();
    passwordNode.dispose();
    confirmPassNode.dispose();
  }

  void handleFirstNameChange(String text) {
    setState(() {
      firstName = text;
      isFirstNameError = false;
    });
  }

  void handleLastNameChange(String text) {
    setState(() {
      lastName = text;
    });
  }

  void handleEmailChange(String text) {
    setState(() {
      email = text;
      emailError = false;
    });
  }

  void handlePasswordChange(String text) {
    setState(() {
      password = text;
      passwordError = false;
    });
  }

  void handleConfirmPasswordChange(String text) {
    setState(() {
      confirmPassword = text;
      confirmPasswordError = false;
    });
  }

  void handleSubmit() async {
    if (firstName.length == 0) {
      setState(() {
        isFirstNameError = true;
        firstNameNode.requestFocus();
      });
      return;
    }

    if (!emailValidator.hasMatch(email)) {
      setState(() {
        emailError = true;
        emailNode.requestFocus();
      });
      return;
    }

    if (password.length < 6) {
      setState(() {
        passwordError = true;
        passwordNode.requestFocus();
      });

      return;
    }

    if (confirmPassword != password) {
      setState(() {
        confirmPasswordError = true;
        confirmPassNode.requestFocus();
      });

      return;
    }

    // all fields are valid, sent signup request to the server
    Response response = await post(API_URL + "/signup",
        headers: <String, String>{'Content-Type': 'application/json'},
        body: jsonEncode(<String, String>{
          'first': firstName,
          'last': lastName,
          'email': email,
          'password': password
        }));
    if (response.statusCode == 201) {
      // successful signup
      // obtain shared preferences
      final prefs = await SharedPreferences.getInstance();
      final secureStorage = new FlutterSecureStorage();
      final responseBody = jsonDecode(response.body);

      prefs.setString('access_token', responseBody['accessToken']);
      prefs.setInt(
          'tokenExpiryTime',
          (responseBody['tokenExpiryTime'] * 1000) +
              DateTime.now().millisecondsSinceEpoch);
      prefs.setString('email', email);
      await secureStorage.write(key: 'websona-password', value: password);

      // go to the home page
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MyStatefulWidget(),
        ),
      );
    } else {
      showAlertDialog(context);
    }
  }

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Error"),
      content: Text("500: Server error. Please try again later"),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: <Widget>[
          BackButtonWidget(),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: <Widget>[
                Expanded(
                    child: Container(
                        margin: EdgeInsets.only(right: 20, left: 10),
                        child: new Theme(
                          data: new ThemeData(
                              primaryColor:
                                  isFirstNameError ? Colors.red : Colors.blue),
                          child: TextField(
                            focusNode: firstNameNode,
                            onChanged: handleFirstNameChange,
                            textCapitalization: TextCapitalization.words,
                            decoration: InputDecoration(
                                hintText: 'First Name',
                                suffixText: isFirstNameError
                                    ? "This can't be empty"
                                    : "",
                                suffixStyle: TextStyle(color: Colors.red),
                                prefixIcon: Icon(Icons.person)),
                          ),
                        )))
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: <Widget>[
                Expanded(
                    child: Container(
                        margin: EdgeInsets.only(right: 20, left: 10),
                        child: TextField(
                          enableSuggestions: true,
                          autocorrect: true,
                          onChanged: handleLastNameChange,
                          textCapitalization: TextCapitalization.words,
                          decoration: InputDecoration(
                              hintText: 'Last Name',
                              prefixIcon: Icon(Icons.person)),
                        )))
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: <Widget>[
                Expanded(
                    child: Container(
                        margin: EdgeInsets.only(right: 20, left: 10),
                        child: new Theme(
                            data: new ThemeData(
                                primaryColor:
                                    emailError ? Colors.red : Colors.blue),
                            child: TextField(
                              focusNode: emailNode,
                              enableSuggestions: true,
                              autocorrect: true,
                              onChanged: handleEmailChange,
                              decoration: InputDecoration(
                                  suffixText: emailError ? "Invalid Email" : "",
                                  suffixStyle: TextStyle(color: Colors.red),
                                  hintText: 'Email',
                                  prefixIcon: Icon(Icons.email)),
                            ))))
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: <Widget>[
                Expanded(
                    child: Container(
                        margin: EdgeInsets.only(right: 20, left: 10),
                        child: new Theme(
                          data: new ThemeData(
                              primaryColor:
                                  passwordError ? Colors.red : Colors.blue),
                          child: TextField(
                            focusNode: passwordNode,
                            obscureText: true,
                            enableSuggestions: false,
                            autocorrect: false,
                            onChanged: handlePasswordChange,
                            decoration: InputDecoration(
                                hintText: 'Password',
                                suffixText: passwordError
                                    ? "Must be at least 6 characters"
                                    : "",
                                suffixStyle: TextStyle(color: Colors.red),
                                prefixIcon: Icon(Icons.lock)),
                          ),
                        )))
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: <Widget>[
                Expanded(
                    child: Container(
                        margin: EdgeInsets.only(right: 20, left: 10),
                        child: new Theme(
                          data: new ThemeData(
                              primaryColor: confirmPasswordError
                                  ? Colors.red
                                  : Colors.blue),
                          child: TextField(
                            focusNode: confirmPassNode,
                            obscureText: true,
                            enableSuggestions: false,
                            autocorrect: false,
                            onChanged: handleConfirmPasswordChange,
                            decoration: InputDecoration(
                                hintText: 'Confirm Password',
                                suffixText: confirmPasswordError
                                    ? "Must match entered password"
                                    : "",
                                suffixStyle: TextStyle(color: Colors.red),
                                prefixIcon: Icon(Icons.lock)),
                          ),
                        )))
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Container(
                height: 60,
                child: RaisedButton(
                  onPressed: handleSubmit,
                  color: Color(0xFF007AFE),
                  child: Text(
                    'SIGN UP',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BackButtonWidget extends StatelessWidget {
  const BackButtonWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage('asset/img/background.png'))),
      child: Positioned(
          child: Stack(
        children: <Widget>[
          Positioned(
              top: 20,
              child: Row(
                children: <Widget>[
                  IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                  Text(
                    'Back',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  )
                ],
              )),
        ],
      )),
    );
  }
}
