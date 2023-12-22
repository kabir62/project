import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:la_creo/Screens/schedule.dart';



class Database {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addUser(name, classStudent, email, uid, token) {
    return _firestore.collection('students')
        .doc(uid).set({
      'name': name,
      'email': email,
      'uid': uid,
      'class': classStudent,
      'interestedEvents': [],
      'interestedEventsDays': [],
      'time': [],
      'timeDays': [],
      'extra1': [],
      'extra2': [],
      'extra3': [],
      'extra4': [],
      'extra5': [],
      'extra6':[],
      'extra7':[],
      'token': token,
    })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  Future checkForUserRegister(String email) async {
    bool returnValue = false;
    await _firestore.collection('students')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        if (doc['email'] == email) {
          returnValue = true;
        }
      }
    });
    return returnValue;
  }

  Future fetchNotices() async {
    List noticesList = [];
    await _firestore.collection('notices')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        noticesList.add(doc['notice']);
      }
    });

    return noticesList;
  }

  Future fetchNoticesHeading() async {
    List noticesList = [];
    await _firestore.collection('notices')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        noticesList.add(doc['heading']);
      }
    });

    return noticesList;
  }


  Future fetchNoticesDate() async {
    List noticesList = [];
    await _firestore.collection('notices')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        noticesList.add(doc['date']);
      }
    });

    return noticesList;
  }

  Future addNotice(String head, String content, String date) async {
    try {
      await _firestore.collection('notices').add({
        'heading': head,
        'notice': content,
        'date': date,
      });
    }
    catch (e) {
      print(e);
    }
  }

  Future createTimeTable(int noOfPeriods, String choiceClass, int dayNo) async {


    List<String> subjOne = [
      "Mathematics",
      "Physics",
      "Chemistry",
      "Biology",
      "History",
      "Geography",
      "English 2",
      "English 1",
      "Hindi",
      "Comp/Com/Eco",
    ];

    List<String> subjTwo = [
      "English 2",
      "English 1",
      "Physics",
      "Chemistry",
      "Biology",
      "Comp/Com/Eco",
      "Mathematics"
    ];
    List<String> day = [];
    List<String> subjects = [];
    await _firestore.collection('schedule')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        if (doc['class'] == choiceClass) {
          doc.reference.update({
            'days': ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"],
          });

          if (choiceClass == "11" || choiceClass == "12") {
            subjects = subjTwo;
          }
          else {
            subjects = subjOne;
          }

          for (int i = 0; i < noOfPeriods; i++) {
            String randomItem = randomChoiceString(subjects);
            day.add(randomItem);
          }
          int dayno = dayNo + 1;
          doc.reference.update({
            'day$dayno': day,
          });
        }
      }
    });


    return day;
  }

  String randomChoiceString<String>(List<String> items) {
    final random = Random();
    final index = random.nextInt(items.length - 1);
    print(items[index]);
    return items[index];
  }

  Future fetchAdminTimeTable(String choiceClass) async {
    List<List> timeTableList = [];
    await _firestore.collection('schedule')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        if (doc['class'] == choiceClass) {
          timeTableList.add(doc['days']);
          for (int i = 1; i <= 5; i++) {
            timeTableList.add(doc['day$i']);
          }
        }
      }
    });


    return timeTableList;
  }

  Future fetchTimeTable(String choiceClass, int dayNo) async {
    List timeTableList = [];
    await _firestore.collection('schedule')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        if (doc['class'] == choiceClass) {
            timeTableList = doc['day$dayNo'];
        }
      }
    });


    return timeTableList;
  }


  Future fetchClassUser() async {
    String classChoice = "";
    await _firestore.collection('students')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        if (doc['uid'] == _auth.currentUser?.uid) {
          classChoice = doc['class'];
        }
      }
    });
    return classChoice;
  }

  Future fetchEventName() async {
    List eventsList = [];
    await _firestore.collection('events')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        eventsList.add(doc['eventname']);
      }
    });
    return eventsList;
  }

  Future fetchEventDetails() async {
    List eventsList = [];
      await _firestore.collection('events')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        eventsList.add(doc['eventdetails']);
      }
    });
    return eventsList;
  }

  Future fetchEventImage() async {
    List eventsList = [];
    await _firestore.collection('events')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        eventsList.add(doc['eventimage']);
      }
    });
    return eventsList;
  }
  Future fetchEventDate() async {
    List eventsList = [];
    await _firestore.collection('events')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        eventsList.add(doc['eventdate']);
      }
    });
    return eventsList;
  }

  Future fetchEventStatus() async {
    List eventsList = [];
    await _firestore.collection('events')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        eventsList.add(doc['eventstatus']);
      }
    });
    return eventsList;
  }

  Future fetchEventday(String eventname) async {
    String eventday = "0";
    await _firestore.collection('events')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        if(doc['eventname']==eventname){
          eventday = doc['eventday'] as String;
        }
      }
    });
    return eventday;
  }

  Future addEvent(String name, String detail, String img, String date, String dayNo) async {
    try {
      await _firestore.collection('events').add({
        'eventdetails': name,
        'eventname': detail,
        'eventimage': img,
        'eventdate' : date,
        'eventday' : dayNo,
        'registrations': [],
      });
    }
    catch (e) {
      print(e);
    }
  }

  // Future addEventStudent(String task) async {
  //   await _firestore.collection('students')
  //       .get()
  //       .then((QuerySnapshot querySnapshot) {
  //     for (var doc in querySnapshot.docs) {
  //       if (doc['uid'] == _auth.currentUser?.uid) {
  //         List e = doc['interestedEvents'];
  //         e.add(task);
  //         doc.reference.update({
  //           'interestedEvents': e,
  //         });
  //       }
  //     }
  //   });
  // }
  Future addTask(String task, dayIndex, String time) async {
    await _firestore.collection('students')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        if (doc['uid'] == _auth.currentUser?.uid) {
          List e = doc['extra$dayIndex'];
          List t = doc['time'];
          List td = doc['timeDays'];
          t.add(time);
          td.add(dayIndex);
          e.add(task);
          doc.reference.update({
            'extra$dayIndex': e,
            'time': t,
            'timeDays': td,
          });
        }
      }
    });
  }

  Future extraTask(int dayIndex) async {
    List e = [];
    await _firestore.collection('students')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        if (doc['uid'] == _auth.currentUser?.uid) {
          e = doc['extra$dayIndex'];
        }
      }
    });

    return e;
  }

  Future checkIfUserIsRegistered(String eventName) async {
    bool check = false;
    await _firestore.collection('events')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        if(doc['eventname']==eventName){
          List reg = doc['registrations'];
          if(reg.contains(_auth.currentUser?.uid)){
            print("Already Registered");
            check = true;
          }
        }
      }
    });

    return check;

  }


    Future registerUser(String eventName) async {
    await _firestore.collection('events')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        if(doc['eventname']==eventName){
          List reg = doc['registrations'];
          reg.add(_auth.currentUser?.uid);
            doc.reference.update({
              'registrations': reg,
            });
          }
        }
      });

    await _firestore.collection('students')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        if(doc['uid']==_auth.currentUser?.uid){
          List reg = doc['interestedEvents'];
          reg.add(eventName);
          doc.reference.update({
            'interestedEvents': reg,
          });
        }
      }
    });

  }

  Future deleteScheduleExtraTasks(int dayNo,int no, String dayIndexVal) async {
    await _firestore.collection('students')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        if (doc['uid'] == _auth.currentUser?.uid) {
          List e = doc['extra$dayNo'];
          e.remove(dayIndexVal);
          doc.reference.update({
            'extra$dayNo': e,
          });
        }
      }
    });
  }

  Future sendEventsInterestedWithoutDay() async {
    List e = [];
    await _firestore.collection('students')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        if (doc['uid'] == _auth.currentUser?.uid) {
          e = doc['interestedEvents'];
        }
      }
    });
    return e;
  }


  Future sendEventsInterested(int day) async {
    List e = [];
    await _firestore.collection('students')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        if (doc['uid'] == _auth.currentUser?.uid) {
          List interested = doc['interestedEventsDays'];
          List interestedE = doc['interestedEvents'];
          for(int i = 0;i<interested.length; i++){
            if(i==day) e.add(interestedE[i]);
          }
        }
      }
    });
    return e;
  }

  Future sendCurrentUserDetails() async {
    Map<String, dynamic> currentUserDetails = {};
    await _firestore.collection('students')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        if (doc['uid'] == _auth.currentUser?.uid) {
          currentUserDetails['name'] = doc['name'];
          currentUserDetails['email'] = doc['email'];
          currentUserDetails['cls'] = doc['class'];
        }
      }
    });

    return currentUserDetails;
  }

  Future sendTimeCorrespondingDay(int dayNo) async{
    List time = [];
    await _firestore.collection('students')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        if (doc['uid'] == _auth.currentUser?.uid) {
          List timeDays = doc['timeDays'];
          for(int i = 0;i<timeDays.length;i++){
            if(timeDays[i] == dayNo){
              time.add(doc['time'][i]);
            }
          }
        }
      }
    });


    return time;
  }

  Future Feedback(String email, String content) async {
    try {
      await _firestore.collection('feedback').add({
        'email': email,
        'message': content,
      });
    }
    catch (e) {
      print(e);
    }
  }

}
