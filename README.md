##📱 About The Project
Destor is a gamified learning mobile application specifically designed for design students. Originally developed as a Human-Computer Interaction course project mockup, it has now been transformed into a fully functional Flutter application with interactive features and modern UI/UX design.
The app helps students learn design principles through interactive modules, mentor-based challenges, and gamified progress tracking, making education more engaging and enjoyable.

✨ Key Features
🔐 Authentication System - Secure login/register with form validation
🏠 Interactive Home Dashboard - Personalized learning experience
📚 Course Management - Browse, enroll, and track course progress
🎮 Drag & Drop Practice Games - Interactive learning modules
📊 Progress Tracking - Real-time learning analytics and achievements
👤 User Profile Management - Personal stats and preferences
🏆 Points & Achievements System - Gamified learning rewards
🎨 Modern Dark Theme UI - Sleek and professional design
💾 Offline Data Persistence - Local storage with SharedPreferences

🛠️ Built With
Framework & Language

Flutter - Cross-platform mobile development framework
Dart - Programming language optimized for building mobile apps

State Management

Provider - Simple and scalable state management solution

Navigation

go_router - Declarative routing solution for Flutter

UI & Styling

Google Fonts - Beautiful typography
Cached Network Image - Image caching and loading

Data Persistence

SharedPreferences - Local data storage
JSON Serialization - Model serialization

Development Tools

Build Runner - Code generation
JSON Serializable - JSON model generation

📁 Project Structure
lib/
├── core/
│   ├── constants/          # App-wide constants (colors, strings)
│   ├── routes/             # Navigation and routing logic
│   ├── themes/             # App theme configuration
│   └── utils/              # Utility functions
├── data/
│   ├── models/             # Data models (User, Course, Lesson, etc.)
│   ├── repositories/       # Data access layer
│   └── services/           # API and external services
├── presentation/
│   ├── providers/          # State management (Provider)
│   ├── screens/            # UI screens
│   │   ├── auth/           # Authentication screens
│   │   ├── course/         # Course-related screens
│   │   ├── home/           # Home and main screens
│   │   ├── practice/       # Practice game screens
│   │   └── profile/        # Profile and progress screens
│   └── widgets/            # Reusable UI components
└── main.dart               # App entry point

Key Components
Data Models

User - User account and profile information
Course - Course details, lessons, and metadata
Lesson - Individual lesson content and structure
Practice - Interactive drag & drop game data
Progress - User learning progress and achievements

State Management

AuthProvider - Authentication state and user management
CourseProvider - Course data and selection logic
ProgressProvider - Learning progress and statistics tracking

Core Features

Responsive UI with dark theme design
Smooth animations and transitions
Form validation and error handling
Local data persistence
Interactive drag & drop functionality


🎮 Features Showcase
Authentication Flow

Animated splash screen with app branding
Clean login/register forms with validation
Persistent authentication state
Smooth navigation transitions

Learning Experience

Personalized dashboard with welcome messages
Featured courses with attractive cards
Interactive lesson progression
Drag & drop practice games with real-time feedback

Progress Tracking

Comprehensive progress analytics
Points and achievements system
Course completion certificates
Visual progress indicators

User Interface

Modern dark theme design
Consistent color scheme and typography
Responsive layouts for different screen sizes
Intuitive navigation with bottom tabs

🐛 Known Issues

Video player functionality is placeholder (UI ready)
Search functionality is UI-only (backend integration needed)
Some menu items show "coming soon" messages
Limited practice game variations

🙏 Acknowledgments

Original mockup design came from course Human-Computer Interaction course
Design inspiration from modern educational platforms
Open source community for the packages used
