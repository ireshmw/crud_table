import 'form_item.dart';

class FormRow<T>{
  List<FormItem> Function() formItems;
  FormRow({required this.formItems});
}