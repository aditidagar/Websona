import 'package:flutter/material.dart';

class Event extends StatefulWidget {
  @override
  _EventState createState() => _EventState();
}

class _EventState extends State<Event> {
  DateTime selectedDate = DateTime.now();

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

  // createDialog(BuildContext context) {
  //   TextEditingController customController = TextEditingController();
  //   return showDialog(
  //       context: context,
  //       builder: (context) {
  //         return AlertDialog(
  //           title: Text("New event"),
  //           content:new Column(children: <Widget>[
  //             new TextField(
  //               controller: customController,
  //               decoration: InputDecoration(hintText: "Event Name"),
  //             ),
  //             new TextField(
  //               controller: customController,
  //               decoration: InputDecoration(hintText: "Location"),
  //             ),
  //             new RaisedButton(
  //               onPressed: () => _selectDate(context),
  //               child: Text("Select date"),
  //             )
  //           ]),
  //           actions: <Widget>[
  //             MaterialButton(
  //                 child: Text("Create"),
  //                 onPressed: () {
  //                   Navigator.of(context).pop(customController.text.toString());
  //                 }),
  //           ],
  //         );
  //       });
  // }

  createDialog(BuildContext context) {
    TextEditingController customController = TextEditingController();
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)), //this right here
            child: Container(
              height: 250,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: customController,
                      decoration: InputDecoration(hintText: 'Name'),
                    ),
                    TextField(
                      controller: customController,
                      decoration: InputDecoration(hintText: 'Location'),
                    ),
                    new RaisedButton(
                      onPressed: () => _selectDate(context),
                      child: Text("Select date"),
                    ),
                    SizedBox(
                      width: 150.0,
                      child: RaisedButton(
                        onPressed: () {},
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
              child: RaisedButton(
                  textColor: Colors.black,
                  color: Colors.blue[50],
                  padding: const EdgeInsets.all(10.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40)),
                  onPressed: () => {createDialog(context)},
                  child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                                flex: 3,
                                child: Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Text('Create New Event',
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.black87)))),
                            Expanded(
                                flex: 1,
                                child: Icon(Icons.add_circle,
                                    color: Colors.blue[200], size: 40)),
                          ]))),
            ),
          ],
        ),
      ),
    );
  }
}
