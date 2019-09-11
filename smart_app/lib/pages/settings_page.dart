
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_app/services/auth_service.dart';

import 'login_page.dart';


const Color PURPLE = Color(0xFF8c77ec);

class SettingsPage extends StatefulWidget{
  // TODO: implement createState
  @override
  State<StatefulWidget> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>{

  AuthService authService = new AuthService();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: PURPLE,
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
//          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Padding(
              padding:  EdgeInsets.all(150.0),
              child: RaisedButton(
                color: PURPLE,
                onPressed: (){
                  authService.signOut(context);
                  var route = new MaterialPageRoute(builder: (context) => LoginPage());
                  Navigator.of(context).push(route);
                },
                child: Text('Sign out'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}