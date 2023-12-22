import 'package:flutter/material.dart';
import 'package:la_creo/admin_panel/admin_navbar.dart';

import '../Assets/navbar.dart';
import '../Firebase/database.dart';



class Question extends StatefulWidget {
  @override
  _QuestionState createState() => _QuestionState();
}

class _QuestionState extends State<Question> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _message = '';

  static const List<String> items = <String>['Main', 'Subsidiary'];

  String dropdownValue = items.first;

  final Database _firestoreDatabase = Database();

  String formatDateTime(DateTime dateTime) {
    final day = dateTime.day;
    final month = dateTime.month;
    final year = dateTime.year;

    final dayWithSuffix = _getDayWithSuffix(day);
    final monthName = _getMonthName(month);

    return '$dayWithSuffix $monthName, $year';
  }

  String _getDayWithSuffix(int day) {
    if (day >= 11 && day <= 13) {
      return '$day th';
    }
    switch (day % 10) {
      case 1:
        return '$day st';
      case 2:
        return '$day nd';
      case 3:
        return '$day rd';
      default:
        return '$day th';
    }
  }

  String _getMonthName(int month) {
    final monthNames = [
      'January', 'February', 'March', 'April', 'May', 'June', 'July', 'August',
      'September', 'October', 'November', 'December'
    ];
    return monthNames[month - 1];
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavBar(),
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text(
            'Question'),
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
                  hintText: 'Email',
                  labelText: 'email',
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
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the email';
                  }
                  return null;
                },
                onChanged: (value) {
                  _email = value!;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: 'Please Enter Your Message',
                  labelText: 'Question',
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
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your message';
                  }
                  return null;
                },
                onChanged: (value) {
                  _message = value!;
                },
              ),

              const SizedBox(height: 32),
              SizedBox(
                width:400,
                child: ElevatedButton(
                  onPressed: () async{
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                    }

                    DateTime now = DateTime.now();
                    String date = formatDateTime(now);

                    if(_email.isNotEmpty && _message.isNotEmpty) {
                      await _firestoreDatabase.Feedback(_email, _message);
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return const AlertDialog(
                              title: Text("Sent ✅"),
                              content: Text("You have successfully sent your Question!"),
                            );
                          });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                  ),
                  child: const Text(
                    'Submit',
                    style: TextStyle(
                      fontSize: 20,
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