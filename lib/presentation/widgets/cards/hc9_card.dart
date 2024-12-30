import 'package:flutter/material.dart';
import 'package:contextual_cards/data/models/card_model.dart';
import 'package:contextual_cards/utils/gradient_utils.dart';
import 'package:contextual_cards/utils/hex_color.dart';
import 'package:contextual_cards/utils/url_launch.dart';

class HC9Card extends StatelessWidget {
  final CardModel card;
  final double height;

  const HC9Card({super.key, required this.card, required this.height});

  @override
  Widget build(BuildContext context) {
    final double width =
        card.bgImage != null && card.bgImage!.aspectRatio != null
            ? height * card.bgImage!.aspectRatio!
            : 130;

    return GestureDetector(
      onTap: () {
        if (card.url != null) {
          URLLaunch.launchURL(card.url);
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.all(16),
        height: height,
        width: width,
        // Image Section
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
              ? card.bgImage!.imageType == 'ext'
                  ? DecorationImage(
                      image: NetworkImage(card.bgImage!.imageUrl!),
                      fit: BoxFit.cover,
                      onError: (error, stackTrace) => const Icon(Icons.error),
                    )
                  : card.bgImage!.assetType != null
                      ? DecorationImage(
                          image: AssetImage(card.bgImage!.assetType!),
                          fit: BoxFit.cover,
                        )
                      : null
              : null,
        ),
      ),
    );
  }
}
