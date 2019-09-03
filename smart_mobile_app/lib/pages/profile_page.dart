
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_mobile_app/services/auth_service.dart';

class ProfilePage extends StatefulWidget {

  ProfilePage({Key key, this.auth, this.userId})
      : super(key: key);

  final BaseAuth auth;
  final String userId;


  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with SingleTickerProviderStateMixin  {
  TabController tabController;

  @override
  void initState() {
    super.initState();
    // TODO : Add tab pages count length
    tabController = new TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

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
              onTap: () {
                Navigator.pop(context);
//                var route = new MaterialPageRoute(builder: (context) => AboutApp());
//                Navigator.of(context).push(route);
              },
            ),
            new Divider(),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('List 2'),
              onTap: () {
                Navigator.pop(context);
//                var route = new MaterialPageRoute(builder: (context) => AboutApp());
//                Navigator.of(context).push(route);
              },
            ),
            new Divider(),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('List 3'),
              onTap: () {
                Navigator.pop(context);
//                var route = new MaterialPageRoute(builder: (context) => AboutApp());
//                Navigator.of(context).push(route);
              },
            ),

          ],
        ),
      ),
      bottomNavigationBar: new Material(
//        color: Color.fromRGBO(r, g, b, opacity),
        child: new TabBar(
          controller: tabController,
          tabs: <Widget>[
            new Tab(icon: new Icon(Icons.tv) , text: 'Channels',),
            new Tab(icon: new Icon(Icons.add_to_photos ), text: 'Packages', ),
            new Tab(icon: new Icon(Icons.history) ,  text: 'History'),
          ],
        ),

      ),

//-------------------------------- BODY ----------------------------------------
      body : new TabBarView(
        controller: tabController,
        children: <Widget>[
            // TODO : Add tab pages
//          ChannelsPage(),
//          Packages(),
//          Icon(Icons.history),
        ],
      ),
    );


  }// widget end



}