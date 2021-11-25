import 'form_item.dart';

class FormRow<T>{
  //List<FormItem> formItems;

  // List<FormItem> Function(T data) formItems;
  List<FormItem> Function() formItems;


  FormRow({required this.formItems});
}