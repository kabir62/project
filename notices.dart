import 'package:flutter/material.dart';

import '../Assets/navbar.dart';
import '../Firebase/database.dart';

//Variables
final Database _firestoreDatabase = Database();
String noticeContent = "";
String noticeDate = "";

class Notices extends StatefulWidget {
  const Notices({Key? key}) : super(key: key);

  @override
  State<Notices> createState() => _NoticesState();
}

class _NoticesState extends State<Notices> {

  List noticesHeadingList = [];

  @override
  void initState(){
    super.initState();
    load().then((result){
      setState(() {

      });
    });
  }



  Future<void> load() async{
    await fetchNoticesHeading();
  }

  Future fetchNoticesHeading() async{
    noticesHeadingList = await _firestoreDatabase.fetchNoticesHeading();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text("Notices"),
      ),
      drawer: NavBar(),
      body: ListView.builder(
        itemCount: noticesHeadingList.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              onTap: () async{
                List tempNotices = await _firestoreDatabase.fetchNotices();
                List tempNoticesDate = await _firestoreDatabase.fetchNoticesDate();
                setState(() {
                  noticeDate = tempNoticesDate[index];
                  noticeContent = tempNotices[index];
                });
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => fullNoticePage()));

              },
              title: Column(children: [
                Text(
                  "${noticesHeadingList[index]}",
                  style: const TextStyle(
                      backgroundColor: Colors.white,
                      color: Colors.black,
                      fontSize: 19.0),
                  textAlign: TextAlign.left,
                ),

              ]),
            ),
          );
        },
      ),
    );
  }
}

class fullNoticePage extends StatelessWidget{
  const fullNoticePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20.0),
          const Center(
            child: Text(
              "NOTICE",
              style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
              )
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 25, 220,0),
            child: Text(
              noticeDate,
              style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
              )
            ),
          ),
          const SizedBox(height: 20.0),
          Padding(
            padding: const EdgeInsets.fromLTRB(10.0, 30.0, 10.0,0),
            child: Text(
              noticeContent,
              style: const TextStyle(fontSize: 20.0)),
          ),
      ]
      ),
    );
  }
}