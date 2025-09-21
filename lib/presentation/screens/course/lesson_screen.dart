import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../providers/auth_provider.dart';
import '../../providers/course_provider.dart';
import '../../providers/progress_provider.dart';
import '../../widgets/custom_button.dart';

class LessonScreen extends StatefulWidget {
  final String courseId;
  final String lessonId;

  const LessonScreen({
    Key? key,
    required this.courseId,
    required this.lessonId,
  }) : super(key: key);

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  bool _isLessonCompleted = false;

  @override
  Widget build(BuildContext context) {
    return Consumer3<CourseProvider, AuthProvider, ProgressProvider>(
      builder: (context, courseProvider, authProvider, progressProvider, child) {
        final course = courseProvider.getCourseById(widget.courseId);
        final lesson = courseProvider.getLessonById(widget.courseId, widget.lessonId);
        final user = authProvider.currentUser;

        if (course == null || lesson == null) {
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.pop(),
              ),
            ),
            body: const Center(
              child: Text('Lesson not found'),
            ),
          );
        }

        final isCompleted = user != null
            ? progressProvider.isLessonCompleted(user.id, course.id, lesson.id)
            : false;

        return Scaffold(
          appBar: AppBar(
            title: Text(lesson.title),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => context.pop(),
            ),
            actions: [
              if (isCompleted)
                const Icon(
                  Icons.check_circle,
                  color: AppColors.success,
                ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Lesson Header
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: course.category == 'Basic Design'
                        ? AppColors.primaryGradient
                        : const LinearGradient(
                      colors: [AppColors.purple, AppColors.lightPurple],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              lesson.contentType.toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.access_time,
                                  size: 14,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${lesson.estimatedTime} min',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        lesson.title,
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        lesson.description,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Lesson Content
                _buildLessonContent(lesson, course),

                const SizedBox(height: 32),
              ],
            ),
          ),

          // Action Buttons
          bottomNavigationBar: Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: AppColors.cardBackground,
              border: Border(
                top: BorderSide(color: AppColors.borderLight),
              ),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  // Previous Lesson Button
                  if (_hasPreviousLesson(course, lesson))
                    Expanded(
                      child: CustomButton(
                        text: 'Previous',
                        isSecondary: true,
                        onPressed: () => _navigateToPreviousLesson(course, lesson),
                      ),
                    ),

                  if (_hasPreviousLesson(course, lesson) &&
                      (_hasNextLesson(course, lesson) || !isCompleted))
                    const SizedBox(width: 16),

                  // Complete/Next Lesson Button
                  if (_hasNextLesson(course, lesson) || !isCompleted)
                    Expanded(
                      flex: _hasPreviousLesson(course, lesson) ? 1 : 2,
                      child: CustomButton(
                        text: isCompleted
                            ? (_hasNextLesson(course, lesson) ? 'Next Lesson' : 'Course Complete')
                            : 'Complete Lesson',
                        onPressed: () => _handleLessonAction(
                          context,
                          course,
                          lesson,
                          isCompleted,
                          user,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLessonContent(lesson, course) {
    switch (lesson.contentType) {
      case 'video':
        return _buildVideoContent(lesson);
      case 'practice':
        return _buildPracticeContent(lesson, course);
      case 'reading':
        return _buildReadingContent(lesson);
      default:
        return _buildVideoContent(lesson);
    }
  }

  Widget _buildVideoContent(lesson) {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.play_circle_outline,
            size: 64,
            color: AppColors.primaryBlue,
          ),
          SizedBox(height: 16),
          Text(
            'Video Player',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Video content will be implemented here',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPracticeContent(lesson, course) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.games_outlined,
            size: 64,
            color: AppColors.primaryBlue,
          ),
          const SizedBox(height: 16),
          Text(
            'Interactive Practice',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Ready to practice what you\'ve learned?',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          CustomButton(
            text: 'Start Practice',
            onPressed: () {
              if (lesson.practiceItems != null && lesson.practiceItems!.isNotEmpty) {
                context.push('/practice/${course.id}/${lesson.id}/${lesson.practiceItems![0].id}');
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildReadingContent(lesson) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.article_outlined,
                size: 24,
                color: AppColors.primaryBlue,
              ),
              const SizedBox(width: 12),
              Text(
                'Reading Material',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            lesson.content ?? 'Reading content will be available here. This lesson covers the fundamental concepts and principles you need to understand.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  bool _hasPreviousLesson(course, lesson) {
    final currentIndex = course.lessons.indexWhere((l) => l.id == lesson.id);
    return currentIndex > 0;
  }

  bool _hasNextLesson(course, lesson) {
    final currentIndex = course.lessons.indexWhere((l) => l.id == lesson.id);
    return currentIndex < course.lessons.length - 1;
  }

  void _navigateToPreviousLesson(course, lesson) {
    final currentIndex = course.lessons.indexWhere((l) => l.id == lesson.id);
    if (currentIndex > 0) {
      final previousLesson = course.lessons[currentIndex - 1];
      context.go('/course/${course.id}/lesson/${previousLesson.id}');
    }
  }

  void _handleLessonAction(
      BuildContext context,
      course,
      lesson,
      bool isCompleted,
      user,
      ) async {
    final progressProvider = context.read<ProgressProvider>();

    if (!isCompleted && user != null) {
      // Mark lesson as completed
      await progressProvider.completeLesson(user.id, course.id, lesson.id, course);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Lesson completed! 🎉'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    }

    // Navigate to next lesson if available
    if (_hasNextLesson(course, lesson)) {
      final currentIndex = course.lessons.indexWhere((l) => l.id == lesson.id);
      final nextLesson = course.lessons[currentIndex + 1];
      context.go('/course/${course.id}/lesson/${nextLesson.id}');
    } else {
      // Course completed
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Congratulations! 🎉'),
            content: const Text('You have completed this course!'),
            actions: [
              TextButton(
                onPressed: () {
                  context.pop(); // Close dialog
                  context.go('/course/${course.id}'); // Go back to course detail
                },
                child: const Text('Continue'),
              ),
            ],
          ),
        );
      }
    }
  }
}