import 'dart:ui';
import 'package:contextual_cards/utils/hex_color.dart';
import 'formatted_text.dart';
import 'card_image.dart';
import 'call_to_action.dart';
import 'gradient.dart';

class CardModel {
  final int? id;
  final String? title;
  final String? description;
  final FormattedText? formattedTitle;
  final FormattedText? formattedDescription;
  final CardImage? bgImage;
  final CardImage? icon;
  final Color? bgColor;
  final GradientModel? bgGradient;
  final List<CallToAction>? cta;
  final String? url;

  CardModel({
    this.id,
    this.title,
    this.description,
    this.formattedTitle,
    this.formattedDescription,
    this.bgImage,
    this.icon,
    this.bgColor,
    this.bgGradient,
    this.cta,
    this.url,
  });

  factory CardModel.fromJson(Map<String, dynamic> json) {
    return CardModel(
      id: json['id'],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      formattedTitle: json['formatted_title'] != null
          ? FormattedText.fromJson(json['formatted_title'])
          : null,
      formattedDescription: json['formatted_description'] != null
          ? FormattedText.fromJson(json['formatted_description'])
          : null,
      bgImage: json['bg_image'] != null
          ? CardImage.fromJson(json['bg_image'])
          : null,
      icon: json['icon'] != null ? CardImage.fromJson(json['icon']) : null,
      bgColor:
          json['bg_color'] != null ? HexColor.fromHex(json['bg_color']) : null,
      bgGradient: json['bg_gradient'] != null
          ? GradientModel.fromJson(json['bg_gradient'])
          : null,
      cta: json['cta'] != null
          ? (json['cta'] as List)
              .map((cta) => CallToAction.fromJson(cta))
              .toList()
          : null,
      url: json['url'] ?? '',
    );
  }
}
