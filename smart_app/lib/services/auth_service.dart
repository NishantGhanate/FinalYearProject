import 'package:firebase_auth/firebase_auth.dart';
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

    return currentUser;
  }

    Future<void> signOut(context) async {
     _auth.signOut();
     await _googleSignIn.signOut(); //Add this to ask again for diffrent id
//     FirebaseAuth.instance.signOut();

  }

}