import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagramclone/models/user.dart' as model;
import 'package:instagramclone/providers/user/provider.dart';
import 'package:instagramclone/resources/firestor_methods.dart';
import 'package:instagramclone/screens/comments_screen.dart';
import 'package:instagramclone/utils/colors.dart';
import 'package:instagramclone/utils/utils.dart';
import 'package:instagramclone/widgets/like_animaion.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../responsive/dimensions.dart';

class PostCard extends StatefulWidget {
  final snap;

  const PostCard({Key? key, required this.snap}) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLikeAnimating = false;
  int commentLength = 0;
  @override
  void initState() {
    super.initState();
    getComments();
  }

  void getComments()async {
      try{
        QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid).
        collection('posts').
        doc(widget.snap['postId']).
        collection('comments').get();
        commentLength = snapshot.docs.length;
      }catch(e){
        print(e.toString());
        showSnackBar(e.toString(), context);
      }
      setState(() {

      });
  }


  @override
  Widget build(BuildContext context) {
    final model.User? user = Provider.of<UserProvider>(context).getUser;
    final width = MediaQuery.of(context).size.width ;
    return Container(
      color: width > webScreenSize ? webBackgroundColor :mobileBackgroundColor,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          //Header section
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16)
                .copyWith(right: 0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(widget.snap['profileImage']),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.snap['username'],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ),
                IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) => Dialog(
                                child: ListView(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  shrinkWrap: true,
                                  children: [
                                    'Delete',
                                  ]
                                      .map((e) => InkWell(
                                            onTap: () async {
                                              await FirestoreMethods().deletePost(widget.snap['postId']);
                                              Navigator.of(context).pop();
                                            },
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 12,
                                                      horizontal: 16),
                                              child: Text(e),
                                            ),
                                          ))
                                      .toList(),
                                ),
                              ));
                    },
                    icon: const Icon(Icons.more_vert)),
              ],
            ),
          ),
          GestureDetector(
            onDoubleTap: () async {
              await FirestoreMethods().likePost(
                  widget.snap['postId'], user!.uid, widget.snap['likes']);
              setState(() {
                isLikeAnimating = true;
              });
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.35,
                  width: double.infinity,
                  child: Image.network(
                    widget.snap['postUrl'],
                    fit: BoxFit.cover,
                  ),
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: isLikeAnimating ? 1 : 0,
                  child: LikeAnimation(
                    isAnimating: isLikeAnimating,
                    duration: const Duration(milliseconds: 400),
                    onEnd: () {
                      setState(() {
                        isLikeAnimating = false;
                      });
                    },
                    child: const Icon(
                      Icons.favorite,
                      color: Colors.white,
                      size: 120,
                    ),
                  ),
                )
              ],
            ),
          ),
          Row(
            children: [
              LikeAnimation(
                isAnimating: widget.snap['likes'].contains(user?.uid),
                smallLike: true,
                child: IconButton(
                    onPressed: () async {
                      await FirestoreMethods().likePost(
                          widget.snap['postId'],
                          user!.uid,
                          widget.snap['likes']);
                    },
                    icon: widget.snap['likes'].contains(user?.uid)? const Icon(
                      Icons.favorite,
                      color: Colors.red,
                    ): const Icon(Icons.favorite_border,)
                )

              ),
              IconButton(
                  onPressed: () =>
                      Navigator.push(
                          context, MaterialPageRoute(
                          builder: (context) =>  CommentsScreen(
                            snap: widget.snap ,))),
                  icon: const Icon(
                    Icons.mode_comment_outlined,
                  )),
              IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.send_outlined,
                  )),
              Expanded(
                  child: Align(
                alignment: Alignment.bottomRight,
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.bookmark_border,
                  ),
                ),
              ))
            ],
          ),
          //Description and number of comments
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DefaultTextStyle(
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall!
                        .copyWith(fontWeight: FontWeight.w800),
                    child: Text(
                      '${widget.snap['likes'].length} likes',
                      style: Theme.of(context).textTheme.bodyMedium,
                    )),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 8),
                  child: RichText(
                    text: TextSpan(
                        style: const TextStyle(color: Colors.white),
                        children: [
                          TextSpan(
                              text: widget.snap['username'],
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          const TextSpan(text: ' '),
                          TextSpan(
                              text: widget.snap['description'],
                              style: const TextStyle(
                                  fontWeight: FontWeight.normal)),
                        ]),
                  ),
                ),
                //Number of comments
                InkWell(
                  onTap: () {
                    if (commentLength == 0){
                      showSnackBar('No comments for this post', context);
                    }else {
                      Navigator.push(
                          context, MaterialPageRoute(
                          builder: (context) =>  CommentsScreen(
                            snap: widget.snap ,)));
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child:  Text(
                      'View all $commentLength comments',
                      style: const TextStyle(fontSize: 16, color: secondaryColor),
                    )
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    DateFormat.yMMMd()
                        .format(widget.snap['datePublished'].toDate()),
                    style: const TextStyle(fontSize: 12, color: secondaryColor),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
