import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart';
import 'package:rxdart/rxdart.dart';
import 'package:smart_security/pages/loginpage.dart';

class AuthService with ChangeNotifier  {
  // Init Dependencies
   GoogleSignIn _googleSignIn = GoogleSignIn();
   FirebaseAuth _auth = FirebaseAuth.instance;
   Firestore _db = Firestore.instance;
   PublishSubject loading = PublishSubject();


  Future<FirebaseUser> getUser() {
    return _auth.currentUser();
  }

  Future<FirebaseUser> googleSingIn() async {
    // Start
    loading.add(true);
    
    // Init sign in
    GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: googleSignInAuthentication.accessToken, accessToken: googleSignInAuthentication.idToken);

    final FirebaseUser user = await _auth.signInWithCredential(credential);
    _db.settings(persistenceEnabled: true);
    // Done
    loading.add(false);

    print("signed in " + user.displayName);
    return user;

  }

   Future signOut(BuildContext context){
     var result = FirebaseAuth.instance.signOut(); //_auth.signOut();
     notifyListeners();
     return result;
   }


  final AuthService authService = AuthService();

}

/**
  Links :
  https://firebase.google.com/docs/firestore/manage-data/enable-offline#configure_offline_persistence
  https://pub.dev/packages/rxdart#-installing-tab-
    https://fireship.io/lessons/flutter-firebase-google-oauth-firestore/
    https://github.com/aaronksaunders/simple_firebase_auth


 **/

