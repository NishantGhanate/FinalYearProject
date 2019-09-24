import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_app/services/auth_service.dart';

import 'package:smart_app/pages/login_page.dart';
import 'package:smart_app/pages/profile_page.dart';


enum AuthStatus {
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN,
}

class RootPage extends StatefulWidget {
  RootPage({this.auth});

  final BaseAuth auth;

  @override
  State<StatefulWidget> createState() => new _RootPageState();
}


class _RootPageState extends State<RootPage>{
  FirebaseUser _userId ;
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  Firestore _db = Firestore.instance;
  // Setting set once tapped on button and logged in
  @override
  void initState() {
    super.initState();
    widget.auth.getCurrentUser().then((FirebaseUser user) {
      setState(() {
        if (user != null) {
          _userId = user;
          _db.settings(persistenceEnabled: true);
        }
        authStatus =
        user?.uid == null ? AuthStatus.NOT_LOGGED_IN : AuthStatus.LOGGED_IN;
      });
    });
  }

  // Loading screen widget
  Widget _buildWaitingScreen() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    switch (authStatus) {

      case AuthStatus.NOT_DETERMINED:
      // TODO: Show loading screen
        return _buildWaitingScreen();
        break;
      case AuthStatus.NOT_LOGGED_IN:
      // TODO: Redirect to login page
        return new LoginPage();
        break;
      case AuthStatus.LOGGED_IN:
      // TODO: Redirect to profile page
        if (_userId.uid.length > 0 && _userId != null) {
          return new ProfilePage(
              user: _userId,
//              auth: widget.auth
          );
        }
        else return _buildWaitingScreen();
        break;

      default:
        return _buildWaitingScreen();
    }
  }

}
