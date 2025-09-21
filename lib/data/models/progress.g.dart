// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'progress.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Progress _$ProgressFromJson(Map<String, dynamic> json) => Progress(
      userId: json['userId'] as String,
      courseId: json['courseId'] as String,
      completedLessons: (json['completedLessons'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      currentLessonIndex: (json['currentLessonIndex'] as num?)?.toInt() ?? 0,
      completionPercentage:
          (json['completionPercentage'] as num?)?.toDouble() ?? 0.0,
      lastAccessed: DateTime.parse(json['lastAccessed'] as String),
      isCompleted: json['isCompleted'] as bool? ?? false,
      pointsEarned: (json['pointsEarned'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$ProgressToJson(Progress instance) => <String, dynamic>{
      'userId': instance.userId,
      'courseId': instance.courseId,
      'completedLessons': instance.completedLessons,
      'currentLessonIndex': instance.currentLessonIndex,
      'completionPercentage': instance.completionPercentage,
      'lastAccessed': instance.lastAccessed.toIso8601String(),
      'isCompleted': instance.isCompleted,
      'pointsEarned': instance.pointsEarned,
    };
