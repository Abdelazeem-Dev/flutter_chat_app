import 'package:chat_app/cubit/login_cubit.dart';
import 'package:chat_app/screen/register_screen.dart';
import 'package:chat_app/widgets/custom_button.dart';
import 'package:chat_app/widgets/custom_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../helper/show_snack_bar.dart';
import '../models/text_model.dart';
import '../widgets/custom_textfield.dart';
import 'chat_screen.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  static String id = 'login_screen';
  String? email;
  String? password;
   GlobalKey<FormState> formKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if(state is  LoginLoading){
         }
        else if(state is LoginSuccess){
           Navigator.pushReplacementNamed(
            context,
            ChatScreen.id,
            arguments: email,
          );
        }
        else if(state is LoginFailure){
           showSnackBar(context, state.errorMessage);
        }
      },
    builder: (BuildContext context, LoginState state) =>
    ModalProgressHUD(
        inAsyncCall:  state is LoginLoading,
        child: Scaffold(
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
                    validator: (data) {
                      if (data!.isEmpty) {
                        return 'please enter your password';
                      } else if (data.length < 6) {
                        return 'password must be at least 6 characters';
                      } else {
                        return null;
                      }
                    },
                  ),

                  CustomButton(
                    text: 'Login',
                    onTap: () async {
                      if (formKey.currentState!.validate()) {
                        BlocProvider.of<LoginCubit>(context).loginUser(email: email!, password: password!);
                      
                      } else {
                        showSnackBar(context, 'please enter your data');
                      }
                    },
                  ),
                  Spacer(flex: 1),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomText(font: TextModel("Don't have an account?", 20)),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, RegisterScreen.id);
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
        ),
      ),
    );
  }

  Future<void> loginUser() async {
    final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email!,
      password: password!,
    );
  }
}
