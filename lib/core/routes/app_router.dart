import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../presentation/providers/auth_provider.dart';
import '../../presentation/screens/auth/splash_screen.dart';
import '../../presentation/screens/auth/login_screen.dart';
import '../../presentation/screens/auth/register_screen.dart';
import '../../presentation/screens/home/main_screen.dart';
import '../../presentation/screens/home/home_screen.dart';
import '../../presentation/screens/course/course_detail_screen.dart';
import '../../presentation/screens/course/lesson_screen.dart';
import '../../presentation/screens/practice/practice_screen.dart';
import '../../presentation/screens/profile/profile_screen.dart';
import '../../presentation/screens/profile/progress_screen.dart';

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorKey = GlobalKey<NavigatorState>();

  static GoRouter createRouter(AuthProvider authProvider) {
    return GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: '/splash',
      redirect: (context, state) {
        final isLoggedIn = authProvider.isLoggedIn;
        final isOnAuthScreens = state.matchedLocation.startsWith('/auth');
        final isOnSplash = state.matchedLocation == '/splash';

        // If on splash, don't redirect
        if (isOnSplash) return null;

        // If not logged in and not on auth screens, go to login
        if (!isLoggedIn && !isOnAuthScreens) {
          return '/auth/login';
        }

        // If logged in and on auth screens, go to home
        if (isLoggedIn && isOnAuthScreens) {
          return '/home';
        }

        return null;
      },
      routes: [
        // Splash Screen
        GoRoute(
          path: '/splash',
          name: 'splash',
          builder: (context, state) => const SplashScreen(),
        ),

        // Auth Routes
        GoRoute(
          path: '/auth/login',
          name: 'login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/auth/register',
          name: 'register',
          builder: (context, state) => const RegisterScreen(),
        ),

        // Main App with Bottom Navigation
        ShellRoute(
          navigatorKey: _shellNavigatorKey,
          builder: (context, state, child) => MainScreen(child: child),
          routes: [
            GoRoute(
              path: '/home',
              name: 'home',
              builder: (context, state) => const HomeScreen(),
            ),
            GoRoute(
              path: '/profile',
              name: 'profile',
              builder: (context, state) => const ProfileScreen(),
            ),
            GoRoute(
              path: '/progress',
              name: 'progress',
              builder: (context, state) => const ProgressScreen(),
            ),
          ],
        ),

        // Course Routes
        GoRoute(
          path: '/course/:courseId',
          name: 'course_detail',
          builder: (context, state) {
            final courseId = state.pathParameters['courseId']!;
            return CourseDetailScreen(courseId: courseId);
          },
        ),
        GoRoute(
          path: '/course/:courseId/lesson/:lessonId',
          name: 'lesson',
          builder: (context, state) {
            final courseId = state.pathParameters['courseId']!;
            final lessonId = state.pathParameters['lessonId']!;
            return LessonScreen(
              courseId: courseId,
              lessonId: lessonId,
            );
          },
        ),
        GoRoute(
          path: '/practice/:courseId/:lessonId/:practiceId',
          name: 'practice',
          builder: (context, state) {
            final courseId = state.pathParameters['courseId']!;
            final lessonId = state.pathParameters['lessonId']!;
            final practiceId = state.pathParameters['practiceId']!;
            return PracticeScreen(
              courseId: courseId,
              lessonId: lessonId,
              practiceId: practiceId,
            );
          },
        ),
      ],
    );
  }
}

extension GoRouterExtension on GoRouter {
  void clearStackAndNavigate(String location) {
    while (canPop()) {
      pop();
    }
    pushReplacement(location);
  }
}