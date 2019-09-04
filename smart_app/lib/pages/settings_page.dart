
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


const Color PURPLE = Color(0xFF8c77ec);

class SettingsPage extends StatefulWidget{
  // TODO: implement createState
  @override
  State<StatefulWidget> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>{


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: PURPLE,
      ),
    );
  }
}