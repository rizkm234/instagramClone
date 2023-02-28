import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagramclone/resources/firestor_methods.dart';
import 'package:instagramclone/utils/colors.dart';
import 'package:provider/provider.dart';
import 'package:instagramclone/models/user.dart' as model;
import '../providers/user/provider.dart';
import '../widgets/comment_card.dart';

class CommentsScreen extends StatefulWidget {
  final snap ;
  const CommentsScreen({Key? key, required this.snap}) : super(key: key);

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final TextEditingController _commentController = TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _commentController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final model.User? user = Provider.of<UserProvider>(context).getUser;
    return  Scaffold(
        appBar: AppBar(
          backgroundColor: mobileBackgroundColor,
          title: const Text('Comments',
            style: TextStyle(
                fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: false  ,
        ),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: kToolbarHeight,
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom
          ),
          padding: const EdgeInsets.only(left: 16 , right: 8),
          child: Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundImage: NetworkImage(user!.photoUrl) ,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0 , right: 8),
                  child: TextFormField(
                    controller: _commentController,
                    decoration:  InputDecoration(
                      hintText: 'Comment as ${user.username} ...',
                      border: InputBorder.none,
                    ),
                    maxLines: 8,
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                  await FirestoreMethods().postComment(
                      widget.snap['postId'],
                      _commentController.text,
                      user.uid,
                      user.username,
                      user.photoUrl);
                  setState(() {
                    _commentController.text = '';
                  });
                } ,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  child: const Text('Post',
                    style: TextStyle(
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold),),
                ),
              )
            ],
          ),
        ),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).
          collection('posts').
          doc(widget.snap['postId']).
          collection('comments').orderBy('datePublished' , descending: true).snapshots(),
          builder: (context, snapshot){
            if (snapshot.connectionState == ConnectionState.waiting){
              return const Center(child: CircularProgressIndicator(color: Colors.white,));
            }
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) => CommentCard(
                  snap : snapshot.data!.docs[index].data()
                ));
      }),
    );
  }
}
