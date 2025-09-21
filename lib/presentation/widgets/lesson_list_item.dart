import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/lesson.dart';

class LessonListItem extends StatelessWidget {
  final Lesson lesson;
  final bool isCompleted;
  final bool isLocked;
  final VoidCallback? onTap;

  const LessonListItem({
    Key? key,
    required this.lesson,
    this.isCompleted = false,
    this.isLocked = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLocked ? null : onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isCompleted
                ? AppColors.success
                : AppColors.borderLight,
          ),
        ),
        child: Row(
          children: [
            // Lesson Icon/Status
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _getIconBackgroundColor(),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                _getIconData(),
                color: _getIconColor(),
                size: 20,
              ),
            ),

            const SizedBox(width: 16),

            // Lesson Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          lesson.title,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: isLocked
                                ? AppColors.textTertiary
                                : AppColors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isCompleted)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.success,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'Completed',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 4),

                  Text(
                    lesson.description,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: isLocked
                          ? AppColors.textTertiary
                          : AppColors.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 8),

                  // Lesson Meta Info
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 14,
                        color: AppColors.textTertiary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${lesson.estimatedTime} min',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textTertiary,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Icon(
                        _getContentTypeIcon(),
                        size: 14,
                        color: AppColors.textTertiary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _getContentTypeLabel(),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Arrow Icon
            if (!isLocked)
              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: AppColors.textTertiary,
              ),
          ],
        ),
      ),
    );
  }

  Color _getIconBackgroundColor() {
    if (isLocked) return AppColors.borderDark;
    if (isCompleted) return AppColors.success.withOpacity(0.2);
    return AppColors.primaryBlue.withOpacity(0.2);
  }

  Color _getIconColor() {
    if (isLocked) return AppColors.textTertiary;
    if (isCompleted) return AppColors.success;
    return AppColors.primaryBlue;
  }

  IconData _getIconData() {
    if (isLocked) return Icons.lock_outline;
    if (isCompleted) return Icons.check;

    switch (lesson.contentType) {
      case 'video':
        return Icons.play_arrow;
      case 'practice':
        return Icons.games_outlined;
      case 'reading':
        return Icons.article_outlined;
      default:
        return Icons.play_arrow;
    }
  }

  IconData _getContentTypeIcon() {
    switch (lesson.contentType) {
      case 'video':
        return Icons.videocam_outlined;
      case 'practice':
        return Icons.games_outlined;
      case 'reading':
        return Icons.article_outlined;
      default:
        return Icons.videocam_outlined;
    }
  }

  String _getContentTypeLabel() {
    switch (lesson.contentType) {
      case 'video':
        return 'Video';
      case 'practice':
        return 'Practice';
      case 'reading':
        return 'Reading';
      default:
        return 'Video';
    }
  }
}