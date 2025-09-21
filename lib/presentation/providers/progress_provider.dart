import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/models/progress.dart';
import '../../data/models/course.dart';
import 'dart:convert';

class ProgressProvider extends ChangeNotifier {
  Map<String, Progress> _userProgress = {};
  bool _isLoading = false;

  Map<String, Progress> get userProgress => _userProgress;
  bool get isLoading => _isLoading;

  ProgressProvider() {
    _loadProgressFromStorage();
  }

  Future<void> _loadProgressFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final progressJson = prefs.getString('user_progress');
      if (progressJson != null) {
        final progressMap = json.decode(progressJson) as Map<String, dynamic>;
        _userProgress = progressMap.map(
              (key, value) => MapEntry(
            key,
            Progress.fromJson(value as Map<String, dynamic>),
          ),
        );
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading progress from storage: $e');
    }
  }

  Future<void> _saveProgressToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final progressMap = _userProgress.map(
            (key, value) => MapEntry(key, value.toJson()),
      );
      final progressJson = json.encode(progressMap);
      await prefs.setString('user_progress', progressJson);
    } catch (e) {
      debugPrint('Error saving progress to storage: $e');
    }
  }

  Progress? getProgressForCourse(String userId, String courseId) {
    final key = '${userId}_$courseId';
    return _userProgress[key];
  }

  Future<void> enrollInCourse(String userId, String courseId) async {
    final key = '${userId}_$courseId';

    if (!_userProgress.containsKey(key)) {
      final progress = Progress(
        userId: userId,
        courseId: courseId,
        lastAccessed: DateTime.now(),
      );

      _userProgress[key] = progress;
      await _saveProgressToStorage();
      notifyListeners();
    }
  }

  Future<void> completeLesson(
      String userId,
      String courseId,
      String lessonId,
      Course course,
      ) async {
    final key = '${userId}_$courseId';
    final currentProgress = _userProgress[key];

    if (currentProgress != null) {
      final updatedProgress = currentProgress.completeLesson(
        lessonId,
        course.lessons.length,
      );

      _userProgress[key] = updatedProgress;
      await _saveProgressToStorage();
      notifyListeners();
    }
  }

  Future<void> updateCurrentLesson(
      String userId,
      String courseId,
      int lessonIndex,
      ) async {
    final key = '${userId}_$courseId';
    final currentProgress = _userProgress[key];

    if (currentProgress != null) {
      final updatedProgress = currentProgress.copyWith(
        currentLessonIndex: lessonIndex,
        lastAccessed: DateTime.now(),
      );

      _userProgress[key] = updatedProgress;
      await _saveProgressToStorage();
      notifyListeners();
    }
  }

  List<Progress> getUserEnrolledCourses(String userId) {
    return _userProgress.values
        .where((progress) => progress.userId == userId)
        .toList()
      ..sort((a, b) => b.lastAccessed.compareTo(a.lastAccessed));
  }

  double getOverallProgress(String userId) {
    final userCourses = getUserEnrolledCourses(userId);
    if (userCourses.isEmpty) return 0.0;

    final totalProgress = userCourses.fold<double>(
      0.0,
          (sum, progress) => sum + progress.completionPercentage,
    );

    return totalProgress / userCourses.length;
  }

  int getTotalPointsEarned(String userId) {
    final userCourses = getUserEnrolledCourses(userId);
    return userCourses.fold<int>(
      0,
          (sum, progress) => sum + progress.pointsEarned,
    );
  }

  int getCompletedCoursesCount(String userId) {
    final userCourses = getUserEnrolledCourses(userId);
    return userCourses.where((progress) => progress.isCompleted).length;
  }

  bool isLessonCompleted(String userId, String courseId, String lessonId) {
    final progress = getProgressForCourse(userId, courseId);
    return progress?.completedLessons.contains(lessonId) ?? false;
  }

  bool isCourseEnrolled(String userId, String courseId) {
    final key = '${userId}_$courseId';
    return _userProgress.containsKey(key);
  }

  void clearProgress() {
    _userProgress.clear();
    _saveProgressToStorage();
    notifyListeners();
  }
}