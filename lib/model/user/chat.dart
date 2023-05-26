class Chat {
  int? id;
  String? firstName;
  String? lastName;
  String? username;
  String? type;

  Chat({this.id, this.firstName, this.lastName, this.username, this.type});

  factory Chat.fromJson(Map<String, dynamic> json) => Chat(
        id: json['id'] as int?,
        firstName: json['first_name'] as String?,
        lastName: json['last_name'] as String?,
        username: json['username'] as String?,
        type: json['type'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'first_name': firstName,
        'last_name': lastName,
        'username': username,
        'type': type,
      };
}
