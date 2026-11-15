import 'package:chat_app/cubit/cubit/register_cubit.dart';
import 'package:chat_app/screen/chat_page.dart';
import 'package:chat_app/widgets/custom_button.dart';
import 'package:chat_app/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../helper/show_snack_bar.dart';
import '../models/text_model.dart';
import '../widgets/custom_textfield.dart';

class RegisterScreen extends StatelessWidget {
    RegisterScreen({super.key});
String ?email,password;
GlobalKey<FormState>formKey= GlobalKey();
static String id='register_screen';
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Color(0xff274460),
      body:  BlocConsumer<RegisterCubit, RegisterState>(
        listener: (context, state) {
          if(state is RegisterLoading){
          }
          else if(state is RegisterSuccess){
            Navigator.pushReplacementNamed(
              context,
               ChatPage.id,
              arguments: email,
            );
          }
          else if(state is RegisterFailure){
            showSnackBar(context, state.errorMessage);
          }
        },
        builder: (context, state) {
          return ModalProgressHUD(
              inAsyncCall:  state is RegisterLoading,
              child: Padding(
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
                              BlocProvider.of<RegisterCubit>(context).registerUser(email: email!, password: password!);
              
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
        },
      ),
    );
  }
   
}
