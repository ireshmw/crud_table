import 'crud_action_listener.dart';
import 'form_section.dart';
import 'crud_table.dart';
import 'package:flutter/cupertino.dart';

class CrudViewSource<T> {
  List<String> columns;
  double rowHeight;
  int pageLimit;
  final T Function() emptyEntityFactory;
  List<Widget> Function(T data,int index) createRows;
  List<FormSection> Function(T data)? createForm;
  Future<List<T>> Function(Pagination pagination) onPageChange;
  CrudActionListener? crudActionListener;

  CrudViewSource({required this.columns, required this.rowHeight,required this.pageLimit,required this.emptyEntityFactory, required this.createRows, this.createForm,required this.onPageChange, this.crudActionListener});
  T getEmptyEntity() => emptyEntityFactory();


}
