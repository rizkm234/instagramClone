import 'package:flutter/cupertino.dart';
import 'package:instagramclone/providers/user/provider.dart';
import 'package:instagramclone/responsive/dimensions.dart';
import 'package:provider/provider.dart';

class responsiveLayout extends StatefulWidget {
  final Widget webScreenLayout;
  final Widget mobileScreenLayout;
  const responsiveLayout({Key? key,
    required this.webScreenLayout,
    required this.mobileScreenLayout}) : super(key: key);

  @override
  State<responsiveLayout> createState() => _responsiveLayoutState();
}

class _responsiveLayoutState extends State<responsiveLayout> {
  @override

  void initState() {
    super.initState();
    addData();
  }

  addData () async {
    UserProvider _userProvider = Provider.of(context , listen: false);
    await _userProvider.refreshUser();
  }
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context , constrains){
          if (constrains.maxWidth > webScreenSize){
            //web screen
            return widget.webScreenLayout;
          }
          //mobile screen
          return widget.mobileScreenLayout;
        });
  }
}
