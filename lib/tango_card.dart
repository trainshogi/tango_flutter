import 'package:json_annotation/json_annotation.dart';

part 'tango_card.g.dart';

@JsonSerializable()
class TangoCard {
  TangoCard(this.front, this.back, this.memo);

  String front;
  String back;
  String memo;

  // _$UserFromJsonが生成される
  factory TangoCard.fromJson(Map<String, dynamic> json) => _$TangoCardFromJson(json);

  // _$UserToJsonが生成される
  Map<String, dynamic> toJson() => _$TangoCardToJson(this);
}