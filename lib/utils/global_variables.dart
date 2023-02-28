import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagramclone/screens/addPost_screen.dart';
import 'package:instagramclone/screens/feed_screen.dart';
import 'package:instagramclone/screens/profile_screen.dart';
import 'package:instagramclone/screens/search_screen.dart';

const webScreenSize = 600;

 List<Widget> homeScreenItems = [
  const FeedScreen(),
  const SearchScreen(),
  const addPostScreen(),
  const Text('notification'),
  ProfileScreen(uid: FirebaseAuth.instance.currentUser!.uid,)
];