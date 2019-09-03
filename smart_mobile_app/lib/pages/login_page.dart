import 'package:flutter/material.dart';
import 'package:smart_mobile_app/pages/profile_page.dart';
import 'package:smart_mobile_app/services/auth_service.dart';
import 'package:smart_mobile_app/services/auth_service.dart';

class LoginPage extends StatefulWidget{

  @override
  State<StatefulWidget> createState() => _LoginPageState() ;

}

class _LoginPageState extends State<LoginPage> {
  AuthService authService = new AuthService();
  BaseAuth auth;
  String userId;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FlutterLogo(size: 150),
              SizedBox(height: 50),
              _loginInButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _loginInButton() {
    return OutlineButton(
      splashColor: Colors.grey,
      onPressed: () {
        _login();
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      highlightElevation: 0,
      borderSide: BorderSide(color: Colors.grey),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(image: AssetImage("assets/google_logo.png"), height: 35.0),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                'Sign in with Google',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
  void _login() async {
    String uid = await authService.googleSingIn();
    print(uid);
    if(uid != null){
      var route = new MaterialPageRoute(builder: (context) => ProfilePage(userId : uid , auth: auth));
      Navigator.of(context).push(route);
    }


  }

}