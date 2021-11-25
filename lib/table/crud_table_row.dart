import 'package:flutter/cupertino.dart';

class CrudTableRow <T>extends StatelessWidget {
  T? data;
  Widget? child;
   CrudTableRow({required Key key,this.data,this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(child: child,
    );
  }
}
