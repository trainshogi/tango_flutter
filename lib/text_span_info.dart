import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class TextSpanInfo {
  TextSpanInfo(this.text, this.color);

  String text;
  String color;

  TextSpanInfo.fromJson(Map<String, dynamic> json)
      : text = json['text'],
        color = json['color'];

  Map<String, dynamic> toJson() =>
      {
        'text': text,
        'color': color
      };
}