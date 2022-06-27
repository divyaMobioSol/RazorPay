import 'package:flutter/material.dart';

class TextFormFieldWidget extends StatelessWidget {
  TextInputType textInputType;
  TextEditingController controller;
  String text;
  String hintText;

  TextFormFieldWidget(
      {required this.textInputType,
      required this.controller,
      required this.hintText,
      required this.text});

  //const TextFormFieldWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: textInputType,
      decoration: InputDecoration(
        hintText: hintText,
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey, width: 0.0),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue, width: 0.0),
        ),
      ),
      controller: controller,
      onSaved: (value) => controller.text = value ?? '',
      validator: (value) {
        if (value!.isEmpty) {
          return text;
        }
        return null;
      },
    );
  }
}
