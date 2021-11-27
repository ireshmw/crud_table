import 'form_row.dart';

class FormSection<T>{
  String? sectionTitle;
  List<FormRow> Function()? formRows;


  FormSection({this.sectionTitle, required this.formRows});
}