import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../providers/auth_provider.dart';
import '../../providers/course_provider.dart';
import '../../providers/progress_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/lesson_list_item.dart';

class CourseDetailScreen extends StatefulWidget {
  final String courseId;

  const CourseDetailScreen({
    Key? key,
    required this.courseId,
  }) : super(key: key);

  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final courseProvider = context.read<CourseProvider>();
      final course = courseProvider.getCourseById(widget.courseId);
      if (course != null) {
        courseProvider.selectCourse(course);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<CourseProvider, AuthProvider, ProgressProvider>(
      builder: (context, courseProvider, authProvider, progressProvider, child) {
        final course = courseProvider.getCourseById(widget.courseId);

        if (course == null) {
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.pop(),
              ),
            ),
            body: const Center(
              child: Text('Course not found'),
            ),
          );
        }

        final user = authProvider.currentUser;
        final isEnrolled = user != null
            ? progressProvider.isCourseEnrolled(user.id, course.id)
            : false;
        final progress = user != null
            ? progressProvider.getProgressForCourse(user.id, course.id)
            : null;

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              // Course Header
              SliverAppBar(
                expandedHeight: 300,
                pinned: true,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => context.pop(),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: course.category == 'Basic Design'
                          ? const LinearGradient(
                        colors: [AppColors.primaryBlue, AppColors.lightBlue],
                      )
                          : const LinearGradient(
                        colors: [AppColors.purple, AppColors.lightPurple],
                      ),
                    ),
                    child: Stack(
                      children: [
                        Center(
                          child: Icon(
                            course.category == 'Basic Design'
                                ? Icons.design_services_outlined
                                : Icons.auto_awesome,
                            size: 80,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                        Positioned(
                          bottom: 20,
                          left: 20,
                          right: 20,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                  course.category,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                course.title,
                                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Course Content
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Course Stats
                      Row(
                        children: [
                          _buildStatItem(
                            Icons.star,
                            course.rating.toString(),
                            Colors.amber,
                          ),
                          const SizedBox(width: 24),
                          _buildStatItem(
                            Icons.people_outline,
                            '${course.enrolledStudents}',
                            AppColors.primaryBlue,
                          ),
                          const SizedBox(width: 24),
                          _buildStatItem(
                            Icons.access_time,
                            '${course.duration}m',
                            AppColors.textTertiary,
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Mentor Info
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: AppColors.primaryBlue,
                            child: Text(
                              course.mentorName[0],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                course.mentorName,
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                'Design Instructor',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppColors.textTertiary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Description Section
                      Text(
                        AppStrings.description,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        course.description,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          height: 1.6,
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Progress Section (if enrolled)
                      if (isEnrolled && progress != null) ...[
                        Text(
                          'Your Progress',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.cardBackground,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.borderLight),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${progress.completionPercentage.toInt()}% Complete',
                                    style: Theme.of(context).textTheme.titleMedium,
                                  ),
                                  Text(
                                    '${progress.completedLessons.length}/${course.lessons.length} lessons',
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppColors.textTertiary,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              LinearProgressIndicator(
                                value: progress.completionPercentage / 100,
                                backgroundColor: AppColors.borderLight,
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                  AppColors.primaryBlue,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),
                      ],

                      // Lessons Section
                      Text(
                        AppStrings.lessons,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),

              // Lessons List
              SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    final lesson = course.lessons[index];
                    final isCompleted = user != null
                        ? progressProvider.isLessonCompleted(user.id, course.id, lesson.id)
                        : false;

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                      child: LessonListItem(
                        lesson: lesson,
                        isCompleted: isCompleted,
                        isLocked: !isEnrolled && index > 0, // First lesson is always free
                        onTap: isEnrolled || index == 0
                            ? () => context.push('/course/${course.id}/lesson/${lesson.id}')
                            : null,
                      ),
                    );
                  },
                  childCount: course.lessons.length,
                ),
              ),

              // Bottom Padding
              const SliverToBoxAdapter(
                child: SizedBox(height: 100),
              ),
            ],
          ),

          // Enroll/Continue Button
          bottomNavigationBar: Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: AppColors.cardBackground,
              border: Border(
                top: BorderSide(color: AppColors.borderLight),
              ),
            ),
            child: SafeArea(
              child: CustomButton(
                text: isEnrolled ? 'Continue Learning' : 'Enroll Course',
                onPressed: () => _handleEnrollOrContinue(
                  context,
                  course,
                  isEnrolled,
                  progress,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatItem(IconData icon, String value, Color color) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  void _handleEnrollOrContinue(
      BuildContext context,
      course,
      bool isEnrolled,
      progress,
      ) async {
    final authProvider = context.read<AuthProvider>();
    final progressProvider = context.read<ProgressProvider>();
    final user = authProvider.currentUser;

    if (user == null) return;

    if (!isEnrolled) {
      // Enroll in course
      await progressProvider.enrollInCourse(user.id, course.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Successfully enrolled in course!'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    }

    // Navigate to first lesson or current lesson
    final lessonIndex = progress?.currentLessonIndex ?? 0;
    final lesson = course.lessons[lessonIndex];
    context.push('/course/${course.id}/lesson/${lesson.id}');
  }
}