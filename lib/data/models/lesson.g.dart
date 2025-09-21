// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lesson.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Lesson _$LessonFromJson(Map<String, dynamic> json) => Lesson(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      contentType: json['contentType'] as String,
      videoUrl: json['videoUrl'] as String?,
      content: json['content'] as String?,
      practiceItems: (json['practiceItems'] as List<dynamic>?)
          ?.map((e) => Practice.fromJson(e as Map<String, dynamic>))
          .toList(),
      order: (json['order'] as num).toInt(),
      estimatedTime: (json['estimatedTime'] as num).toInt(),
      isCompleted: json['isCompleted'] as bool? ?? false,
    );

Map<String, dynamic> _$LessonToJson(Lesson instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'contentType': instance.contentType,
      'videoUrl': instance.videoUrl,
      'content': instance.content,
      'practiceItems': instance.practiceItems,
      'order': instance.order,
      'estimatedTime': instance.estimatedTime,
      'isCompleted': instance.isCompleted,
    };
