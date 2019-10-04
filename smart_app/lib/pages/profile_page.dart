
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:flutter_launcher_icons/xml_templates.dart';
import 'package:smart_app/pages/aboutapp_page.dart';

import 'package:smart_app/pages/contacts_page.dart';
import 'package:smart_app/pages/dev_page.dart';

import 'package:smart_app/pages/settings_page.dart';
import 'package:smart_app/services/fcm_service.dart';
import 'package:smart_app/tabpages/images_page.dart';
import 'package:smart_app/tabpages/notificaton_page.dart';
import 'package:smart_app/tabpages/sensors_page.dart';
import 'package:smart_app/services/auth_service.dart';


class ProfilePage extends StatefulWidget {

  ProfilePage({Key key,  this.user})
      : super(key: key);

//  final BaseAuth auth;
  final FirebaseUser user;

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with SingleTickerProviderStateMixin  {
   FcmHandler fcmHandler = new FcmHandler();
   TabController _tabController;
   AuthService authService = new AuthService();
   FirebaseAuth _auth = FirebaseAuth.instance;
   ImagesPage _imagesPage ;
   NotificationPage _notificationPage;
   SensorsPage _sensorsPage;
   final FirebaseDatabase _database = FirebaseDatabase.instance;
   var pages = [ ];
   var currentPage;

  @override
  void initState()  {
    super.initState();
    // TODO : Add tab pages count length
    _tabController = new TabController(length: 3, vsync: this );
    _imagesPage = new ImagesPage(widget.user.uid);
    _notificationPage = new NotificationPage(widget.user.uid);
    _sensorsPage = new SensorsPage(widget.user.uid);
    pages = [_imagesPage,_notificationPage,_sensorsPage];
    saveDeviceToken();

}


  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  // Sets current active page


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Smart Security'),
        backgroundColor: Colors.deepPurple,
          brightness: Brightness.dark,
          actions: <Widget>[
//            IconButton(
//              icon: Icon(Icons.clear),
//              onPressed:() {
//                 authService.signOut(context);
//                var route = new MaterialPageRoute(builder: (context) => LoginPage());
//                Navigator.of(context).push(route);
//              },
//            ),
          ],
      ),
      drawer: Opacity(
        opacity: 0.85,
        child: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[

              DrawerHeader(
                curve: Curves.fastOutSlowIn,
                child: Column(
                  children: <Widget>[
                    CircleAvatar(
                        backgroundImage :  widget.user.photoUrl  == null   ? AssetImage('assets/images/google_logo.png') : NetworkImage( widget.user.photoUrl ),
//                    backgroundColor : Colors.grey[800],
                      radius: 40,
                    ),
                    Spacer(),
                    Text(widget.user.displayName ,style: TextStyle(fontSize: 14),),
                    Spacer(),
                    Text(widget.user.email ,style: TextStyle(fontSize: 12),),
                    Spacer(),
                  ],
                ),
//                decoration: BoxDecoration(
////                  color:Colors.grey[800] ,
//                ),
              ),

              ListTile(
                leading: Icon(Icons.contacts),
                title: Text('Contacts'),
                onTap: () {
                  Navigator.pop(context);
                  var route = new MaterialPageRoute(builder: (context) => ContactsPage(widget.user.uid));
                  Navigator.of(context).push(route);
                },
              ),
              new Divider(),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text('Settings'),
                onTap: () {
                  Navigator.pop(context);
                  var route = new MaterialPageRoute(builder: (context) => SettingsPage());
                  Navigator.of(context).push(route);
                },
              ),
              new Divider(),
              ListTile(
                leading: Icon(Icons.info),
                title: Text('About app'),
                onTap: () {
                  Navigator.pop(context);
                  var route = new MaterialPageRoute(builder: (context) =>  AboutAppPage());
                  Navigator.of(context).push(route);
                },
              ),
              new Divider(),
              ListTile(
                leading: Icon(Icons.details),
                title: Text('Source code'),
                onTap: () {
                  Navigator.pop(context);
                  var route = new MaterialPageRoute(builder: (context) =>  DevAppPage());
                  Navigator.of(context).push(route);
                },
              ),


            ],
          ),
        ),
      ),
      bottomNavigationBar:  BottomNavigationBar(

        currentIndex: _tabController.index,
        selectedItemColor: Colors.white,
        unselectedFontSize: 10,
        selectedFontSize: 12,
        selectedIconTheme: IconThemeData(size: 28, color: Colors.white),
//        showSelectedLabels: false,
        items: [

          BottomNavigationBarItem(
              icon: Icon(Icons.image),
              backgroundColor: Colors.deepPurpleAccent,
//              activeIcon: Icon(Icons.verified_user),
              title: Text(
                'Images',
//                style: TextStyle(fontFamily: 'Lexend Deca' , ),
              )),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications),
              title: Text(
                'Notices',
//                style: TextStyle(fontFamily: 'Lexend Deca'),
              )),
          BottomNavigationBarItem(
              icon: Icon(Icons.album),
              title: Text(
                'Sensors',
//                style: TextStyle(fontFamily: 'Lexend Deca'),
              ))
        ],
        onTap: (int index) {
          setState(() {
            _tabController.index = index;
          });
        },

      ),
//-------------------------------- BODY ----------------------------------------
      body :TabBarView(
        controller: _tabController,
        children: <Widget>[
          _imagesPage,
          _notificationPage,
          _sensorsPage
        ],
      ),
    );

  }// widget end

   saveDeviceToken() async {
     FirebaseUser firebaseUser = await _auth.currentUser();
     String uid = firebaseUser.uid;
     final FirebaseMessaging _fcm = FirebaseMessaging();
     // Get the token for this device
     String fcmToken = await _fcm.getToken();
     print('Fcmtoken = ' + fcmToken);
     // Save it to Firestore
     if (fcmToken != null) {

       var fmcRef = _database
           .reference()
           .child("users")
           .child(uid);

       fmcRef.update({"fcmtoken": fcmToken});
     }
   }

}