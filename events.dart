import 'package:flutter/material.dart';
import 'package:la_creo/Screens/notices.dart';

import '../Assets/navbar.dart';
import '../Firebase/database.dart';
import 'package:page_transition/page_transition.dart';

//Variables
final Database _firestoreDatabase = Database();
String eventday = "";
String eventname = "";
String eventimage = "";
String eventcontent = "";
String eventdate = "";
String namereg = "";
String phreg = "";


Future<void> navigateToRegister(context) async {
  Navigator.push(
      context,
      PageTransition(
        child: const Registration(),
        type: PageTransitionType.fade,
        duration: const Duration(milliseconds: 500),
      ));
}


class Events extends StatefulWidget {
  const Events({Key? key}) : super(key: key);

  @override
  State<Events> createState() => _EventsState();
}

class _EventsState extends State<Events> {

  List events_name_List = [];
  List events_image_List = [];

  @override
  void initState(){
    super.initState();
    load().then((result){
      setState(() {

      });
    });
  }



  Future<void> load() async{
    await fetchEventname();
    await fetchEventimage();
  }

  Future fetchEventname() async{
    events_name_List = await _firestoreDatabase.fetchEventName();
  }
  Future fetchEventimage() async{
    events_image_List = await _firestoreDatabase.fetchEventImage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text("Events"),
      ),
      drawer: NavBar(),
      body: ListView.builder(
        itemCount: events_name_List.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              onTap: () async{
                List tempEventName = await _firestoreDatabase.fetchEventName();
                List tempEventdet = await _firestoreDatabase.fetchEventDetails();
                List tempEventimg = await _firestoreDatabase.fetchEventImage();
                List tempEventdate = await _firestoreDatabase.fetchEventDate();
                String tempEventday = await _firestoreDatabase.fetchEventday(tempEventName[index]);
                setState(() {
                  eventimage  = tempEventimg[index];
                  eventcontent  = tempEventdet[index];
                  eventdate  = tempEventdate[index];
                  eventname = tempEventName[index];
                  eventday = tempEventday;
                });
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => fullEventPage()));

              },
              title: Column(children: [
                Image.network(events_image_List[index]),
                SizedBox(height: 15,),
                Text(
                  "${events_name_List[index]}",
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

class fullEventPage extends StatelessWidget{
  const fullEventPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(backgroundColor: Colors.deepPurple,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network(
                    eventimage,
                    alignment:  Alignment.center, width:MediaQuery.of(context).size.width*1.4, height:MediaQuery.of(context).size.width*1.0,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text( eventname,
                        textAlign: TextAlign.justify,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32, color: Colors.black),),
                      const SizedBox(height: 15.0),
                      Text( eventdate,
                        textAlign: TextAlign.justify,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32, color: Colors.black),),
                      const SizedBox(height: 15.0),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(eventcontent,
                          textAlign: TextAlign.justify,
                          style: TextStyle(fontSize: 14, color: Colors.black),),
                      ),
                      const SizedBox(height: 15.0),
                      ElevatedButton(
                        onPressed: () {
                          navigateToRegister(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black.withOpacity(0.5),
                          textStyle: TextStyle(
                            fontFamily: 'Xavier2',
                            fontSize: 0.0631 * MediaQuery.of(context).size.width,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          fixedSize: Size( 0.5 * MediaQuery.of(context).size.width, .1 * MediaQuery.of(context).size.width),
                        ),
                        child: const Text("REGISTER",style: TextStyle(color: Colors.white),),),
                      const SizedBox(height: 15.0),
                    ],
                  ),
                ],
              )
            ],
          ),
        )
    );
  }
}

class Registration extends StatefulWidget {
  const Registration({Key? key}) : super(key: key);

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  @override
  Widget build(BuildContext context) {
    TextEditingController _nameController = TextEditingController();
    TextEditingController _phoneController = TextEditingController();
    return AlertDialog(
      backgroundColor: Colors.grey,
      title: const Text("Register Yourself"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Enter your name and phone number."),
          const SizedBox(height: 16),
          TextFormField(
            maxLines: 1,
            decoration: InputDecoration(
              hintText: 'Phone Number',
              labelText: 'Phone Number',
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
              setState(() {
                phreg = value!;
              });
            },

          ),
          const SizedBox(height: 10),
          TextFormField(
            maxLines: 1,
            decoration: InputDecoration(
              hintText: 'Name',
              labelText: 'Name',
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
              setState(() {
                namereg = value!;
              });
            }
          ),
        ],
      ),
      actions: [
        TextButton(
          child: const Text("Cancel",style: TextStyle(color: Colors.white)),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text("Submit",style: TextStyle(color: Colors.white)),
          onPressed: () async{
            bool check = await _firestoreDatabase.checkIfUserIsRegistered(eventname);
            if(!check){
              await _firestoreDatabase.registerUser(eventname);
              Navigator.of(context).pop();
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return const AlertDialog(
                      title: Text("Registered ✅"),
                      content: Text("You have successfully registered for this event"),
                    );
                  });
            }
            else{
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return const AlertDialog(
                      title: Text("You are already registered"),
                      content: Text("You are already registered for this event"),
                    );
                  });
            }
            if (phreg.isEmpty) {
              Text ("Please enter your name");
            }
            else

              Navigator.of(context).pop();

          },
        ),
      ],
    );
  }
}