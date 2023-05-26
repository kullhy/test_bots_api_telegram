import 'chat.dart';
import 'entity.dart';
import 'from.dart';

class Message {
  int? messageId;
  From? from;
  Chat? chat;
  int? date;
  String? text;
  List<Entity>? entities;

  Message({
    this.messageId,
    this.from,
    this.chat,
    this.date,
    this.text,
    this.entities,
  });

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        messageId: json['message_id'] as int?,
        from: json['from'] == null
            ? null
            : From.fromJson(json['from'] as Map<String, dynamic>),
        chat: json['chat'] == null
            ? null
            : Chat.fromJson(json['chat'] as Map<String, dynamic>),
        date: json['date'] as int?,
        text: json['text'] as String?,
        entities: (json['entities'] as List<dynamic>?)
            ?.map((e) => Entity.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'message_id': messageId,
        'from': from?.toJson(),
        'chat': chat?.toJson(),
        'date': date,
        'text': text,
        'entities': entities?.map((e) => e.toJson()).toList(),
      };
}
