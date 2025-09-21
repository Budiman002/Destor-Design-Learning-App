import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/practice.dart';

class DropZoneWidget extends StatefulWidget {
  final DropZone dropZone;
  final List<DragItem> dragItems;
  final Function(String itemId, String zoneId) onItemDropped;
  final Function(String itemId, String zoneId) onItemRemoved;

  const DropZoneWidget({
    Key? key,
    required this.dropZone,
    required this.dragItems,
    required this.onItemDropped,
    required this.onItemRemoved,
  }) : super(key: key);

  @override
  State<DropZoneWidget> createState() => _DropZoneWidgetState();
}

class _DropZoneWidgetState extends State<DropZoneWidget>
    with SingleTickerProviderStateMixin {
  bool _isDragOver = false;
  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
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
    final currentItem = widget.dropZone.currentItemId != null
        ? widget.dragItems.firstWhere(
          (item) => item.id == widget.dropZone.currentItemId,
    )
        : null;

    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: DragTarget<String>(
            onWillAccept: (data) => data != null,
            onAccept: (data) {
              widget.onItemDropped(data, widget.dropZone.id);
              setState(() {
                _isDragOver = false;
              });
              _animationController.stop();
            },
            onMove: (details) {
              if (!_isDragOver) {
                setState(() {
                  _isDragOver = true;
                });
                _animationController.repeat(reverse: true);
              }
            },
            onLeave: (data) {
              setState(() {
                _isDragOver = false;
              });
              _animationController.stop();
            },
            builder: (context, candidateData, rejectedData) {
              return Container(
                width: double.infinity,
                height: 80,
                decoration: BoxDecoration(
                  color: _getBackgroundColor(currentItem),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _getBorderColor(currentItem),
                    width: _isDragOver ? 3 : 2,
                    style: currentItem == null ? BorderStyle.solid : BorderStyle.solid,
                  ),
                ),
                child: currentItem != null
                    ? _buildPlacedItem(currentItem)
                    : _buildEmptyZone(),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildPlacedItem(DragItem item) {
    final isCorrect = widget.dropZone.isCorrect;

    return Stack(
      children: [
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isCorrect
                      ? AppColors.success.withOpacity(0.1)
                      : AppColors.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  item.label,
                  style: TextStyle(
                    color: isCorrect ? AppColors.success : AppColors.error,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                isCorrect ? Icons.check_circle : Icons.error,
                color: isCorrect ? AppColors.success : AppColors.error,
                size: 20,
              ),
            ],
          ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: GestureDetector(
            onTap: () {
              widget.onItemRemoved(item.id, widget.dropZone.id);
            },
            child: Container(
              width: 24,
              height: 24,
              decoration: const BoxDecoration(
                color: AppColors.error,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyZone() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          _isDragOver ? Icons.add_circle : Icons.add_circle_outline,
          color: _isDragOver ? AppColors.primaryBlue : AppColors.textTertiary,
          size: 24,
        ),
        const SizedBox(height: 8),
        Text(
          widget.dropZone.label,
          style: TextStyle(
            color: _isDragOver ? AppColors.primaryBlue : AppColors.textTertiary,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Color _getBackgroundColor(DragItem? currentItem) {
    if (currentItem != null) {
      return widget.dropZone.isCorrect
          ? AppColors.success.withOpacity(0.05)
          : AppColors.error.withOpacity(0.05);
    }

    if (_isDragOver) {
      return AppColors.primaryBlue.withOpacity(0.1);
    }

    return AppColors.backgroundColor;
  }

  Color _getBorderColor(DragItem? currentItem) {
    if (currentItem != null) {
      return widget.dropZone.isCorrect ? AppColors.success : AppColors.error;
    }

    if (_isDragOver) {
      return AppColors.primaryBlue;
    }

    return AppColors.borderLight;
  }
}