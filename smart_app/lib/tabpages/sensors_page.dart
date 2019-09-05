
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SensorsPage extends StatefulWidget{

  SensorsPage(this.userId);
  final String userId;

  @override
  State<StatefulWidget> createState() => _SensorsPageState();
// TODO: implement createState

}

class _SensorsPageState extends State<SensorsPage> with AutomaticKeepAliveClientMixin<SensorsPage> {

  var sensorList = ['1','2','3'];

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  void initState() {
    // TODO: implement firebase images list and listner
    super.initState();
  }


  Widget _buildList(BuildContext context, DocumentSnapshot document) {
//    print(document.documentID);
//    print(document['value']);
    return Card(
      shape: new RoundedRectangleBorder(
          side: new BorderSide(color: Colors.grey[700], width: 2.0),
          borderRadius: BorderRadius.circular(4.0)),
      elevation: 5.0,
      child: new Container(
        alignment: Alignment.center,
//          child: new Text( document.documentID +'\n' +document['value'] , style: TextStyle(fontSize: 10),),
           child: Column(
             children: <Widget>[
               new Image.network('https://picsum.photos/250?image=9',scale: 10,),

               new Text( document.documentID +'\n' +document['value'] , style: TextStyle(fontSize: 10),),
             ],
           ),
      ),
    );
  }

  // ignore: must_call_super
  Widget build(BuildContext context) {

    CollectionReference streamRef = Firestore.instance.collection('users').document(widget.userId).collection('sensors');

    // TODO: implement sensors grid view
    return Scaffold(
       body: StreamBuilder(
         stream: streamRef.snapshots(),
          builder: (context , snapshot) {
            if (!snapshot.hasData) {
              return Text("Loading..");
            }
            return GridView.builder(
              itemCount :snapshot.data.documents.length,
              gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                itemBuilder: (BuildContext context, int index) {
                  return _buildList(context, snapshot.data.documents[index]);
                }
            );
          }// Builder
       ),

    ); // This

  }

}


