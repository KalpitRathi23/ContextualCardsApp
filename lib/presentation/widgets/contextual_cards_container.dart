import 'package:contextual_cards/data/models/card_model.dart';
import 'package:contextual_cards/data/providers/card_provider.dart';
import 'package:contextual_cards/presentation/widgets/cards/hc1_card.dart';
import 'package:contextual_cards/presentation/widgets/cards/hc3_card.dart';
import 'package:contextual_cards/presentation/widgets/cards/hc5_card.dart';
import 'package:contextual_cards/presentation/widgets/cards/hc6_card.dart';
import 'package:contextual_cards/presentation/widgets/cards/hc9_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ContextualCardsContainer extends StatelessWidget {
  const ContextualCardsContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F6F3),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          elevation: 0,
          flexibleSpace: Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 25),
              child: Image.asset(
                'assets/fampaylogo.png',
                height: 35,
              ),
            ),
          ),
        ),
      ),
      body: ChangeNotifierProvider(
        create: (_) => CardProvider(),
        child: Consumer<CardProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.black),
              );
            }
            if (provider.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Error loading cards'),
                    const SizedBox(height: 15),
                    ElevatedButton(
                      onPressed: provider.loadCards,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: provider.loadCards,
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFF7F6F3),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: ListView.builder(
                  itemCount: provider.cardGroups.length,
                  itemBuilder: (context, index) {
                    final group = provider.cardGroups[index];

                    if (group.designType == 'HC9') {
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
                                if (cardIndex < group.cards.length - 1)
                                  const SizedBox(width: 14),
                              ],
                            );
                          },
                        ),
                      );
                    }

                    if (group.designType == 'HC1') {
                      if (group.isScrollable == true) {
                        return SizedBox(
                          height: 90,
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
                                  if (cardIndex < group.cards.length - 1)
                                    const SizedBox(width: 12),
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
                                  (MediaQuery.of(context).size.width - 36) /
                                      group.cards.length;
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

                    // Handle other card types
                    return Column(
                      children: group.cards.map((card) {
                        switch (group.designType) {
                          case 'HC3':
                            return HC3Card(
                              card: card,
                              onRemindLater: (CardModel card) {
                                provider.remindLater(card);
                              },
                              onDismissNow: (CardModel card) {
                                provider.dismissNow(card);
                              },
                            );
                          case 'HC6':
                            return HC6Card(card: card);
                          case 'HC5':
                            return HC5Card(card: card);
                          default:
                            debugPrint(
                                'Unknown designType: ${group.designType}');
                            return const SizedBox.shrink();
                        }
                      }).toList(),
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
