import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:contextual_cards/presentation/widgets/build_cards.dart';
import 'package:contextual_cards/data/providers/card_provider.dart';

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
              padding: const EdgeInsets.only(top: 20),
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
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(10),
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: const Text(
                        'Retry',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: provider.loadCards,
              color: Colors.black,
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

                    return renderCardGroup(context, group, provider);
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget renderCardGroup(
      BuildContext context, dynamic group, CardProvider provider) {
    switch (group.designType) {
      case 'HC1':
        return buildHC1Group(context, group);
      case 'HC3':
        return buildHC3Group(context, group, provider);
      case 'HC5':
        return buildHC5Group(context, group);
      case 'HC6':
        return buildHC6Group(context, group);
      case 'HC9':
        return buildHC9Group(context, group);
      default:
        debugPrint('Unknown designType: ${group.designType}');
        return buildUnsupportedCard();
    }
  }
}
