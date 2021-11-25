import 'form_row.dart';

class FormSection<T>{
  String? sectionTitle;
  //List<FormRow> formRows;

  // List<FormRow> Function(T data)? formRows;
  List<FormRow> Function()? formRows;


  FormSection({this.sectionTitle, required this.formRows});
}