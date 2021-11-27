import 'package:flutter/widgets.dart';

class CrudTableUtil{

  static Key? formFieldKey(var value){
    return value!=null ? Key(value.toString()) :null;
  }

  static String? formFieldInitValue(var value){
    return value?.toString();
  }
}