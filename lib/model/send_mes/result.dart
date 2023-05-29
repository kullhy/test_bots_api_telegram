import 'chat.dart';
import 'from.dart';

class Result2 {
  int? messageId;
  From? from;
  Chat? chat;
  int? date;
  String? text;

  Result2({this.messageId, this.from, this.chat, this.date, this.text});

  factory Result2.fromJson(Map<String, dynamic> json) => Result2(
        messageId: json['message_id'] as int?,
        from: json['from'] == null
            ? null
            : From.fromJson(json['from'] as Map<String, dynamic>),
        chat: json['chat'] == null
            ? null
            : Chat.fromJson(json['chat'] as Map<String, dynamic>),
        date: json['date'] as int?,
        text: json['text'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'message_id': messageId,
        'from': from?.toJson(),
        'chat': chat?.toJson(),
        'date': date,
        'text': text,
      };
}
