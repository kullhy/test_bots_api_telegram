class From {
  int? id;
  bool? isBot;
  String? firstName;
  String? username;

  From({this.id, this.isBot, this.firstName, this.username});

  factory From.fromJson(Map<String, dynamic> json) => From(
        id: json['id'] as int?,
        isBot: json['is_bot'] as bool?,
        firstName: json['first_name'] as String?,
        username: json['username'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'is_bot': isBot,
        'first_name': firstName,
        'username': username,
      };
}
