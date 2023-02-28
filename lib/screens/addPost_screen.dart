import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagramclone/providers/user/provider.dart';
import 'package:instagramclone/resources/firestor_methods.dart';
import 'package:instagramclone/utils/colors.dart';
import 'package:instagramclone/utils/global_variables.dart';
import 'package:instagramclone/utils/utils.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';

class addPostScreen extends StatefulWidget {
  const addPostScreen({Key? key}) : super(key: key);

  @override
  State<addPostScreen> createState() => _addPostScreenState();
}

class _addPostScreenState extends State<addPostScreen> {
  Uint8List? _file;
  final TextEditingController _descriptionController = TextEditingController();
  bool _isLoading = false;

  _selectImage(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text('Create a post'),
            children:<Widget> [
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Take a photo'),
                onPressed: () async {
                  Navigator.pop(context);
                  Uint8List file = await pickImage(
                    ImageSource.camera,
                  );
                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Choose from gallery'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(
                    ImageSource.gallery,
                  );
                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  void postImage(
    String uid,
    String username,
    String profImage,

  ) async {
    setState(() {
      _isLoading = true;
    });
    try {
      String res = await FirestoreMethods().uploadPost(
          _descriptionController.text, _file!, uid, username, profImage );

      if (res == 'success') {
        setState(() {
          _isLoading = false;
          _file = null ;
        });
        showSnackBar('Post is published', context);

      } else {
        showSnackBar(res, context);
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      showSnackBar(e.toString(), context);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider user = Provider.of<UserProvider>(context);
    final width = MediaQuery.of(context).size.width ;
    return user == null? const Center(child: CircularProgressIndicator(color: Colors.white,),)
        :_file == null
        ? Center(
            child: IconButton(
              icon: const Icon(
                Icons.upload,
              ),
              onPressed: () => _selectImage(context),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              leading: IconButton(
                onPressed: (){setState(() {
                  _file = null;
                });},
                icon: const Icon(Icons.arrow_back),
              ),
              title: const Text('Post to'),
              actions: <Widget>[
                TextButton(
                    onPressed: () =>
                        postImage(
                        user.getUser!.uid,
                        user.getUser!.username,
                        user.getUser!.photoUrl
                        ),
                        // postImage(
                        //     user.getUser!.uid,
                        //     user.getUser!.username,
                        //     user.getUser!.photoUrl),
                    child: const Text(
                      'Post',
                      style: TextStyle(
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ))
              ],
            ),
            body: Column(
              children: <Widget>[
                _isLoading
                    ? const LinearProgressIndicator()
                    : const Padding(padding: EdgeInsets.only(top: 0.0)),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    CircleAvatar(
                      backgroundImage: NetworkImage(user.getUser!.photoUrl),
                      radius: width > webScreenSize ? 80 : 20,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: TextFormField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                          hintText: 'Write a caption...',
                          border: InputBorder.none,
                        ),
                        maxLines: 8,
                      ),
                    ),
                    SizedBox(
                      height: width > webScreenSize ? 170 : 45,
                      width: width > webScreenSize ? 170 : 45,
                      child: AspectRatio(
                        aspectRatio: 487 / 451,
                        child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                            image: MemoryImage(_file!),
                            fit: BoxFit.fill,
                            alignment: FractionalOffset.topCenter,
                          )),
                        ),
                      ),
                    ),
                    const Divider(),
                  ],
                )
              ],
            ),
          );
  }
}
