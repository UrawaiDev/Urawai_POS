import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:urawai_pos/core/Enums/user_roles.dart';
import 'package:urawai_pos/core/Models/users.dart';
import 'package:urawai_pos/core/Services/error_handling.dart';

class FirebaseAuthentication {
  FirebaseAuth _auth = FirebaseAuth.instance;
  Firestore _firestore = Firestore.instance;

  //Stream Auth onChanged
  Stream<FirebaseUser> get userState => _auth.onAuthStateChanged;

  //SignOUt
  Future<void> signOut() async {
    await _auth.signOut();
  }

  //SignUp with Email & Password
  Future<dynamic> signUpWithEmail(
      String email, String password, String username, String shopName) async {
    try {
      AuthResult authResult = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser _firebaseUser = authResult.user;

      Users _user = Users(_firebaseUser.uid, shopName, username,
          _firebaseUser.email, UserRole.ADMIN);

      //create users to Firestore DB
      _firestore
          .collection('Users')
          .document(shopName + '_' + username + '_' + _firebaseUser.uid)
          .setData({
        'id': _firebaseUser.uid,
        'shopName': shopName,
        'email': email,
        'username': username,
        'roles': UserRole.ADMIN.toString(),
      });

      return _user;
    } catch (e) {
      return FirebaseAuthError(e.message.toString());
    }
  }

  //Sign In With Email & Password
  Future<dynamic> signInWithEmailandPassword(
      String email, String password) async {
    try {
      AuthResult authResult = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser firebaseUser = authResult.user;
      //  Users _user = Users(id, shopName, username, email, roles)

      return firebaseUser;
    } catch (e) {
      FirebaseAuthError msg = FirebaseAuthError(e.message.toString());
      return msg;
    }
  }
}
