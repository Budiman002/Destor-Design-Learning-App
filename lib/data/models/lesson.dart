import 'package:json_annotation/json_annotation.dart';
import 'practice.dart';

part 'lesson.g.dart';

@JsonSerializable()
class Lesson {
  final String id;
  final String title;
  final String description;
  final String contentType; // "video", "practice", "reading"
  final String? videoUrl;
  final String? content; // For reading type
  final List<Practice>? practiceItems;
  final int order;
  final int estimatedTime; // in minutes
  final bool isCompleted;

  const Lesson({
    required this.id,
    required this.title,
    required this.description,
    required this.contentType,
    this.videoUrl,
    this.content,
    this.practiceItems,
    required this.order,
    required this.estimatedTime,
    this.isCompleted = false,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) => _$LessonFromJson(json);
  Map<String, dynamic> toJson() => _$LessonToJson(this);

  Lesson copyWith({
    String? id,
    String? title,
    String? description,
    String? contentType,
    String? videoUrl,
    String? content,
    List<Practice>? practiceItems,
    int? order,
    int? estimatedTime,
    bool? isCompleted,
  }) {
    return Lesson(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      contentType: contentType ?? this.contentType,
      videoUrl: videoUrl ?? this.videoUrl,
      content: content ?? this.content,
      practiceItems: practiceItems ?? this.practiceItems,
      order: order ?? this.order,
      estimatedTime: estimatedTime ?? this.estimatedTime,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Lesson && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}