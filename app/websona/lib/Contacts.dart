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
  Person person1 =
      new Person('John', ['john@gmail.com', 'john123', 'john_stamos']);
  Person person2 = new Person('Julie', ['julie@yahoo.com', 'julie_s']);
  Person person3 = new Person('Adam', []);
  Person person4 = new Person(
      'Rachel', ['rachel@gmail.com', 'RachelGreen', 'r_green', '@rachel']);
  List<Person> contactInfo = [];
  List<Person> contactsFiltered = [];
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
    contactInfo.add(person3);
    contactInfo.add(person4);
    
    contactInfo.sort((a, b) => a.name.compareTo(b.name));
  }

  filterContacts() {
    List<Person> _contacts = [];
    _contacts.addAll(contactInfo);
    if (searchController.text.isNotEmpty) {
      _contacts.retainWhere((contact) {
        String searchTerm = searchController.text.toLowerCase();
        String contactName = contact.name.toLowerCase();
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
                child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 20, right: 20.0, top: 20.0),
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
