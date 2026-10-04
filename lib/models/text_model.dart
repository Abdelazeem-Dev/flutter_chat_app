import 'dart:ui';

import 'package:flutter/material.dart';

class TextModel {
  String text;
  double size;
  Color color ;
  String? fontFamily;
  TextModel(this.text,this.size,{this.color=Colors.white,this.fontFamily='Pacifico'});

}