
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
        backgroundColor: Colors.red[800],
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            GestureDetector(
              onTap: (){
                authService.signOut(context);
                Navigator.pop(context);
//                     Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => LoginPage()));

//     Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
//         LoginPage()), (Route<dynamic> route) => false);

                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) {return LoginPage();}), ModalRoute.withName('pages/LoginPage'));

              },
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
                    child: Text('Sign out' , textScaleFactor: 1.2, ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(240, 20, 20, 10),
                    child: Icon(Icons.exit_to_app , color: Colors.red,),
                  ),
                ],
              ),
            ),
            new Divider(),
          ],
        ),
      ),
    );
  }
}