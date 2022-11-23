import 'package:json_annotation/json_annotation.dart';
part 'models.g.dart';

@JsonSerializable()
class TaskList {
  String uid;
  List<Map<String, dynamic>> tasks;
  TaskList({this.uid = '', this.tasks = const []});

  factory TaskList.fromJson(Map<String, dynamic> json) =>
      _$TaskListFromJson(json);
  Map<String, dynamic> toJson() => _$TaskListToJson(this);
}
