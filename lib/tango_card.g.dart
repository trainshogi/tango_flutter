// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tango_card.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TangoCard _$TangoCardFromJson(Map<String, dynamic> json) {
  return TangoCard(
    json['front'] as String,
    json['back'] as String,
    json['memo'] as String,
  );
}

Map<String, dynamic> _$TangoCardToJson(TangoCard instance) => <String, dynamic>{
      'front': instance.front,
      'back': instance.back,
      'memo': instance.memo,
    };
