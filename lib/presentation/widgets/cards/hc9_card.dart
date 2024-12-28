import 'dart:math';
import 'package:contextual_cards/data/models/card_model.dart';
import 'package:flutter/material.dart';

class HC9Card extends StatelessWidget {
  final CardModel card;
  final double height;

  const HC9Card({super.key, required this.card, required this.height});

  @override
  Widget build(BuildContext context) {
    final double width =
        card.bgImage != null && card.bgImage!.aspectRatio != null
            ? height * card.bgImage!.aspectRatio!
            : 100;

    Alignment calculateAlignment(double angle) {
      final double radians = angle * (pi / 180);
      return Alignment(cos(radians), sin(radians));
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      height: height,
      width: width,
      decoration: BoxDecoration(
        gradient: card.bgGradient != null
            ? LinearGradient(
                colors: card.bgGradient!.colors.map((hex) {
                  return Color(int.parse(hex.replaceFirst('#', '0xFF')));
                }).toList(),
                begin: calculateAlignment(card.bgGradient!.angle.toDouble()),
                end: calculateAlignment(
                  (card.bgGradient!.angle.toDouble() + 180) % 360,
                ),
              )
            : null,
        borderRadius: BorderRadius.circular(12),
        image: card.bgImage != null
            ? DecorationImage(
                image: NetworkImage(card.bgImage!.imageUrl!),
                fit: BoxFit.cover,
              )
            : null,
      ),
    );
  }
}
