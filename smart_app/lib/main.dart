import 'package:flutter/material.dart';
import 'package:smart_app/pages/root_page.dart';
import 'package:smart_app/services/auth_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:smart_app/services/fcm_service.dart';

import 'package:flutter_launcher_icons/android.dart';
import 'package:flutter_launcher_icons/constants.dart';
import 'package:flutter_launcher_icons/custom_exceptions.dart';
import 'package:flutter_launcher_icons/ios.dart';
import 'package:flutter_launcher_icons/main.dart';
import 'package:flutter_launcher_icons/xml_templates.dart';


void main() {
  fcmHandler();
//  FcmHandler();
  runApp(MyApp());
}

void fcmHandler() async{
  final FirebaseMessaging _firebaseMessaging= FirebaseMessaging();

  _firebaseMessaging.configure(
    onMessage: (Map<String, dynamic> message) async {
      print("onMessage: $message");
      //_showItemDialog(message);
    },
    //onBackgroundMessage: myBackgroundMessageHandler,
    onLaunch: (Map<String, dynamic> message) async {
      print("onLaunch: $message");
      //_navigateToItemDetail(message);
    },
    onResume: (Map<String, dynamic> message) async {
      print("onResume: $message");
      //_navigateToItemDetail(message);
    },
  ); // Fcm configure
}


class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.red[800],
        // new
      ),

      home: RootPage(auth: new AuthService()),
    );
  }
}





