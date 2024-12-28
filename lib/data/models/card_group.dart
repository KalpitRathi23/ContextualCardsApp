import 'card_model.dart';

class CardGroup {
  final String designType;
  final List<CardModel> cards;
  final int? height;
  final bool? isScrollable;

  CardGroup({
    required this.designType,
    required this.cards,
    this.height,
    this.isScrollable,
  });

  factory CardGroup.fromJson(Map<String, dynamic> json) {
    return CardGroup(
      designType: json['design_type'] ?? '',
      cards: (json['cards'] as List)
          .map((card) => CardModel.fromJson(card))
          .toList(),
      height: json['height'],
      isScrollable: json['is_scrollable'],
    );
  }
}
