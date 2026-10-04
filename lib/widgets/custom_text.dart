import 'package:chat_app/models/text_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  const CustomText({super.key, required this.font});
final  TextModel font;
  @override
  Widget build(BuildContext context) {
    return  Text( font.text,style: TextStyle(
      color: font.color,
      fontSize:  font.size,
      fontWeight: FontWeight.bold,
      fontFamily: 'Pacifico'
    ),);
  }
}
