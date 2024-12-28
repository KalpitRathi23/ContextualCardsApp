import 'package:flutter/material.dart';
import '../../../data/models/card_model.dart';

class HC1Card extends StatelessWidget {
  final CardModel card;

  const HC1Card({super.key, required this.card});

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
            CircleAvatar(
              backgroundImage: NetworkImage(card.icon!.imageUrl!),
              radius: 24,
            ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                card.formattedTitle?.text ?? card.title ?? '',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                card.formattedDescription?.text ?? card.description ?? '',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
