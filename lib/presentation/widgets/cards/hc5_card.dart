import 'package:flutter/material.dart';
import '../../../data/models/card_model.dart';

class HC5Card extends StatelessWidget {
  final CardModel card;

  const HC5Card({super.key, required this.card});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: card.bgImage != null
            ? DecorationImage(
                image: NetworkImage(card.bgImage!.imageUrl!),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: SizedBox(
        height: 200,
        child: Center(
          child: Text(
            card.formattedTitle?.text ?? card.title ?? '',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
