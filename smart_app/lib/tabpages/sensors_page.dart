
import 'dart:async';

//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class SensorsPage extends StatefulWidget{

  SensorsPage(this.userId);
  final String userId;

  @override
  State<StatefulWidget> createState() => _SensorsPageState();
// TODO: implement createState

}

class _SensorsPageState extends State<SensorsPage> with AutomaticKeepAliveClientMixin<SensorsPage> {

  var sensorList = ['1','2','3'];
  List<Todo> _todoList;
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  StreamSubscription<Event> _onTodoAddedSubscription;
  StreamSubscription<Event> _onTodoChangedSubscription;
  Query _todoQuery;

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  void initState() {
    // TODO: implement firebase images list and listner
    super.initState();
    _todoList = new List();
    _todoQuery = _database
        .reference()
        .child("users")
        .child(widget.userId)
        .child("sensors");
//    _todoQuery.once().then((DataSnapshot snapshot) {
//      print('Data : ${snapshot.value}');
//    });
    _onTodoAddedSubscription = _todoQuery.onChildAdded.listen(_onEntryAdded);
    _onTodoChangedSubscription = _todoQuery.onChildChanged.listen(_onEntryChanged);

  }

  @override

  void dispose() {
    _onTodoAddedSubscription.cancel();
    _onTodoChangedSubscription.cancel();
    super.dispose();
  }

  _onEntryAdded(Event event) {
    setState(() {
      _todoList.add(Todo.fromSnapshot(event.snapshot));
    });
  }

  _onEntryChanged(Event event) {
    var oldEntry = _todoList.singleWhere((entry) {
      return entry.key == event.snapshot.key;
    });

    setState(() {
      _todoList[_todoList.indexOf(oldEntry)] = Todo.fromSnapshot(event.snapshot);
    });
  }

  _updateTodo(Todo todo){
    //Toggle completed
    todo.value = (todo.value);
    if (todo != null) {
      _database.reference().child("user").child(todo.key).set(todo.toJson());
    }
  }


  Widget _buildList(BuildContext context, int index) {

    String key = _todoList[index].key;
    String icon = _todoList[index].icon;
    String value = _todoList[index].value.toString();
    print(value);
    return new GestureDetector(
      onTap: (){
        print(value);
//        _updateTodo(_todoList[index]);
      },
      child: Card(
       shape: new RoundedRectangleBorder(
       side: new BorderSide(color: Colors.grey[700], width: 2.0),
       borderRadius: BorderRadius.circular(4.0)),
       elevation: 5.0,
        child: new Container(
         margin: const EdgeInsets.only(top: 20.0,),
         alignment: Alignment.center,
          child: Column(
           children: <Widget>[
            Padding(
             padding: EdgeInsets.all(10.0),
              child: new Image.network("https://upload.wikimedia.org/wikipedia/commons/thumb/2/2c/Rotating_earth_%28large%29.gif/200px-Rotating_earth_%28large%29.gif",scale: 2,),
              ),
            new Text("Sesnor : " + key + "\n" , style: TextStyle(fontSize: 14,),),
            new Text("Value : " + value , style: TextStyle(fontSize: 14,),),
            ],
          ),
        ),
      ),
    );
  } // End of build list

  Widget _showTodoList(){
    print(_todoList.length);
    if (_todoList.length > 0){
      return GridView.builder(
          shrinkWrap: true,
          gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          itemCount: _todoList.length,
          itemBuilder: (BuildContext context, int index){
            return _buildList(context, index);

          }
      );
    }
    else{
      return Center(child: Text("Loading....",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 30.0),));
    }

  }

  // ignore: must_call_super
  Widget build(BuildContext context) {

    // TODO: implement sensors grid view
    return Scaffold(
       body:_showTodoList(),
    ); // This

  }

}

class Todo {
  String key;
  String icon;
  int value;

  Todo(this.key, this.icon, this.value);

  Todo.fromSnapshot(DataSnapshot snapshot) :
        key = snapshot.key,
        icon = snapshot.value["icon"],
        value = snapshot.value["value"];

  toJson() {
    return {
      "sensor": key,
      "icon": icon,
      "value": value,
    };
  }

}


