import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:la_creo/Screens/events.dart';
import 'package:la_creo/Screens/home.dart';
import 'package:la_creo/Screens/schedule.dart';
import 'package:page_transition/page_transition.dart';
import '../Authentication/login.dart';
import '../Screens/notices.dart';
import '../Screens/profile.dart';
import '../Screens/feedback.dart';


class NavBar extends StatelessWidget {
  const NavBar({super.key});


  Future<void> navigateToProfile(context) async {
    Navigator.push(
        context,
        PageTransition(
          child: Profile(),
          type: PageTransitionType.fade,
          duration: const Duration(milliseconds: 500),
        ));
  }


  Future<void> navigateToHome(context) async {
    Navigator.push(
        context,
        PageTransition(
          child: const Home(),
          type: PageTransitionType.fade,
          duration: const Duration(milliseconds: 500),
        ));
  }


  Future<void> navigateToNotices(context) async {
    Navigator.push(
        context,
        PageTransition(
          child: const Notices(),
          type: PageTransitionType.fade,
          duration: const Duration(milliseconds: 500),
        ));
  }
  Future<void> navigateToEvents(context) async {
    Navigator.push(
        context,
        PageTransition(
          child: const Events(),
          type: PageTransitionType.fade,
          duration: const Duration(milliseconds: 500),
        ));
  }

  Future<void> navigateToFeedback(context) async {
    Navigator.push(
        context,
        PageTransition(
          child: Question(),
          type: PageTransitionType.fade,
          duration: const Duration(milliseconds: 500),
        ));
  }


  Future<void> navigateToTimeTable(context) async {
    Navigator.push(
        context,
        PageTransition(
          child: const MySchedulePage(),
          type: PageTransitionType.fade,
          duration: const Duration(milliseconds: 500),
        ));
  }


  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    String? name = FirebaseAuth.instance.currentUser?.displayName == null
        ? "N/A"
        : FirebaseAuth.instance.currentUser!.displayName.toString();
    String email = user!.email != null ? user.email.toString() : " ";
    return Drawer(
      backgroundColor:Colors.deepPurple,
      child: ListView(
        // Remove padding
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(name, style: TextStyle(color: Colors.black)),
            accountEmail: Text(email,  style: TextStyle(color: Colors.black)),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child:  Image.asset("images/Login.png",
                fit: BoxFit.cover,
                  width: 90,
                  height: 90,
                ),
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.white,
            ),
          ),
          ListTile(

            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () => navigateToHome(context),
          ),
          ListTile(

            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            onTap: () => navigateToProfile(context),
          ),
          //
          ListTile(

            leading: const Icon(Icons.book_online),
            title: const Text('Notices'),
            onTap: () => navigateToNotices(context),
          ),
          ListTile(

            leading: const Icon(Icons.question_mark),
            title: const Text('Schedule'),
            onTap: () => navigateToTimeTable(context),
          ),
          ListTile(

            leading: const Icon(Icons.abc),
            title: const Text('Events'),
            onTap: () => navigateToEvents(context),
          ),
          ListTile(

            leading: const Icon(Icons.abc),
            title: const Text('Feedback'),
            onTap: () => navigateToFeedback(context),
          ),

          ListTile(

            title: const Text('Log Out'),
            leading: const Icon(Icons.exit_to_app),
            onTap: () {
              Navigator.pushReplacement(context,
                MaterialPageRoute(
                  builder: (BuildContext context) => const Login(),),
              );
            },
          ),
        ],
      ),
    );
  }
}