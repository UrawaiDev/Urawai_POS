import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:urawai_pos/core/Models/users.dart';
import 'package:urawai_pos/core/Services/error_handling.dart';
import 'package:urawai_pos/core/Services/firestore_service.dart';

class FirebaseAuthentication {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirestoreServices _firestoreServices = FirestoreServices();

  //Stream Auth onChanged
  Stream<FirebaseUser> get userState => _auth.onAuthStateChanged;

  Users _currentUser;
  Future<Users> get currentUserXXX async {
    var firebaseUser = await _auth.currentUser();
    Users result = await _populateCurrentUser(firebaseUser);
    return result;
  }

  //SignOUt
  Future<void> signOut() async {
    await _auth.signOut();
  }

  //Reset Password
  Future<dynamic> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return true;
    } catch (e) {
      return e.message.toString();
    }
  }

  //SignUp with Email & Password
  Future<dynamic> signUpWithEmail(
      String email, String password, String username, String shopName) async {
    try {
      AuthResult authResult = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser _firebaseUser = authResult.user;

      Users _user = Users(
          _firebaseUser.uid, shopName, username, _firebaseUser.email, 'admin');

      //create users to Firestore DB
      await _firestoreServices.createUser(_user);

      // await _populateCurrentUser(_firebaseUser);

      return _user;
    } catch (e) {
      return OnErrorState(e.message.toString());
    }
  }

  //Sign In With Email & Password
  Future signInWithEmailandPassword(String email, String password) async {
    try {
      AuthResult authResult = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      // _currentUser = await _populateCurrentUser(authResult.user);
      _currentUser = await _firestoreServices.currentUser(authResult.user.uid);
      // return authResult.user;
      return _currentUser;
    } catch (e) {
      OnErrorState msg = OnErrorState(e.message.toString());
      return msg;
    }
  }

  Future<Users> _populateCurrentUser(FirebaseUser firebaseUser) async {
    if (firebaseUser != null) {
      Users result = await _firestoreServices.getUser(firebaseUser.uid);

      return result;
    }
    return null;
  }
}
