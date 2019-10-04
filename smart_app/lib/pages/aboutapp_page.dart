import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutAppPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AboutAppPageState();
  // TODO: implement createState

}

class _AboutAppPageState extends State<AboutAppPage>
    with SingleTickerProviderStateMixin {
  // AnimationController _animationController;
  // Animation<double> animation;
  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   _animationController=new AnimationController(
  //     duration: const Duration(milliseconds: 1000),
  //     //upperBound: 60,
  // 	vsync: this,
  //   );
  //   animation=new Tween<double>(begin: 0,end: 100,).animate(_animationController);//CurvedAnimation(parent: _animationController,curve: Curves.bounceIn);
  //   _animationController.forward();
  // }
  @override
  Widget build(BuildContext context) {
    //print(animation.value);
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text('About app'),
          backgroundColor: Colors.grey[600],
        ),
        body: Container(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(70,55,0,0),
                child: Image.asset('assets/icons/logo.png' , ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(70,55,0,20),
                child: Text( ' Version 0.1 ' , style:  TextStyle(fontSize: 14),),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(50,55,0,20),
                child: Text(' Features : \n\n - Notification on motion with image \n\n - Alert on Temrature rise  \n\n - Live Sensors data  \n\n - BuiltIn caller ' , style:  TextStyle(fontSize: 16),),
              ),
            ],
          ),
        )
      );
    }


}
