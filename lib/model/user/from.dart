class From {
  int? id;
  bool? isBot;
  String? firstName;
  String? lastName;
  String? username;
  String? languageCode;

  From({
    this.id,
    this.isBot,
    this.firstName,
    this.lastName,
    this.username,
    this.languageCode,
  });

  factory From.fromJson(Map<String, dynamic> json) => From(
        id: json['id'] as int?,
        isBot: json['is_bot'] as bool?,
        firstName: json['first_name'] as String?,
        lastName: json['last_name'] as String?,
        username: json['username'] as String?,
        languageCode: json['language_code'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'is_bot': isBot,
        'first_name': firstName,
        'last_name': lastName,
        'username': username,
        'language_code': languageCode,
      };
}
