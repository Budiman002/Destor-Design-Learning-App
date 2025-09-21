import 'package:flutter/foundation.dart';
import '../../data/models/course.dart';
import '../../data/models/lesson.dart';
import '../../data/models/practice.dart';

class CourseProvider extends ChangeNotifier {
  List<Course> _courses = [];
  List<Course> _featuredCourses = [];
  Course? _selectedCourse;
  bool _isLoading = false;
  String? _errorMessage;

  List<Course> get courses => _courses;
  List<Course> get featuredCourses => _featuredCourses;
  Course? get selectedCourse => _selectedCourse;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  CourseProvider() {
    _initializeMockData();
  }

  void _initializeMockData() {
    _setLoading(true);

    // Create mock practice items for drag & drop
    final loginPractice = Practice(
      id: 'practice_1',
      instruction: 'Drag & Drop the graphics into the right spot',
      dragItems: const [
        DragItem(id: 'login_btn', label: 'Login', type: 'button', color: '#3B82F6'),
        DragItem(id: 'signin_btn', label: 'Sign In', type: 'button', color: '#8B5CF6'),
        DragItem(id: 'password_field', label: 'Password', type: 'input', color: '#6B7280'),
      ],
      dropZones: const [
        DropZone(id: 'zone_1', correctItemId: 'login_btn', label: 'Primary Action'),
        DropZone(id: 'zone_2', correctItemId: 'signin_btn', label: 'Secondary Action'),
        DropZone(id: 'zone_3', correctItemId: 'password_field', label: 'Input Field'),
      ],
      correctFeedback: 'You are correct! 🎉\n\nExplanation: Placing the login button on top are best in most cases and placing the input next to each other is more neat, cleaner and tasty placing button on the bottom telling that it is the last step that user should take.',
      incorrectFeedback: 'Try again! Think about the logical flow of the interface.',
    );

    // Create mock lessons
    final basicDesignLessons = [
      Lesson(
        id: 'lesson_1',
        title: 'Get Acquainted with Figma',
        description: 'Learn the basics of Figma interface and tools',
        contentType: 'video',
        videoUrl: 'https://example.com/video1',
        order: 1,
        estimatedTime: 15,
      ),
      Lesson(
        id: 'lesson_2',
        title: 'Optimize design with Auto Layout',
        description: 'Master Auto Layout for responsive designs',
        contentType: 'video',
        videoUrl: 'https://example.com/video2',
        order: 2,
        estimatedTime: 20,
      ),
      Lesson(
        id: 'lesson_3',
        title: 'Prototype & Smart Animate',
        description: 'Create interactive prototypes',
        contentType: 'video',
        videoUrl: 'https://example.com/video3',
        order: 3,
        estimatedTime: 25,
      ),
      Lesson(
        id: 'lesson_4',
        title: 'User Flow & Wireframe',
        description: 'Practice drag & drop interface design',
        contentType: 'practice',
        practiceItems: [loginPractice],
        order: 4,
        estimatedTime: 10,
      ),
    ];

    final advancedDesignLessons = [
      Lesson(
        id: 'lesson_5',
        title: 'Advanced Component Systems',
        description: 'Build scalable design systems',
        contentType: 'video',
        videoUrl: 'https://example.com/video4',
        order: 1,
        estimatedTime: 30,
      ),
      Lesson(
        id: 'lesson_6',
        title: 'Complex Interactions',
        description: 'Advanced prototyping techniques',
        contentType: 'video',
        videoUrl: 'https://example.com/video5',
        order: 2,
        estimatedTime: 35,
      ),
    ];

    // Create mock courses
    _courses = [
      Course(
        id: 'course_1',
        title: 'Basic Design',
        description: 'Get to know the basic of designing. Understanding design principles and learn how to implement design concepts with various design systems such as Material Design, Human Interface, etc. Know how to create and animate prototypes. Know how to manage and hand over designs when working in a team.',
        imageUrl: 'https://via.placeholder.com/300x200/3B82F6/FFFFFF?text=Basic+Design',
        category: 'Basic Design',
        lessons: basicDesignLessons,
        mentorId: 'mentor_1',
        mentorName: 'Sarah Johnson',
        duration: 70,
        level: 'Beginner',
        rating: 4.8,
        enrolledStudents: 1250,
      ),
      Course(
        id: 'course_2',
        title: 'Advance Design',
        description: 'Advanced design concepts and techniques for professional designers',
        imageUrl: 'https://via.placeholder.com/300x200/8B5CF6/FFFFFF?text=Advanced+Design',
        category: 'Advance Design',
        lessons: advancedDesignLessons,
        mentorId: 'mentor_2',
        mentorName: 'John Smith',
        duration: 65,
        level: 'Advanced',
        rating: 4.9,
        enrolledStudents: 890,
      ),
    ];

    _featuredCourses = _courses;
    _setLoading(false);
  }

  void selectCourse(Course course) {
    _selectedCourse = course;
    notifyListeners();
  }

  void clearSelectedCourse() {
    _selectedCourse = null;
    notifyListeners();
  }

  List<Course> searchCourses(String query) {
    if (query.isEmpty) return _courses;

    return _courses.where((course) =>
    course.title.toLowerCase().contains(query.toLowerCase()) ||
        course.description.toLowerCase().contains(query.toLowerCase()) ||
        course.category.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }

  Course? getCourseById(String courseId) {
    try {
      return _courses.firstWhere((course) => course.id == courseId);
    } catch (e) {
      return null;
    }
  }

  Lesson? getLessonById(String courseId, String lessonId) {
    final course = getCourseById(courseId);
    if (course == null) return null;

    try {
      return course.lessons.firstWhere((lesson) => lesson.id == lessonId);
    } catch (e) {
      return null;
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}