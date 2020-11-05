import 'package:flutter/material.dart';

class Event extends StatefulWidget {
  @override
  _EventState createState() => _EventState();
}

class _EventState extends State<Event> {
  DateTime selectedDate = DateTime.now();
  List<String> eventItems = [];
  List<String> eventLocations = [];

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
                          eventLocations.add(locationController.text);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Events'),
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
                    style: TextStyle(fontSize: 18, color: Colors.black, fontWeight:FontWeight.w600),
                  ),
                  trailing: Icon(Icons.add_circle, color: Colors.blue[200],size:40,),
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
                return new ListTile(
                  tileColor: Colors.blue[50] ,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.horizontal()),
                  title: Text(
                    eventItems[index],
                    style: TextStyle(fontSize: 18, color: Colors.black, fontWeight:FontWeight.w600),
                  ),
                  subtitle: Text(eventLocations[index]),
                  trailing: Icon(Icons.list),
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
  }
}
