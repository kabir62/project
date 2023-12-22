import 'package:flutter/material.dart';
import 'package:la_creo/admin_panel/admin_navbar.dart';

import '../Firebase/database.dart';



class Admin_Events extends StatefulWidget {
  @override
  _Admin_EventsState createState() => _Admin_EventsState();
}

class _Admin_EventsState extends State<Admin_Events> {
  final _formKey = GlobalKey<FormState>();
  String _eventname = '';
  String _eventdet = '';
  String _eventimg = '';
  String _eventdate = '';

  final Database _firestoreDatabase = Database();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Admin_NavBar(),
      appBar: AppBar(
        title: Text('Events'),
        backgroundColor: Colors.blueGrey,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Event Name',
                  labelText: 'Event Name',
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                  fillColor: Colors.grey.shade200,
                  filled: true,
                  hintStyle: const TextStyle(color: Colors.black),
                  labelStyle: const TextStyle(color: Colors.black),

                ),
                onChanged: (value) {
                  setState(() {
                    _eventname = value!;
                  });
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Date of the Event',
                  labelText: 'Event date',
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                  fillColor: Colors.grey.shade200,
                  filled: true,
                  hintStyle: const TextStyle(color: Colors.black),
                  labelStyle: const TextStyle(color: Colors.black),

                ),
                onChanged: (value) {
                  setState(() {
                    _eventdate = value;
                  });
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Please Enter Event Details',
                  labelText: 'Event Details',
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                  fillColor: Colors.grey.shade200,
                  filled: true,
                  hintStyle: const TextStyle(color: Colors.black),
                  labelStyle: const TextStyle(color: Colors.black),

                ),
                onChanged: (value) {
                  setState(() {
                    _eventdet = value!;
                  });
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                maxLines: 2,
                decoration: InputDecoration(
                  hintText: 'Please enter URL of the Image of the Event',
                  labelText: 'Event Image',
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                  fillColor: Colors.grey.shade200,
                  filled: true,
                  hintStyle: const TextStyle(color: Colors.black),
                  labelStyle: const TextStyle(color: Colors.black),

                ),
                onChanged: (value) {
                  setState(() {
                    _eventimg = value;
                  });
                },
              ),
              SizedBox(height: 16),
              SizedBox(
                width:400,
                child: ElevatedButton(
                  onPressed: () async{
                    String dayNo = '1';
                    final date = DateTime.parse(_eventdate);
                    if(date.weekday == DateTime.tuesday){
                      dayNo = '2';
                    }
                    else if(date.weekday == DateTime.wednesday){
                      dayNo = '3';
                    }
                    else if(date.weekday == DateTime.thursday){
                      dayNo = '4';
                    }
                    else if(date.weekday == DateTime.friday){
                      dayNo = '5';
                    }
                    else if(date.weekday == DateTime.saturday){
                      dayNo = '6';
                    }
                    else if(date.weekday == DateTime.sunday){
                      dayNo = '7';
                    }

                    await _firestoreDatabase.addEvent(_eventname, _eventdet, _eventimg, _eventdate,dayNo);
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return const AlertDialog(
                            title: Text("Event Information"),
                            content: Text("You have successfully created the event"),
                          );
                        });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey,
                  ),
                  child: const Text(
                    'Submit',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}