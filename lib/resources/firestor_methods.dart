import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:instagramclone/models/post.dart';
import 'package:instagramclone/resources/storage_methods.dart';
import 'package:instagramclone/utils/utils.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //upload post
  // Future<String> uploadPost(
  //   String description,
  //   Uint8List file,
  //   String uid,
  //   String username,
  //   String profileImage,
  //
  // ) async {
  //   String res = 'Some errors occurred';
  //   try {
  //
  //
  //     String photoUrl =
  //         await StorageMethods().uploadImageToStorage('posts', file, true);
  //     String postId = const Uuid().v1();
  //     Post post = Post(
  //         description: description,
  //         uid: uid,
  //         username: username,
  //         postId: postId,
  //         datePublished: DateTime.now(),
  //         postUrl: photoUrl,
  //         profileImage: profileImage,
  //         likes: [],
  //         );
  //     _firestore.collection('posts').doc(postId).set(post.toJson());
  //     res = 'success';
  //   } catch (e) {
  //     res = e.toString();
  //   }
  //   return res;
  // }
  //upload post
  Future<String> uploadPost(
    String description,
    Uint8List file,
    String uid,
    String username,
    String profileImage,

  ) async {
    String res = 'Some errors occurred';
    try {


      String photoUrl =
          await StorageMethods().uploadImageToStorage('posts', file, true);
      String postId = const Uuid().v1();
      Post post = Post(
          description: description,
          uid: uid,
          username: username,
          postId: postId,
          datePublished: DateTime.now(),
          postUrl: photoUrl,
          profileImage: profileImage,
          likes: [],
          );
      _firestore.collection('users').doc(uid).collection('posts').doc(postId).set(post.toJson());
      res = 'success';
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<void> likePost(String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _firestore.collection('users').doc(uid).collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        await _firestore.collection('users').doc(uid).collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid]),
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }


  int likesNumber = 0;
  Future<void> likeComment(
      String postId, String commentId, String uid, List likes) async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('users')
          .doc(uid).
      collection('posts').
      doc(postId).
      collection('comments').doc(commentId).get();
      likesNumber =  snapshot.get('likes').length;
      if (likes.contains(uid)) {
        // likesNumber = ['likes'].length-1;
        await _firestore
            .collection('users')
            .doc(uid)
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .update({
          'likes': FieldValue.arrayRemove([uid]),
          'LikesNumber': likesNumber-1,
        });
      } else {
        // likesNumber = ['likes'].length;
        await _firestore
            .collection('users')
            .doc(uid)
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .update({
          'likes': FieldValue.arrayUnion([uid]),
          'LikesNumber': likesNumber+1,
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> postComment(String postId, String text, String uid, String name,
      String profilePic) async {
    String commentId = const Uuid().v1();
    try {
      if (text.isNotEmpty) {
        await _firestore
            .collection('users')
            .doc(uid).
            collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'profilePic': profilePic,
          'name': name,
          'uid': uid,
          'postId': postId,
          'text': text,
          'commentId': commentId,
          'datePublished': DateTime.now(),
          'likes': [],
          'LikesNumber' : likesNumber
        });
      } else {
        print('text is empty');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  //Delete post
  Future<void> deletePost(String postId ) async {
    try {
      await _firestore.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('posts').doc(postId).delete();
    }catch(e){
      print(e.toString());
    }
  }
  
  //Delete comment
  Future<void> deleteComment(String postId , String commentId ) async {
    try {
      await _firestore.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('posts').doc(postId).collection('comments').doc(commentId).delete();
    }catch(e){
      print(e.toString());
    }
  }

  Future<void> followUser(
      String uid,
      String followId,
      ) async{
    try{
      DocumentSnapshot snap = await _firestore.collection('users').doc(uid).get();
      List following = (snap.data()! as dynamic)['following'];
      if (following.contains(followId)){
        await _firestore.collection('users').doc(followId).update({
          'followers' : FieldValue.arrayRemove([uid]),
        });
        await _firestore.collection('users').doc(uid).update({
          'following' : FieldValue.arrayRemove([followId]),
        });
      }else {
        await _firestore.collection('users').doc(followId).update({
          'followers' : FieldValue.arrayUnion([uid]),
        });
        await _firestore.collection('users').doc(uid).update({
          'following' : FieldValue.arrayUnion([followId]),
        });
      }
    }catch(e){
      print(e.toString());
    }
  }
}
