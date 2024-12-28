import 'dart:convert';
import 'package:contextual_cards/data/models/card_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/card_group.dart';

class CardProvider extends ChangeNotifier {
  List<CardGroup> cardGroups = [];
  bool isLoading = true;
  bool hasError = false;

  CardProvider() {
    loadCards();
  }

  Future<void> loadCards() async {
    try {
      isLoading = true;
      hasError = false;
      notifyListeners();

      const url =
          'https://polyjuice.kong.fampay.co/mock/famapp/feed/home_section/?slugs=famx-paypage';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;
        List<CardGroup> fetchedGroups = data[0]['hc_groups']
            .map<CardGroup>((group) => CardGroup.fromJson(group))
            .toList();

        // Apply filters for dismissed and remindLater cards
        final prefs = await SharedPreferences.getInstance();
        List<String> dismissedCards =
            prefs.getStringList('dismissedCards') ?? [];
        List<String> remindLaterCards =
            prefs.getStringList('remindLaterCards') ?? [];

        // Remove dismissed cards
        for (var group in fetchedGroups) {
          group.cards.removeWhere(
              (card) => dismissedCards.contains(card.id.toString()));
        }

        // Remove remindLater cards unless reload flag is true
        final reload = prefs.getBool('reload') ?? false;
        if (!reload) {
          for (var group in fetchedGroups) {
            group.cards.removeWhere(
                (card) => remindLaterCards.contains(card.id.toString()));
          }
        }

        // Update the card groups
        cardGroups = fetchedGroups;

        // Reset reload flag
        prefs.setBool('reload', false);
      } else {
        hasError = true;
      }
    } catch (e) {
      debugPrint('Error while loading cards: $e');
      hasError = true;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> remindLater(CardModel card) async {
    // Save the card ID to "remindLaterCards" in shared preferences
    final prefs = await SharedPreferences.getInstance();
    List<String> remindLaterCards =
        prefs.getStringList('remindLaterCards') ?? [];

    if (!remindLaterCards.contains(card.id.toString())) {
      remindLaterCards.add(card.id.toString());
      await prefs.setStringList('remindLaterCards', remindLaterCards);
    }

    // Remove the card from the display
    for (var group in cardGroups) {
      group.cards.removeWhere((c) => c.id == card.id);
    }

    notifyListeners();
  }

  Future<void> dismissNow(CardModel card) async {
    // Save the card ID to "dismissedCards" in shared preferences
    final prefs = await SharedPreferences.getInstance();
    List<String> dismissedCards = prefs.getStringList('dismissedCards') ?? [];

    if (!dismissedCards.contains(card.id.toString())) {
      dismissedCards.add(card.id.toString());
      await prefs.setStringList('dismissedCards', dismissedCards);
    }

    // Remove the card from the display
    for (var group in cardGroups) {
      group.cards.removeWhere((c) => c.id == card.id);
    }

    notifyListeners();
  }
}
