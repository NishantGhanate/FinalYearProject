
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget{

  NotificationPage(this.userId);
  final String userId;

  @override
  State<StatefulWidget> createState() => _NotificationPageState();
// TODO: implement createState

}

class _NotificationPageState extends State<NotificationPage> with AutomaticKeepAliveClientMixin<NotificationPage> {


  Firestore _db = Firestore.instance;

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  void initState() {
    // TODO: implement firebase images list and listner
    super.initState();
    _db.settings(persistenceEnabled: true);
  }


  Widget _buildList(BuildContext context, DocumentSnapshot document) {
    print(document.documentID);
    return ListTile(
      trailing: Icon(Icons.notifications),
      title: Text(document['title']),
      subtitle: Text(document['body']),

    );
  }


  // ignore: must_call_super
  Widget build(BuildContext context) {
    CollectionReference streamRef = _db.collection('users').document(widget.userId).collection('notifications');

    // TODO: implement build
    return  Scaffold(
      body: StreamBuilder(
        stream: streamRef.snapshots(),
        builder: (context , snapshot){
          if (!snapshot.hasData) {
            return Text("Loading..");
          }
          return ListView.builder(
//              itemExtent: 80.0,
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
                    _deleteNotificattion(document.documentID);
                  },
                  background: Container(color: Colors.red , child: Icon(Icons.delete , size: 25,)),
                  child:  _buildList(context, snapshot.data.documents[index]),
                );

              },
          );
        },
      ),
    );
  }

  Future _deleteNotificattion(doc) async {
    _db.collection('users').document(widget.userId).collection('notifications').document(doc).delete();
//    Firestore.instance.collection('test').document(doc).delete();

  }


}