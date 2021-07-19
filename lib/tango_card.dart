import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class TangoCard {
  TangoCard(this.cardID, this.front, this.back, this.memo);

  int cardID;
  String front;
  String back;
  String memo;

  TangoCard.fromJson(Map<String, dynamic> json)
      : cardID = json['CardID'],
        front = json['Front'],
        back = json['Back'],
        memo = json['Memo'];

  Map<String, dynamic> toJson() =>
      {
        'CardID': cardID,
        'Front': front,
        'Back': back,
        'Memo': memo
      };
}