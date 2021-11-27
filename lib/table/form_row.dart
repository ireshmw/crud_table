import 'form_item.dart';
/// single row of the form
class FormRow<T>{
  /// widgets which need to display in the row
  List<FormItem> Function() formItems;
  FormRow({required this.formItems});
}