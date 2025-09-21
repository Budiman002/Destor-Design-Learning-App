import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../providers/course_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/draggable_item.dart';
import '../../widgets/drop_zone_widget.dart';
import '../../../data/models/practice.dart';

class PracticeScreen extends StatefulWidget {
  final String courseId;
  final String lessonId;
  final String practiceId;

  const PracticeScreen({
    Key? key,
    required this.courseId,
    required this.lessonId,
    required this.practiceId,
  }) : super(key: key);

  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen>
    with SingleTickerProviderStateMixin {
  List<DropZone> _dropZones = [];
  List<DragItem> _dragItems = [];
  bool _showWelcome = true;
  bool _isCompleted = false;
  bool _showFeedback = false;
  String _feedbackMessage = '';
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _initializePractice();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  void _initializePractice() {
    final courseProvider = context.read<CourseProvider>();
    final lesson = courseProvider.getLessonById(widget.courseId, widget.lessonId);

    if (lesson?.practiceItems != null && lesson!.practiceItems!.isNotEmpty) {
      final practice = lesson.practiceItems!.first;
      setState(() {
        _dropZones = practice.dropZones.map((zone) => zone.copyWith()).toList();
        _dragItems = practice.dragItems;
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_showWelcome) {
      return _buildWelcomeScreen();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Practice'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Instructions
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.borderLight),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.info_outline,
                      color: AppColors.primaryBlue,
                      size: 24,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      AppStrings.dragDropInstruction,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Drag Items Section
              Text(
                'Drag these items:',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),

              // Drag Items Container
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.borderLight),
                ),
                child: Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: _dragItems.map((item) {
                    // Check if item is already placed
                    final isPlaced = _dropZones.any((zone) => zone.currentItemId == item.id);

                    return DraggableItem(
                      item: item,
                      isPlaced: isPlaced,
                      onDragStarted: () {
                        setState(() {
                          _showFeedback = false;
                        });
                      },
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 32),

              // Drop Zones Section
              Text(
                'Drop them here:',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),

              // Drop Zones
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.borderLight),
                  ),
                  child: Column(
                    children: _dropZones.map((zone) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: DropZoneWidget(
                          dropZone: zone,
                          dragItems: _dragItems,
                          onItemDropped: _handleItemDropped,
                          onItemRemoved: _handleItemRemoved,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),

              // Feedback Section
              if (_showFeedback)
                AnimatedBuilder(
                  animation: _fadeAnimation,
                  builder: (context, child) {
                    return FadeTransition(
                      opacity: _fadeAnimation,
                      child: Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(top: 16),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: _isCompleted ? AppColors.success : AppColors.error,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              _isCompleted ? Icons.check_circle : Icons.error,
                              color: Colors.white,
                              size: 32,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              _feedbackMessage,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

              const SizedBox(height: 20),

              // Complete Button
              if (_isCompleted)
                CustomButton(
                  text: AppStrings.finish,
                  onPressed: () {
                    context.go('/course/${widget.courseId}/lesson/${widget.lessonId}');
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeScreen() {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.primaryGradient,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const Spacer(),

                // Welcome Icon
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Icon(
                    Icons.games_outlined,
                    size: 60,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 32),

                // Welcome Text
                Text(
                  AppStrings.welcomeToPractice,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 16),

                Text(
                  AppStrings.practiceInstruction,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.white.withOpacity(0.9),
                  ),
                  textAlign: TextAlign.center,
                ),

                const Spacer(),

                // Start Button
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _showWelcome = false;
                    });
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 2,
                      ),
                    ),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.touch_app,
                          color: Colors.white,
                          size: 32,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          AppStrings.tapToContinue,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleItemDropped(String itemId, String zoneId) {
    setState(() {
      // Remove item from any other zones first
      for (var zone in _dropZones) {
        if (zone.currentItemId == itemId) {
          final index = _dropZones.indexOf(zone);
          _dropZones[index] = zone.copyWith(currentItemId: null);
        }
      }

      // Add item to the target zone
      final zoneIndex = _dropZones.indexWhere((zone) => zone.id == zoneId);
      if (zoneIndex != -1) {
        _dropZones[zoneIndex] = _dropZones[zoneIndex].copyWith(currentItemId: itemId);
      }

      _checkCompletion();
    });
  }

  void _handleItemRemoved(String itemId, String zoneId) {
    setState(() {
      final zoneIndex = _dropZones.indexWhere((zone) => zone.id == zoneId);
      if (zoneIndex != -1) {
        _dropZones[zoneIndex] = _dropZones[zoneIndex].copyWith(currentItemId: null);
      }

      _showFeedback = false;
      _isCompleted = false;
    });
  }

  void _checkCompletion() {
    final allZonesFilled = _dropZones.every((zone) => zone.currentItemId != null);

    if (allZonesFilled) {
      final allCorrect = _dropZones.every((zone) => zone.isCorrect);

      setState(() {
        _isCompleted = allCorrect;
        _showFeedback = true;
        _feedbackMessage = allCorrect
            ? AppStrings.youAreCorrect
            : 'Try again! Some items are in the wrong place.';
      });

      _animationController.forward();
    }
  }
}