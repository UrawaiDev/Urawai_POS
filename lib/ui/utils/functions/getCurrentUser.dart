import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:urawai_pos/core/Models/users.dart';

class CurrentUserLoggedIn {
  static Future<Users> get currentUser async {
    final Firestore _firestore = Firestore.instance;
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    final FirebaseUser _firebaseUser = await _firebaseAuth.currentUser();

    if (_firebaseUser == null)
      return null;
    else {
      var document = await _firestore
          .collection('Users')
          .document(_firebaseUser.uid)
          .get();

      return Users.fromJson(document.data);
    }
  }

  static Future<Users> getCurrentUser(String uid) async {
    final Firestore _firestore = Firestore.instance;

    var document = await _firestore.collection('Users').document(uid).get();

    return Users.fromJson(document.data);
  }
}
