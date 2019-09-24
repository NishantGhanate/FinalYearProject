import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
          backgroundColor: Colors.blue,
        ),
        body: Container(
          color: Colors.black12,
          child: new Column(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.width * 0.65,
                width: MediaQuery.of(context).size.width * 1,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      bottomLeft:
                          Radius.circular(MediaQuery.of(context).size.height*0.5),
                      bottomRight:
                          Radius.circular(MediaQuery.of(context).size.height*0.5)),
                ),
                //padding: EdgeInsets.all(25.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(bottomRight: Radius.circular(MediaQuery.of(context).size.height),bottomLeft: Radius.circular(MediaQuery.of(context).size.height)),
                                  child: Image.network(
                    'https://avatars1.githubusercontent.com/u/26281560?s=460&v=4',
                    fit: BoxFit.cover
                    //backgroundImage: NetworkImage('https://avatars1.githubusercontent.com/u/26281560?s=460&v=4'),
                    //radius: 80,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(25.0),
                child: new Text(
                  'Hello ! My name is Nishant Ghanate and'
                  ' This is first flutter app which i had made in my final year project for year 2020 .\n\n'
                  'This is an pretty naive application , i will be happy  if anyone could contrinute thier ideas and extennd this app futher',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
              new RaisedButton(
                onPressed: () {
                  String url =
                      'https://docs.google.com/presentation/d/1CHybxaSqHeoeLkoh-vqelIEi8K-K_FK3gluK_C3RHuE/edit#slide=id.g55d16254f0_1_21';
                  _launchURL(url);
                },
                color: Colors.amber[600],
                child: new Text('Project PPT '),
              ),
              new RaisedButton(
                onPressed: () {
                  String url =
                      'https://github.com/NishantGhanate/FinalYearProject/tree/MobileApp/smart_app';
                  _launchURL(url);
                },
                child: new Text('Source Code'),
              ),
            ],
          ),
        ));
  }

  _launchURL(url) async {
//    const url = '';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
