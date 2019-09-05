
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ImagesPage extends StatefulWidget{
  ImagesPage(this.userId) ;
  final String userId;
  @override
  State<StatefulWidget> createState() => _ImagesPageState();
    // TODO: implement createState
}

class _ImagesPageState extends State<ImagesPage> with AutomaticKeepAliveClientMixin<ImagesPage> {

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  void initState() {
    // TODO: implement firebase images list and listner
    super.initState();
  }
 

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    CollectionReference reference = Firestore.instance.collection('users').document(widget.userId).collection('images');
    // TODO: implement build
    return Scaffold(

    );

  }




}

