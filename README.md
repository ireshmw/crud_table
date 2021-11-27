# CRUD Table Flutter

CRUD Table Flutter is a package for crating CURD-UI for your entity/object/class easily.
It consists of a Lazy loading function, resizable columns, and integrated CRUD Form.

## Features
- Lazy loading Table
- Resizable columns
- Intergrated CRUD Form
- Customizeble UI

| <img src="https://github.com/ireshmw/crud_table/blob/main/img/crud_table_anim_1.gif" width="400"/><br /><sub><b>CRUD UI</b></sub> | <img src="https://github.com/ireshmw/crud_table/blob/main/img/crud_table_anim_lazy_load.gif" width="400"/><br /><sub><b>Lazy loading</b></sub> |
| :---: | :---: |

## Getting started

The package uses Riverpod for state management. So Please ensure you import flutter_riverpod and wrap the app with ProviderScope.

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
```
See the [example](https://github.com/ireshmw/crud_table/tree/main/example) project.

## Installing:
In your pubspec.yaml
```yaml
dependencies:
  crud_table: 
```
```dart
import 'package:crud_table/crud_table.dart';
```

## Usage
<img src="https://github.com/ireshmw/crud_table/blob/main/img/crud_table_ui_explain.jpg" />

<img src="https://github.com/ireshmw/crud_table/blob/main/img/crud_table_uml.png" />

When you user CrudTable there you have to pass a CurdViewSource field and it is cannot be null, 

---
**NOTE**

It works with almost all markdown flavours (the below blank line matters).

---

## Additional information

TODO: Tell users more about the package: where to find more information, how to 
contribute to the package, how to file issues, what response they can expect 
from the package authors, and more.
