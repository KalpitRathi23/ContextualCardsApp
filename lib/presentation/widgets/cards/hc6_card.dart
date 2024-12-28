import 'package:contextual_cards/data/models/card_model.dart';
import 'package:contextual_cards/data/models/entity.dart';
import 'package:contextual_cards/utils/hex_color.dart';
import 'package:flutter/material.dart';

class HC6Card extends StatelessWidget {
  final CardModel card;

  const HC6Card({super.key, required this.card});

  @override
  Widget build(BuildContext context) {
    const double iconHeight = 40.0;
    final double aspectRatio = card.icon?.aspectRatio ?? 1.0;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: card.bgColor ?? Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (card.icon != null)
            SizedBox(
              height: iconHeight,
              width: iconHeight * aspectRatio,
              child: Image.network(
                card.icon!.imageUrl!,
                fit: BoxFit.contain,
              ),
            ),
          const SizedBox(width: 8),
          if (card.formattedTitle != null)
            Expanded(
              child: _buildFormattedText(
                card.formattedTitle!.text,
                card.formattedTitle!.entities,
                card.formattedTitle?.align ?? 'left',
              ),
            )
          else if (card.title?.trim().isNotEmpty == true)
            Expanded(
              child: Text(
                card.title!,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          const Icon(Icons.arrow_forward_ios, size: 16),
        ],
      ),
    );
  }

  Widget _buildFormattedText(String text, List<Entity> entities, String align) {
    final List<TextSpan> spans = [];
    final List<String> parts = text.split('{}');
    for (int i = 0; i < parts.length; i++) {
      spans.add(TextSpan(
        text: parts[i],
        style: const TextStyle(
          fontSize: 16,
          color: Colors.black,
        ),
      ));

      if (i < entities.length) {
        final entity = entities[i];
        spans.add(TextSpan(
          text: entity.text,
          style: TextStyle(
            color: HexColor.fromHex(entity.color) ?? Colors.black,
            fontSize: entity.fontSize ?? 18,
            fontWeight: FontWeight.bold,
            fontStyle: entity.fontStyle == "italic"
                ? FontStyle.italic
                : FontStyle.normal,
            decoration: entity.fontStyle == "underline"
                ? TextDecoration.underline
                : TextDecoration.none,
          ),
        ));
      }
    }

    return Text.rich(
      TextSpan(children: spans),
      textAlign: _getTextAlign(align),
    );
  }

  TextAlign _getTextAlign(String align) {
    switch (align) {
      case 'center':
        return TextAlign.center;
      case 'right':
        return TextAlign.right;
      default:
        return TextAlign.left;
    }
  }
}
