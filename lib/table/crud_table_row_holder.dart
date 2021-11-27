import 'crud_action_listener.dart';
import 'form_section.dart';
import 'crud_table.dart';
import 'package:flutter/cupertino.dart';

class CrudViewSource<T> {
  /// columns of the table, provide name of the column as a string array
  List<String> columns;

  /// row height of the table
  double rowHeight;

  /// page limit when lazy loading
  int pageLimit;

  /// provide an empty Object which you are use with this CRUD UI, which we get back when click on the submit button of the form
  final T Function() emptyEntityFactory;

  /// function which will crate rows of the table (check example for more details)
  List<Widget> Function(T data, int index) createRows;

  /// when click a row of table, form will create according, here you have to provide the form fields crate function (check example for more details)
  List<FormSection> Function(T data)? createForm;

  /// when scrolling the table you will notify with the result of pagination object
  Future<List<T>> Function(Pagination pagination) onPageChange;

  ///form crud actions listener (add, delete, update)
  CrudActionListener? crudActionListener;

  CrudViewSource(
      {required this.columns,
      required this.rowHeight,
      required this.pageLimit,
      required this.emptyEntityFactory,
      required this.createRows,
      this.createForm,
      required this.onPageChange,
      this.crudActionListener});
  T getEmptyEntity() => emptyEntityFactory();
}
