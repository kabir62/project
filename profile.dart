import 'package:flutter/material.dart';
import '../Assets/navbar.dart';
import '../Authentication/login.dart';
import '../Firebase/auth.dart';
import '../Firebase/database.dart';


final Database _firestoreDatabase = Database();

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {


  String name = '';
  String email = '';
  String cls = '';

  final AuthService _auth = AuthService();

  Map<String, dynamic> currentUserDetails = {};

  @override
  void initState(){
    super.initState();
    load().then((result){
      setState(() {

      });
    });
  }

  Future<void> load() async{
    currentUserDetails = await _firestoreDatabase.sendCurrentUserDetails();
    name = currentUserDetails['name'];
    email = currentUserDetails['email'];
    cls = currentUserDetails['cls'];
    print(email + " " + name);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: Colors.deepPurple,
      ),
      drawer: NavBar(),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          alignment: Alignment.center,
          child: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(350, 10, 0, 0),
                  child: IconButton(
                    icon: const Icon(
                      Icons.logout,
                      color: Colors.black,
                    ),
                    onPressed: () async{
                      await _auth.signOut();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => const Login()),
                      );
                    },
                  ),
                ),

                const Padding(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage("https://pbs.twimg.com/profile_images/1176104612798951424/9Do9QXzf_400x400.png"),
                    backgroundColor: Colors.white,
                    radius: 50.0,
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 37.5, 0, 0),
                  child: Container(
                    width: 500,
                    height: 567,
                    decoration: const BoxDecoration(
                      color: Colors.deepPurple,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.fromLTRB(10, 50, 300, 0),
                          child: Center(
                            child: Text(
                              "Username",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15.0
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 300, 0),
                          child: Center(
                            child: Text(
                              name,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24.0
                              ),
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.fromLTRB(10, 50, 330, 0),
                          child: Text(
                            "Class",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 15.0
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 0, 330, 0),
                          child: Text(
                            cls,
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20.0
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.fromLTRB(10, 50, 330, 0),
                          child: Text(
                            "Email",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 15.0
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 0, 50, 0),
                          child: Text(
                            email,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20.0
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}