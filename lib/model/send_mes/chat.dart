class Chat {
  int? id;
  String? firstName;
  String? type;

  Chat({this.id, this.firstName, this.type});

  factory Chat.fromJson(Map<String, dynamic> json) => Chat(
        id: json['id'] as int?,
        firstName: json['first_name'] as String?,
        type: json['type'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'first_name': firstName,
        'type': type,
      };
}
