import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagramclone/models/user.dart' as model;
import 'package:instagramclone/resources/storage_methods.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<model.User> getUserDetails() async{
      User currentUser = _auth.currentUser!;
      DocumentSnapshot snap =
      await _firestore.
      collection('users').
      doc(currentUser.uid).
      get();

      return model.User.fromSnap(snap);
  }

  //signup method
  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List file,
  }) async {
    String res = 'some errors occurred';
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          bio.isNotEmpty) {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        print(cred.user!.uid);
        String photoUrl = await StorageMethods()
            .uploadImageToStorage('profilePics', file, false);

        model.User user = model.User(
          username: username,
          uid: cred.user!.uid,
          email: email,
          bio: bio,
          photoUrl: photoUrl,
          following: [],
          followers: [],
        );
        await _firestore.collection('users').doc(cred.user!.uid).set(user.toJson());
        res = 'success';
      }
    } on FirebaseAuthException catch (err) {
      if (err.code == 'invalid-email') {
        res = 'The email is wrong format';
      } else if (err.code == 'weak-password') {
        res = 'The password is weak or too short';
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

// log in method
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = 'Some errors occurred';
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = 'login success';
      }else {
        res = 'Please enter all fields';
      }
    } on FirebaseAuthException catch (err) {
      if (err.code == 'user-not-found') {
        res = 'Wrong mail or user has been deleted';
      } else if (err.code == 'wrong-password') {
        res = 'Wrong password, please enter right one';
      }
    } catch (err) {
      res = err.toString();
    }
    return res ;
  }

  // sign out function
Future <void> signOut() async {
    await _auth.signOut();
}
}
