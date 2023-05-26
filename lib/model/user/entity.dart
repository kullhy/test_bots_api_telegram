class Entity {
  int? offset;
  int? length;
  String? type;

  Entity({this.offset, this.length, this.type});

  factory Entity.fromJson(Map<String, dynamic> json) => Entity(
        offset: json['offset'] as int?,
        length: json['length'] as int?,
        type: json['type'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'offset': offset,
        'length': length,
        'type': type,
      };
}
