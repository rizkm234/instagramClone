import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagramclone/resources/auth_method.dart';
import 'package:instagramclone/screens/login_screen.dart';
import 'package:instagramclone/utils/utils.dart';

import '../responsive/mobile_screen_layout.dart';
import '../responsive/responsive_layout_screen.dart';
import '../responsive/web_screen_layout.dart';
import '../widgets/text_field.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passController.dispose();
    _bioController.dispose();
    _usernameController.dispose();
  }

  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  void signUpUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().signUpUser(
      email: _emailController.text,
      password: _passController.text,
      username: _usernameController.text,
      bio: _bioController.text,
      file: _image!,
    );
    setState(() {
      _isLoading = false;
    });
    print(res);
    if (res != 'success') {
      showSnackBar(res, context);
    } else {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => const responsiveLayout(
                    mobileScreenLayout: MobileScreenLayout(),
                    webScreenLayout: WebScreenLayout(),
                  )));
    }
  }

  void NavigateToLogin() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Flexible(
                //   flex: 1,
                //   child: Container(),
                // ),
                const SizedBox(
                  height: 50,
                ),
                SvgPicture.asset(
                  'assets/images/ic_instagram.svg',
                  color: Colors.white,
                  height: 64,
                ),
                const SizedBox(
                  height: 30,
                ),
                Stack(
                  children: [
                    _image != null
                        ? CircleAvatar(
                            radius: 60, backgroundImage: MemoryImage(_image!))
                        : const CircleAvatar(
                            radius: 60,
                            backgroundImage: NetworkImage(
                                'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_640.png'),
                          ),
                    Positioned(
                        bottom: -10,
                        left: 80,
                        child: IconButton(
                            onPressed: selectImage,
                            icon: const Icon(
                              Icons.add_a_photo,
                              color: Colors.white,
                            )))
                  ],
                ),
                const SizedBox(
                  height: 24,
                ),
                textFieldInput(
                    textEditingController: _usernameController,
                    hintText: 'Please enter your user name',
                    textInputType: TextInputType.emailAddress),
                const SizedBox(
                  height: 24,
                ),
                textFieldInput(
                    textEditingController: _bioController,
                    hintText: 'Please enter your bio',
                    textInputType: TextInputType.text),
                const SizedBox(
                  height: 24,
                ),
                textFieldInput(
                    textEditingController: _emailController,
                    hintText: 'Please enter your e-mail address',
                    textInputType: TextInputType.emailAddress),
                const SizedBox(
                  height: 24,
                ),
                textFieldInput(
                    textEditingController: _passController,
                    hintText: 'Please enter your password',
                    isPass: true,
                    textInputType: TextInputType.text),
                const SizedBox(
                  height: 24,
                ),
                InkWell(
                  onTap: signUpUser,
                  child: Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: const ShapeDecoration(
                        color: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        )),
                    child: _isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Sign-Up',
                            style: TextStyle(
                                fontSize: 30,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                // Flexible(
                //   flex: 1,
                //   child: Container(),
                // ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: const Text('You have an account?'),
                    ),
                    GestureDetector(
                      onTap: NavigateToLogin,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: const Text(
                          ' Sign in',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
