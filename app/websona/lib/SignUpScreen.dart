import 'package:flutter/material.dart';
import 'main.dart';

const Pattern emailRegexPattern =
    r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$";

RegExp emailValidator = new RegExp(emailRegexPattern);

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String firstName = "";
  bool isFirstNameError = false;
  FocusNode firstNameNode = new FocusNode();

  String lastName = "";

  String email = "";
  bool emailError = false;
  FocusNode emailNode = new FocusNode();

  String password = "";
  bool passwordError = false;
  FocusNode passwordNode = new FocusNode();

  String confirmPassword = "";
  bool confirmPasswordError = false;
  FocusNode confirmPassNode = new FocusNode();

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

  void handleSubmit() {
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
                  onPressed: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => MyStatefulWidget(),
                    //   ),
                    // );
                    handleSubmit();
                  },
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
