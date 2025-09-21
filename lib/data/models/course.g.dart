// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Course _$CourseFromJson(Map<String, dynamic> json) => Course(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String,
      category: json['category'] as String,
      lessons: (json['lessons'] as List<dynamic>)
          .map((e) => Lesson.fromJson(e as Map<String, dynamic>))
          .toList(),
      mentorId: json['mentorId'] as String,
      mentorName: json['mentorName'] as String,
      duration: (json['duration'] as num).toInt(),
      level: json['level'] as String,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      enrolledStudents: (json['enrolledStudents'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$CourseToJson(Course instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'imageUrl': instance.imageUrl,
      'category': instance.category,
      'lessons': instance.lessons,
      'mentorId': instance.mentorId,
      'mentorName': instance.mentorName,
      'duration': instance.duration,
      'level': instance.level,
      'rating': instance.rating,
      'enrolledStudents': instance.enrolledStudents,
    };
