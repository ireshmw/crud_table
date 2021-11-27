# CRUD Table Flutter

CRUD Table Flutter is a package for crating CURD-UI for your entity/object/class easily.
It consists of a Lazy loading function, resizable columns, and integrated CRUD Form.

## Features
- Lazy loading Table
- Resizable columns
- Integrated CRUD Form
- Customizable UI

| <img src="https://user-images.githubusercontent.com/24836910/143689692-3a0cefb4-26f1-40d0-a647-cc47101a1e5a.gif" width="400"/><br /><sub><b>CRUD UI</b></sub> | <img src="https://user-images.githubusercontent.com/24836910/143689708-872d9c96-8207-4463-97c5-71b47cc7634d.gif" width="400"/><br /><sub><b>Lazy loading</b></sub> |
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
<img src="https://user-images.githubusercontent.com/24836910/143689744-4c5fa32c-2007-498f-861d-d7ebbd55fbf0.jpg" />

<img src="https://user-images.githubusercontent.com/24836910/143689737-57858024-9084-48b3-9d48-07befc3c964e.png" />

When you use `CrudTable` there you have to pass a `CurdViewSource` field, and it cannot be `null`. <br>
In `CurdViewSource` you can see there is a function field call `emptyEntityFactory` there you have to provide an empty Object 
which you are use with this CRUD UI. <br>
**Ex** :<br>
  &nbsp;Let's say you use` User.class` with this CrudTable, then the `emptyEntityFactory` will be<br>
```
emptyEntityFactory: () => User();
```
**Note :**<br>
_Give unique on every `FormItem` otherwise form data change will not work as we expect._ 


Check the [example](https://github.com/ireshmw/crud_table/tree/main/example) project.

## Additional information
Inspired by [Vaadin Crud UI Add-on](https://vaadin.com/directory/component/crud-ui-add-on)

## License
Licensed under the [Apache License, Version 2.0](LICENSE)
