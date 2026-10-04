import 'package:chat_app/screen/chat_screen.dart';
import 'package:chat_app/screen/login_screen.dart';
import 'package:chat_app/screen/register_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ChatApp());
}
class ChatApp extends StatelessWidget {
  const ChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
          LoginScreen.id:(context)=> LoginScreen(),
          RegisterScreen.id:(context)=>RegisterScreen(),
          ChatScreen.id:(context)=>ChatScreen(),
      },
       initialRoute: LoginScreen.id,
    );
  }
}
