import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:contextual_cards/data/models/card_model.dart';
import 'package:contextual_cards/data/models/entity.dart';
import 'package:contextual_cards/utils/hex_color.dart';
import 'package:contextual_cards/utils/url_launch.dart';

class HC6Card extends StatelessWidget {
  final CardModel card;
  final bool isScrollable;

  const HC6Card({super.key, required this.card, required this.isScrollable});

  @override
  Widget build(BuildContext context) {
    const double iconHeight = 40.0;
    final double aspectRatio = card.icon?.aspectRatio ?? 1.0;
    final double width = iconHeight * aspectRatio;

    return GestureDetector(
      onTap: () {
        if (card.url != null) {
          URLLaunch.launchURL(card.url);
        }
      },
      child: Container(
        margin: isScrollable
            ? const EdgeInsets.symmetric(vertical: 5)
            : const EdgeInsets.symmetric(vertical: 5, horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: card.bgColor ?? Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Icon Section
                if (card.icon != null)
                  SizedBox(
                    height: iconHeight,
                    width: width,
                    child: card.icon!.imageType == 'ext'
                        ? Image.network(
                            card.icon!.imageUrl!,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(
                              Icons.broken_image,
                              size: iconHeight,
                              color: Colors.grey,
                            ),
                          )
                        : card.icon!.assetType != null
                            ? Image.asset(
                                card.icon!.assetType!,
                                fit: BoxFit.contain,
                              )
                            : const SizedBox.shrink(),
                  ),
                const SizedBox(width: 6),
                // Text Section
                if (card.formattedTitle != null)
                  Flexible(
                    fit: FlexFit.loose,
                    child: _buildFormattedText(
                      card.formattedTitle!.text,
                      card.formattedTitle!.entities,
                      card.formattedTitle?.align ?? 'left',
                    ),
                  )
                else if (card.title?.trim().isNotEmpty == true)
                  Flexible(
                    fit: FlexFit.loose,
                    child: Text(
                      card.title!,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            const Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              child: Icon(Icons.arrow_forward_ios, size: 16),
            ),
          ],
        ),
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
        spans.add(
          TextSpan(
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
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                if (entity.url != null) {
                  URLLaunch.launchURL(entity.url);
                }
              },
          ),
        );
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
