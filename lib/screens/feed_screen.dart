import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagramclone/responsive/dimensions.dart';
import 'package:instagramclone/utils/colors.dart';
import 'package:instagramclone/widgets/post_card.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width ;
    return Scaffold(
      appBar: width > webScreenSize ? null :AppBar(
        backgroundColor: width > webScreenSize ? webBackgroundColor :mobileBackgroundColor,
        centerTitle: false,
        title: SvgPicture.asset(
          'assets/images/ic_instagram.svg',
          color: Colors.white,
          height: 32,
        ),
        actions: [
          IconButton(
              onPressed: () {}, icon: const Icon(Icons.messenger_outline))
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('posts').orderBy('datePublished', descending: true).snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting){
            return const Center(
              child: CircularProgressIndicator(color: Colors.blueAccent,),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
              itemBuilder: (context , index) =>  Container(
                margin:   EdgeInsets.symmetric(
                  horizontal: width > webScreenSize ? width*0.1 : 0,
                  vertical: width > webScreenSize ? 15 : 0,
                ),
                child: PostCard(
                  snap : snapshot.data!.docs[index].data(),
                ),
              ),
          );
        },
      ),
    );
  }
}
