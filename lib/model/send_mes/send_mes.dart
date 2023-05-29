import 'result.dart';

class SendMes {
  bool? ok;
  Result2? result2;

  SendMes({this.ok, this.result2});

  factory SendMes.fromJson(Map<String, dynamic> json) => SendMes(
        ok: json['ok'] as bool?,
        result2: json['result'] == null
            ? null
            : Result2.fromJson(json['result'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'ok': ok,
        'result': result2?.toJson(),
      };
}
