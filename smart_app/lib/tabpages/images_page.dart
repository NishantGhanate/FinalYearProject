
import 'package:flutter/material.dart';

class ImagesPage extends StatefulWidget{
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
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.black12,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
          ],
        ),
      ),
    );
  }

}