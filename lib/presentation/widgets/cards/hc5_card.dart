import 'package:contextual_cards/data/models/card_model.dart';
import 'package:contextual_cards/data/models/entity.dart';
import 'package:flutter/material.dart';

class HC5Card extends StatelessWidget {
  final CardModel card;

  const HC5Card({super.key, required this.card});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;
        final double aspectRatio = card.bgImage?.aspectRatio ?? 1.0;
        final double height = width / aspectRatio;

        return Container(
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
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
            color: entity.color != null
                ? Color(int.parse(entity.color!.replaceFirst('#', '0xFF')))
                : Colors.white,
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
