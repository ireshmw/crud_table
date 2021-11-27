import 'package:crud_table/crud_table.dart';
import 'package:crud_table/table/crud_table.dart';
import 'package:crud_table/table/crud_table_row_holder.dart';
import 'package:crud_table/table/form_item.dart';
import 'package:crud_table/table/form_row.dart';
import 'package:crud_table/table/form_section.dart';
import 'package:crud_table_example/user_task.dart';
import 'package:crud_table_example/user_tasks_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: CrudTable<UserTask>(
              crudViewSource: createCrudSource(),
              onTap: (t) {
                t as UserTask;
              },
            ),
          ),

        ],
      ),
    );
  }

  CrudViewSource createCrudSource() {
    return CrudViewSource(
      columns: ["id", "code", "description", "active"],
      pageLimit: 20,
      rowHeight: 30,
      emptyEntityFactory: () => UserTask(),
      createRows: (d, index) {
        d as UserTask;
        List<Widget> rows = [];
        rows.add(Text(d.id.toString(), style: const TextStyle(fontSize: 16)));
        rows.add(Text(d.taskCode.toString(), style: const TextStyle(fontSize: 16)));
        rows.add(Text(d.description.toString(), style: const TextStyle(fontSize: 16)));
        rows.add(Text(d.active.toString(), style: const TextStyle(fontSize: 16)));
        return rows;
      },
      createForm: (d) {
        d as UserTask;

        List<FormSection> fields = [];

        FormSection section1 = FormSection(
            sectionTitle: "System Tasks",
            formRows: () {
              List<FormRow> r = [];
              FormRow r1 = FormRow(formItems: () {
                List<FormItem> items = [];
                items.add(FormItem(
                  ratio: 1,
                  item: TextFormField(
                    key: CrudTableUtil.formFieldKey(d.id),
                    initialValue: CrudTableUtil.formFieldInitValue(d.id),
                    decoration: const InputDecoration(labelText: 'Id', border: OutlineInputBorder(),),
                    enabled: false,
                  ),
                ));
                items.add(FormItem(
                  ratio: 1,
                  item: TextFormField(
                    key: CrudTableUtil.formFieldKey(d.taskCode),
                    initialValue: CrudTableUtil.formFieldInitValue(d.taskCode),
                    onSaved: (v) {
                      d.taskCode = v;
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter The Task Code!';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(labelText: 'Code', border: OutlineInputBorder(),),
                  ),
                ));
                return items;
              });
              r.add(r1);
              return r;
            });

        FormSection section2 = FormSection(
            sectionTitle: "System Tasks Section 02",
            formRows: () {
              List<FormRow> r = [];
              FormRow r1 = FormRow(formItems: () {
                List<FormItem> items = [];

                items.add(FormItem(
                  ratio: 1,
                  item: TextFormField(
                    // key:  d.description != null ? Key(d.description.toString()) : null,
                    // initialValue: d.description != null ? d.description : null,
                    key: CrudTableUtil.formFieldKey(d.description),
                    initialValue:
                    CrudTableUtil.formFieldInitValue(d.description),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter a Description!';
                      }
                      return null;
                    },
                    onSaved: (v) {
                      d.description = v;
                    },
                    decoration: const InputDecoration(labelText: 'Description', border: OutlineInputBorder(),),
                  ),
                ));

                return items;
              });
              FormRow r2 = FormRow(formItems: () {
                return [
                  (FormItem(
                    ratio: 1,
                    item: CheckboxListTile(
                      title: const Text("Active"),
                      controlAffinity: ListTileControlAffinity.leading,
                      value: d.active ?? false,
                      onChanged: (bool? value) {
                        setState(() {
                          d.active = value!;
                        });
                      },
                    ),
                  ))
                ];
              });

              r.add(r1);
              r.add(r2);
              return r;
            });

        fields.add(section1);
        fields.add(section2);
        return fields;
      },
      crudActionListener: CrudActionListener<UserTask>(
        add: (data) async {
          UserTasksService userS =  UserTasksService.instance!;
          return userS.addTask(data);
        },
        edit: (data) async {
          data as UserTask;
          UserTasksService userS =  UserTasksService.instance!;
          return userS.updateTask(data, data.id!.toInt());
          return null;
        },
        delete: (data) async {
          data as UserTask;
          UserTasksService userS =  UserTasksService.instance!;
          return userS.deleteTask(data.id!.toInt());
        },
      ),
      onPageChange: (pagination) async {
        // UserAbleTasksService userS =
        //     await context.read(userAbleTasksServiceProvider);
        UserTasksService userS =  UserTasksService.instance!;
        return userS.getTasks(pagination.pageNumber, pagination.limit);
      },
    );
  }
}
