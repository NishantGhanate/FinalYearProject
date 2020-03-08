import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


Color mainColor = Colors.green[700];

class ContactsPage extends StatefulWidget{
  ContactsPage( this.userId);
  final String userId;

  @override
  State<StatefulWidget> createState() => _ContactPageState();
    // TODO: implement createState
}

class _ContactPageState extends State<ContactsPage>{
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();

  Firestore _db = Firestore.instance;
  CollectionReference streamRef;
  @override
  void initState() {
    // TODO: get contact saves from firebase
    super.initState();
    _db.settings(persistenceEnabled: true);
    streamRef = _db.collection('users').document(widget.userId).collection('contacts');
  }

  _showDialog(BuildContext context){
    return showDialog(context: context,
        builder: (BuildContext context){
          return AlertDialog(
//            backgroundColor: Colors.white,
            title: Text('Enter your contact details',style: TextStyle(fontSize: 15),),
            content: SingleChildScrollView(
                child: Column(
                  children: <Widget>[

                    TextFormField(
                      keyboardType: TextInputType.text,
                      controller: nameController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Contact name',
//                          prefixIcon: Icon(Icons.),
                          suffixStyle: TextStyle(color: Colors.white , fontSize: 14)
                      ),
                      maxLines: 1,
                      maxLength: 14,
//                      onSaved: (String val){setState(() {_name =  val;});},
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      controller: phoneController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Phone number',
                          prefixIcon: Icon(Icons.phone),
                          suffixStyle: TextStyle(color: Colors.white)
                      ),
                      maxLines: 1,
                      maxLength: 14,
//                      onSaved: (String val){setState(() {_phone =  val;});},
                    ),
//                    const SizedBox(height: 15.0,),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: emailController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Emaill address',
                          prefixIcon: Icon(Icons.email),
                          suffixStyle: TextStyle(color: Colors.white)
                      ),
                      maxLines: 1,
                      maxLength: 26,
//                      onSaved: (String val){setState(() {_email =  val;});},
                    ),
                  ],
                ),
            ),
            actions : <Widget>[
              RaisedButton(
                child: Text('Save'),
                shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                textColor: Colors.white,
                elevation: 4.0,
                splashColor: Colors.blue[300],
                onPressed: (){
                  _newContacts(nameController.text,phoneController.text,emailController.text);
                  nameController.clear();
                  phoneController.clear();
                  emailController.clear();
                Navigator.pop(context);
              },
            ),
            ],
          );
        }
    );
  }

  Widget _buildList(BuildContext context, DocumentSnapshot document) {
    print(document.documentID);
    return ListTile(
      leading: Icon(Icons.call),
      title: Text(document.documentID),
      subtitle: Text(document['phone']),
      onTap: (){
        _launchURL(document['phone']);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
      appBar: AppBar(
        title: Text('Contacts'),
        backgroundColor: mainColor,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: (){
              _showDialog(context);
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: streamRef.snapshots(),
          builder: (context , snapshot){
            if (!snapshot.hasData) {
              return Text("Loading..");
            }
            return ListView.builder(
              // itemExtent: 80.0,
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
                      _deleteContact(document.documentID);
                    },
                    background: Container(color: Colors.red , child: Icon(Icons.delete , size: 25,)),
                    child:   _buildList(context, snapshot.data.documents[index]),
                  );
              }
              );
          }
      ),
    );
  }

  _launchURL(url) async {
    var telurl = 'tel:'+url;
    if (await canLaunch(telurl)) {
      await launch(telurl);
    } else {
      throw 'Could not launch $url';
    }
  }

  _newContacts(_name,_phone,_email) async{
    // TODO : Add new contact and error handling
    DocumentReference streamRef = _db.collection('users').document(widget.userId).collection('contacts').document(_name) ;
    streamRef.setData({
      "name" :_name,
      "phone": _phone,
      "email": _email,
    }).catchError((e) {
//      handleError(e);
      print("Got error: ${e.error}");     // Finally, callback fires.
      return ;
    });
  }

  _deleteContact(doc) async{
    _db.collection('users').document(widget.userId).collection('contacts').document(doc).delete();
  }



}