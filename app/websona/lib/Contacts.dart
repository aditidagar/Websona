import 'package:flutter/material.dart';
import 'Contact.dart';

class Contacts extends StatefulWidget {
  @override
  _ContactsState createState() => _ContactsState();
}

//Person class
class Person {
  String name;
  List<String> socialLinks;
  Person(this.name, this.socialLinks);
}

class _ContactsState extends State<Contacts> {
  Person person1 = new Person('John', ['john@gmail.com', 'john123']);
  Person person2 = new Person('Julie', ['julie@yahoo.com', 'julie_s']);
  List<Person> contactInfo = [];
  List<String> contacts = [];
  List<String> contactsFiltered = [];
  TextEditingController searchController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      filterContacts();
    });
    //adds two people
    contactInfo.add(person1);
    contactInfo.add(person2);
    //loops through list of 'Persons' to extract contact names
    for (int i = 0; i < contactInfo.length; i++) {
      contacts.add(contactInfo[i].name);
    }
  }

  filterContacts() {
    List<String> _contacts = [];
    _contacts.addAll(contacts);
    if (searchController.text.isNotEmpty) {
      _contacts.retainWhere((contact) {
        String searchTerm = searchController.text.toLowerCase();
        String contactName = contact.toLowerCase();
        return contactName.startsWith(searchTerm);
      });

      setState(() {
        contactsFiltered = _contacts;
      });
    }
  }

  Widget build(BuildContext context) {
    bool isSearching = searchController.text.isNotEmpty;
    return MaterialApp(
        title: 'Contacts',
        home: Scaffold(
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
                padding: EdgeInsets.all(20),
                child: Column(
                  children: <Widget>[
                    Container(
                      child: TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(10),
                            labelText: 'Search',
                            border: new OutlineInputBorder(
                                borderSide:
                                    new BorderSide(color: Colors.blue[800])),
                            prefixIcon: Icon(
                              Icons.search,
                              color: Colors.blue[800],
                            )),
                      ),
                    ),
                    Expanded(
                        child: ListView.builder(
                            padding: EdgeInsets.all(10.0),
                            shrinkWrap: true,
                            itemCount: isSearching == true
                                ? contactsFiltered.length
                                : contacts.length,
                            itemBuilder: (context, idex) {
                              String contact = isSearching == true
                                  ? contactsFiltered[idex]
                                  : contacts[idex];
                              return ListTile(
                                title: Text(contact),
                                //COULD ADD SUBTITLE HERE FOR THE TAGS FEATURE
                                //displays first letter of name, can change to show picture or initials
                                leading: CircleAvatar(
                                  child: Text(contact[0]),
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Contact(
                                        person: contactInfo[idex],
                                      ),
                                    ),
                                  );
                                },
                              );
                            }))
                  ],
                ))));
  }
}
