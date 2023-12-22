import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:la_creo/Screens/profile.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../Assets/navbar.dart';
import '../Firebase/database.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  late StreamSubscription subscription;
  bool isDeviceConnected = false;
  bool isAlertSet = false;

  getConnectivity() =>
      subscription = Connectivity().onConnectivityChanged.listen(
            (ConnectivityResult result) async {
          isDeviceConnected = await InternetConnectionChecker().hasConnection;
          if (!isDeviceConnected && isAlertSet == false) {
            showDialogBox();
            setState(() => isAlertSet = true);
          }
        },
      );

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  final Database _firestoreDatabase = Database();

  List registeredEvents = [];
  List interestedEventsDate = [];

  int i = 0;

  String data = '';
  String author = '';

  Future<void> getQuote() async {
    var url = Uri.parse('https://api.quotable.io/random?tags=education|dreams|success|motivation');
    var response = await http.get(url);
    var jsonData = jsonDecode(response.body);
    setState(() {
      data = jsonData['content'];
      author = jsonData['author'];
    });
  }

  Future<void> getRegisteredEventsList() async{
    registeredEvents = await _firestoreDatabase.sendEventsInterestedWithoutDay();
  }

  void initState() {
    getRegisteredEventsList();
    getConnectivity();
    getQuote();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          shadowColor: Colors.transparent,
          elevation: 0,
          toolbarHeight: 40,
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.person),
              color: Colors.white,
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Profile()));
              },
            )
          ],
        ),
        drawer: NavBar(),
        body: Container(
          color: Colors.deepPurple,
          child: Column(
            children: [
              Flexible(
                flex:1,
                child: Column(children: [
                  Center(
                    child: CircleAvatar(
                      radius:50,
                      child: ClipOval(
                        child: Image.asset(
                          'images/Login.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height:8),
                  Center(child: Text("Hi there,", style: const TextStyle(
                    color: Colors.white,
                    fontFamily: "Sarabun",
                    fontSize: 20,
                  )),),
                  const SizedBox(height:6),
                  const Center(child: Text("It's a great day to learn!", style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Sarabun",
                    fontSize: 16,
                  )),),
                  const SizedBox(height:30),
                  Flexible(
                    fit: FlexFit.tight,
                    flex: 1,
                    child: Container(
                      decoration:  BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(50),topRight: Radius.circular(50))
                      ),

                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children:[

                            const SizedBox(height: 30),
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Text('"$data"', textAlign: TextAlign.center,style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.black,
                                )),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                                children: <Widget>[
                                  const Expanded(
                                      child: Divider(thickness: 2,color: Colors.black)
                                  ),
                                  Text("  Interested Events  ", style: TextStyle(
                                    color: Theme.of(context).colorScheme.primary,
                                    fontFamily: "Sarabun",
                                    fontSize: 24,
                                  )),
                                  const Expanded(
                                      child: Divider(thickness: 2,color: Colors.black)
                                  ),
                                ]
                            ),
                            const SizedBox(height:20),
                            Expanded(
                              child: ListView.builder(
                                itemCount: registeredEvents.length,
                                itemBuilder: (context, index) {
                                  return Card(
                                    child: ListTile(
                                      onTap: () {
                                      },
                                      title: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            registeredEvents[index] ,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ]

                      ),
                    ),
                  ),
                ]),
              )
            ],
          ),
        ));
  }
  showDialogBox() => showCupertinoDialog<String>(
    context: context,
    builder: (BuildContext context) => CupertinoAlertDialog(
      title: const Text('No Connection'),
      content: const Text('Please check your internet connectivity'),
      actions: <Widget>[
        TextButton(
          onPressed: () async {
            Navigator.pop(context, 'Cancel');
            setState(() => isAlertSet = false);
            isDeviceConnected =
            await InternetConnectionChecker().hasConnection;
            if (!isDeviceConnected && isAlertSet == false) {
              showDialogBox();
              setState(() => isAlertSet = true);
            }
          },
          child: const Text('OK'),
        ),
      ],
    ),
  );

}