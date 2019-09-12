
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:scoped_model/scoped_model.dart';

class UserModel extends Model{
  final Firestore _db = Firestore.instance;
  String displayName,email,photoUrl;
  FirebaseUser currentUser;
  notifyListeners();


  Future<FirebaseUser> getUserData() async{
//    currentUser = await _auth.currentUser();
    notifyListeners();
    _db.settings(persistenceEnabled: true);
    return currentUser;
  }

  Future<bool> updateLogin() async {
    // TODO : As user login update
    return true;
  }







}