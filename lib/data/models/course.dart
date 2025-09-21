import 'package:json_annotation/json_annotation.dart';
import 'lesson.dart';

part 'course.g.dart';

@JsonSerializable()
class Course {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String category;
  final List<Lesson> lessons;
  final String mentorId;
  final String mentorName;
  final int duration;
  final String level;
  final double rating;
  final int enrolledStudents;

  const Course({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.category,
    required this.lessons,
    required this.mentorId,
    required this.mentorName,
    required this.duration,
    required this.level,
    this.rating = 0.0,
    this.enrolledStudents = 0,
  });

  factory Course.fromJson(Map<String, dynamic> json) => _$CourseFromJson(json);
  Map<String, dynamic> toJson() => _$CourseToJson(this);

  Course copyWith({
    String? id,
    String? title,
    String? description,
    String? imageUrl,
    String? category,
    List<Lesson>? lessons,
    String? mentorId,
    String? mentorName,
    int? duration,
    String? level,
    double? rating,
    int? enrolledStudents,
  }) {
    return Course(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      lessons: lessons ?? this.lessons,
      mentorId: mentorId ?? this.mentorId,
      mentorName: mentorName ?? this.mentorName,
      duration: duration ?? this.duration,
      level: level ?? this.level,
      rating: rating ?? this.rating,
      enrolledStudents: enrolledStudents ?? this.enrolledStudents,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Course && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}