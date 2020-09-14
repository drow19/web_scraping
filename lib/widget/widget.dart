import 'package:flutter/material.dart';

Widget loadingView() {
  return Center(
    child: CircularProgressIndicator(),
  );
}

TextStyle standardFont(){
  return TextStyle(
      fontSize: 14, color: Colors.white, fontWeight: FontWeight.w500);
}

TextStyle titleText(double size) {
  return TextStyle(
      color: Colors.white, fontWeight: FontWeight.w600, fontSize: size);
}

TextStyle italicStyle() {
  return TextStyle(
      fontSize: 14, color: Colors.white, fontStyle: FontStyle.italic);
}
