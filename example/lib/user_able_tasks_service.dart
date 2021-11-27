import 'dart:convert';

import 'package:crud_table_example/user_able_task.dart';

class UserAbleTasksService {
  static UserAbleTasksService? _userAbleTasksService;
  List<UserAbleTask>? taskData = [];

  UserAbleTasksService._() {
    generateTestData();
  }

  void generateTestData() {
    for (int i = 1; i < 100; i++) {
      taskData!.add(UserAbleTask(
          id: i, taskCode: "$i - Task", description: "$i - Description",active: true));
    }
  }

  static UserAbleTasksService? get instance {
    if (_userAbleTasksService == null) {
      _userAbleTasksService = UserAbleTasksService._();
    }
    return _userAbleTasksService;
  }

  Future<List<UserAbleTask>> getTasks(int offSet, int limit) async {
    return  Future.value(taskData);
  }

  Future<UserAbleTask> addTask(UserAbleTask ableTask) async {
    taskData!.add(ableTask);
    return Future.value(ableTask);
  }

  Future<UserAbleTask> updateTask(UserAbleTask ableTask, int taskId) async {
    //Todo add your own Update logic
    return Future.value(ableTask);
  }

  Future<bool> deleteTask(int taskId) async {
    //Todo : add your own delete logic
    return Future.value(true);
  }
}
