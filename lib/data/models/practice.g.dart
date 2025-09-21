// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'practice.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Practice _$PracticeFromJson(Map<String, dynamic> json) => Practice(
      id: json['id'] as String,
      instruction: json['instruction'] as String,
      dragItems: (json['dragItems'] as List<dynamic>)
          .map((e) => DragItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      dropZones: (json['dropZones'] as List<dynamic>)
          .map((e) => DropZone.fromJson(e as Map<String, dynamic>))
          .toList(),
      correctFeedback: json['correctFeedback'] as String,
      incorrectFeedback: json['incorrectFeedback'] as String,
      isCompleted: json['isCompleted'] as bool? ?? false,
    );

Map<String, dynamic> _$PracticeToJson(Practice instance) => <String, dynamic>{
      'id': instance.id,
      'instruction': instance.instruction,
      'dragItems': instance.dragItems,
      'dropZones': instance.dropZones,
      'correctFeedback': instance.correctFeedback,
      'incorrectFeedback': instance.incorrectFeedback,
      'isCompleted': instance.isCompleted,
    };

DragItem _$DragItemFromJson(Map<String, dynamic> json) => DragItem(
      id: json['id'] as String,
      label: json['label'] as String,
      type: json['type'] as String,
      color: json['color'] as String?,
    );

Map<String, dynamic> _$DragItemToJson(DragItem instance) => <String, dynamic>{
      'id': instance.id,
      'label': instance.label,
      'type': instance.type,
      'color': instance.color,
    };

DropZone _$DropZoneFromJson(Map<String, dynamic> json) => DropZone(
      id: json['id'] as String,
      correctItemId: json['correctItemId'] as String,
      label: json['label'] as String,
      currentItemId: json['currentItemId'] as String?,
    );

Map<String, dynamic> _$DropZoneToJson(DropZone instance) => <String, dynamic>{
      'id': instance.id,
      'correctItemId': instance.correctItemId,
      'label': instance.label,
      'currentItemId': instance.currentItemId,
    };
