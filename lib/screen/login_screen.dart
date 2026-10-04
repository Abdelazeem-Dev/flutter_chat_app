import 'package:chat_app/screen/register_screen.dart';
import 'package:chat_app/widgets/custom_button.dart';
import 'package:chat_app/widgets/custom_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../helper/show_snack_bar.dart';
import '../models/text_model.dart';
import '../widgets/custom_textfield.dart';
import 'chat_screen.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  static String id = 'login_screen';
  String? email;
  String? password;
GlobalKey<FormState>formKey= GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff274460),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(flex: 8),
              Image.asset('assets/image/scholar.png'),
          
              CustomText(font: TextModel("Scholar chat", 35)),
              Spacer(flex: 4),
              Align(
                alignment: Alignment.centerLeft,
                child: CustomText(font: TextModel("Login", 25)),
              ),
              const SizedBox(height: 15),
              CustomTextfield(
                hintText: 'Email',
                onChanged: (data) {
                  email = data;
                },
                validator: (data) {
                  if (data!.isEmpty) {
                    return 'please enter your email';
                  }
                  return null;
                },
              ),
              CustomTextfield(
                obscureText: true,
                hintText: 'Password',
                onChanged: (data) {
                  password = data;
                },
                validator: (data){
                  if(data!.isEmpty  ){
                    return 'please enter your password';
                  }else if(data.length<6){
                    return 'password must be at least 6 characters';
                  }
                  else{
                    return null;
                  }
                },
              ),
          
              CustomButton(
                text: 'Login',
                onTap: () async {
                  if(formKey.currentState!.validate()){
                  try {
                    await  loginUser();
                    Navigator.pushReplacementNamed (context, ChatScreen.id,arguments: email);
                   }   on FirebaseAuthException catch (e) {
                    if (e.code == 'user-not-found') {
                      showSnackBar(context, 'No user found for that email.');
                    } else if (e.code == 'wrong-password') {
                      showSnackBar(context, 'Wrong password provided for that user.');
                     }}
                  catch (e) {
                    showSnackBar(context, e.toString());
                  }

                 }else{
                    showSnackBar(context, 'please enter your data');
                  }
                }
              ),
              Spacer(flex: 1),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(font: TextModel("Don't have an account?", 20)),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context,  RegisterScreen.id);
                    },
                    child: CustomText(
                      font: TextModel("Register", 20, color: Colors.blue),
                    ),
                  ),
                ],
              ),
              Spacer(flex: 6),
            ],
          ),
        ),
      ),
    );
  }



  Future<void> loginUser() async {
    final credential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(
          email: email!,
          password: password!,
        );
  }
}
