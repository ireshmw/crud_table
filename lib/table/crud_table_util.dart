import 'package:flutter/widgets.dart';

///Util class of CURD Table
class CrudTableUtil {
  /// return a Key base on the value you provides
  static Key? formFieldKey(var value) {
    return value != null ? Key(value.toString()) : null;
  }

  /// return a String value of on the value you provides
  static String? formFieldInitValue(var value) {
    return value?.toString();
  }
}
