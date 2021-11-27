import 'form_row.dart';

/// Section of the form
/// you can have multiple form sections
class FormSection<T>{
  /// Title of the section
  String? sectionTitle;
  /// Rows of the section, (rows consist of widgets)
  List<FormRow> Function()? formRows;


  FormSection({this.sectionTitle, required this.formRows});
}