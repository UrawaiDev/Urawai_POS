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
      var snapshot = await _firestore
          .collection('Users')
          .where('id', isEqualTo: _firebaseUser.uid)
          .getDocuments();
      var users =
          snapshot.documents.map((documents) => Users.fromJson(documents.data));
      var currentUser =
          users.firstWhere((element) => element.id == _firebaseUser.uid);

      return currentUser;
    }
  }

  // Stream<Users> getCurrentUser() {
  //   Stream<Users> currentUser;
  //   final Firestore _firestore = Firestore.instance;
  //   final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  //   _firebaseAuth.onAuthStateChanged.listen((user) async {
  //     if (user == null)
  //       currentUser = null;
  //     else {
  //       var snapshot = _firestore
  //           .collection('Users')
  //           .where('id', isEqualTo: user.uid)
  //           .snapshots();

  //       var result = snapshot.forEach((querySnapshot) {
  //         return querySnapshot.documents
  //             .map((document) => Users.fromJson(document.data));
  //       });

  //       currentUser = Stream.fromFuture(result);
  //     }
  //   });
  //   return currentUser;
  // }
}
