import 'result.dart';

class User {
  bool? ok;
  List<Result>? result;

  User({this.ok, this.result});

  factory User.fromJson(Map<String, dynamic> json) => User(
        ok: json['ok'] as bool?,
        result: (json['result'] as List<dynamic>?)
            ?.map((e) => Result.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'ok': ok,
        'result': result?.map((e) => e.toJson()).toList(),
      };
}
