import 'package:flutter/material.dart';
import '../../../data/models/card_model.dart';

class HC6Card extends StatelessWidget {
  final CardModel card;

  const HC6Card({super.key, required this.card});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: card.bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          if (card.icon != null)
            Image.network(
              card.icon!.imageUrl!,
              height: 40,
              width: 40,
            ),
          const SizedBox(width: 16),
          Text(
            card.formattedTitle?.text ?? card.title ?? '',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          const Icon(Icons.arrow_forward_ios, size: 16),
        ],
      ),
    );
  }
}
