import 'package:flutter/material.dart';

class textFieldInput extends StatelessWidget {
  final TextEditingController textEditingController;
  final bool isPass;
  final String hintText;
  final TextInputType textInputType;

  const textFieldInput({Key? key,
    required this.textEditingController,
    this.isPass = false,
    required this.hintText,
    required this.textInputType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(
        borderSide: Divider.createBorderSide(context)
    );

    return TextFormField(
    controller: textEditingController,
    decoration: InputDecoration(
    hintText: hintText,
    border: inputBorder,
    focusedBorder: inputBorder,
    enabledBorder: inputBorder,
    filled: true,
    ),
    keyboardType:textInputType ,
    obscureText: isPass,
    );
  }
}
