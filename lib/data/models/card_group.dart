import 'card_model.dart';

class CardGroup {
  final String designType;
  final List<CardModel> cards;
  final int? height;

  CardGroup({
    required this.designType,
    required this.cards,
    this.height,
  });

  factory CardGroup.fromJson(Map<String, dynamic> json) {
    return CardGroup(
      designType: json['design_type'] ?? '',
      cards: (json['cards'] as List)
          .map((card) => CardModel.fromJson(card))
          .toList(),
      height: json['height'],
    );
  }
}
