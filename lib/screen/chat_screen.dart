import 'dart:math';

import 'package:chat_app/widgets/chat_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';

import '../models/text_model.dart';
import '../widgets/custom_text.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});
static String id='chat_screen';
  @override
  Widget build(BuildContext context) {
    String email=ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(

      appBar: AppBar(
          backgroundColor: Color(0xff274460),
          title:
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('assets/image/scholar.png',
                  width: 50, height: 50,),
                CustomText(font: TextModel("Scholar chat", 20)),
              ],
            ),
          )
      ),
body: ChatUi(email: email,),
    );
  }}
