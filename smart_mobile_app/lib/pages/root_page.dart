import 'package:flutter/material.dart';
import 'package:smart_mobile_app/pages/login_page.dart';
import 'package:smart_mobile_app/pages/profile_page.dart';
import 'package:smart_mobile_app/services/auth_service.dart';

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
  String _userId = "";
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;

  // Setting set once tapped on button and logged in
  @override
  void initState() {
    super.initState();
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        if (user != null) {
          _userId = user?.uid;
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
        if (_userId.length > 0 && _userId != null) {
          return new ProfilePage(
              userId: _userId,
              auth: widget.auth
          );
        }
        else return _buildWaitingScreen();
        break;

      default:
        return _buildWaitingScreen();
    }
  }

}
