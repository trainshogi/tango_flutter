// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tango_cards_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TangoCardsDTO _$TangoCardsDTOFromJson(Map<String, dynamic> json) {
  return TangoCardsDTO(
    (json['tangoCardList'] as List<dynamic>)
        .map((e) => TangoCard.fromJson(e as Map<String, dynamic>))
        .toList(),
    DateTime.parse(json['updatedTime'] as String),
  );
}

Map<String, dynamic> _$TangoCardsDTOToJson(TangoCardsDTO instance) =>
    <String, dynamic>{
      'tangoCardList': instance.tangoCardList,
      'updatedTime': instance.updatedTime.toIso8601String(),
    };
