import 'package:flutter/material.dart';
import 'package:contextual_cards/data/models/card_model.dart';
import 'package:contextual_cards/data/models/entity.dart';
import 'package:contextual_cards/utils/hex_color.dart';

class HC5Card extends StatelessWidget {
  final CardModel card;
  final bool isScrollable;

  const HC5Card({super.key, required this.card, required this.isScrollable});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double width = isScrollable
            ? MediaQuery.of(context).size.width - 50
            : constraints.maxWidth;
        final double aspectRatio = card.bgImage?.aspectRatio ?? 1.0;
        final double height = width / aspectRatio;

        return Container(
          margin: isScrollable
              ? const EdgeInsets.symmetric(vertical: 5)
              : const EdgeInsets.symmetric(vertical: 5, horizontal: 16),
          padding: const EdgeInsets.all(16),
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            image: card.bgImage != null
                ? DecorationImage(
                    image: NetworkImage(card.bgImage!.imageUrl!),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: _getCrossAxisAlignment(
                  card.formattedTitle?.align ?? 'center'),
              children: [
                _buildFormattedText(
                  card.formattedTitle?.text ?? card.title ?? '',
                  card.formattedTitle?.entities ?? [],
                  card.formattedTitle?.align ?? 'center',
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFormattedText(String text, List<Entity> entities, String align) {
    final List<TextSpan> spans = [];
    final List<String> parts = text.split('{}');

    for (int i = 0; i < parts.length; i++) {
      if (parts[i].trim().isNotEmpty) {
        spans.add(TextSpan(
          text: parts[i],
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ));
      }

      if (i < entities.length && entities[i].text.isNotEmpty == true) {
        final entity = entities[i];
        spans.add(TextSpan(
          text: entity.text,
          style: TextStyle(
            color: HexColor.fromHex(entity.color) ?? Colors.white,
            fontSize: entity.fontSize?.toDouble() ?? 20,
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

  CrossAxisAlignment _getCrossAxisAlignment(String align) {
    switch (align) {
      case 'center':
        return CrossAxisAlignment.center;
      case 'right':
        return CrossAxisAlignment.end;
      default:
        return CrossAxisAlignment.start;
    }
  }
}
