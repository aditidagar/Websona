import 'package:flutter/material.dart';

class Item {
  Item(this.name);
  String name;
}

class editsurvey extends StatefulWidget {
  @override
  _editsurveyState createState() => _editsurveyState();
}

class _editsurveyState extends State<editsurvey> {
  int surveyquestionnum = 1;
  int surveyquestiontotal = 1;

  List<Item> selectedUser = [null];
  List<Item> selecteddata = [null, null];
  List<Item> users;

  int linkdevices = 1;
  String dropdownvalue = "SELECT FROM DROPDOWN";
  List data = [
    'Sample Data 1',
    'Sample Data 2',
    'Sample Data 3',
    'Sample Data 4',
    'Sample Data 5',
    'Sample Data 6',
  ];

  @override
  void initState() {
    super.initState();
    users = <Item>[
      Item('Sample device 1'),
      Item('Sample device 2'),
      Item('Sample device 3'),
      Item('Sample device 4'),
    ];
  }

  @override
  Widget _dropdownbutton(List<Item> userlist, int index) {
    return Container(
      padding: EdgeInsets.all(1),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.all(Radius.circular(15.0) //
            ),
      ),
      child: DropdownButton<Item>(
        underline: SizedBox(),
        isExpanded: true,
        icon: Icon(Icons.arrow_drop_down),
        hint: Text("  $dropdownvalue"),
        value: selectedUser[index],
        onChanged: (Item Value) {
          print(Value.toString());
          print(index);
          setState(() {
            selectedUser[index] = Value;
          });
        },
        items: userlist.map((Item user) {
          return DropdownMenuItem<Item>(
            value: user,
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: 10,
                ),
                Text(
                  user.name,
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _text(texthere, bold, size, color) {
    return Text(texthere,
        style: TextStyle(fontWeight: bold, fontSize: size, color: color),
        overflow: TextOverflow.ellipsis,
        maxLines: 1);
  }

  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.black,
                            width: 1.0,
                            style: BorderStyle.solid)),
                    width: screenWidth / 1.6,
                    height: screenHeight / 1.6,
                    child: Column(
                      children: <Widget>[
                        _text("DEVICES PINNED", FontWeight.bold, 20.0,
                            Colors.blue),
                        ListView.separated(
                          shrinkWrap: true,
                          itemCount: linkdevices,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: _dropdownbutton(users, index),
                            );
                          },
                          separatorBuilder: (context, index) =>
                              Container(height: 10),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            InkWell(
                              child: Text("ADD DEVICE"),
                              onTap: () {
                                selectedUser.add(null);
                                linkdevices++;
                                setState(() {});
                                /*listWidget.add(  ListView.separated(
                                  shrinkWrap: true,
                                  itemCount: linkdevices,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: _dropdownbutton(users, index),
                                    );
                                  },
                                  separatorBuilder: (context, index) => Container(height: 10),
                                ));
                                setState(() {

                                });*/
                              },
                            ),
                            InkWell(
                              child: Text("CLEAR ALL DEVICE"),
                              onTap: () {},
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
