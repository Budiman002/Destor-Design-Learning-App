import 'package:json_annotation/json_annotation.dart';

part 'practice.g.dart';

@JsonSerializable()
class Practice {
  final String id;
  final String instruction;
  final List<DragItem> dragItems;
  final List<DropZone> dropZones;
  final String correctFeedback;
  final String incorrectFeedback;
  final bool isCompleted;

  const Practice({
    required this.id,
    required this.instruction,
    required this.dragItems,
    required this.dropZones,
    required this.correctFeedback,
    required this.incorrectFeedback,
    this.isCompleted = false,
  });

  factory Practice.fromJson(Map<String, dynamic> json) => _$PracticeFromJson(json);
  Map<String, dynamic> toJson() => _$PracticeToJson(this);

  Practice copyWith({
    String? id,
    String? instruction,
    List<DragItem>? dragItems,
    List<DropZone>? dropZones,
    String? correctFeedback,
    String? incorrectFeedback,
    bool? isCompleted,
  }) {
    return Practice(
      id: id ?? this.id,
      instruction: instruction ?? this.instruction,
      dragItems: dragItems ?? this.dragItems,
      dropZones: dropZones ?? this.dropZones,
      correctFeedback: correctFeedback ?? this.correctFeedback,
      incorrectFeedback: incorrectFeedback ?? this.incorrectFeedback,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

@JsonSerializable()
class DragItem {
  final String id;
  final String label;
  final String type;
  final String? color; // For styling

  const DragItem({
    required this.id,
    required this.label,
    required this.type,
    this.color,
  });

  factory DragItem.fromJson(Map<String, dynamic> json) => _$DragItemFromJson(json);
  Map<String, dynamic> toJson() => _$DragItemToJson(this);
}

@JsonSerializable()
class DropZone {
  final String id;
  final String correctItemId;
  final String label;
  final String? currentItemId; // Currently dropped item

  const DropZone({
    required this.id,
    required this.correctItemId,
    required this.label,
    this.currentItemId,
  });

  factory DropZone.fromJson(Map<String, dynamic> json) => _$DropZoneFromJson(json);
  Map<String, dynamic> toJson() => _$DropZoneToJson(this);

  DropZone copyWith({
    String? id,
    String? correctItemId,
    String? label,
    String? currentItemId,
  }) {
    return DropZone(
      id: id ?? this.id,
      correctItemId: correctItemId ?? this.correctItemId,
      label: label ?? this.label,
      currentItemId: currentItemId ?? this.currentItemId,
    );
  }

  bool get isCorrect => currentItemId == correctItemId;
}