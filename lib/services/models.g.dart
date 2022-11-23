// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Task _$TaskFromJson(Map<String, dynamic> json) => Task(
      description: json['description'] as String? ?? '',
      done: json['done'] as bool? ?? false,
    );

Map<String, dynamic> _$TaskToJson(Task instance) => <String, dynamic>{
      'description': instance.description,
      'done': instance.done,
    };

TaskList _$TaskListFromJson(Map<String, dynamic> json) => TaskList(
      uid: json['uid'] as String? ?? '',
      tasks: (json['tasks'] as List<dynamic>?)
              ?.map((e) => Task.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$TaskListToJson(TaskList instance) => <String, dynamic>{
      'uid': instance.uid,
      'tasks': instance.tasks,
    };
