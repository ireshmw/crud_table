import 'package:flutter/cupertino.dart';

/// FormItem Class user for provide form field widgets for CRUD Table
class FormItem {
  /// define the how much width ratio the form field is compare to sibling form fields
  int ratio;

  /// form field widget (ex: TextFormField,Checkbox, etc)
  Widget item;

  FormItem({required this.ratio, required this.item});
}
