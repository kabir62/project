import 'package:flutter/material.dart';
import '../Assets/navbar.dart';
import '../Firebase/database.dart';

String day = "";
int dayIndex = 1;

class MySchedulePage extends StatefulWidget {
  const MySchedulePage({super.key});

  @override
  State<MySchedulePage> createState() => _MySchedulePageState();
}

class _MySchedulePageState extends State<MySchedulePage> {

  List days = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text("Schedule"),
      ),
      drawer: NavBar(),
      body: ListView.builder(
        itemCount: days.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              onTap: () {

                setState(() {
                  day = days[index];
                  dayIndex = index + 1;
                });
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Schedules()));
              },
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    days[index],
                    style: const TextStyle(
                      backgroundColor: Colors.white,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class Schedules extends StatefulWidget {
  const Schedules({super.key});

  @override
  State<Schedules> createState() => _SchedulesState();
}

class _SchedulesState extends State<Schedules> {
  final Database _firestoreDatabase = Database();

  Color color= Colors.white;

  List dayOne = [];
  List extraTask = [];
  List timeList = ["8:00","9:00","10:00","11:00","12:00"];

  int i = 0;
  int interestedEventsLength =0;
  int currentCard = -1;
  Set<int> selectedCardIndices = Set<int>();

  String task = "";
  String time = "";


  @override
  void initState() {
    super.initState();
    load().then((result) {
      setState(() {});
    });
  }

  Future load() async {
    String classUser = await _firestoreDatabase.fetchClassUser();
    try {
      dayOne = await _firestoreDatabase.fetchTimeTable(classUser, dayIndex);
    }catch(e){
      print(e);
    }
    extraTask = await _firestoreDatabase.extraTask(dayIndex);
    List timeTemp = await _firestoreDatabase.sendTimeCorrespondingDay(dayIndex);
    timeList.addAll(timeTemp);
    print(timeList);
    List interestedEvents = await _firestoreDatabase.sendEventsInterested(dayIndex);
    interestedEventsLength= interestedEvents.length;
    dayOne = dayOne + interestedEvents + extraTask;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text(day),
      ),
      body: ListView.builder(
        itemCount: dayOne.length,
        itemBuilder: (context, index) {
          return Card(
            color: Colors.white,
            child: ListTile(
              onTap: () {

                },
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    timeList[i++],
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    dayOne[index],
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  const Spacer(),
                  index>=(5+interestedEventsLength) || day =="Sunday" ||day == "Saturday"? IconButton(
                    icon: const Icon(Icons.delete),
                    color: Colors.red,
                    onPressed: () async {
                      await _firestoreDatabase.deleteScheduleExtraTasks(dayIndex, index, dayOne[index]);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => Schedules()),
                      );
                    },
                  ): Container(),
                ],
              ),
            ),
          );
        },
      ),
        floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            backgroundColor: Colors.black,
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Add a new Task"),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text("Enter your name and phone number."),
                          const SizedBox(height: 16),
                          TextFormField(
                            maxLines: 1,
                            decoration: InputDecoration(
                              hintText: 'Enter your task',
                              labelText: 'Task',
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
                                task = value;
                              });
                            },

                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            maxLines: 1,
                            decoration: InputDecoration(
                              hintText: 'Timing',
                              labelText: 'Timing',
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
                                time = value;
                              });

                            },
                          ),
                        ],
                      ),
                      actions: <Widget>[
                        ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.green),
                            ),
                            child: const Text('Add Task',
                                style: TextStyle(color: Colors.black)),
                            onPressed: () async {
                              if (task.isEmpty) {
                                Navigator.of(context).pop();
                                return;
                              }
                              await _firestoreDatabase.addTask(task, dayIndex, time);
                              Navigator.of(context).pop();
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) => Schedules()),
                              );
                            }),
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.red),
                          ),
                          child: const Text(
                            'Close',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  });
            }),
      );
    }
}