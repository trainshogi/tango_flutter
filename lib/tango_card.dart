import 'package:json_annotation/json_annotation.dart';
import 'package:tango_flutter/text_span_info.dart';

@JsonSerializable()
class TangoCard {
  TangoCard(this.cardID, this.front, this.back, this.memo);

  int cardID;
  List<TextSpanInfo> front;
  List<TextSpanInfo> back;
  String memo;

  TangoCard.fromJson(Map<String, dynamic> json)
      : cardID = json['CardID'],
        front = List<TextSpanInfo>.from((json['Front']).map(
                (textSpanInfo) => TextSpanInfo.fromJson(
                    textSpanInfo))),
        back = List<TextSpanInfo>.from((json['Back']).map(
                (textSpanInfo) => TextSpanInfo.fromJson(
                    textSpanInfo))),
        memo = json['Memo'];

  Map<String, dynamic> toJson() =>
      {
        'CardID': cardID,
        'Front': front,
        'Back': back,
        'Memo': memo
      };
}