import 'package:flutter/material.dart';
import 'SignUpScreen.dart';
import 'Main.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const Pattern emailRegexPattern =
    r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$";

RegExp emailValidator = new RegExp(emailRegexPattern);

const String API_URL = "https://api.thewebsonaapp.com";

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  String email;
  bool emailError;
  FocusNode emailNode;

  String password;
  bool passwordError;
  FocusNode passwordNode;

  @override
  void initState() {
    super.initState();
    email = "";
    emailError = false;
    emailNode = new FocusNode();

    password = "";
    passwordError = false;
    passwordNode = new FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    emailNode.dispose();
    passwordNode.dispose();
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

  void handleSubmit() async {
    if (!emailValidator.hasMatch(email)) {
      setState(() {
        emailError = true;
        emailNode.requestFocus();
      });
      return;
    }

    if (password.length < 2) {
      setState(() {
        passwordError = true;
        passwordNode.requestFocus();
      });

      return;
    }

    // all fields are valid, sent signup request to the server
    Response response = await post(API_URL + "/login",
        headers: <String, String>{'Content-Type': 'application/json'},
        body:
            jsonEncode(<String, String>{'email': email, 'password': password}));

    if (response.statusCode == 200) {
      // successful login
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
    } else if (response.statusCode == 401) {
      showAlertDialog(context, "Email or Password is incorrect");
    } else {
      showAlertDialog(context, "500: Server error. Please try again later");
    }
  }

  showAlertDialog(BuildContext context, String msg) {
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
      content: Text(msg),
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
          Container(
            height: 300,
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage('asset/img/title.png'))),
          ),
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
                                    emailError ? Colors.red : Colors.blue),
                            child: TextField(
                              focusNode: emailNode,
                              enableSuggestions: true,
                              autocorrect: false,
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
                        ))),
              ],
            ),
          ),
          SizedBox(
            height: 20,
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
                    'SIGN IN',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SignUpScreen(),
                ),
              );
            },
            child: Center(
              child: RichText(
                text: TextSpan(
                    text: 'Don\'t have an account?',
                    style: TextStyle(color: Colors.black),
                    children: [
                      TextSpan(
                        text: ' SIGN UP',
                        style: TextStyle(
                            color: Color(0xFF007AFE),
                            fontWeight: FontWeight.bold),
                      )
                    ]),
              ),
            ),
          )
        ],
      ),
    );
  }
}
