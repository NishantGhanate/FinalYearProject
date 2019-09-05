import 'package:flutter/material.dart';
import 'package:smart_app/pages/login_page.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:smart_app/pages/root_page.dart';
import 'package:smart_app/services/auth_service.dart';

void main() => runApp(MyApp());

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



