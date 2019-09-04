import 'package:flutter/material.dart';
import 'package:smart_app/pages/login_page.dart';


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

      home: LoginPage(),
    );
  }
}



