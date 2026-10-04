import 'package:chat_app/models/text_model.dart';
import 'package:flutter/material.dart';

import 'custom_text.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({super.key, this.onTap, required this.text});
final void Function()? onTap;
final String text;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:  onTap,
      child: Container(
        width: double.infinity,
        height: 50,
      decoration:  BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20)
       ),
        child:Center(child: CustomText(  font:TextModel(text,20,color: Colors.black),))
      ),
    );
  }
}
