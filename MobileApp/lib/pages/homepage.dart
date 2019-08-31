import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class MyHomePage extends StatefulWidget {

  final FirebaseUser currentUser;
  // Recieves snapshot.data
  MyHomePage(this.currentUser, this.title);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutterbase'),
        backgroundColor: Colors.amber,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[

            DrawerHeader(
              curve: Curves.fastOutSlowIn,
              child: Text('Drawer Header'),
              decoration: BoxDecoration(
                color: Colors.teal,
              ),
            ),

            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('List 1'),
              onTap: (){
                Navigator.pop(context);
//                var route = new MaterialPageRoute(builder: (context) => AboutApp());
//                Navigator.of(context).push(route);
              },
            ),
            new Divider(),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('List 2'),
              onTap: (){
                Navigator.pop(context);
//                var route = new MaterialPageRoute(builder: (context) => AboutApp());
//                Navigator.of(context).push(route);
              },
            ),
            new Divider(),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('List 3'),
              onTap: (){
                Navigator.pop(context);
//                var route = new MaterialPageRoute(builder: (context) => AboutApp());
//                Navigator.of(context).push(route);
              },
            ),

          ],
        ),
      ),
//-------------------------------- BODY ----------------------------------------
//    body: ,
    );
  }
}