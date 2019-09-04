import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactsPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _ContactPageState();
    // TODO: implement createState
}

class _ContactPageState extends State<ContactsPage>{

  @override
  void initState() {
    // TODO: get contact saves from firebase
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Contacts'),
        backgroundColor: Colors.red[800],
      ),
      body: Container(
        child: Center(
          child: RaisedButton(
            onPressed: _launchURL,
            child: Text('Open Dialer'),
          ),
        ),
      ),
    );
  }

  _launchURL() async {
    const url = 'tel:+918692947192';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }



}