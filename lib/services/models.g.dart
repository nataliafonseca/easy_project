// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaskList _$TaskListFromJson(Map<String, dynamic> json) => TaskList(
      uid: json['uid'] as String? ?? '',
      tasks: (json['tasks'] as List<dynamic>?)
              ?.map((e) => e as Map<String, dynamic>)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$TaskListToJson(TaskList instance) => <String, dynamic>{
      'uid': instance.uid,
      'tasks': instance.tasks,
    };
