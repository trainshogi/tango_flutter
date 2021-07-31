import 'package:json_annotation/json_annotation.dart';
import 'package:tango_flutter/text_span_info.dart';

@JsonSerializable()
class TangoCard {
  TangoCard(this.cardID, this.front, this.back);

  int cardID;
  List<TextSpanInfo> front;
  List<TextSpanInfo> back;

  TangoCard.fromJson(Map<String, dynamic> json)
      : cardID = json['CardID'],
        front = List<TextSpanInfo>.from((json['Front']).map(
                (textSpanInfo) => TextSpanInfo.fromJson(
                    textSpanInfo))),
        back = List<TextSpanInfo>.from((json['Back']).map(
                (textSpanInfo) => TextSpanInfo.fromJson(
                    textSpanInfo)));

  Map<String, dynamic> toJson() =>
      {
        'CardID': cardID,
        'Front': front,
        'Back': back
      };
}