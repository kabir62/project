import 'package:flutter/material.dart';
import 'package:la_creo/admin_panel/admin_navbar.dart';

import '../Assets/navbar.dart';
import '../Firebase/database.dart';

String choiceClass = "";

class Admin_Schedule extends StatefulWidget {
  const Admin_Schedule({super.key});


  @override
  State<Admin_Schedule> createState() => _Admin_ScheduleState();
}

class _Admin_ScheduleState extends State<Admin_Schedule> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          title: Text("Schedule Timetable"),
        ),
        drawer: Admin_NavBar(),
        body: Container(
            child: Column(
              children: [
                const Center(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0,70, 0, 0),
                      child: Text(
                        "Choose a class.",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    )
                ),
                Expanded(
                  child: GridView.count(
                    padding: const EdgeInsets.fromLTRB(20, 100, 20, 0),
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    crossAxisCount: 2,
                    children: <Widget>[
                      buildGameItem(
                          Icons.class_outlined, '9', Colors.red, Colors.blueAccent,
                          context),
                      buildGameItem(Icons.class_, '10', Colors.red,
                          Colors.blueAccent, context),
                      buildGameItem(Icons.book_sharp, '11', Colors.green,
                          Colors.blueAccent, context),
                      buildGameItem(Icons.school, '12', Colors.green,
                          Colors.blueAccent, context),
                    ],
                  ),
                ),
              ],
            )
        )
    );
  }


  Widget buildGameItem(IconData icon, String label, Color color1, Color color2,
      BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 5,
      child: InkWell(
        onTap: () {
          setState(() {
            choiceClass = label;
          });

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SchedulePageClass()));
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color1, color2],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon, size: 50, color: Colors.white),
              const SizedBox(height: 20),
              Text(
                label,
                style: const TextStyle(fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SchedulePageClass extends StatefulWidget {
  const SchedulePageClass({Key? key}) : super(key: key);

  @override
  State<SchedulePageClass> createState() => _SchedulePageClassState();
}

class _SchedulePageClassState extends State<SchedulePageClass> {


  final Database _firestoreDatabase = Database();
  List<List> timetableData = [];

  @override
  void initState() {
    super.initState();
    load().then((result){
      setState(() {
      });
    });
  }

  Future load() async{
    timetableData = await _firestoreDatabase.fetchAdminTimeTable(choiceClass);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          title: const Text("TimeTable"),
        ),
        body: Container(
            child: Column(
              children: [
                const SizedBox(height: 20.0),
                const Center(
                  child: Text(
                      "TimeTable",
                      style: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      )
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 25, 220,0),
                  child: Text(
                      "Class: $choiceClass",
                      style: const TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      )
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(200, 20, 0, 10),
                  child: ElevatedButton(
                    onPressed: () async{
                      timetableData.add(["Monday","Tuesday","Wednesday","Thursday","Friday"]);
                      for(int i = 0; i<5;i++) {
                        timetableData.add(await _firestoreDatabase.createTimeTable(
                            5, choiceClass,i));
                      }
                      print(timetableData);
                      setState(() {

                      });
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => const SchedulePageClass()),
                      );
                    },

                    child:const Text("Create Timetable"),

                  ),
                ),
                Table(
                  border: TableBorder.all(),
                  children: [
                    for (List rowData in timetableData)
                      TableRow(
                        children: [
                          for (String cellData in rowData)
                            TableCell(child: TimetableCell(cellData)),
                        ],
                      ),
                  ],
                ),
              ],
            )
        )
    );
  }

}

class TimetableCell extends StatelessWidget {
  final String text;

  TimetableCell(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      alignment: Alignment.center,
      child: Text(text),
    );
  }
}





