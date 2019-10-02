import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_app/pages/profile_page.dart';
import 'package:smart_app/services/auth_service.dart';
//import 'package:smart_app/services/auth_service.dart';


class LoginPage extends StatefulWidget{

  @override
  State<StatefulWidget> createState() => _LoginPageState() ;

}

class _LoginPageState extends State<LoginPage> {
  AuthService authService = new AuthService();
//  BaseAuth auth;
  String userId;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  Scaffold(
       body:Stack(
         fit: StackFit.expand,
        children: <Widget>[
          Container(child: Image.asset('assets/gifs/matrix.gif',fit: BoxFit.fill,),height: MediaQuery.of(context).size.height,),
          Positioned(child: Image.asset('assets/icons/logo.png',scale: 1,),top: MediaQuery.of(context).size.height*0.22,left: MediaQuery.of(context).size.width*0.18,),
          Positioned(child: Text('Smart security' ,style: TextStyle(color: Colors.white, fontSize: 36)  ) , top: MediaQuery.of(context).size.height*0.50,left: MediaQuery.of(context).size.width*0.25,),
          Positioned(child: _loginInButton(),top: MediaQuery.of(context).size.height*0.75,left: MediaQuery.of(context).size.width*0.2,),

        ],
      )
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
            Image(image: AssetImage("assets/images/google_logo.png"), height: 35.0),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                'Sign in with Google',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _login() async {
    FirebaseUser user = await authService.googleSingIn();
    print(user.uid);
    if (user != null) {
      var route = new MaterialPageRoute(
          builder: (context) => ProfilePage(user: user));
      Navigator.of(context).push(route);
    }
  }



}