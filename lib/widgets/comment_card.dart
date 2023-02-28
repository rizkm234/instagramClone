

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagramclone/utils/utils.dart';
import 'package:intl/intl.dart';
import 'package:instagramclone/models/user.dart' as model;
import 'package:provider/provider.dart';
import '../providers/user/provider.dart';
import '../resources/firestor_methods.dart';
import 'like_animaion.dart';

class CommentCard extends StatefulWidget {
  final snap;
  const CommentCard({Key? key, required this.snap}) : super(key: key);

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  // int likeLength = 0;
  //
  // @override
  // void initState() {
  //   super.initState();
  //   getLikes();
  // }
  //
  // void getLikes () async {
  //   try {
  //     DocumentSnapshot snapshot = await FirebaseFirestore.instance.
  //     collection('posts').
  //     doc(widget.snap['postId']).
  //     collection('comments').doc(widget.snap['commentId']).get();
  //      likeLength =  snapshot.get('likes').length;
  //
  //   }catch (e){
  //     print(e.toString());
  //     showSnackBar(e.toString(), context);
  //   }
  //   setState(() {
  //
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final model.User? user = Provider.of<UserProvider>(context).getUser;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundImage: NetworkImage(widget.snap['profilePic']),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                      text: TextSpan(children: [
                    TextSpan(
                        text: widget.snap['name'],
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    const TextSpan(
                        text: '  ',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(
                        text: widget.snap['text'],
                        style: const TextStyle(fontWeight: FontWeight.normal)),
                  ])),
                  Row(
                    children: [
                      Text(
                        DateFormat.yMMMd().format(widget.snap['datePublished'].toDate()),
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                      ),
                      IconButton(
                        onPressed: () async {
                          await FirestoreMethods().deleteComment(
                              widget.snap['postId'],
                              widget.snap['commentId']);
                        },
                        icon: const Icon(Icons.delete , color: Colors.redAccent, size: 20,),),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Column(
            children: [
              LikeAnimation(
                  isAnimating: widget.snap['likes'].contains(user?.uid),
                  smallLike: true,
                  child: IconButton(
                      onPressed: () async {
                        await FirestoreMethods().likeComment(
                            widget.snap['postId'],
                            widget.snap['commentId'],
                            user!.uid,
                            widget.snap['likes'],
                        );
                      },
                      icon: widget.snap['likes'].contains(user?.uid)? const Icon(
                        Icons.favorite,
                        color: Colors.red,
                      ): const Icon(Icons.favorite_border,)
                  )

              ),
              Text('${widget.snap['LikesNumber']} likes'),
            ],
          ),
        ],
      ),
    );
  }
}
