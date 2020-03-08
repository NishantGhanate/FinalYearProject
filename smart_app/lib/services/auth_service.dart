import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



abstract class BaseAuth {
  Future<FirebaseUser> googleSingIn();
  Future<FirebaseUser> getCurrentUser();
  Future<void> signOut(context);
}

class AuthService implements BaseAuth {

  // Init Dependencies
  GoogleSignIn _googleSignIn = GoogleSignIn();
  FirebaseAuth _auth = FirebaseAuth.instance;
  Firestore _db = Firestore.instance;

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _auth.currentUser();
    return user;
  }

  Future<FirebaseUser> googleSingIn() async {
    // Start
    // Init sign in
    GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount
        .authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);

    final AuthResult authResult = await _auth.signInWithCredential(credential);
    assert(!authResult.user.isAnonymous);
    assert(await authResult.user.getIdToken() != null);
    final FirebaseUser currentUser = await _auth.currentUser();

    assert(authResult.user.uid == currentUser.uid);
    _db.settings(persistenceEnabled: true);
    print("signed in " + currentUser.displayName);

    FirebaseUser firebaseUser = await _auth.currentUser();
    String uid = firebaseUser.uid;
    final FirebaseDatabase _database = FirebaseDatabase.instance;
    var sensors = _database
        .reference()
        .child("users")
        .child(uid)
        .child('sensors');

    sensors.child('ldr').update({'value':0});
    sensors.child('ldr').update({'icon':'https://i.imgur.com/ZIjIO6m.png'});

    sensors.child('temp').update({'value':0});
    sensors.child('temp').update({'icon':'https://i.imgur.com/b8xvTTf.png'});

    sensors.child('buzz').update({'value':0});
    sensors.child('buzz').update({'icon':'https://i.imgur.com/NGeM4Rp.png'});

    sensors.child('pir').update({'value':0});
    sensors.child('pir').update({'icon':'https://i.imgur.com/hhKmC8W.png'});


    return currentUser;
  }

    Future<void> signOut(context) async {
     await FirebaseAuth.instance.signOut();
     await _googleSignIn.signOut(); //Add this to ask again for diffrent id

  }

}