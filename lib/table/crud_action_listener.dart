/// CRUD Table from action listener
class CrudActionListener<T> {
  /// notify when click add new item button
  Future<T?> Function(dynamic data)? add;

  /// notify when click edit button
  Future<T?>? Function(dynamic data)? edit;

  /// notify when click delete button
  Future<bool> Function(dynamic data)? delete;

  /// notify when click refresh button
  List<T> Function()? refresh;

  CrudActionListener({this.add, this.edit, this.delete, this.refresh});
}
