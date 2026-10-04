import 'package:flutter/material.dart';

class CustomTextfield extends StatelessWidget {

    CustomTextfield({super.key, required this.hintText, this.onChanged, this.validator,   this.obscureText =false});
final String hintText;
 final void Function(String)? onChanged;
 final String? Function(String?)? validator;
  bool obscureText ;
  @override
  Widget build(BuildContext context) {
    return   Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextFormField(
        obscureText:  obscureText,
        validator: validator,
        onChanged:onChanged ,
        decoration: InputDecoration(

            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
             ),
            hintText:  hintText,
            hintStyle: TextStyle(
                color: Colors.grey
            )
        ),
      ),
    );
  }
}
