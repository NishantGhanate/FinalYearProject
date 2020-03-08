
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_app/pages/root_page.dart';
import 'package:smart_app/services/auth_service.dart';
import 'package:smart_app/services/fcm_service.dart';


void main() async{
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  FcmHandler();
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.grey[800],
        // new
      ),

      home: RootPage(auth: new AuthService()),
    );
  }
}




