


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagramclone/resources/auth_method.dart';
import 'package:instagramclone/responsive/dimensions.dart';
import 'package:instagramclone/screens/home_screen.dart';
import 'package:instagramclone/screens/signup_screen.dart';
import 'package:instagramclone/utils/utils.dart';
import 'package:instagramclone/widgets/text_field.dart';

import '../responsive/mobile_screen_layout.dart';
import '../responsive/responsive_layout_screen.dart';
import '../responsive/web_screen_layout.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  bool _isLoading = false;


  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passController.dispose();
  }


  void loginUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().loginUser(
        email: _emailController.text, password: _passController.text);
    print (res);

    if (res == 'success') {
      showSnackBar(res, context);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => const responsiveLayout(
                mobileScreenLayout: MobileScreenLayout(),
                webScreenLayout: WebScreenLayout(),
              )));

    } else {
      showSnackBar(res, context);
    }
    setState(() {
      _isLoading = false;
    });
  }

  void NavigateToSignUp(){
    Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) => const SignupScreen()));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: MediaQuery.of(context).size.width > webScreenSize?
           EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/5)
              : const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                flex: 2,
                child: Container(),
              ),
              SvgPicture.asset(
                'assets/images/ic_instagram.svg',
                color: Colors.white,
                height: 64,
              ),
              const SizedBox(
                height: 64,
              ),
              textFieldInput(
                  textEditingController: _emailController,
                  hintText: 'Please enter your e-mail',
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
                onTap: loginUser,
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
                          'Login',
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
              Flexible(
                flex: 2,
                child: Container(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: const Text('You do not have an account?'),
                  ),
                  GestureDetector(
                    onTap: NavigateToSignUp,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: const Text(
                        ' Sign up',
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
    );
  }
}
