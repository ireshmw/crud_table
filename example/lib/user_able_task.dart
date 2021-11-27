import 'package:json_annotation/json_annotation.dart';
part 'user_able_task.g.dart';

@JsonSerializable(explicitToJson: true)
class UserAbleTask {

  int? id;
  bool? active;
  String? description;
  String? taskCode;

  UserAbleTask({ this.id, this.active, this.description,this.taskCode});

 factory UserAbleTask.fromJson(Map<String, dynamic> json) => _$UserAbleTaskFromJson(json);
  Map<String, dynamic> toJson() => _$UserAbleTaskToJson(this);

  @override
  String toString() {
    return '$taskCode';
  }

}