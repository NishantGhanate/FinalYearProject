
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';
import 'package:simple_share/simple_share.dart';
import 'package:smart_app/services/storage_service.dart';


class ImagesPage extends StatefulWidget{
  ImagesPage(this.userId) ;
  final String userId;
  @override
  State<StatefulWidget> createState() => _ImagesPageState();
    // TODO: implement createState
}

class _ImagesPageState extends State<ImagesPage> with AutomaticKeepAliveClientMixin<ImagesPage> {

  Firestore _db = Firestore.instance;

  Storage storage = new Storage();
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  void initState() {
    // TODO: implement firebase images list and listner
    super.initState();
    _db.settings(persistenceEnabled: true);
  }


   _showDialog(BuildContext context , Uint8List bytes , String id) {
    return showDialog(context: context,
        builder: (BuildContext context){
          return AlertDialog(
            backgroundColor: Colors.grey[800],
            title: Text('Please select an action below',style: TextStyle(fontSize: 15),),
//              content: Text(''),
            actions: <Widget>[
              FlatButton(
                child: Text('Save'),
                textColor: Colors.white,
                onPressed: () async {
                  try{
                    var dir = '/storage/emulated/0/Smartapp/';
                    File file = await new File(dir+id+'.jpg').create(recursive: true);
                    file.writeAsBytes(bytes);
//
//                    final snackBar = SnackBar(
//                        content: Text('Yay! A SnackBar!'),
//                        action: SnackBarAction(
//                          label: 'Undo',
//                          onPressed: () {},
//                        ),
//                    );
//
//                    Scaffold.of(context).showSnackBar(snackBar);
                    Navigator.pop(context);

                  }
                  catch(e){
                    print('error: $e');
                  }
                },
              ),
              FlatButton(
                child: Text('Share'),
                textColor: Colors.white,
                onPressed: () async {
                  try{
                    var tempDir = await getTemporaryDirectory();
                    var savePath = '${tempDir.path}/image.jpg';
                    final file = await new File(savePath).create(recursive: true);
                    file.writeAsBytesSync(bytes);
                    print(savePath);
                    final uri = Uri.file(savePath);
                    SimpleShare.share(
                        uri: uri.toString(),
                        title: 'title',
                        msg: id
                    );
                    Navigator.pop(context);
                    // Scaffold
                  }
                  catch(e){
                    print('error: $e');
                  }
                },
              )
            ],
          );
        }
    );
  }

  Widget _buildList(BuildContext context, DocumentSnapshot document) {
//    print(document.documentID);
    Uint8List bytes = base64Decode(document['blob']);
    return new GestureDetector(
      onTap: () async {
        // TODO : open ImageVIew Save / Share
        _showDialog(context,bytes,document.documentID);
    },
      child: Card(
        shape: new RoundedRectangleBorder(
            side: new BorderSide(color: Colors.grey[700], width: 2.0),
            borderRadius: BorderRadius.circular(4.0)),
        elevation: 5.0,
        child: new Container(
//          margin: const EdgeInsets.only(top: 20.0,),
          alignment: Alignment.center,
//          child: new Text( document.documentID +'\n' +document['value'] , style: TextStyle(fontSize: 10),),
          child: Column(
            children: <Widget>[
//              Padding(
//                padding: EdgeInsets.all(10.0),
//                child: new Text( document.documentID  , style: TextStyle(fontSize: 14),),
//              ),
              Padding(
                padding: EdgeInsets.all(10.0),
                child:  new Image.memory(bytes,scale: 1,),
              ),
            ],
          ),
        ),
      ),
    );
  }// End of build list



  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    CollectionReference imgReference = _db.collection('users').document(widget.userId).collection('images');

//    DocumentReference imgReference =  Firestore.instance.collection('testting').document('Images');
    // TODO: implement build
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: imgReference.snapshots(),
        builder: (context , snapshot){
        if (!snapshot.hasData) {
          return Text("Loading..");
          }
        return ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder:(context , index){
              DocumentSnapshot document  = snapshot.data.documents[index];
              return  Dismissible(
                direction: DismissDirection.startToEnd,
                resizeDuration: Duration(microseconds: 200),
                key : ObjectKey(document.documentID),
                onDismissed: (direction){
                  // TODO: implement  delete function and check direction if needed
                  setState(() {
                    // TODO: implement deletion of local snapshot and setState
                    snapshot.data.documents.removeAt(index);
                  });
                  // TODO : Delete Firebase Notification
                  _delete(document.documentID);
                },
                background: Container(color: Colors.red , child: Icon(Icons.delete , size: 50,),),
                child:  _buildList(context, snapshot.data.documents[index]),
              );
            }
          );
        }
      ),
    );
  }

  Future _delete(doc) async {
    _db.collection('users').document(widget.userId).collection('images').document(doc).delete();
  }



}

