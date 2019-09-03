import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class BaseAuth {
  Future<String> googleSingIn();
  Future<FirebaseUser> getCurrentUser();
  Future<void> signOut();
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

  Future<String> googleSingIn() async {
    // Start
    // Init sign in
    GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount
        .authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);


    final FirebaseUser user = await _auth.signInWithCredential(credential);
    assert(!user.isAnonymous);

    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();

    assert(user.uid == currentUser.uid);

    _db.settings(persistenceEnabled: true);
    // Done


    print("signed in " + user.displayName);
    return user.uid;
  }

  Future<void> signOut() async {
    return _auth.signOut();

  }

}