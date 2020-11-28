import 'package:flutter/material.dart';

class Event extends StatefulWidget {
  @override
  _EventState createState() => _EventState();
}

class _EventState extends State<Event> {
  DateTime selectedDate = DateTime.now();
  List<String> eventItems = [];
  List<String> eventDates = [];
  List<String> eventNames = [
    'Harsh Jhunjhunwala',
    'Aditi Dagar',
    'Ibrahim Fazili',
    'Saakshi Shah',
    'Gautam Gireesh'
  ];
  List<String> eventEmails = [
    'harsh.jhunjhunwala@mail.utoronto.ca',
    'aditi.dagar@mail.utoronto.ca',
    'ibrahim.fazili@mail.utoronto.ca',
    'saakshi.shah@mail.utoronto.ca',
    'gautam.gireesh@mail.utoronto.ca'
  ];

  List<String> eventPictures = [
    'https://picsum.photos/250?image=9',
    'https://picsum.photos/250?image=10',
    'https://picsum.photos/250?image=11',
    'https://picsum.photos/250?image=12',
    'https://picsum.photos/250?image=13'
  ];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  createDialog(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController locationController = TextEditingController();
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            child: Container(
              height: 250,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(hintText: 'Name'),
                    ),
                    TextField(
                      controller: locationController,
                      decoration: InputDecoration(hintText: 'Location'),
                    ),
                    new RaisedButton(
                      onPressed: () => _selectDate(context),
                      child: Text("Select date"),
                    ),
                    SizedBox(
                      width: 150.0,
                      child: RaisedButton(
                        onPressed: () {
                          eventItems.add(nameController.text);
                          eventDates.add(
                              "${selectedDate.day.toString().padLeft(2, '0')}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.year.toString()}");
                          setState(() {});
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          "Create",
                          style: TextStyle(color: Colors.white),
                        ),
                        color: const Color(0xFF1BC0C5),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  displayEvent(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(
              leading: InkWell(
                  child: new Icon(
                    Icons.arrow_back_ios,
                    color: Colors.black,
                    size: 22.0,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  }),
              title: const Text(
                'Events',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
              ),
              backgroundColor: Colors.blue,
              bottomOpacity: 0.0,
              elevation: 0.0,
              centerTitle: false,
              automaticallyImplyLeading: false,
            ),
            body: new Container(
              padding: new EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  new Align(
                      alignment: Alignment.centerLeft,
                      child: new Text("Participants",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                              fontSize: 30))),
                  new Expanded(
                      child: ListView.separated(
                    padding: EdgeInsets.only(top: 15),
                    itemCount: eventNames.length,
                    separatorBuilder: (BuildContext context, int index) =>
                        Divider(
                      color: Colors.white,
                    ),
                    itemBuilder: (BuildContext ctxt, int index) {
                      return new ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(eventPictures[
                              index]), // no matter how big it is, it won't overflow
                        ),
                        tileColor: Colors.blue[50],
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        title: Text(
                          eventNames[index],
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text(eventEmails[index]),
                        onTap: () {
                          //code to see each event here
                        },
                      );
                    },
                  ))
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '  Events',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
        ),
        backgroundColor: Colors.transparent,
        bottomOpacity: 0.0,
        elevation: 0.0,
        centerTitle: false,
        automaticallyImplyLeading: false,
      ),
      body: new Container(
        padding: new EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: ListTile(
                tileColor: Color(0xFFEAF4FE),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.horizontal()),
                title: Text(
                  "Create New Event",
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.w600),
                ),
                trailing: Icon(
                  Icons.add_circle,
                  color: Colors.blue[200],
                  size: 40,
                ),
                onTap: () {
                  createDialog(context);
                },
              ),
            ),
            new Expanded(
                child: ListView.separated(
              padding: EdgeInsets.only(top: 15),
              itemCount: eventItems.length,
              separatorBuilder: (BuildContext context, int index) => Divider(
                color: Colors.white,
              ),
              itemBuilder: (BuildContext ctxt, int index) {
                final item = eventItems[index];
                return new Dismissible(
                    key: Key(item),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) {
                      // if (direction == DismissDirection.endToStart) {
                      setState(() {
                        eventDates.removeAt(index);
                        eventItems.removeAt(index);
                      });
                      Scaffold.of(context).showSnackBar(
                          SnackBar(content: Text("Event deleted ")));
                      // }
                    },
                    background: Container(color: Colors.red),
                    child: ListTile(
                      tileColor: Colors.blue[50],
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.horizontal()),
                      title: Text(
                        eventItems[index],
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(eventDates[index]),
                      trailing: InkWell(
                        child: Icon(Icons.list),
                        onTap: () {
                          displayEvent(context);
                        },
                      ),
                    ));
                // ListTile(
                //   tileColor: Colors.blue[50],
                //   shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.horizontal()),
                //   title: Text(
                //     eventItems[index],
                //     style: TextStyle(
                //         fontSize: 18,
                //         color: Colors.black,
                //         fontWeight: FontWeight.w600),
                //   ),
                //   subtitle: Text(eventDates[index]),
                //   trailing: InkWell(
                //     child: Icon(Icons.list),
                //     onTap: () {
                //       displayEvent(context);
                //     },
                //   ),
                // );
              },
            ))
          ],
        ),
      ),
    );
  }
}
