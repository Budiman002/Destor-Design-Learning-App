import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/practice.dart';

class DraggableItem extends StatefulWidget {
  final DragItem item;
  final bool isPlaced;
  final VoidCallback? onDragStarted;

  const DraggableItem({
    Key? key,
    required this.item,
    this.isPlaced = false,
    this.onDragStarted,
  }) : super(key: key);

  @override
  State<DraggableItem> createState() => _DraggableItemState();
}

class _DraggableItemState extends State<DraggableItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isPlaced) {
      return Container(
        width: 120,
        height: 50,
        decoration: BoxDecoration(
          color: AppColors.borderDark,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.borderLight,
            style: BorderStyle.solid,
            width: 2,
          ),
        ),
        child: const Center(
          child: Text(
            'Placed',
            style: TextStyle(
              color: AppColors.textTertiary,
              fontSize: 12,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      );
    }

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Draggable<String>(
            data: widget.item.id,
            feedback: _buildDraggedItem(true),
            childWhenDragging: _buildDraggedItem(false, isGhost: true),
            onDragStarted: () {
              setState(() {
                _isDragging = true;
              });
              _animationController.forward();
              widget.onDragStarted?.call();
            },
            onDragEnd: (details) {
              setState(() {
                _isDragging = false;
              });
              _animationController.reverse();
            },
            child: _buildDraggedItem(false),
          ),
        );
      },
    );
  }

  Widget _buildDraggedItem(bool isFeedback, {bool isGhost = false}) {
    return Container(
      width: 120,
      height: 50,
      decoration: BoxDecoration(
        color: isGhost
            ? AppColors.cardBackground.withOpacity(0.5)
            : _getItemColor(),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isGhost
              ? AppColors.borderLight.withOpacity(0.5)
              : AppColors.borderLight,
          width: 2,
        ),
        boxShadow: isFeedback || _isDragging
            ? [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ]
            : null,
      ),
      child: Center(
        child: Text(
          widget.item.label,
          style: TextStyle(
            color: isGhost
                ? AppColors.textTertiary
                : AppColors.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Color _getItemColor() {
    switch (widget.item.type) {
      case 'button':
        return AppColors.primaryBlue.withOpacity(0.1);
      case 'input':
        return AppColors.cardBackground;
      default:
        return AppColors.cardBackground;
    }
  }
}