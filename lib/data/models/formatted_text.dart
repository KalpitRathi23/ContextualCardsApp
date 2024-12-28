import 'package:contextual_cards/data/models/entity.dart';

class FormattedText {
  final String text;
  final String? align;
  final List<Entity> entities;

  FormattedText({required this.text, this.align, required this.entities});

  factory FormattedText.fromJson(Map<String, dynamic> json) {
    return FormattedText(
      text: json['text'] ?? '',
      align: json['align'],
      entities: (json['entities'] as List)
          .map((entity) => Entity.fromJson(entity))
          .toList(),
    );
  }
}
