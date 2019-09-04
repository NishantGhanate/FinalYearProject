
import 'package:flutter/material.dart';
import 'package:smart_app/pages/contacts_page.dart';

import 'package:smart_app/pages/settings_page.dart';
import 'package:smart_app/tabpages/images_page.dart';
import 'package:smart_app/tabpages/notificaton_page.dart';
import 'package:smart_app/tabpages/sensors_page.dart';
//import 'package:smart_app/services/auth_service.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';

Color mainColor = Colors.red[800];

class ProfilePage extends StatefulWidget {

  ProfilePage({Key key,  this.userId})
      : super(key: key);

//  final BaseAuth auth;
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
    super.dispose();
    tabController.dispose();
  }
  var pages = [new ImagesPage(),new NotificationPage() , new SensorsPage()];
  var currentPage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Smart Security'),
        backgroundColor: mainColor,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.clear),
              onPressed:() {
              },
            ),
          ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[

            DrawerHeader(
              curve: Curves.fastOutSlowIn,
              child: Text('Drawer Header'),
              decoration: BoxDecoration(
                color: mainColor,
              ),
            ),

            ListTile(
              leading: Icon(Icons.contacts),
              title: Text('Contacts'),
              onTap: () {
                Navigator.pop(context);
                var route = new MaterialPageRoute(builder: (context) => ContactsPage());
                Navigator.of(context).push(route);
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
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                var route = new MaterialPageRoute(builder: (context) =>  SettingsPage());
                Navigator.of(context).push(route);
              },
            ),

          ],
        ),
      ),
      bottomNavigationBar:  FancyBottomNavigation(
        circleColor: mainColor,
        activeIconColor: Colors.white ,
      inactiveIconColor: Colors.white,
        textColor: Colors.white,
        barBackgroundColor: Colors.grey[900],
        tabs: [
          TabData(iconData: Icons.image, title: "Images" ),
          TabData(iconData: Icons.notifications, title: "notifications"),
          TabData(iconData: Icons.device_hub, title: "Sensors")
        ],
        onTabChangedListener: (position) {
          setState(() {
            currentPage = pages[position];
          });
        },
      ),
//-------------------------------- BODY ----------------------------------------
      body :currentPage,
    );

  }// widget end

}