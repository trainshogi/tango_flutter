import 'package:json_annotation/json_annotation.dart';
import 'package:tango_flutter/tango_card.dart';

part 'tango_cards_dto.g.dart';

@JsonSerializable()
class TangoCardsDTO {
  TangoCardsDTO(this.tangoCardList, this.updatedTime);

  List<TangoCard> tangoCardList;
  DateTime updatedTime;

  // _$UserFromJsonが生成される
  factory TangoCardsDTO.fromJson(Map<String, dynamic> json) => _$TangoCardsDTOFromJson(json);

  // _$UserToJsonが生成される
  Map<String, dynamic> toJson() => _$TangoCardsDTOToJson(this);
}