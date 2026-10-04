import 'package:chat_app/widgets/custom_button.dart';
import 'package:chat_app/widgets/custom_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../helper/show_snack_bar.dart';
import '../models/text_model.dart';
import '../widgets/custom_textfield.dart';
import 'chat_screen.dart';
class RegisterScreen extends StatelessWidget {
    RegisterScreen({super.key});
String ?email,password;
GlobalKey<FormState>formKey= GlobalKey();
static String id='register_screen';
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
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
                child: CustomText(font: TextModel("Register", 25 )),
              ),
              const SizedBox(height: 20,),

              CustomTextfield(hintText: 'Email',onChanged: (data){
                email=data;
              },),
              CustomTextfield(hintText: 'Password',onChanged: (data){
                password=data;
              }
              , obscureText: true,),

              CustomButton(text: 'Register',
                  onTap: () async {
                    if(formKey.currentState!.validate()){
                      try {
                        await registerUser();
                        Navigator.pushReplacementNamed(context, ChatScreen.id,arguments: email);
                      }   on FirebaseAuthException catch (e) {
                        if (e.code == 'weak-password') {
                          showSnackBar(context, 'The password provided is too weak.');
                        } else if (e.code == 'email-already-in-use') {
                          showSnackBar(context, 'The account already exists for that email.');
                        }}
                      catch (e) {
                        showSnackBar(context, e.toString());
                      }

                    }else{
                      showSnackBar(context, 'please enter your data');
                    }
                  }),


              Spacer(flex: 6),
            ],
          ),
        ),
      ),
    );
  }
  Future<void> registerUser() async {
    final credential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: email!,
      password: password!,
    );
  }
}
