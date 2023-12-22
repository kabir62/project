import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:la_creo/Authentication/login.dart';
import 'package:la_creo/admin_panel/admin_notices.dart';
import 'package:la_creo/admin_panel/admin_schedule.dart';
import 'package:page_transition/page_transition.dart';
import '../Screens/notices.dart';
import '../Screens/profile.dart';
import 'admin_events.dart';

class Admin_NavBar extends StatelessWidget {
  const Admin_NavBar({super.key});


  Future<void> navigateToNotices(context) async {
    Navigator.push(
        context,
        PageTransition(
          child: Admin_Notices(),
          type: PageTransitionType.fade,
          duration: const Duration(milliseconds: 500),
        ));
  }

  Future<void> navigateToEvents(context) async {
    Navigator.push(
        context,
        PageTransition(
          child: Admin_Events(),
          type: PageTransitionType.fade,
          duration: const Duration(milliseconds: 500),
        ));
  }

  Future<void> navigateToTimeTable(context) async {
    Navigator.push(
        context,
        PageTransition(
          child: const Admin_Schedule(),
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
    String? email = user?.email != null ? user?.email.toString() : "N/A";
    return Drawer(
      backgroundColor:Colors.blueGrey,
      child: ListView(
        // Remove padding
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text("School admin"),
            accountEmail: Text(""),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: Image.asset(
                  'images/Login.png',
                  fit: BoxFit.cover,
                  width: 90,
                  height: 90,
                ),
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.white24,
            ),
          ),
          ListTile(

            leading: const Icon(Icons.book_online),
            title: const Text('Notices'),
            onTap: () => navigateToNotices(context),
          ),
          ListTile(

            leading: const Icon(Icons.question_mark),
            title: const Text('Events'),
            onTap: () => navigateToEvents(context),
          ),
          ListTile(

            leading: const Icon(Icons.abc),
            title: const Text('TimeTable'),
            onTap: () => navigateToTimeTable(context),
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