import 'package:flutter/material.dart';
import 'package:contextual_cards/data/models/card_model.dart';
import 'package:contextual_cards/utils/gradient_utils.dart';
import 'package:contextual_cards/utils/hex_color.dart';

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

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.all(16),
      height: height,
      width: width,
      decoration: BoxDecoration(
        gradient: card.bgGradient != null
            ? LinearGradient(
                colors: card.bgGradient!.colors
                    .map((hex) => HexColor.fromHex(hex) ?? Colors.transparent)
                    .toList(),
                begin: GradientUtils.calculateAlignment(
                    card.bgGradient!.angle.toDouble()),
                end: GradientUtils.calculateAlignment(
                    (card.bgGradient!.angle.toDouble() + 180) % 360),
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
