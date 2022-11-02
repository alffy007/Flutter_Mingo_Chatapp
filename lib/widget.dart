import 'package:flutter/material.dart';

InputDecoration textFieldInputDecoration(String hintText) {
  return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: Colors.white54),
      focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white)),
      enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white)));
}

TextStyle simpleTextStyle() {
  return const TextStyle(
      color: Color.fromARGB(255, 249, 249, 249), fontSize: 16);
}

TextStyle biggerTextStyle() {
  return const TextStyle(color: Colors.white, fontSize: 17);
}

class GlowingActionButton extends StatelessWidget {
  const GlowingActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Color(0xff007EF4), Color.fromARGB(255, 159, 21, 186)]),
          borderRadius: BorderRadius.circular(190)),
      padding: EdgeInsets.all(12),
      child: Icon(
        Icons.send,
        color: Colors.white,
      ),
    );
  }
}

