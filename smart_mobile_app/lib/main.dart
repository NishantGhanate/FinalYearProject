import 'package:flutter/material.dart';
import 'package:smart_mobile_app/pages/root_page.dart';
import 'package:smart_mobile_app/services/auth_service.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: RootPage(auth: new AuthService()),
    );
  }
}
