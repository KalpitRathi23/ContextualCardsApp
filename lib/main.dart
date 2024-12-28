import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:contextual_cards/data/providers/card_provider.dart';
import 'package:contextual_cards/presentation/widgets/contextual_cards_container.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  prefs.setBool('reload', true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CardProvider(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Contextual Cards',
        home: ContextualCardsContainer(),
      ),
    );
  }
}
