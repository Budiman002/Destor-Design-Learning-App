import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../providers/auth_provider.dart';
import '../../providers/course_provider.dart';
import '../../widgets/course_card.dart';
import '../../widgets/search_bar_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser;
    final courseProvider = context.watch<CourseProvider>();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              _buildHeader(user?.name ?? 'User'),
              const SizedBox(height: 24),

              // Search Bar
              SearchBarWidget(
                controller: _searchController,
                onSearch: (query) {
                  // TODO: Implement search functionality
                },
              ),
              const SizedBox(height: 32),

              // Design Principles Banner
              _buildDesignPrinciplesBanner(),
              const SizedBox(height: 32),

              // Featured Courses Section
              _buildSectionHeader(
                AppStrings.featuredCourses,
                AppStrings.viewAll,
                    () {
                  // TODO: Navigate to all courses
                },
              ),
              const SizedBox(height: 16),

              // Featured Courses List
              if (courseProvider.isLoading)
                const Center(child: CircularProgressIndicator())
              else if (courseProvider.featuredCourses.isEmpty)
                const Center(child: Text('No courses available'))
              else
                SizedBox(
                  height: 280,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: courseProvider.featuredCourses.length,
                    itemBuilder: (context, index) {
                      final course = courseProvider.featuredCourses[index];
                      return Padding(
                        padding: EdgeInsets.only(
                          right: index < courseProvider.featuredCourses.length - 1 ? 16 : 0,
                        ),
                        child: CourseCard(
                          course: course,
                          onTap: () => context.push('/course/${course.id}'),
                        ),
                      );
                    },
                  ),
                ),

              const SizedBox(height: 32),

              // Top Mentors Section
              _buildSectionHeader(
                AppStrings.topMentors,
                AppStrings.viewAll,
                    () {
                  // TODO: Navigate to mentors
                },
              ),
              const SizedBox(height: 16),

              // Top Mentors List
              _buildTopMentors(),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(String userName) {
    return Row(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: AppColors.primaryBlue,
          child: Text(
            userName.isNotEmpty ? userName[0].toUpperCase() : 'U',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello, $userName',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              Text(
                AppStrings.welcomeBack,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () {
            // TODO: Implement notifications
          },
          icon: const Icon(Icons.notifications_outlined),
          color: AppColors.textPrimary,
        ),
      ],
    );
  }

  Widget _buildDesignPrinciplesBanner() {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 24,
            top: 24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.designPrinciples,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: List.generate(
                    3,
                        (index) => Container(
                      margin: const EdgeInsets.only(right: 8),
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: index == 0 ? Colors.white : Colors.white54,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 20,
            top: 20,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.design_services,
                color: Colors.white,
                size: 40,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, String? actionText, VoidCallback? onAction) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        if (actionText != null && onAction != null)
          TextButton(
            onPressed: onAction,
            child: Text(actionText),
          ),
      ],
    );
  }

  Widget _buildTopMentors() {
    final mentors = [
      {'name': 'Sarah Johnson', 'expertise': 'UI/UX Design'},
      {'name': 'John Smith', 'expertise': 'Product Design'},
      {'name': 'Emily Chen', 'expertise': 'Visual Design'},
    ];

    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: mentors.length,
        itemBuilder: (context, index) {
          final mentor = mentors[index];
          return Container(
            width: 80,
            margin: EdgeInsets.only(
              right: index < mentors.length - 1 ? 16 : 0,
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: AppColors.primaryBlue,
                  child: Text(
                    mentor['name']![0],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  mentor['name']!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}