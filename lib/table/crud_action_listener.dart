
class CrudActionListener<T> {
  Future<T?> Function(dynamic data)? add;
  Future<T?>? Function(dynamic data)? edit;
  Future<bool> Function(dynamic data)? delete;
  List<T> Function()? refresh;

  CrudActionListener({this.add, this.edit, this.delete, this.refresh});
}
