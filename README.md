# CRUD Table Flutter

CRUD Table Flutter is a powerful Flutter package that simplifies the creation of CRUD UI for your entity, object or class. This package features a highly efficient lazy loading function, resizable columns, and an integrated CRUD form to provide a seamless user experience. With CRUD Table Flutter, you can easily manage and organize your data, boosting your productivity and efficiency.

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

When using CrudTable, a CrudViewSource field must be passed and cannot be null. In the CrudViewSource, you will find a function field called emptyEntityFactory. This function requires an empty object that will be used with the CRUD UI. <br>
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
