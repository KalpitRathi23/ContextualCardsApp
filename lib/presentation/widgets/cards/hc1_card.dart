import 'package:flutter/material.dart';
import 'package:contextual_cards/data/models/card_model.dart';
import 'package:contextual_cards/data/models/entity.dart';
import 'package:contextual_cards/utils/hex_color.dart';

class HC1Card extends StatelessWidget {
  final CardModel card;
  final bool isScrollable;

  const HC1Card({super.key, required this.card, required this.isScrollable});

  @override
  Widget build(BuildContext context) {
    const double iconHeight = 40.0;
    final double aspectRatio = card.icon?.aspectRatio ?? 1.0;

    return Container(
      width: isScrollable
          ? MediaQuery.of(context).size.width - 50
          : (MediaQuery.of(context).size.width - 65) / 2,
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: card.bgColor ?? Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Icon Section
          if (card.icon != null)
            SizedBox(
              height: iconHeight,
              width: iconHeight * aspectRatio,
              child: Image.network(
                card.icon!.imageUrl!,
                fit: BoxFit.contain,
              ),
            ),
          const SizedBox(width: 16),

          // Text Section
          Expanded(
            child: Column(
              mainAxisSize:
                  MainAxisSize.min, // Ensure the column wraps its children
              crossAxisAlignment:
                  _getTextAlignment(card.formattedTitle?.align ?? 'left'),
              children: [
                // Title and Entities
                Flexible(
                  fit: FlexFit.loose,
                  child: _buildFormattedText(
                    card.formattedTitle?.text ?? card.title ?? '',
                    card.formattedTitle?.entities ?? [],
                    const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    card.formattedTitle?.align ?? 'left',
                  ),
                ),
                const SizedBox(height: 4),
                // Description and Entities
                Flexible(
                  fit: FlexFit.loose,
                  child: _buildFormattedText(
                    card.formattedDescription?.text ?? card.description ?? '',
                    card.formattedDescription?.entities ?? [],
                    const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                    card.formattedDescription?.align ?? 'left',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormattedText(
      String text, List<Entity> entities, TextStyle baseStyle, String align) {
    final List<TextSpan> spans = [];
    final List<String> parts = text.split('{}');

    for (int i = 0; i < parts.length; i++) {
      if (parts[i].trim().isNotEmpty) {
        spans.add(TextSpan(
          text: parts[i],
          style: baseStyle,
        ));
      }

      if (i < entities.length && entities[i].text.isNotEmpty) {
        final entity = entities[i];
        spans.add(TextSpan(
          text: entity.text,
          style: TextStyle(
            color: entity.color != null
                ? HexColor.fromHex(entity.color)
                : baseStyle.color,
            fontSize: entity.fontSize?.toDouble() ?? baseStyle.fontSize,
            fontStyle: entity.fontStyle == "italic"
                ? FontStyle.italic
                : FontStyle.normal,
            decoration: entity.fontStyle == "underline"
                ? TextDecoration.underline
                : TextDecoration.none,
            fontWeight: baseStyle.fontWeight,
          ),
        ));
      }
    }

    return Text.rich(
      TextSpan(children: spans),
      textAlign: _getTextAlign(align),
      overflow: TextOverflow.ellipsis,
      maxLines: 2,
    );
  }

  CrossAxisAlignment _getTextAlignment(String align) {
    switch (align) {
      case 'center':
        return CrossAxisAlignment.center;
      case 'right':
        return CrossAxisAlignment.end;
      default:
        return CrossAxisAlignment.start;
    }
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
