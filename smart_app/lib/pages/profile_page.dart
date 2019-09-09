
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';

import 'package:smart_app/pages/contacts_page.dart';
import 'package:smart_app/pages/login_page.dart';
import 'package:smart_app/pages/settings_page.dart';
import 'package:smart_app/tabpages/images_page.dart';
import 'package:smart_app/tabpages/notificaton_page.dart';
import 'package:smart_app/tabpages/sensors_page.dart';
import 'package:smart_app/services/auth_service.dart';

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
   AuthService authService = new AuthService();
   FirebaseAuth _auth = FirebaseAuth.instance;
   FirebaseUser _firebaseUseruser;


  @override
  void initState()  {
    super.initState();
    // TODO : Add tab pages count length
    tabController = new TabController(length: 3, vsync: this);

  }

   firebaseUser() async{
   return  await _auth.currentUser();
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
  }

  // Sets current active page
  var currentPage;

  @override
  Widget build(BuildContext context) {
    var pages = [new ImagesPage(widget.userId) , new NotificationPage(widget.userId) , new SensorsPage(widget.userId) ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Smart Security'),
        backgroundColor: mainColor,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.clear),
              onPressed:() {
                 authService.signOut(context);
                var route = new MaterialPageRoute(builder: (context) => LoginPage());
                Navigator.of(context).push(route);
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
              child: Column(
                children: <Widget>[
                  CircleAvatar(
//                      backgroundImage :  _firebaseUseruser.photoUrl  == null   ? AssetImage('assets/images/google_logo.png') : NetworkImage(_firebaseUseruser.photoUrl),
                    backgroundImage : AssetImage('assets/images/google_logo.png'),
                    radius: 40,
                  ),
                  new Divider(),
                  Text(widget.userId ,style: TextStyle(fontSize: 10),)
                ],
              ),
              decoration: BoxDecoration(
                color: mainColor,
              ),
            ),

            ListTile(
              leading: Icon(Icons.contacts),
              title: Text('Contacts'),
              onTap: () {
                Navigator.pop(context);
                var route = new MaterialPageRoute(builder: (context) => ContactsPage(widget.userId));
                Navigator.of(context).push(route);
              },
            ),
//            new Divider(),
//            ListTile(
//              leading: Icon(Icons.account_circle),
//              title: Text('List 2'),
//              onTap: () {
//                Navigator.pop(context);
////                var route = new MaterialPageRoute(builder: (context) => AboutApp());
////                Navigator.of(context).push(route);
//              },
//            ),
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