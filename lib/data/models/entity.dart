class Entity {
  final String text;
  final String? color;
  final double? fontSize;
  final String? fontStyle;
  final String? url;

  Entity(
      {required this.text,
      this.color,
      this.fontSize,
      this.fontStyle,
      this.url});

  factory Entity.fromJson(Map<String, dynamic> json) {
    return Entity(
      text: json['text'] ?? '',
      color: json['color'],
      fontSize: json['font_size']?.toDouble(),
      fontStyle: json['font_style'],
      url: json['url'] ?? '',
    );
  }
}
