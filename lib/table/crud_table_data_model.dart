
class CrudTableDataModel<T> {
   bool? isError = false;
   bool? isLoading = false;
   List<T>? data;

   CrudTableDataModel({this.isError, this.isLoading, this.data});

   @override
  String toString() {
    return 'MyTableDataModel{isError: $isError, isLoading: $isLoading, data: $data}';
  }
}