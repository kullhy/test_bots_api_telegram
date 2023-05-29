import 'message.dart';

class Result {
  int? updateId;
  Message? message;

  Result({this.updateId, this.message});

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        updateId: json['update_id'] as int?,
        message: json['message'] == null
            ? null
            : Message.fromJson(json['message'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'update_id': updateId ?? 0,
        'message': message?.toJson(),
      };
}
