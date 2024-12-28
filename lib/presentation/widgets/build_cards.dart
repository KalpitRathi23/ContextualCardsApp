import 'package:flutter/material.dart';
import 'package:contextual_cards/data/models/card_model.dart';
import 'package:contextual_cards/data/providers/card_provider.dart';
import 'package:contextual_cards/presentation/widgets/cards/hc1_card.dart';
import 'package:contextual_cards/presentation/widgets/cards/hc3_card.dart';
import 'package:contextual_cards/presentation/widgets/cards/hc5_card.dart';
import 'package:contextual_cards/presentation/widgets/cards/hc6_card.dart';
import 'package:contextual_cards/presentation/widgets/cards/hc9_card.dart';

Widget buildHC1Group(BuildContext context, dynamic group) {
  if (group.isScrollable == true) {
    return SizedBox(
      height: 85,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: group.cards.length,
        itemBuilder: (context, cardIndex) {
          final card = group.cards[cardIndex];
          return Row(
            children: [
              HC1Card(
                card: card,
                isScrollable: true,
              ),
              if (cardIndex < group.cards.length - 1) const SizedBox(width: 12),
            ],
          );
        },
      ),
    );
  } else {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: group.cards.map((card) {
          final double cardWidth =
              (MediaQuery.of(context).size.width - 36) / group.cards.length;
          return SizedBox(
            width: cardWidth,
            child: HC1Card(
              card: card,
              isScrollable: false,
            ),
          );
        }).toList(),
      ),
    );
  }
}

Widget buildHC3Group(
    BuildContext context, dynamic group, CardProvider provider) {
  if (group.isScrollable == true) {
    return SizedBox(
      height: 420,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: group.cards.length,
        itemBuilder: (context, cardIndex) {
          final card = group.cards[cardIndex];
          return Row(
            children: [
              HC3Card(
                card: card,
                onRemindLater: (CardModel card) {
                  provider.remindLater(card);
                },
                onDismissNow: (CardModel card) {
                  provider.dismissNow(card);
                },
                isScrollable: true,
              ),
              if (cardIndex < group.cards.length - 1) const SizedBox(width: 12),
            ],
          );
        },
      ),
    );
  } else {
    return HC3Card(
      card: group.cards.first,
      onRemindLater: (CardModel card) {
        provider.remindLater(card);
      },
      onDismissNow: (CardModel card) {
        provider.dismissNow(card);
      },
      isScrollable: false,
    );
  }
}

Widget buildHC5Group(BuildContext context, dynamic group) {
  if (group.isScrollable == true) {
    return SizedBox(
      height: group.height?.toDouble() ?? 160,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: group.cards.length,
        itemBuilder: (context, cardIndex) {
          final card = group.cards[cardIndex];
          return Row(
            children: [
              HC5Card(card: card, isScrollable: true),
              if (cardIndex < group.cards.length - 1) const SizedBox(width: 12),
            ],
          );
        },
      ),
    );
  } else {
    return HC5Card(
      card: group.cards.first,
      isScrollable: false,
    );
  }
}

Widget buildHC6Group(BuildContext context, dynamic group) {
  if (group.isScrollable == true) {
    return SizedBox(
      height: 85,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: group.cards.length,
        itemBuilder: (context, cardIndex) {
          final card = group.cards[cardIndex];
          return Row(
            children: [
              SizedBox(
                  width: MediaQuery.of(context).size.width * 0.87,
                  child: HC6Card(card: card, isScrollable: true)),
              if (cardIndex < group.cards.length - 1) const SizedBox(width: 12),
            ],
          );
        },
      ),
    );
  } else {
    return HC6Card(
      card: group.cards.first,
      isScrollable: false,
    );
  }
}

Widget buildHC9Group(BuildContext context, dynamic group) {
  return SizedBox(
    height: group.height?.toDouble() ?? 150,
    child: ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      scrollDirection: Axis.horizontal,
      itemCount: group.cards.length,
      itemBuilder: (context, cardIndex) {
        final card = group.cards[cardIndex];
        return Row(
          children: [
            HC9Card(
              card: card,
              height: group.height?.toDouble() ?? 150,
            ),
            if (cardIndex < group.cards.length - 1) const SizedBox(width: 14),
          ],
        );
      },
    ),
  );
}

Widget buildUnsupportedCard() {
  return Padding(
    padding: const EdgeInsets.symmetric(
      vertical: 5,
      horizontal: 16,
    ),
    child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(
        child: Text(
          'Unsupported card type.',
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
      ),
    ),
  );
}
