import 'package:flutter/material.dart';
import 'Contact.dart';
import 'dart:convert';
import 'main.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart';

const String API_URL = "https://api.thewebsonaapp.com";

class Contacts extends StatefulWidget {
  @override
  _ContactsState createState() => _ContactsState();
}

//Social Class
class Social {
  String socialMedia;
  String handle;
  Social(this.socialMedia, this.handle);
}

//Person class
class Person {
  String name;
  List<Social> socialLinks;
  Person(this.name, this.socialLinks);
}

class _ContactsState extends State<Contacts> {
  Person person1 = new Person('John', [
    new Social('Instagram', 'john123'),
    new Social('Email', 'john@gmail.com'),
    new Social('Twitter', 'johnStamos')
  ]);
  //Person person2 = new Person('Julie', ['julie@yahoo.com', 'julie_s']);
  //Person person3 = new Person('Adam', []);
  //Person person4 = new Person(
  //'Rachel', ['rachel@gmail.com', 'RachelGreen', 'r_green', '@rachel']);
  List<Person> contactInfo = [];
  List<Person> contactsFiltered = [];
  TextEditingController searchController = new TextEditingController();
  String _email = '';

  @override
  void initState() {
    super.initState();
    // searchController.addListener(() {
    //   filterContacts();
    // });
    //adds two people

    // contactInfo.add(person1);
    // contactInfo.add(person2);
    // contactInfo.add(person3);
    // contactInfo.add(person4);
    loadContacts(context);
  }

  void loadContacts(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _email = prefs.getString('email');
    });
    Response response = await get(
      API_URL + "/getContact?email=" + this._email,
      headers: <String, String>{
        'authorization': await getAuthorizationToken(context),
      },
    );

    var contacts = jsonDecode(response.body);
    List<Person> listContact = [];
    List<Social> listSocial = [];
    for (int i = 0; i < contacts.length; i++) {
      var name = contacts[i]['user'];
      var socialList = contacts[i]['sharedSocials'];
      for (int j = 0; j < socialList.length; j++) {
        String handle = socialList[i]['social'];
        String media = socialList[i]['username'];
        Social s = new Social(media, handle);
        listSocial.add(s);
      }
      Person p = new Person(name, listSocial);
      listContact.add(p);
    }

    setState(() {
      contactInfo = listContact;
    });
  }

  // filterContacts() {
  //   List<Person> _contacts = [];
  //   _contacts.addAll(contactInfo);
  //   if (searchController.text.isNotEmpty) {
  //     _contacts.retainWhere((contact) {
  //       String searchTerm = searchController.text.toLowerCase();
  //       String contactName = contact.name.toLowerCase();
  //       return contactName.startsWith(searchTerm);
  //     });

  //     setState(() {
  //       contactsFiltered = _contacts;
  //     });
  //   }
  // }

  Widget build(BuildContext context) {
    bool isSearching = searchController.text.isNotEmpty;
    if (this.contactInfo.length == 1) {
      return MaterialApp(
          title: 'Contacts',
          home: Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                title: const Text(
                  '  Contacts',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w700),
                ),
                backgroundColor: Colors.transparent,
                bottomOpacity: 0.0,
                elevation: 0.0,
                centerTitle: false,
                automaticallyImplyLeading: false,
              ),
              body: Container(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      "You don't have any contacts yet",
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black54,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ))));
    }
    return MaterialApp(
        title: 'Contacts',
        home: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              title: const Text(
                '  Contacts',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
              ),
              backgroundColor: Colors.transparent,
              bottomOpacity: 0.0,
              elevation: 0.0,
              centerTitle: false,
              automaticallyImplyLeading: false,
            ),
            body: Container(
                child: Column(
              children: <Widget>[
                // Container(
                //   padding: EdgeInsets.only(left: 20, right: 20.0, top: 0.0),
                //   child: TextField(
                //     controller: searchController,
                //     decoration: InputDecoration(
                //         contentPadding: EdgeInsets.all(10),
                //         labelText: 'Search',
                //         border: new OutlineInputBorder(
                //             borderSide:
                //                 new BorderSide(color: Colors.blue[800])),
                //         prefixIcon: Icon(
                //           Icons.search,
                //           color: Colors.blue[800],
                //         )),
                //   ),
                // ),
                Expanded(
                    child: ListView.builder(
                        padding: EdgeInsets.all(5.0),
                        shrinkWrap: true,
                        itemCount: isSearching == true
                            ? contactsFiltered.length
                            : contactInfo.length,
                        itemBuilder: (context, idex) {
                          Person contact = isSearching == true
                              ? contactsFiltered[idex]
                              : contactInfo[idex];
                          return ListTile(
                            title: Text(contact.name),
                            //COULD ADD SUBTITLE HERE FOR THE TAGS FEATURE
                            //displays first letter of name, can change to show picture or initials
                            leading: CircleAvatar(
                              child: Text(contact.name[0]),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      Contact(person: contact),
                                ),
                              );
                            },
                          );
                        }))
              ],
            ))));
  }
}
