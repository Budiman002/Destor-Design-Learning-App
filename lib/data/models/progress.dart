import 'package:json_annotation/json_annotation.dart';

part 'progress.g.dart';

@JsonSerializable()
class Progress {
  final String userId;
  final String courseId;
  final List<String> completedLessons;
  final int currentLessonIndex;
  final double completionPercentage;
  final DateTime lastAccessed;
  final bool isCompleted;
  final int pointsEarned;

  const Progress({
    required this.userId,
    required this.courseId,
    this.completedLessons = const [],
    this.currentLessonIndex = 0,
    this.completionPercentage = 0.0,
    required this.lastAccessed,
    this.isCompleted = false,
    this.pointsEarned = 0,
  });

  factory Progress.fromJson(Map<String, dynamic> json) => _$ProgressFromJson(json);
  Map<String, dynamic> toJson() => _$ProgressToJson(this);

  Progress copyWith({
    String? userId,
    String? courseId,
    List<String>? completedLessons,
    int? currentLessonIndex,
    double? completionPercentage,
    DateTime? lastAccessed,
    bool? isCompleted,
    int? pointsEarned,
  }) {
    return Progress(
      userId: userId ?? this.userId,
      courseId: courseId ?? this.courseId,
      completedLessons: completedLessons ?? this.completedLessons,
      currentLessonIndex: currentLessonIndex ?? this.currentLessonIndex,
      completionPercentage: completionPercentage ?? this.completionPercentage,
      lastAccessed: lastAccessed ?? this.lastAccessed,
      isCompleted: isCompleted ?? this.isCompleted,
      pointsEarned: pointsEarned ?? this.pointsEarned,
    );
  }

  Progress completeLesson(String lessonId, int totalLessons) {
    final newCompletedLessons = [...completedLessons];
    if (!newCompletedLessons.contains(lessonId)) {
      newCompletedLessons.add(lessonId);
    }

    final newCompletionPercentage = (newCompletedLessons.length / totalLessons) * 100;
    final newIsCompleted = newCompletionPercentage >= 100;

    return copyWith(
      completedLessons: newCompletedLessons,
      completionPercentage: newCompletionPercentage,
      lastAccessed: DateTime.now(),
      isCompleted: newIsCompleted,
      pointsEarned: pointsEarned + 10, // 10 points per lesson
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Progress &&
              runtimeType == other.runtimeType &&
              userId == other.userId &&
              courseId == other.courseId;

  @override
  int get hashCode => userId.hashCode ^ courseId.hashCode;
}